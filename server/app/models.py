"""
Data Models
"""

from google.appengine.ext import db
from google.appengine.ext import blobstore
import datetime, json

# class Cinema(db.Model):
#     """ Cinema model definition """
#     name = db.StringProperty(required=True)
#     cid = db.StringProperty(required=True)
#     owner = db.StringProperty(required=True)
#     address = db.StringProperty(indexed=False)
#     phone = db.StringProperty(indexed=False)
#     lat = db.FloatProperty(indexed=False)
#     lng = db.FloatProperty(indexed=False)
#     
#     def toJSON(self):
#         d = {'id': self.key().id(),
#              'name': self.name,
#              'owner': self.owner,
#              'address': self.address,
#              'phone': self.phone,
#              'lat': self.lat,
#              'lng': self.lng}
#         return d
#     
#     def __str__(self):
#         return json.dumps(self.toJSON(), sort_keys=True, indent=4)
