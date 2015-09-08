#!/usr/bin/env python
# -*- coding: utf8 -*- 

import os
import hashlib
import logging

from datetime import datetime

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from jsonschema import SchemaError, ValidationError
from bson.json_util import loads, dumps

from pymongo.errors import OperationFailure

from models import Models

class BaseHandler(RequestHandler):

    def parse_body(self):
        try:
            body = self.request.body
            body = body.decode('utf-8')
            return None if not body else loads(body)
        except:
            raise HTTPError(400, 'Invalid request body')

    def write_error(self, status_code, **kwargs):
        if status_code == 500:
            self.write('Internal server error')

        if 'message' in kwargs:
            self.write(kwargs['message'])

        if 'exc_info' in kwargs and issubclass(kwargs['exc_info'][0], HTTPError):
            self.write(kwargs['exc_info'][1].log_message)

    def get_current_user(self):
        return self.get_secure_cookie("user")

class UsersHandler(BaseHandler):

    @coroutine
    def get(self):
        database = self.settings['database']
        users = database.users
        options = QueryOptions(self)

        cursor = users.find(options.query)
        cursor = cursor.limit(options.limit)
        cursor = cursor.skip(options.offset)

        if options.count:
            result = yield cursor.count(with_limit_and_skip=True)
            json_users = { 'count': result }
        else:
            result = yield cursor.to_list(None)
            json_users = { 'results': result }

        self.finish(dumps(json_users))

    @coroutine
    def post(self):
        # Parse body
        user_body = self.parse_body()

        if not user_body['tnc']:
            raise HTTPError(400, 'Accept terms first')
        
        # Remove unused fields
        del user_body['tnc']
        del user_body['rpassword']

        # Validate model
        try:
            Models.users.validate(user_body)
        except SchemaError:
            raise HTTPError(500, 'Invalid JSON schema')
        except ValidationError as e:
            raise HTTPError(400, 'JSON body not valid')

        # Get collections
        database = self.settings['database']
        users = database.users
        internal_users = database.internal.users

        # Modify user a bit
        raw_password = user_body.pop('password')
        user_body['created'] = datetime.utcnow()
        user_body['birthdate'] = datetime.strptime(user_body['birthdate'], '%Y-%m-%d')

        # Generate password hash
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
            'token': verify_token,
            'usergroups': []
        }

        # Save internal part
        try:
            yield users.save(user_body)
            yield internal_users.save(internal_body)
        except OperationFailure:
            raise HTTPError(500, 'Cannot save user')

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

class LoginHandler(BaseHandler):
    
    @coroutine
    def post(self):
        username = self.get_argument('username', None)
        password = self.get_argument('password', None)

        if not username or not password:
            raise HTTPError(403, 'No credentials supplied')

        database = self.settings['database']
        users = database['internal.users']

        user = yield users.find_one({'_id': username})
        if not user:
            raise HTTPError(403, 'User not found')

        salt = user['salt']
        rawpassword = password.encode('utf-8')
        hexpass = hashlib.sha256(salt + rawpassword).digest()

        if not hexpass == user['password']:
            raise HTTPError(403, 'Wrong password')

        self.set_secure_cookie('user', user['_id'], expires_days=7)

class LogoutHandler(BaseHandler):

    @coroutine
    def post(self):
        self.clear_all_cookies()

class ResetHandler(BaseHandler):

    @coroutine
    def post(self):
        pass