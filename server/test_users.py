import os
import unittest
import tempfile
import server
import server.database

class FlaskrTestCase(unittest.TestCase):
    def setUp(self):
        server.app.config['TESTING'] = True
        server.app.config['MONGODB_DB'] = 'hackcessangels_test'
        self.app = server.app.test_client()
    
    def login(self, username, password):
        return self.app.post('/login', data=dict(
            username=username,
            password=password
            ), follow_redirects=True)

    def tearDown(self):
        server.database.connection.drop_database(server.app.config['MONGODB_DB'])

    def test_new_user(self):
        rv = self.app.post("/api/user", data={
            "email": "user@domain.tld",
            "password": "password"})
        assert 200 == rv.status_code

if __name__ == '__main__':
    unittest.main()

