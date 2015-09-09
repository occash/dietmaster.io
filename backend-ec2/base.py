#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError

from template import Template

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

class PageHandler(BaseHandler):
    template = Template('web')

    def render(self, name, **params):
        return PageHandler.template.render(name, **params)