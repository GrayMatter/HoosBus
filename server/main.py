#!/usr/bin/env python

import wsgiref.handlers
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db
from google.appengine.api import memcache
from google.appengine.api import urlfetch
import simplejson, re, logging, datetime
from datamodel import *
from BeautifulSoup import BeautifulSoup

class MainHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write('OK')
        
class PredictionHandler(webapp.RequestHandler):
    def get(self):
        json = memcache.get(self.request.url)
        if json is None:
            stopNumber = self.request.get('stop')
            url = "http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%s&Referrer=uvamobile" % (stopNumber)
        
            result = urlfetch.fetch(url, deadline=10)
            if result.status_code == 200:
                soup = BeautifulSoup(result.content, convertEntities=BeautifulSoup.HTML_ENTITIES)
            else:
                self.error(500)
        
            tableTag = soup.find('table', {"class": "tableET"})
            if tableTag is None:
                self.error(501) # 501: no bus is coming
            
            result = []
            for trTag in tableTag.tbody.findAll('tr'):
                count = 0
                entry = {}
                for tdTag in trTag.findAll('td'):
                    if count == 0:
                        entry["route"] = tdTag.renderContents()
                    
                    elif count == 1:
                        dest = tdTag.renderContents()
                        note = None
                        matchObj = re.search("(via .*)", dest)
                        if matchObj is not None:
                            note = matchObj.group(1)
                        else:
                            matchObj = re.search("(to .*)", dest)
                            if matchObj is not None:
                                note = matchObj.group(1)
                        if note is not None:
                            entry["note"] = note
                        
                    elif count == 2:
                        entry["eta"] = tdTag.renderContents()
                    
                    count = count+1
                
                if entry:
                    result.append(entry)
            
            json = simplejson.dumps(result)
            memcache.set(self.request.url, json, 30) # expire in 30s
        
        self.response.out.write(json)
        

def main():
    application = webapp.WSGIApplication([('/', MainHandler),
                                          ('/prediction', PredictionHandler),
                                          ], debug=True)
    run_wsgi_app(application)

if __name__ == '__main__':
    main()