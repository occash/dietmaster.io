#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import RequestHandler, HTTPError
from tornado.gen import coroutine

from base import PageHandler

class LoginPage(PageHandler):

    def get(self):
        if self.current_user:
            self.redirect('/')
        else:
            html = self.render('login.html')
            self.write(html)

class HomePage(PageHandler):

    @coroutine
    def get(self):
        if self.current_user:
            '''database = self.settings['database']
            users = database.users
            user = yield users.find_one({'username': self.current_user.decode('utf-8')})
            if not user:
                self.clear_all_cookies()
                self.redirect('/login')'''

            html = self.render('index.html')
        else:
            html = 'Hello'

        self.write(html)