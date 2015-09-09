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
    (r'/api/reset', ResetHandler),

    # Site handlers
    (r'/login', LoginPage),
    (r'/', HomePage),
    (r'/(.*)', StaticFileHandler, {'path': r'web/'})
]