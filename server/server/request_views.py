# coding=utf-8

from server import app
from server import utils
from server.database import get_db
from server.models import Point
import server.error_messages

from flask import Response
from flask import redirect
from flask import render_template
from flask import request
from flask import session

import datetime

# POST: Creates a new user. Needed parameters: email, password
# GET: Get an existing user. Needed parameters: email
# PUT: Updates an existing user. Needed parameters: email, password, user
# DELETE: Delets an existing user. Needed parameters: email, password
@app.route("/api/request",methods=['GET', 'POST', 'DELETE'])
@utils.json_response
@utils.user_login_required
def request_api():
    requests = get_db().request
    users = get_db().user

    # Create a new request
    if request.method == "POST":
        if "lat" not in request.form and "lng" not in request.form:
            return server.error_messages.MALFORMED_REQUEST, 400

        user = users.find_one({"email": request.form["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)

        request = Request()
        request["user"] = user["_id"]
        request["location"]["user_location"] = Point(
                request.form["lat"], request.form["lng"])
        request["location"]["last_update"] = datetime.datetime.today()
        request["date_requested"] = datetime.datetime.today()
        request["active"] = True
        request.save()

        return request.to_json()

    # Get the current user
    elif request.method == "GET":
        user = collection.find_one({"email": session["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)
        user_requests = requests.find({"user": user["_id"], "active": True})
        return map(users.User, user)

    elif request.method == "DELETE":
        user = collection.find_one({"email": session["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)
        user_requests = requests.find({"user": user["_id"], "active": True})
        for request in user_requests:
            request = requests.Request(request)
            request["active"] = False
            request.save()
        return "", 200

    return "", 405

