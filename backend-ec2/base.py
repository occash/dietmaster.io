#!/usr/bin/env python
# -*- coding: utf8 -*-

import json 
from json import JSONEncoder, JSONDecoder
from jsonschema import validate, ValidationError
from urllib.parse import parse_qsl

from tornado.web import RequestHandler, StaticFileHandler, HTTPError
from tornado.gen import coroutine
from tornado.httputil import _parse_header

from bson.objectid import ObjectId
from datetime import datetime

from template import Template

class MongoEncoder(JSONEncoder):

    def default(self, obj):
        if isinstance(obj, ObjectId):
            return str(obj)
        if isinstance(obj, datetime):
            return obj.strftime('%Y-%m-%d')

        return JSONEncoder.default(self, obj)

def dumps(obj, *args, **kwargs):
    return json.dumps(obj, cls=MongoEncoder, *args, **kwargs)

def loads(obj, *args, **kwargs):
    return json.loads(obj, *args, **kwargs)

def auth(func):

    @coroutine
    def check_auth(self, *args, **kwargs):
        bearer = self.request.headers.get('bearer', None)
        if not bearer:
            raise HTTPError(400, 'Access token required')

        database = self.settings['database']
        tokens = database.tokens

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
        tokens = database.tokens

        # Get token
        token = yield tokens.find_one({'bearer': bearer})
        if not token:
            self.redirect('/login')
            return

        self.user = token['_id']
        result = yield func(self, *args, **kwargs)

    return check_auth

def parse_accept_header(accept):
    '''
    Parse the Accept header *accept*, returning a list with 3-tuples of
    [(str(media_type), dict(params), float(q_value)),] ordered by q values.
    If the accept header includes vendor-specific types like::
        application/vnd.yourcompany.yourproduct-v1.1+json
    It will actually convert the vendor and version into parameters and 
    convert the content type into `application/json` so appropriate content
    negotiation decisions can be made.
    Default `q` for values that are not specified is 1.0
    '''
    result = []
    for media_range in accept.split(','):
        parts = media_range.split(';')
        media_type = parts.pop(0).strip()
        media_params = []
        # convert vendor-specific content types into something useful (see
        # docstring)
        typ, subtyp = media_type.split('/')
        # check for a + in the sub-type
        if '+' in subtyp:
            # if it exists, determine if the subtype is a vendor-specific type
            vnd, sep, extra = subtyp.partition('+')
            if vnd.startswith('vnd'):
                # and then... if it ends in something like "-v1.1" parse the
                # version out
                if '-v' in vnd:
                    vnd, sep, rest = vnd.rpartition('-v')
                    if len(rest):
                        # add the version as a media param
                        try:
                            version = media_params.append(('version', 
                                                           float(rest)))
                        except ValueError:
                            version = 1.0 # could not be parsed
                # add the vendor code as a media param
                media_params.append(('vendor', vnd))
                # and re-write media_type to something like application/json so
                # it can be used usefully when looking up emitters
                media_type = '{}/{}'.format(typ, extra)
        q = 1.0
        for part in parts:
            (key, value) = part.lstrip().split('=', 1)
            key = key.strip()
            value = value.strip()
            if key == 'q':
                q = float(value)
            else:
                media_params.append((key, value))
        result.append((media_type, dict(media_params), q))
    result.sort(key=lambda obj: obj[2])
    return result

class ApiHandler(RequestHandler):

    response_types = ['*/*', 'application/json']

    def set_default_headers(self):
        self.set_header('Accept', 'application/json')

    def prepare(self):
        if not getattr(self, self.request.method.lower(), None):
            raise HTTPError(405, 'Method not allowed')

        # Check content type
        accept_types = self.request.headers.get('Accept', '*/*')
        accept_types = parse_accept_header(accept_types)
        best_match = None
        for accept_type in accept_types:
            if accept_type[0] in self.response_types:
                self.response_type = accept_type[0]
                break
        
        if not self.response_type:
            raise HTTPError(406, 'Not acceptable')

        content_type = self.request.headers.get('Content-Type', 'application/x-www-form-urlencoded')
        content_type, params = _parse_header(content_type)
        if self.request.method == 'GET':
            body = self.request.query
        else:
            body = self.request.body
            body = body.decode(params.get('charset', 'UTF-8'))

        # Parse body
        if content_type == 'application/x-www-form-urlencoded':
            try:
                body = dict(parse_qsl(body))
            except Exception as e:
                raise HTTPError(400, 'Invalid query string')
        elif content_type == 'application/json':
            try:
                body = loads(body) if body else None
            except Exception as e:
                raise HTTPError(400, 'Invalid JSON body')
        else:
            raise HTTPError(415, 'Unsupported Media Type')

        # Find schema
        schema = self.settings['schema']
        class_schema = schema.get(self.__class__.__name__, None)
        method_schema = class_schema.get(self.request.method, None)

        # Validate schema
        try:
            validate(body, method_schema)
            self.json_body = body
        except ValidationError as e:
            raise HTTPError(400, 'Invalid value: %s' % e.message)

    # Write content according to accept type
    def write_content(self, obj):
        if self.response_type == '*/*':
            self.write(dumps(obj))
        elif self.response_type == 'application/json':
            self.write(dumps(obj))
        else:
            raise HTTPError(406, 'Not acceptable')

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

class StreamApiHandler(StaticFileHandler):
    pass

class PageHandler(RequestHandler):
    template = Template('web')

    def render(self, name, **params):
        return PageHandler.template.render(name, **params)

class PageNotFound(PageHandler):
    
    def get(self):
        html = self.render('404.html')
        self.write(html)
