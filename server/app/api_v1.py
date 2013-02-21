#!/usr/bin/env python

import fix_path
import webapp2 as webapp
from google.appengine.api import urlfetch
from decorators import *
from models import *
import json, re, logging, datetime
from pyquery import PyQuery

#
# Prediction
#

class PredictionHandler(webapp.RequestHandler):
	@memcached (30)
	def get(self):
		stopNumber = self.request.get('stop')
		url = "http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%s&Referrer=uvamobile" % (stopNumber)
        
		result = urlfetch.fetch(url, deadline=10)
		if result.status_code == 200:
		    S = PyQuery(PyQuery(result.content).html())
		else:
		    self.error(500)
		
		result = []
		for el in S('table.tableET tbody tr'):
		    count = 0
		    entry = {}
		    trTag = S(el)
		    for ell in trTag.find('td'):
		        tdTag = S(ell)
		        if count == 0:
		            entry['route'] = tdTag.text()
		        elif count == 1:
		            dest = tdTag.text()
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
		            entry['eta'] = tdTag.text()
		        count = count + 1
		    
		    if entry:
		        result.append(entry)
		return result

#
# Router
#
routes = [
	(r'/api/v1/prediction', PredictionHandler)
]

application = webapp.WSGIApplication(routes, debug=False)