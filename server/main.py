#!/usr/bin/env python

import wsgiref.handlers
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db
import simplejson
import logging
import datetime

class Device(db.Model):
    udid = db.StringProperty()
    expiryDate = db.DateTimeProperty()

class MainHandler(webapp.RequestHandler):
    def get(self):
        logging.info("main handler")

class ExpiryDateHandler(webapp.RequestHandler):
    def get(self):
        udid = self.request.get('udid')
        device = Device.all().filter('udid =', udid).get()
        if not device is None:
            s = device.expiryDate.strftime("%B %d, %Y")
            self.response.out.write(s)
        else:
            self.response.out.write("January 01, 1900")

class MDotMCallbackHandler(webapp.RequestHandler):
    def post(self):
        udid = self.request.get('deviceid')
        months = int(self.request.get('currency'))
        
        if months == 0:
            months = 1
        
        device = Device.all().filter('udid =', udid).get()
        if device is None:
            expiryDate = datetime.datetime.today()
            device = Device(udid=udid, expiryDate=expiryDate)
        elif device.expiryDate < datetime.datetime.today():
            device.expiryDate = datetime.datetime.today()
        
        # add 4 x #payout ad-free months
        device.expiryDate = device.expiryDate + datetime.timedelta(months*31)
        device.put()
        
        self.response.out.write('OK')

class TapjoyCallbackHandler(webapp.RequestHandler):
    def get(self):
        udid = self.request.get('snuid')
        months = int(self.request.get('currency'))
        
        if months == 0:
            months = 1
        
        device = Device.all().filter('udid =', udid).get()
        if device is None:
            expiryDate = datetime.datetime.today()
            device = Device(udid=udid, expiryDate=expiryDate)
        elif device.expiryDate < datetime.datetime.today():
            device.expiryDate = datetime.datetime.today()
        
        # add #payout ad-free months
        device.expiryDate = device.expiryDate + datetime.timedelta(months*31)
        device.put()

        self.response.out.write('OK')

def main():
    application = webapp.WSGIApplication([('/', MainHandler),
                                          ('/v1/expiry_date', ExpiryDateHandler),
                                          ('/v1/mdotm_callback', MDotMCallbackHandler),
                                          ('/v1/tapjoy_callback', TapjoyCallbackHandler),
                                          ], debug=True)
    run_wsgi_app(application)

if __name__ == '__main__':
    main()