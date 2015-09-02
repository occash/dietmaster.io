#!/usr/bin/env python
# -*- coding: utf8 -*- 

from handlers import *

routes = [
    # Objects routes
    (r'/v1/objects/(\w+)', ObjectsHandler),
    #(r'/v1/objects/<collection:.+>/<id:.+>', ObjectsIdHandler),
    #(r'/v1/objects/<collection:.+>/<id:.+>/atomic', ObjectsIdAtomicHandler),
    #(r'/v1/objects/<collection:.+>/<id:.+>/access', ObjectsIdAccessHandler),
    # Search routes
    (r'/v1/search', SearchHandler),
    # Users routes
    (r'/v1/users', UsersHandler),
    #(r'/v1/users/<id:.+>', UsersIdHandler),
    #(r'/v1/users/<id:.+>/atomic', UsersIdAtomicHandler),
    #(r'/v1/users/<id:.+>/access', UsersIdAccessHandler),
    # User route
    #(r'/v1/user', UserHandler),
    # Authentication routes
    (r'/v1/auth/oauth2/token', AuthTokenHandler),
    #(r'/v1/auth/oauth2/revoke', AuthRevokeHandler),
    # Usergroups routes
    #(r'/v1/usergroups', UsergroupsHandler),
    #(r'/v1/usergroups/<id:.+>', UsergroupsIdHandler),
    #(r'/v1/usergroups/<id:.+>/atomic', UsergroupsIdAtomicHandler),
    #(r'/v1/usergroups/<id:.+>/access', UsergroupsIdAccessHandler),
    # Usergroup members route
    #(r'/v1/usergroups/<id:.+>/members', UsergroupsIdMembersHandler),
    # Files routes
    #(r'/v1/files', FilesHandler),
    #(r'/v1/files/<id:.+>/chunk', FilesIdChunkHandler),
    #(r'/v1/files/<id:.+>', FilesIdHandler),
    #('/v1/files/<id:.+>/download_url', FilesIdUrlHandler),
    # Other routes
    (r'/verify/(\w+)-(\w+)', VerifyHandler),
    #(r'/worker', WorkerHandler)
]