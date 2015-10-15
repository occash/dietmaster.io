#!/usr/bin/env python
# -*- coding: utf8 -*-

from json import loads as jloads, dumps as jdumps
from jsonschema import validate, ValidationError

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from bson.objectid import ObjectId
from datetime import date

from template import Template

def json_convert(obj):
    for k, v in obj.items():
        if isinstance(obj[k], ObjectId):
            obj[k] = str(obj[k])
        if isinstance(obj[k], date):
            obj[k] = obj[k].strftime('%Y-%m-%d')

    return obj

def dumps(obj, *args, **kwargs):
    return jdumps(json_convert(obj), *args, **kwargs)

def auth(func):

    @coroutine
    def check_auth(self, *args, **kwargs):
        bearer = self.request.headers.get('bearer', None)
        if not bearer:
            raise HTTPError(400, 'Access token required')

        database = self.settings['database']
        tokens = database['internal.tokens']

        # Get token
        token = yield tokens.find_one({'bearer': bearer})
        if not token:
            raise HTTPError(401, 'Access token expired')

        self.user = token['_id']
        result = yield func(self, *args, **kwargs)

    return check_auth

def webauth(func):

    @coroutine
    def check_auth(self, *args, **kwargs):
        bearer = self.get_cookie('bearer', None)
        if not bearer:
            self.redirect('/login')

        database = self.settings['database']
        tokens = database['internal.tokens']

        # Get token
        token = yield tokens.find_one({'bearer': bearer})
        if not token:
            self.redirect('/login')

        self.user = token['_id']
        result = yield func(self, *args, **kwargs)

    return check_auth

class ApiHandler(RequestHandler):

    def prepare(self):
        if not getattr(self, self.request.method.lower(), None):
            raise HTTPError(405, 'Method not allowed')

        # Find schema
        schema = self.settings['schema']
        class_schema = schema.get(self.__class__.__name__, None)
        method_schema = class_schema.get(self.request.method, None)

        # Parse JSON body
        try:
            body = self.request.body
            body = jloads(body.decode('utf-8')) if body else None
        except:
            raise HTTPError(400, 'Invalid body')
        
        # Validate schema
        try:
            validate(body, method_schema)
            self.json_body = body
        except ValidationError as e:
            raise HTTPError(400, 'Invalid value: %s' % e.message)

    def write_error(self, status_code, **kwargs):
        # Handle internal error
        if status_code == 500:
            # TODO: send email to admins
            self.write('Internal server error')

        # Write raw message if available
        if 'message' in kwargs:
            self.write(kwargs['message'])

        # Write HTTError message (most common)
        if 'exc_info' in kwargs and issubclass(kwargs['exc_info'][0], HTTPError):
            self.write(kwargs['exc_info'][1].log_message)

class PageHandler(RequestHandler):
    template = Template('web')

    def render(self, name, **params):
        return PageHandler.template.render(name, **params)

class PageNotFound(PageHandler):
    
    def get(self):
        html = self.render('404.html')
        self.write(html)
