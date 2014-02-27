import os
import unittest
import tempfile
import json

import server

import flask

class RequestViewsTestCase(unittest.TestCase):
    def setUp(self):
        server.app.config['TESTING'] = True
        server.app.config['MONGODB_DB'] = 'hackcessangels_test'
        self.app = server.app.test_client()
    
    def tearDown(self):
        server.database.connection.drop_database(
                server.app.config['MONGODB_DB'])

    def create_user_and_login(self):
        """Utility to create a user and log in."""
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})

        with self.app.session_transaction() as sess:
            rv = self.app.post("/api/user/login", data={
                "email": "user@domain.tld",
                "password": "password"})
            self.assertEqual(200, rv.status_code)
            self.assertTrue('Set-Cookie' in rv.headers)
            self.assertEqual("user@domain.tld", sess['email'])

        rv = self.app.get("/api/user?email=user@domain.tld")
        self.assertEqual(200, rv.status_code)

    def test_create(self):
        self.create_user_and_login()

        rv = self.app.post("/api/request", data={
            "lat": 48.843906,
            "lng": 2.375278})
        self.assertEqual(200, rv.status_code)


    def test_get(self):
        self.create_user_and_login()

        rv = self.app.post("/api/request", data={
            "lat": 48.843906,
            "lng": 2.375278})
        self.assertEqual(200, rv.status_code)

        rv = self.app.get("/api/request")
        self.assertEqual(200, rv.status_code)

    def test_put(self):
        self.create_user_and_login()

        rv = self.app.post("/api/request", data={
            "lat": 48.843906,
            "lng": 2.375278})
        self.assertEqual(200, rv.status_code)

        rv = self.app.put("/api/request", data={
            "lat": 30.843906,
            "lng": 3.375278})
        self.assertEqual(200, rv.status_code)

    def test_delete(self):
        self.create_user_and_login()

        rv = self.app.post("/api/request", data={
            "lat": 48.843906,
            "lng": 2.375278})
        self.assertEqual(200, rv.status_code)

        rv = self.app.delete("/api/request")
        self.assertEqual(200, rv.status_code)

if __name__ == '__main__':
    unittest.main()

