#
# Data Models
#

from google.appengine.ext import db

class Device(db.Model):
    udid = db.StringProperty()
    expiryDate = db.DateTimeProperty()