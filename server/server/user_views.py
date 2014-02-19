# coding=utf-8

from server import app
from server import utils
from server.database import get_db
import server.error_messages

from flask import Response
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from flask import url_for

import json
import copy

# POST: Creates a new user. Needed parameters: email, password
# GET: Get an existing user. Needed parameters: email
# PUT: Updates an existing user. Needed parameters: email, password, user
# DELETE: Delets an existing user. Needed parameters: email, password
@app.route("/api/user",methods=['GET', 'POST', 'PUT', 'DELETE'])
@utils.json_response
def user_api():
    collection = get_db().user

    # Create a new user
    if request.method == "POST":
        if "email" not in request.form and "password" not in request.form:
            return server.error_messages.MALFORMED_REQUEST, 400

        already_existing = collection.find_one({"email": request.form["email"]})
        if already_existing != None:
            return server.error_messages.USER_ALREADY_EXISTING, 403
        
        user = collection.User()
        user["email"] = request.form["email"]
        user.set_password(request.form["password"])
        user.save()
        session["email"] = user["email"]
        return user.to_json()

    # All methods below should be authenticated
    if "email" not in session:
        return "", 403

    # Get the current user
    if request.method == "GET":
        if not "email" in request.args:
            return "", 400
        if session["email"] != request.args["email"]:
            return "", 403
        user = collection.find_one({"email": request.args["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = collection.User(user)
        return user.to_json()

    elif request.method == "PUT":
        if not "email" in request.form:
            return "", 400
        if not "user" in request.form:
            return "", 400
        if session["email"] != request.form["email"]:
            return "", 403
        updated_user = json.loads(request.form["user"])
        user = collection.find_one({"email": request.form["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = collection.User(user)
        for k, v in updated_user.items():
            if k == "password":
                user.set_password(v)
            else:
                user[k] = v
        user.save()
        return user.to_json()

    elif request.method == "DELETE":
        if not "email" in request.args:
            return "", 400
        if session["email"] != request.args["email"]:
            return "", 403
        user = collection.find_one({"email": request.args["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = collection.User(user)
        user.delete()
        return "", 200

    return "", 405

@app.route("/api/user/login",methods=['GET', 'POST'])
@utils.json_response
def user_login():
    collection = get_db().user

    if request.method == "POST":
        if "email" not in request.form and "password" not in request.form:
            # Malformed request
            return "", 400
        user = collection.find_one({"email": request.form["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 403
        user = collection.User(user)
        if not user.verify_password(request.form["password"]):
            return server.error_messages.UNKNOWN_USER, 403
        session['email'] = user["email"]
        if "next" in request.args:
            return redirect(request.args["next"])
        else:
            return "", 200
    return "", 405

@app.route("/user",methods=['GET'])
def user():
    return render_template('users.html')
