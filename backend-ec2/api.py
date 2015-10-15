#!/usr/bin/env python
# -*- coding: utf8 -*- 

import os
import hashlib
import logging

from datetime import datetime, timedelta
from tornado.gen import coroutine
from pymongo.errors import DuplicateKeyError
from base import ApiHandler, StreamApiHandler, auth, dumps

class UserHandler(ApiHandler):

    @auth
    @coroutine
    def get(self):
        database = self.settings['database']
        users = database.users
        user = yield users.find_one({'username': self.user})
        if not user:
            raise HTTPError(404, 'User not found')

        self.write(dumps(user))

class UserFactsHandler(ApiHandler):
    pass

class UserPhotoHandler(ApiHandler):
    pass

class UserSettingsHandler(ApiHandler):
    
    @coroutine
    def get(self):
        settings = {
            'language': 'en',
            'measure': 'me',
            'theme': 'light'
        }
        self.write(settings)

    @coroutine
    def post(self):
        pass

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

        self.write({key: result is not None})

    @coroutine
    def post(self):
        # Parse body
        user_body = self.json_body

        # Modify user a bit
        raw_password = user_body.pop('password')
        user_body['created'] = datetime.utcnow()
        user_body['birthdate'] = datetime.strptime(user_body['birthdate'], '%Y-%m-%d')

        database = self.settings['database']
        users = database.users
        internal_users = database['internal.users']

        # Generate password hash
        # TODO: generate hash async
        salt = os.urandom(24)
        raw_password = raw_password.encode('utf-8')
        password = hashlib.sha256(salt + raw_password).digest()

        # Generate verify token
        verify_token = hashlib.sha1(os.urandom(128)).hexdigest()

        username = user_body['username']
        internal_body = {
            '_id': username,
            'salt': salt,
            'password': password,
            'verified': False,
            'token': verify_token
        }

        # Save user
        try:
            # TODO: make transactional query
            yield users.save(user_body)
            yield internal_users.save(internal_body)
        except DuplicateKeyError as e:
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

        self.write(dumps(user_body))

class AuthHandler(ApiHandler):
    
    @coroutine
    def post(self):
        username = self.get_argument('username', None)
        password = self.get_argument('password', None)

        if not username or not password:
            raise HTTPError(400, 'No credentials supplied')

        database = self.settings['database']
        users = database['internal.users']
        tokens = database['internal.tokens']

        user = yield users.find_one({'_id': username})
        if not user:
            raise HTTPError(404, 'User not found')

        salt = user['salt']
        rawpassword = password.encode('utf-8')
        hexpass = hashlib.sha256(salt + rawpassword).digest()

        if not hexpass == user['password']:
            raise HTTPError(400, 'Incorrect password')

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

        self.finish(dumps(token))

    @coroutine
    def delete(self):
        bearer = self.get_argument('bearer', None)
        if not bearer:
            raise HTTPError(403, 'No token supplied')

        database = self.settings['database']
        tokens = database['internal.tokens']
        yield tokens.remove({'bearer': bearer})
