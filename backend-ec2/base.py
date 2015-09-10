#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from template import Template

def auth(func):

    @coroutine
    def check_auth(self, *args, **kwargs):
        bearer = self.request.headers['bearer']

        database = self.settings['database']
        tokens = database['internal.tokens']

        # Get token
        token = yield tokens.find_one({'bearer': bearer})
        if not token:
            raise HTTPError(401, 'Access token expired')

        self.user = token['_id']
        result = yield func(self, *args, **kwargs)

    return check_auth

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

class PageHandler(BaseHandler):
    template = Template('web')

    def render(self, name, **params):
        return PageHandler.template.render(name, **params)

    @coroutine
    def current_user(self):
        bearer = self.get_cookie("bearer")
        if not bearer:
            return None

        database = self.settings['database']
        tokens = database['internal.tokens']

        # Get token
        token = yield tokens.find_one({'bearer': bearer})

        return token['_id'] if token else None