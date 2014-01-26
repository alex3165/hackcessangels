# coding=utf-8

from server import app
from server.database import db
import server.error_messages
from server.models import User
from flask import render_template
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
            app.logger.debug("Not the necessary data available: " + str(request.form))
            return "", 400
        already_existing = collection.find_one({"email": request.form["email"]})
        if already_existing != None:
            return server.error_messages.USER_ALREADY_EXISTING, 403
        # Creates a new user
        user = collection.User()
        app.logger.debug("setting email")
        user["email"] = request.form["email"]
        app.logger.debug("setting password")
        user.set_password(request.form["password"])
        app.logger.debug("setting name")
        if "name" in request.form:
            user["name"] = request.form["name"]
        app.logger.debug("setting description")
        if "description" in request.form:
            user["description"] = request.form["description"]
        app.logger.debug("Saving user")
        user.save()
        app.logger.debug("User saved")
        return json.dumps(user.to_json())

    elif request.method == "GET":
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

    elif request.method == "DELETE":
        if not "email" in request.form:
            return "", 400
        if not "password" in request.form:
            return "", 400

    return "", 405

@app.route("/user",methods=['GET'])
def user():
    return render_template('users.html')
