#!/usr/bin/env python

import fix_path
import webapp2 as webapp
from google.appengine.api import urlfetch
from decorators import *
from models import *
import json, re, logging, datetime
from pyquery import PyQuery


route_map = {
    "001": "CGS",
    "002": "1B"
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
	    urlfetch.make_fetch_call(rpc2, "http://vcu.transloc.com/m/stop/code/117")
	    
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
	            S = PyQuery(result2.content)
	            for el in S('ul#routes li'):
	                entry = {}
	                
	                rowTag = S(el)
	                routeNumber = rowTag.attr('id').split('_')[1].strip()
	                
	                etaTag = rowTag.find('.wait_time')
	                minutes = etaTag.text().split('min')[0].strip()
                    
	                if minutes != '' and minutes != '--':
	                    entry['eta'] = minutes
	                    entry['route'] = 'transLoc' #route_map[routeNumber]
	                
                    if entry:
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