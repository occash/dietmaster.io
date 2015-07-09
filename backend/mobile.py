#!/usr/bin/env python
# -*- coding: utf-8 -*-

from google.appengine.api import taskqueue
from google.appengine.ext.ndb import QueryOptions, GenericProperty
from webapp2_extras.auth import InvalidPasswordError, InvalidAuthIdError

from webapp2_extras import json

from base import BaseHandler, RestHandler

import utils
import logging

from jsonschema import validate
from jsonschema import ValidationError, SchemaError

import models
import schemas

class EmptyModelError(Exception):
    pass

def auth(func):

    def check_auth(self, *args, **kwargs):
        auth = self.request.headers['Authorization']
        bearer = auth[7:]
        user = None

        # Get token
        token_obj = User.token_model.get('', 'auth', bearer)
        if token_obj:
            user = User.get_by_id(int(token_obj.user))

        if not user:
            self.error(401, 'authorization required')
            return

        func(self, *args, **kwargs)

    return check_auth

def prepare_filters(request, model):
    q = request.get('q', None)
    query = {} if not q else json.decode(q)

    filters = ()
    for key, value in query.iteritems():
        property = getattr(model, key, None)
        if not property:
            property = GenericProperty(key)

        filter = (property == value)
        filters = filters + (filter,)

    logging.info(filters)

    return filters

def prepare_sort(request, model):
    sort = request.get('sort', None)
    sort = {} if not sort else json.decode(sort)

    logging.info(sort)

    return sort

def prepare_options(request):
    limit = request.get('limit', None)
    offset = request.get('offset', 0)
    count = request.get('count', True)
    include = request.get('include', None)

    limit = int(limit) if limit else None
    offset = int(offset)
    count = not count
    include = {} if not include else json.decode(include)

    fields = []
    for field, value in include.iteritems():
        if not isinstance(value, dict):
            fields.append(field)

    fields = fields if fields else None

    options = QueryOptions(
        projection=fields,
        limit=limit,
        offset=offset,
        keys_only=count)

    logging.info(options)

    return options, count

def query_objects(request, type):
    model = getattr(models, type, None)
    if model is None:
        raise EmptyModelError()

    options, count = prepare_options(request)
    filters = prepare_filters(request, model)
    sort = prepare_sort(request, model)

    result = []
    response = ''
    if not filters and count:
        result = 0
    else:
        query = model.query().filter(*filters)

        if count:
            result = query.count(None, options=options)
            response = json.encode({'count': result}, default=utils.default)
        else:
            query = query.fetch(None, options=options)
            for user in query:
                result.append(user.to_dict())
            response = json.encode({'results': result}, default=utils.default)

    return response

def validate_schema(name, body):
    # Check JSON schema
    json_body = None if not body else json.decode(body)
    jsonSchema = getattr(schemas, name, None)
    if jsonSchema:
        validate(json_body, jsonSchema)

    return json_body

class ObjectsHandler(BaseHandler):

    #@auth
    def get(self, *args, **kwargs):
        collection = kwargs['collection']
        try:
            result = query_objects(self.request, collection)
            logging.info(result)
            self.response.write(result)
        except EmptyModelError:
            self.error(404, 'Objects %s not found' % collection)

    def post(self, *args, **kwargs):
        collection = kwargs['collection']
        json_body = {}

        try:
            json_body = validate_schema(collection, self.request.body)
        except SchemaError as s:
            self.error(500, s.message)
            return
        except ValidationError as v:
            self.error(400, v.message)
            return

        model = getattr(models, collection, None)
        if not model:
            self.error(404, 'No such collection')
            return

        instance = model(**json_body)
        instance.put()
        
        instancejson = json.encode(instance.to_dict(), default = utils.default)
        self.response.write(instancejson)

class ObjectsIdHandler(BaseHandler):

    def get(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class ObjectsIdAtomicHandler(BaseHandler):

    def put(self):
        pass

class ObjectsIdAccessHandler(BaseHandler):

    def get(self):
        pass

    def post(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class SearchHandler(BaseHandler):

    def get(self):
        pass

class UsersHandler(BaseHandler):

    #@auth
    def get(self):
        try:
            result = query_objects(self.request, 'User')
            logging.info(result)
            self.response.write(result)
        except EmptyModelError:
            self.error(404, 'Objects User not found')

    def post(self):
        json_body = {}

        try:
            json_body = validate_schema('users', self.request.body)
        except SchemaError as s:
            self.error(500, s.message)
            return
        except ValidationError as v:
            self.error(400, v.message)
            return

        username = json_body.pop('username')
        password = json_body.pop('password')

        unique_properties = ['email']
        user_data = self.user_model.create_user(
          username,
          unique_properties,
          password_raw=password, 
          verified=False,
          **json_body
        )

        if not user_data[0]: #user_data is a tuple
            self.error(400, 'email already in use')
            return
    
        user = user_data[1]
        user_id = user.get_id()

        taskqueue.add(url='/worker', params={'id': user_id})

        # Return user in JSON format
        userjson = json.encode(user.to_dict(), default = utils.default)
        self.response.write(userjson)

class UsersIdHandler(BaseHandler):

    def get(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class UsersIdAtomicHandler(BaseHandler):

    def put(self):
        pass

class UsersIdAccessHandler(BaseHandler):

    def get(self):
        pass

    def post(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class UserHandler(BaseHandler):

    def get(self):
        pass

class AuthTokenHandler(BaseHandler):

    def post(self):
        grant_type = self.request.get("grant_type")

        if grant_type == 'password':
            username = self.request.get("username")
            password = self.request.get("password")

            try:
                user = self.user_model.get_by_auth_password(username, password)
            except InvalidPasswordError:
                self.error(400, 'invalid password')
                return
            except InvalidAuthIdError:
                self.error(400, 'invalid credentials')
                return
            
            responsejson = self.prepare_token(user)
            self.response.write(responsejson)
        elif grant_type == 'refresh_token':
            refresh_token = self.request.get("refresh_token")

            user = self.user_model.token_model.get('', 'refresh', refresh_token)

            if not user:
                self.error(400, 'invalid credentials')

            responsejson = self.prepare_token(user)
            self.response.write(responsejson)
        else:
            self.error(406, 'Unsupported grant type')

    def prepare_token(self, user):
        token = self.user_model.create_auth_token(user.get_id())
        refresh = self.user_model.create_refresh_token(user.get_id())
        
        response = {
            "access_token": token,
            "refresh_token": refresh,
            "expires_in": 1,
            "enginio_data": {
                "user": user.to_dict(),
                "usergroups": []
            }
        }

        return json.encode(response, default = utils.default)

class AuthRevokeHandler(RestHandler):

    def post(self):
        token = self.request.get("token")

        if not token:
            self.error(400, 'token not found')

class UsergroupsHandler(BaseHandler):

    def get(selt):
        pass

    def post(self):
        pass

class UsergroupsIdHandler(BaseHandler):

    def get(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class UsergroupsIdAtomicHandler(BaseHandler):

    def put(self):
        pass

class UsergroupsIdAccessHandler(BaseHandler):

    def get(self):
        pass

    def post(self):
        pass

    def put(self):
        pass

    def delete(self):
        pass

class UsergroupsIdMembersHandler(BaseHandler):

    def get(self):
        pass

    def post(self):
        pass

    def delete(self):
        pass

class FilesHandler(BaseHandler):

    def post(self):
        pass

class FilesIdChunkHandler(BaseHandler):

    def put(self):
        pass

class FilesIdHandler(BaseHandler):

    def get(self):
        pass

class FilesIdUrlHandler(BaseHandler):

    def get(self):
        pass

