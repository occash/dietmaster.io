"""
`appengine_config.py` is automatically loaded when Google App Engine
starts a new instance of your application. This runs before any
WSGI applications specified in app.yaml are loaded.
"""

from google.appengine.ext import vendor
from google.appengine.ext.appstats import recording

# Third-party libraries are stored in "lib", vendoring will make
# sure that they are importable by the application.
vendor.add('lib')

# Calculate cost based on statistics
appstats_CALC_RPC_COSTS = True

# Gather statistics
def webapp_add_wsgi_middleware(app):
  app = recording.appstats_wsgi_middleware(app)
  return app