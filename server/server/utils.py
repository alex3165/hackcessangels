# Utility functions
from functools import wraps

from flask import Response
from flask import session
from flask import request
from flask import redirect
from flask import url_for

import werkzeug.wrappers

import json

# Add the JSON Content-Type to the response
def json_response(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        r = f(*args, **kwargs)
       
        if isinstance(r, werkzeug.wrappers.Response):
            return r
        elif isinstance(r, tuple) and len(r) == 2:
            return Response(json.dumps(r[0]), status=r[1],
                    content_type="application/json")
        else:
            return Response(json.dumps(r), 
                    content_type="application/json")
    return decorated_function

def user_login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "email" not in session:
            return redirect(url_for('user_login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function
