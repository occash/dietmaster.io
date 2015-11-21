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
from facts import calculate_index

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

        self.write(user)

class UserFactsHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        database = self.settings['database']
        facts = database.facts
        cursor = facts.find({'username': self.user}, {'_id': 0}).sort('updated', -1).limit(1)
        fact = yield cursor.to_list(1)
        fact = fact[0]
        self.write(fact)

class UserPhotoHandler(StreamApiHandler):

    def set_extra_headers(self, path):
        if __debug__:
            self.set_header('Cache-control', 'no-store, no-cache, must-revalidate, max-age=0')

    def head(self, bearer):
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
        self.write(result)

    @auth
    @coroutine
    def post(self):
        database = self.settings['database']
        users = database.users
        fields = {}
        for key, value in self.json_body.items():
            fields['settings.%s' % key] = value

        yield users.update({'username': self.user}, {'$set': fields}, 
                              upsert=False, multi=False)

class UserRecordsHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        pass

    @auth
    @coroutine
    def post(self):
        pass

class UsersHandler(ApiHandler):

    @coroutine
    def get(self):     
        database = self.settings['database']
        users = database.users
        
        result = yield users.find_one(self.json_body)
        params = {}
        for key in self.json_body.keys():
            params[key] = result is None

        self.write(params)

    @coroutine
    def post(self):
        user = self.json_body
        database = self.settings['database']
        general = self.settings['general']
        users = database.users
        facts = database.facts

        # Modify user a bit
        raw_password = user.pop('password')
        user['created'] = datetime.utcnow()
        user['updated'] = datetime.utcnow()
        # TODO: check date in jsonschema
        user['birthdate'] = datetime.strptime(user['birthdate'], '%Y-%m-%d')

        # Generate password hash
        # TODO: generate hash async
        salt = os.urandom(24)
        raw_password = raw_password.encode('utf-8')
        password = hashlib.sha256(salt + raw_password).digest()

        # Generate verify token
        verify_token = hashlib.sha1(os.urandom(128)).hexdigest()

        # Set default values
        settings = default_settings
        settings.update(user.get('settings', {}))
        user['settings'] = settings

        # Set private part
        private = {
            'salt': salt,
            'password': password,
            'verified': False,
            'vcode': verify_token
        }
        user['private'] = private

        # Prepare facts
        username = user['username']
        body = default_body
        body.update(user.pop('body', {}))
        index, nutrition = calculate_index(user, body)

        fact_body = {
            'username': username,
            'updated': datetime.utcnow(),
            'body': body,
            'index': index,
            'nutrition': nutrition
        }

        # Save user
        try:
            # TODO: make transactional query
            yield users.save(user)
            yield facts.save(fact_body)
        except DuplicateKeyError:
            raise HTTPError(400, 'User with same name or email already exists')

        # Send mail with verification
        mail = self.settings['mail']
        mail.send(
            'DietMaster',
            'support@dietmaster.io',
            user['email'],
            'Account verification',
            'verify',
            base_url=general['host'],
            user=username,
            url='https://dietmaster.io/verify/%s-%s' % (username, verify_token)
        )

        user.pop('_id')
        user.pop('private')

        self.write(user)

class AuthHandler(ApiHandler):
    
    @coroutine
    def post(self):
        username = self.json_body['username']
        password = self.json_body['password']

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
        self.write(token)

    @auth
    @coroutine
    def delete(self):
        database = self.settings['database']
        tokens = database.tokens
        yield tokens.remove({'_id': self.user})

class FoodHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        phrase = self.json_body['phrase']

        database = self.settings['database']
        food = database.food

        rexp = re.compile('^%s.*' % phrase, re.IGNORECASE)
        cursor = food.find({'fullname': rexp}, {'_id': 1, 'fullname': 1})
        result = yield cursor.to_list(length=10)

        self.write({'results': result})

class FoodIdHandler(ApiHandler):

    @auth
    @coroutine
    def get(self, id):
        database = self.settings['database']
        food = database.food

        result = yield food.find_one({'_id': ObjectId(id)})
        if not result:
            raise HTTPError(404, 'Product not found')

        self.write(result)