#!/usr/bin/env python

import fix_path
import webapp2 as webapp
from decorators import *
from models import *
import json, re, logging, datetime

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
		
		return json.dumps(result)

#
# Router
#
routes = [
	(r'/api/v1/prediction', PredictionHandler)
]

application = webapp.WSGIApplication(routes, debug=False)