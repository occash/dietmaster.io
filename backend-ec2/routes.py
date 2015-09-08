#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import StaticFileHandler

from api import *
from pages import *

routes = [
    # Api handlers
    (r'/api/users', UsersHandler),
    (r'/api/login', LoginHandler),
    (r'/api/logout', LogoutHandler),
    (r'/api/reset', ResetHandler),

    # Site handlers
    (r'/app/login', LoginPage),
    (r'/app/home', HomePage),
    (r'/(.*)', StaticFileHandler, {'path': r'web/'})
]