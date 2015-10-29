#!/usr/bin/env python
# -*- coding: utf8 -*- 

import os
import re
import hashlib
import logging

from datetime import datetime, timedelta
from tornado.web import HTTPError
from tornado.gen import coroutine
from pymongo.errors import DuplicateKeyError
from bson.objectid import ObjectId

from base import ApiHandler, StreamApiHandler, auth, dumps

# TODO: default user for country and gender
default_body = {
    'height': 180,
    'weight': 80,
    'neck': 50,
    'abdomen': 80,
    'hip': 24
}

default_settings = {
    'language': 'en',
    'measure': 'me',
    'theme': 'light'
}

class UserHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        database = self.settings['database']
        users = database.users
        user = yield users.find_one({'username': self.user}, {'_id': 0, 'private': 0})
        if not user:
            raise HTTPError(404, 'User not found')

        self.write_content(user)

class UserFactsHandler(ApiHandler):
    pass

class UserPhotoHandler(StreamApiHandler):

    def set_extra_headers(self, path):
        if __debug__:
            self.set_header('Cache-control', 'no-store, no-cache, must-revalidate, max-age=0')

    def head(self):
        return StreamApiHandler.get(self, '/', False)

    @coroutine
    def get(self, bearer):
        database = self.settings['database']
        tokens = database.tokens

        token = yield tokens.find_one({'bearer': bearer})
        if not token:
            raise HTTPError(404, 'Photo not found')

        yield StreamApiHandler.get(self, '/', True)

    @classmethod
    def get_absolute_path(cls, root, path):
        return 'C:/Users/shal/Pictures/projects/mechanic.png'

    def validate_absolute_path(self, root, absolute_path):
        return 'C:/Users/shal/Pictures/projects/mechanic.png'

class UserSettingsHandler(ApiHandler):
    
    @auth
    @coroutine
    def get(self):
        database = self.settings['database']
        users = database.users

        result = yield users.find_one({'username': self.user}, {'_id': 0, 'settings': 1})
        self.write_content(result)

    @auth
    @coroutine
    def post(self):
        database = self.settings['database']
        users = database.users
        yield users.update({'username': self.user}, {'$set': {'settings': self.json_body}}, 
                              upsert=False, multi=False)

class UsersHandler(ApiHandler):

    @coroutine
    def get(self):
        key = self.get_argument('key', None)
        value = self.get_argument('value', None)

        if not key or not value:
            raise HTTPError(400, 'Key and value required')

        if not key in ['username', 'email']:
            raise HTTPError(400, 'Invalid key')
        
        database = self.settings['database']
        users = database.users
        
        result = yield users.find_one({key: value})

        self.write_content({key: result is not None})

    @coroutine
    def post(self):
        user_body = self.json_body
        database = self.settings['database']
        users = database.users
        facts = database.facts

        # Modify user a bit
        raw_password = user_body.pop('password')
        user_body['created'] = datetime.utcnow()
        user_body['updated'] = datetime.utcnow()
        # TODO: check date in jsonschema
        user_body['birthdate'] = datetime.strptime(user_body['birthdate'], '%Y-%m-%d')

        # Generate password hash
        # TODO: generate hash async
        salt = os.urandom(24)
        raw_password = raw_password.encode('utf-8')
        password = hashlib.sha256(salt + raw_password).digest()

        # Generate verify token
        verify_token = hashlib.sha1(os.urandom(128)).hexdigest()

        # Set default values
        settings = default_settings
        settings.update(user_body.get('settings', {}))
        user_body['settings'] = settings

        # Set private part
        private = {
            'salt': salt,
            'password': password,
            'verified': False,
            'vcode': verify_token
        }
        user_body['private'] = private

        # Prepare facts
        username = user_body['username']
        body = default_body
        body.update(user_body.pop('body', {}))
        fact_body = {
            'username': username,
            'updated': datetime.utcnow(),
            'body': body
        }

        # Save user
        try:
            # TODO: make transactional query
            yield users.save(user_body)
            yield facts.save(fact_body)
        except DuplicateKeyError:
            raise HTTPError(400, 'User with same name or email already exists')

        # Send mail with verification
        mail = self.settings['mail']
        mail.send(
            'DietMaster',
            'support@dietmaster.io',
            user_body['email'],
            'Account verification',
            'verify',
            user=username,
            url='https://dietmaster.io/verify/%s-%s' % (username, verify_token)
        )

        user_body.pop('_id')
        user_body.pop('private')

        self.write_content(user_body)

class AuthHandler(ApiHandler):
    
    @coroutine
    def post(self):
        username = self.get_argument('username', None)
        password = self.get_argument('password', None)

        if not username or not password:
            raise HTTPError(400, 'No credentials supplied')

        database = self.settings['database']
        users = database.users
        tokens = database.tokens

        user = yield users.find_one({'username': username}, {'_id': 0})
        if not user:
            raise HTTPError(404, 'User not found')

        private = user.pop('private')
        salt = private['salt']
        rawpassword = password.encode('utf-8')
        hexpass = hashlib.sha256(salt + rawpassword).digest()

        if not hexpass == private['password']:
            raise HTTPError(400, 'Incorrect password')

        # TODO: update expires field
        token = yield tokens.find_one({'_id': username})
        if not token:
            bearer = hashlib.sha1(os.urandom(128)).hexdigest()
            refresh = hashlib.sha1(os.urandom(128)).hexdigest()
            expires = datetime.utcnow() + timedelta(days=7)

            token = {
                '_id': username,
                'bearer': bearer,
                'refresh': refresh,
                'expires': expires
            }

            yield tokens.save(token)

        token.pop('_id')
        token['user'] = user
        self.write_content(token)

    @coroutine
    def delete(self):
        bearer = self.get_argument('bearer', None)
        if not bearer:
            raise HTTPError(403, 'No token supplied')

        database = self.settings['database']
        tokens = database.tokens
        yield tokens.remove({'bearer': bearer})

class FoodHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        phrase = self.get_argument('phrase', None)
        if not phrase:
            raise HTTPError(400, 'Search phrase required')

        database = self.settings['database']
        food = database.food

        rexp = re.compile('^%s.*' % phrase, re.IGNORECASE)
        cursor = food.find({'name': rexp}, {'_id': 1, 'name': 1})
        result = yield cursor.to_list(length=10)

        self.write(dumps({'results': result}))

class FoodIdHandler(ApiHandler):

    @auth
    @coroutine
    def get(self, id):
        database = self.settings['database']
        food = database.food

        result = yield food.find_one({'_id': ObjectId(id)})
        if not result:
            raise HTTPError(404, 'Product not found')

        self.write(dumps(result))