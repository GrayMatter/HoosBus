#!/usr/bin/env python

import webapp2 as webapp

class MainHandler(webapp.RequestHandler):
    def get(self):        
        self.response.out.write('OK')

#
# Application
#
application = webapp.WSGIApplication([('/', MainHandler)], debug=False)