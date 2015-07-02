#!/usr/bin/env python

from google.appengine.api import taskqueue
from google.appengine.ext.ndb import QueryOptions, GenericProperty
from webapp2_extras.auth import InvalidPasswordError, InvalidAuthIdError

from webapp2_extras import json

from base import BaseHandler, RestHandler

import utils
import logging
from models import User

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
    properties = model._properties
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

class ObjectsHandler(BaseHandler):

    def get(selt):
        pass

    def post(self):
        pass

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
        options, count = prepare_options(self.request)
        filters = prepare_filters(self.request, self.user_model)

        result = []
        if not filters and count:
            result = 0
        else:
            user_query = self.user_model.query().filter(*filters)

            if count:
                result = user_query.count(None, options=options)
            else:
                user_query = user_query.fetch(None, options=options)
                for user in user_query:
                    result.append(user.to_dict())

        userjson = json.encode(result, default=utils.default)
        self.response.write(userjson)

    def post(self):
        email = self.json['email']
        username = self.json['username']
        password = self.json['password']

        unique_properties = ['email_address']
        user_data = self.user_model.create_user(
          username,
          unique_properties,
          email_address=email, 
          password_raw=password, 
          verified=False
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
                user = User.get_by_auth_password(username, password)
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

            user = User.token_model.get('', 'refresh', refresh_token)

            if not user:
                self.error(400, 'invalid credentials')

            responsejson = self.prepare_token(user)
            self.response.write(responsejson)
        else:
            self.error(406, 'Unsupported grant type')

    def prepare_token(self, user):
        token = User.create_auth_token(user.get_id())
        refresh = User.create_refresh_token(user.get_id())
        
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

