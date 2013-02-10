from google.appengine.api import memcache
import hashlib

#
# Decorators
#
def auth_required(func):
    """ A decorator that does HMAC authentication"""
    def new_func(requestHandler):
        if 'Authorization' in requestHandler.request.headers:
            h = requestHandler.request.headers['Authorization']
            m = hashlib.sha1("3jkje92&D0-BJjli+" + requestHandler.request.url).hexdigest()
            if h.lower() == m.lower():
                func(requestHandler)
            else:
                requestHandler.error(501)
    return new_func

def memcached(age):
    """
    Note that a decorator with arguments must return the real decorator that,
    in turn, decorates the function. For example:
        @decorate("extra")
        def function(a, b):
        ...
    is functionally equivallent to:
        function = decorate("extra")(function)
    """
    def inner_memcached(func):
        """ A decorator that implements the memcache pattern """
        def new_func(requestHandler):
            result = memcache.get(requestHandler.request.url)
            if result is None:
                result = {}
                data = func(requestHandler)
                if data:
                    result['data'] = data
                    result['ETag'] = hashlib.sha1(data).hexdigest()
                memcache.set(requestHandler.request.url, result, age)
            
            requestHandler.response.headers["Content-Type"] = "application/json"
            
            if result['ETag']:
                requestHandler.response.headers['ETag'] = result['ETag']
            
            if 'If-None-Match' in requestHandler.request.headers:
                etag = requestHandler.request.headers['If-None-Match']
                if result['ETag'] == etag:
                    # Send 304 (Not Modified) if the representation hasn't changed
                    requestHandler.response.set_status(304)
            
            # Otherwise send the body
            requestHandler.response.out.write(result['data'])
        return new_func
    return inner_memcached
