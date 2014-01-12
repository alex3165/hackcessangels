from server import app

@app.route("/user/new")
def create_user():
    """Creates a new user in the database.
    """
    # TODO(etienne): Create a new user
    return ""

@app.route("/user/<int:id>")
def get_user():
    """Get data about the specified user from the database.
    """
    # TODO(etienne): Get the user
    return ""

@app.route("/user/<int:id>/update")
def update_user():
    """Updates the user.
    """
    # TODO(etienne): Updates the user
    return ""
