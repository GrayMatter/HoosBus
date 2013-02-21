from google.appengine.api import memcache
import json

#
# Decorators
#

debug = True

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
        def new_func(requestHandler, *args, **kwargs):
            result = memcache.get(requestHandler.request.url)
            if result is None or debug:
                # Use compact JSON encoding
                result = json.dumps(func(requestHandler, *args, **kwargs), separators=(',',':'))
                memcache.set(requestHandler.request.url, result, age)
            requestHandler.response.headers["Content-Type"] = "application/json"
            requestHandler.response.out.write(result)
        return new_func
    return inner_memcached
