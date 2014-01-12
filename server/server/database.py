from server import app

# connect to the database
from mongokit import Connection
connection = Connection(app.config['MONGODB_HOST'],
                        app.config['MONGODB_PORT'])
