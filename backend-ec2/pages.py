#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from base import PageHandler, webauth

class LoginPage(PageHandler):

    @coroutine
    def get(self):
        bearer = self.get_cookie('bearer', None)
        if bearer:
            database = self.settings['database']
            tokens = database['internal.tokens']

            # Get token
            token = yield tokens.find_one({'bearer': bearer})
            if token:
                self.redirect('/')

        html = self.render('login.html')
        self.write(html)

class HomePage(PageHandler):

    @webauth
    @coroutine
    def get(self):
        html = self.render('index.html')
        self.write(html)

class VerifyPage(PageHandler):
    
    def get(self):
        pass

class ResetPage(PageHandler):

    def get(self):
        pass