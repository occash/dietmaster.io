#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from template import Template

class PageHandler(RequestHandler):
    template = Template('web')

    def render(self, name, **params):
        return PageHandler.template.render(name, **params)

class LoginPage(PageHandler):

    def get(self):
        html = self.render('login.html')
        self.write(html)

class HomePage(PageHandler):

    def get(self):
        html = self.render('index.html')
        self.write(html)