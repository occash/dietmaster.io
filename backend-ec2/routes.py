#!/usr/bin/env python
# -*- coding: utf8 -*- 

from tornado.web import StaticFileHandler

from api import *

routes = [
    (r'/api/users', UsersHandler),
    (r'/api/login', LoginHandler),
    (r'/api/logout', LogoutHandler),
    (r'/api/reset', ResetHandler),
    (r'/(.*)', StaticFileHandler, {'path': r'web/'})
]