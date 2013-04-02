#!/usr/bin/env python

import fix_path
import webapp2 as webapp
from google.appengine.api import urlfetch
from decorators import *
from models import *
import json, re, logging, datetime
from pyquery import PyQuery
import json, time

routes_map = {
    "4003306": "CGS",
    "4003314": "CS",
    "4003302": "G",
    "4003290": "ULA",
    "4003286": "NL",
    "4003294": "ULB",
    "4003298": "SHS"
}

stops_map = {
    
}

#
# Prediction
#

class PredictionHandler(webapp.RequestHandler):
    @memcached (30)
    def get(self):
	    stopNumber = self.request.get('stop')
	    predictions = []
	    
	    # Make asynchronous request to the Connexionz system.
	    rpc1 = urlfetch.create_rpc()
	    urlfetch.make_fetch_call(rpc1, "http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%s&Referrer=uvamobile" % (stopNumber))
	    
	    # Make asynchronous request to the TransLoc system.
	    rpc2 = urlfetch.create_rpc()
	    urlfetch.make_fetch_call(rpc2, "http://feeds.transloc.com/2/arrivals?stop_id=%s&agencies=347" % (stops_map[stopNumber]))
	    
	    # Check result from Connexionz
	    try:
	        result1 = rpc1.get_result()
	        if result1.status_code == 200:
	            S = PyQuery(PyQuery(result1.content).html())
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
	                            entry['note'] = note
	                    elif count == 2:
	                        entry['eta'] = tdTag.text()
	                    count = count + 1
	                
	                if entry:
	                    predictions.append(entry)
	    except urlfetch.DownloadError:
	        # Request time out or failed
	        logging.error("Request time out or failed for Connexionz.")
	    
	    # Check result from TransLoc
	    try:
	        result2 = rpc2.get_result()
	        if result2.status_code == 200:
	            feed = JSON.loads(result2)
	            if feed['success']:
	                arrivals = {}
	                for item in feed['arrivals']:
	                    routeNumber = item['route_id']
	                    if not arrivals[routeNumber]:
	                        arrivals[routeNumber] = []
	                    
	                    eta = int((int(item['timestamp']) - int(time.time())*1000)/(1000*60))
	                    arrivals[routeNumber].append(eta)
	                
	                for k, v in arrivals.items():
	                    entry = {}
	                    entry['route'] = routes_map[k]
	                    entry['eta'] = v.join(', ')
	                    predictions.append(entry)
        
	    except urlfetch.DownloadError:
	        # Request time out or failed
	        logging.error("Request time out or failed for TransLoc.")
	    
	    # Return combined results from two systems.
	    return predictions

#
# Router
#
routes = [
	(r'/api/v1/prediction', PredictionHandler)
]

application = webapp.WSGIApplication(routes, debug=False)