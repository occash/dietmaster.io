#!/usr/bin/env python
# -*- coding: utf8 -*- 

import os
import re
import hashlib
import logging

from datetime import datetime, timedelta

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from jsonschema import SchemaError, ValidationError
from pymongo.errors import OperationFailure

from bson.objectid import ObjectId
from bson.json_util import loads, dumps

from models import Models

EXPIRES_IN = 11800

def add_date_internal(json):
    json['createdAt'] = datetime.utcnow()
    json['updatedAt'] = datetime.utcnow()

def add_user_internal(json, userId):
    json['creator'] = userId
    json['updater'] = userId

def auth(func):

    @coroutine
    def check_auth(self, *args, **kwargs):
        auth = self.request.headers['Authorization']
        bearer = auth[7:]

        database = self.settings['database']
        tokens = database['internal.tokens']

        # Get token
        token = yield tokens.find_one({'access_token': bearer})
        if not token:
            raise HTTPError(401, 'Access token expired')

        result = yield func(self, *args, **kwargs)

    return check_auth

class QueryOptions:

    def __init__(self, request):
        super(QueryOptions, self).__init__()

        q = request.get_argument('q', None)
        sort = request.get_argument('sort', None)
        limit = request.get_argument('limit', 0)
        offset = request.get_argument('offset', 0)
        count = request.get_argument('count', None)
        include = request.get_argument('include', None)

        query = {} if not q else loads(q)
        sort = {} if not sort else loads(sort)
        limit = int(limit)
        offset = int(offset)
        count = count is not None
        include = {} if not include else loads(include)

        self.query = query
        self.sort = sort
        self.limit = limit
        self.offset = offset
        self.count = count
        self.include = include

class BaseHandler(RequestHandler):

    def error(self, code, message):
        self.clear()
        self.set_status(code)
        self.finish(message)

    def parse_body(self):
        body = self.request.body
        body = body.decode('utf-8')
        return None if not body else loads(body)

    def write_error(self, status_code, **kwargs):
        if status_code == 500:
            self.write('Internal server error')

        if 'message' in kwargs:
            self.write(kwargs['message'])

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
        try:
            user_body = self.parse_body()
            Models.users.validate(user_body)

            database = self.settings['database']
            users = database.users
            internal_users = database.internal.users

            raw_password = user_body.pop('password')
            add_date_internal(user_body)

            user_id = yield users.save(user_body)

            salt = os.urandom(24)
            raw_password = raw_password.encode('utf-8')
            password = hashlib.sha256(salt + raw_password).digest()
            username = user_body['username']

            internal_body = {
                '_id': username,
                'salt': salt,
                'password': password,
                'usergroups': []
            }

            internal_id = yield internal_users.save(internal_body)

            self.write(dumps(user_body))
        except SchemaError:
            self.error(500, 'Invalid JSON schema')
        except ValidationError:
            self.error(400, 'JSON body not valid')
        except OperationFailure:
            self.error(400, 'Object could not be saved')

class AuthTokenHandler(BaseHandler):

    @coroutine
    def post(self):
        grant_type = self.get_argument('grant_type', None)
        username = self.get_argument('username', None)
        password = self.get_argument('password', None)

        if not grant_type == 'password':
            raise HTTPError(403, 'Auth type not supported')

        if not username or not password:
            raise HTTPError(401, 'Auth data required')

        database = self.settings['database']
        users = database['internal.users']
        tokens = database['internal.tokens']

        user = yield users.find_one({'_id': username})
        if not user:
            raise HTTPError(401, 'User not found')

        salt = user['salt']
        rawpassword = password.encode('utf-8')
        hexpass = hashlib.sha256(salt + rawpassword).digest()

        if not hexpass == user['password']:
            raise HTTPError(401, 'Invalid credentials')

        token = yield tokens.find_one({'_id': username})
        if not token:
            bearer = hashlib.sha1(os.urandom(128)).hexdigest()
            refresh = hashlib.sha1(os.urandom(128)).hexdigest()
            expires = datetime.utcnow() + timedelta(seconds=EXPIRES_IN)

            token = {
                '_id': username,
                'access_token': bearer,
                'refresh_token': refresh,
                'expires_in': expires
            }

            result = yield tokens.save(token)

        # TODO: add engine data
        '''
            'engine_data': {
                'user': user,
                'usergroups': []
            }
        '''

        real_expires = token['expires_in']
        token['expires_in'] = (real_expires - datetime.utcnow()).seconds

        self.finish(token)

class ObjectsHandler(BaseHandler):

    @auth
    def post(self, collection):
        try:
            json_body = self.parse_body()
            object_model = getattr(models, collection, None)
            if not object_model:
                self.error(404, 'Collection not found')
                return
             
            user = object_model(**json_body).save()
            self.write(user.to_json())
        except OperationError:
            self.error(400, 'Object could not be saved')

    @auth
    @coroutine
    def get(self, collection):
        database = self.settings['database']
        objects = database['objects.' + collection]
        options = QueryOptions(self)

        cursor = objects.find(options.query)
        cursor = cursor.limit(options.limit)
        cursor = cursor.skip(options.offset)

        if options.count:
            result = yield cursor.count(with_limit_and_skip=True)
            json_objects = { 'count': result }
        else:
            result = yield cursor.to_list(None)
            json_objects = { 'results': result }

        self.finish(json_objects)

class SearchHandler(BaseHandler):

    @auth
    @coroutine
    def get(self):
        include = self.get_argument('include', None)
        collection = self.get_argument('objectTypes[]', None)
        search = self.get_argument('search', None)
        limit = self.get_argument('limit', 0)
        offset = self.get_argument('offset', 0)

        include = {} if not include else loads(include)
        search = {} if not search else loads(search)
        limit = int(limit)
        offset = int(offset)

        database = self.settings['database']
        model = database[collection]
        field = search['properties'][0]
        value = search['phrase']

        cursor = model.find({field: re.compile(value, re.IGNORECASE)})
        cursor = cursor.limit(limit)
        cursor = cursor.skip(offset)

        objects = yield cursor.to_list(None)

        self.finish(dumps({'results': objects}))
