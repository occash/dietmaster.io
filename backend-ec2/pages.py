#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from base import PageHandler

class LoginPage(PageHandler):

    @coroutine
    def get(self):
        user = yield self.current_user()
        if user:
            self.redirect('/')
        else:
            html = self.render('login.html')
            self.write(html)

class HomePage(PageHandler):

    @coroutine
    def get(self):
        user = yield self.current_user()
        if user:
            html = self.render('index.html')
        else:
            html = 'Hello'

        self.write(html)

class VerifyPage(PageHandler):
    
    def get(self):
        pass

class ResetPage(PageHandler):

    def get(self):
        pass