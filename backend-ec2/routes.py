#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import StaticFileHandler

from api import *
from pages import *

routes = [
    # Api handlers
    (r'/api/user', UserHandler),
    (r'/api/user/facts', UserFactsHandler),
    (r'/api/user/photo', UserPhotoHandler),
    (r'/api/users', UsersHandler),
    (r'/api/auth', AuthHandler),

    # Site handlers
    (r'/login', LoginPage),
    (r'/reset', ResetPage),
    (r'/verify', VerifyPage),
    (r'/', HomePage),
    (r'/(.*)', StaticFileHandler, {'path': r'web/'})
]