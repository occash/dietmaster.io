#!/usr/bin/env python

import webapp2
import logging

from webapp2_extras import auth
from webapp2_extras import json

from google.appengine.ext.webapp import template

import os
import schemas

from jsonschema import validate
from jsonschema import ValidationError, SchemaError


class BaseHandler(webapp2.RequestHandler):

    @webapp2.cached_property
    def auth(self):
        return auth.get_auth()

    @webapp2.cached_property
    def user_model(self):  
        return self.auth.store.user_model

    # Write error ressponse
    def error(self, status, message):
        self.response.status_int = status
        self.response.write(message)

    # Handle exceptions
    def handle_exception(self, exception, debug):
        logging.exception(exception)

        if isinstance(exception, webapp2.HTTPException):
            self.response.set_status(exception.code)
        else:
            self.response.set_status(500)

        self.response.write('an error occurred')

    # Render template
    def render(self, filename, params={}):
        path = os.path.join(os.path.dirname(__file__), 'views', filename)
        return template.render(path, params)


class RestHandler(BaseHandler):

    # Dispath
    def dispatch(self):
        '''# Check version
        xversion = ''
        if 'X-API-VERSION' not in self.request.headers:
            self.error(406, 'version required')
            return
        
        version = self.request.headers['X-API-VERSION']
        if version != "1.0":
            self.error(406, 'wrong version')
            return'''

        # Check JSON schema
        self.json = None if not self.request.body else json.decode(self.request.body)
        schemaClass = getattr(schemas, self.__class__.__name__, None)
        if schemaClass is not None:
            jsonSchema = getattr(schemaClass, self.request.method, None)
            if jsonSchema is None and self.json is not None:
                self.error(400, 'JSON body not expected')
                return

            try:
                validate(self.json, jsonSchema)
            except SchemaError:
                self.error(500, 'invalid JSON schema')
                return
            except ValidationError:
                self.error(400, 'JSON body not valid')
                return

        super(BaseHandler, self).dispatch()