#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import StaticFileHandler

from base import *
from api import *
from pages import *

routes = [
    # Api handlers
    (r'/api/user', UserHandler),
    (r'/api/user/facts', UserFactsHandler),
    (r'/api/user/photo/(.+)', UserPhotoHandler, {'path': '/'}),
    (r'/api/user/settings', UserSettingsHandler),
    (r'/api/user/records', UserRecordsHandler),
    (r'/api/users', UsersHandler),
    (r'/api/auth', AuthHandler),
    (r'/api/food', FoodHandler),
    (r'/api/food/(\w+)', FoodIdHandler),
    (r'/api/.*', ApiNotFound),

    # Site handlers
    (r'/login', LoginPage),
    (r'/reset', ResetPage),
    (r'/verify', VerifyPage),
    (r'/', HomePage),
    (r'.*', PageNotFound)
]