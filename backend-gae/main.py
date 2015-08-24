#!/usr/bin/env python

import webapp2
import logging

from mobile import *
from browser import *
from worker import *

config = {
  'webapp2_extras.auth': {
    'user_model': 'models.User',
    'user_attributes': ['name']
  },
  'webapp2_extras.sessions': {
    'secret_key': 'YOUR_SECRET_KEY'
  }
}

app = webapp2.WSGIApplication([
    # Objects routes
    webapp2.Route('/v1/objects/<collection:.+>', ObjectsHandler, name='objects'),
    webapp2.Route('/v1/objects/<collection:.+>/<id:.+>', ObjectsIdHandler, name='objects_id'),
    webapp2.Route('/v1/objects/<collection:.+>/<id:.+>/atomic', ObjectsIdAtomicHandler, name='objects_id_atomic'),
    webapp2.Route('/v1/objects/<collection:.+>/<id:.+>/access', ObjectsIdAccessHandler, name='objects_id_access'),
    # Search routes
    webapp2.Route('/v1/search', SearchHandler, name='search'),
    # Users routes
    webapp2.Route('/v1/users', UsersHandler, name='users'),
    webapp2.Route('/v1/users/<id:.+>', UsersIdHandler, name='users_id'),
    webapp2.Route('/v1/users/<id:.+>/atomic', UsersIdAtomicHandler, name='users_id_atomic'),
    webapp2.Route('/v1/users/<id:.+>/access', UsersIdAccessHandler, name='users_id_access'),
    # User route
    webapp2.Route('/v1/user', UserHandler, name='user'),
    # Authentication routes
    webapp2.Route('/v1/auth/oauth2/token', AuthTokenHandler, name='token'),
    webapp2.Route('/v1/auth/oauth2/revoke', AuthRevokeHandler, name='revoke'),
    # Usergroups routes
    webapp2.Route('/v1/usergroups', UsergroupsHandler, name='usergroups'),
    webapp2.Route('/v1/usergroups/<id:.+>', UsergroupsIdHandler, name='usergroups_id'),
    webapp2.Route('/v1/usergroups/<id:.+>/atomic', UsergroupsIdAtomicHandler, name='usergroups_id_atomic'),
    webapp2.Route('/v1/usergroups/<id:.+>/access', UsergroupsIdAccessHandler, name='usergroups_id_access'),
    # Usergroup members route
    webapp2.Route('/v1/usergroups/<id:.+>/members', UsergroupsIdMembersHandler, name='usergroups_id_members'),
    # Files routes
    webapp2.Route('/v1/files', FilesHandler, name='files'),
    webapp2.Route('/v1/files/<id:.+>/chunk', FilesIdChunkHandler, name='files_id_chunk'),
    webapp2.Route('/v1/files/<id:.+>', FilesIdHandler, name='files_id'),
    webapp2.Route('/v1/files/<id:.+>/download_url', FilesIdUrlHandler, name='files_id_url'),
    # Other routes
    webapp2.Route('/verify/<id:\d+>-<token:.+>', VerifyHandler, name='verify'),
    webapp2.Route('/worker', WorkerHandler, name='worker')
], debug=True, config=config)

logging.getLogger().setLevel(logging.DEBUG)
