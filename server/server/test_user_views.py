import os
import unittest
import tempfile
import json

import server

import flask

class UserViewsTestCase(unittest.TestCase):
    def setUp(self):
        server.app.config['TESTING'] = True
        server.app.config['MONGODB_DB'] = 'hackcessangels_test'
        self.app = server.app.test_client()
    
    def tearDown(self):
        server.database.connection.drop_database(
                server.app.config['MONGODB_DB'])

    def test_new_user(self):
        """Verify we can create a new user."""
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})
        assert 200 == rv.status_code

    def test_login(self):
        """Verify we can log-in with an existing user."""
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})

        with self.app.session_transaction() as sess:
            rv = self.app.post("/api/user/login", data={
                "email": "user@domain.tld",
                "password": "password"})
            assert 200 == rv.status_code
            assert 'Set-Cookie' in rv.headers
            assert "user@domain.tld" == sess['email']

        rv = self.app.get("/api/user?email=user@domain.tld")
        assert 200 == rv.status_code

    def test_delete(self):
        """Verify we can delete an existing user."""
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})

        with self.app.session_transaction() as sess:
            rv = self.app.post("/api/user/login", data={
                "email": "user@domain.tld",
                "password": "password"})

        rv = self.app.delete("/api/user?email=user@domain.tld")
        assert 200 == rv.status_code

        rv = self.app.get("/api/user?email=user@domain.tld")
        assert 404 == rv.status_code

    def test_modify(self):
        """Verify we update an existing user."""
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})

        with self.app.session_transaction() as sess:
            rv = self.app.post("/api/user/login", data={
                "email": "user@domain.tld",
                "password": "password"})

        rv = self.app.put("/api/user", data={
            "email": "user@domain.tld",
            "user": json.dumps({
                "email": "user@domain.tld",
                "name": "Joe Doe"})})
        assert 200 == rv.status_code

        rv = self.app.get("/api/user?email=user@domain.tld")
        assert 200 == rv.status_code

if __name__ == '__main__':
    unittest.main()

