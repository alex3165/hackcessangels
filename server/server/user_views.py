from server import app
from server.database import db
import server.error_messages
from server.models import User

from flask import request
import json

collection = db.user

# POST: Creates a new user. Needed parameters: email, password
# GET: Get an existing user. Needed parameters: email
# PUT: Updates an existing user. Needed parameters: email, data
@app.route("/api/user",methods=['GET', 'POST', 'PUT'])
def user_api():
    if request.method == "POST":
        if "email" not in request.form and "password" not in request.form:
            # Malformed request
            return "", 400
        already_existing = collection.find_one({"email": request.form["email"]})
        if already_existing != None:
            return server.error_messages.USER_ALREADY_EXISTING, 403
        # Creates a new user
        user = collection.User()
        user["email"] = request.form["email"]
        user.set_password(request.form["password"])
        user["name"] = request.form["name"]
        user["description"] = request.form["description"]
        user.save()
        return user.to_json()

    elif request.method == "GET":
        print request.form
        if not "email" in request.args:
            return "", 400
        user = collection.find_one({"email": request.form["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        return json.dumps(user.to_json())

    elif request.method == "PUT":
        if not "email" in request.form:
            return "", 400
        if not "data" in request.form:
            return "", 400
        updated_user = json.loads(request.form["data"])
        user = collection.find_one({"email": request.form["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        for k, v in updated_user.items():
            if k == "password":
                user.set_password(v)
            else:
                user[k] = v
        user.save()
        return user.to_json()
    return "", 405
