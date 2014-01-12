import bson
import hashlib
import os
import datetime
from mongokit import Document, CustomType
from server.database import connection

class AuthUser(object):
    def set_password(self, password):
        """ Hash password on the fly """
        password_salt = hashlib.sha1(os.urandom(60)).hexdigest()
        crypt = hashlib.sha1(password + password_salt).hexdigest()
        self['password'] = str(password_salt + crypt)

    def get_password(self):
        """ Return the password hashed """
        return self['password']

    def del_password(self):
        """Resets the password"""
        self['password'] = None

    password = property(get_password, set_password, del_password)

    def verify_password(self, password):
        """ Check the password against existing credentials  """
        password_salt = self['password'][:40]
        crypt_pass = hashlib.sha1(password + password_salt).hexdigest()
        if crypt_pass == self['password'][40:]:
            return True
        else:
            return False


@connection.register
class Agent(AuthUser, Document):
    structure = {
        'name': str,
        'email': str,
        'password': str,
        'profile': bson.binary.Binary,
        'station': bson.objectid.ObjectId,
    }
    required_fields = ['email', 'password']


@connection.register
class User(AuthUser, Document):
    structure = {
        'name': str,
        'email': str,
        'password': str,
        'description': str,
        'profile': bson.binary.Binary,
    }
    required_fields = ['email', 'password']


class Point(object):
    """A 2-dimensional point on a sphere."""
    def __init__(self, longitude, latitude):
        self.longitude = longitude
        self.latitude = latitude


class PointType(CustomType):
    mongo_type = dict

    def to_bson(self, value):
        return {'type' : 'Point',
                'coordinates': [value.longitude, value.latitude]}

    def to_python(self, value):
        return Point(value['coordinates'][0], value['coordinates'][1])

@connection.register
class Request(Document):
    structure = {
        'user': bson.objectid.ObjectId,
        'location': {
            'station': bson.objectid.ObjectId,
            'user_location': PointType,
            'last_update': datetime.datetime,
        },
        'date_requested': datetime.datetime,
        'agent': bson.objectid.ObjectId,
    }


class Polygon(object):
    def __init__(self, points):
        self.points = points

class PolygonType(CustomType):
    mongo_type = dict

    def to_bson(self, value):
        geometry = {'type' : 'Polygon', 'coordinates': []}
        for point in value:
            geometry['coordinates'].append([point.longitude, point.latitude])
        return geometry

    def to_python(self, value):
        points = []
        for point in value['coordinates']:
            points.append(Point(point[0], point[1]))
        return Polygon(points)

@connection.register
class Station(Document):
    structure = {
        'name': str,
        'geometry': PolygonType,
    }
