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
    '10349': 4119850,
    '10354': 4119962,
    '10377': 4120050,
    '10396': 4119974,
    '10401': 4119882,
    '10417': 4120046,
    '10429': 4119922,
    '10472': 4119934,
    '10486': 4120098,
    '10493': 4119910,
    '10504': 4120166,
    '10543': 4120106,
    '10570': 4119930,
    '10641': 4120034,
    '10656': 4120042,
    '10660': 4119946,
    '10687': 4120014,
    '11155': 4120062,
    '11164': 4120070,
    '11172': 4120074,
    '11193': 4119862,
    '11210': 4120066,
    '11234': 4120018,
    '11473': 4120158,
    '11487': 4120154,
    '11592': 4120010,
    '11603': 4120174,
    '11619': 4120006,
    '11635': 4120118,
    '11661': 4120178,
    '11690': 4120058,
    '11707': 4119858,
    '11711': 4120138,
    '11724': 4120002,
    '11730': 4120134,
    '11753': 4119870,
    '11769': 4120130,
    '11782': 4119970,
    '11795': 4119874,
    '11822': 4119998,
    '11846': 4120078,
    '11851': 4120102,
    '11867': 4120114,
    '11879': 4119842,
    '11880': 4119846,
    '11949': 4119854,
    '11954': 4119954,
    '11983': 4119958,
    '11996': 4119926,
    '12006': 4119986,
    '12109': 4119978,
    '12121': 4120022,
    '12132': 4120086,
    '12145': 4120094,
    '12150': 4119966,
    '12166': 4120026,
    '12215': 4119890,
    '12236': 4119894,
    '12258': 4119898,
    '12262': 4120110,
    '12289': 4120038,
    '12291': 4120150,
    '12301': 4119914,
    '12317': 4119982,
    '12329': 4119902,
    '12338': 4119906,
    '14801': 4120054,
    '14817': 4120090,
    '14872': 4119918,
    '15096': 4120162,
    '16343': 4120170,
    '16358': 4119994,
    '16370': 4120030,
    '16389': 4119938,
    '16698': 4119866,
    '16701': 4120082,
    '16717': 4119950,
    '16786': 4120146,
    '16819': 4119942,
    '16842': 4119886,
    '16857': 4119990,
    '16861': 4120142,
    '12243': 4119838,
    '12215': 4119886,
    '14339': 4120106
}

#
# Prediction
#

class PredictionHandler(webapp.RequestHandler):
    @memcached (30)
    def get(self):
        stopNumber = self.request.get('stop')
        predictions = []
        arrivals = {}
        
        # Make asynchronous request to the Connexionz system.
        rpc1 = urlfetch.create_rpc()
        urlfetch.make_fetch_call(rpc1, "http://avlweb.charlottesville.org/RTT/Public/RoutePositionET.aspx?PlatformNo=%s&Referrer=uvamobile" % (stopNumber))
        
        if stops_map.get(stopNumber) is not None:
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
                    trTag = S(el)
                    routeNumber = None
                    for ell in trTag.find('td'):
                        tdTag = S(ell)
                        if count == 0:
                            routeNumber = tdTag.text()
                            if not arrivals.get(routeNumber):
                                arrivals[routeNumber] = []
                        elif count == 2:
                            eta = int(tdTag.text())
                            arrivals[routeNumber].append(eta)
                        count = count + 1
        except urlfetch.DownloadError:
            # Request time out or failed
            logging.error("Request time out or failed for Connexionz.")
        
        if stops_map.get(stopNumber) is not None:
            try:
                result2 = rpc2.get_result()
                if result2.status_code == 200:
                    #logging.info(result2.content)
                    feed = json.loads(result2.content)
                    if feed['success']:
                        for item in feed['arrivals']:
                            routeNumber = routes_map.get(str(item['route_id']))
                            if routeNumber is None:
                                continue
                            if not arrivals.get(routeNumber):
                                arrivals[routeNumber] = []
                            eta = int((int(item['timestamp']) - int(time.time())*1000)/(1000*60))
                            arrivals[routeNumber].append(eta)
            except urlfetch.DownloadError:
                # Request time out or failed
                logging.error("Request time out or failed for TransLoc.")
        
        for k, v in arrivals.items():
            if len(v) == 0:
                continue
            entry = {}
            entry['route'] = k
            v.sort()
            entry['eta'] = ', '.join([str(eta) for eta in v[:2]])
            predictions.append(entry)
        
        # Return combined results from two systems.
        return predictions

#
# Router
#
routes = [
    (r'/api/v1/prediction', PredictionHandler)
]

application = webapp.WSGIApplication(routes, debug=False)
