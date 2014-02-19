from server import app

from flask import g

# connect to the database
from mongokit import Connection
connection = Connection(app.config['MONGODB_HOST'],
                        app.config['MONGODB_PORT'])

def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """    
    if not hasattr(g, 'db'):
        g.db = connection[app.config['MONGODB_DB']]
    return g.db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the app."""
    if hasattr(g, 'db'):
        del g.db
