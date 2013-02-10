#!/usr/bin/env python

import fix_path
import webapp2 as webapp
from decorators import *
from models import *
import json, re, logging, datetime

#
# Cinema
#

# class CinemasHandler(webapp.RequestHandler):
#     @memcached (24 * 60 * 60)
#     def get(self):
#         cinemas = Cinema.all()
#         return json.dumps([c.toJSON() for c in cinemas])


#
# Router
#
routes = [
    # (r'/v2/movies', MoviesHandler)
]

application = webapp.WSGIApplication(routes, debug=False)
