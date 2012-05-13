import api
import boto
import flask
import main
import mock
import os
import unittest
import urllib
import urllib2
from common import settings

def setUpModule():
    assert True == settings.SANDBOX
    main.app.config['TESTING'] = True

    api.setup()
    app = main.app.test_client()
    api.authenticate = mock.Mock(return_value="weibo_alice")
    app.post("/my/backup_version/v1.0/",data = dict(
        version = 1234,
        app_version = "9.9.9"
    ))

def tearDownModule():
    assert True == settings.SANDBOX
    # remove test domain
    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
    conn.delete_domain(settings.SDB_DOMAIN_BACKUP_VERSION)

    # remove test S3 bucket
    conn = boto.connect_s3(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
    bucket = conn.get_bucket(settings.S3_BUCKET_CLOUD_BACKUP)
    if bucket.get_key("weibo_alice.bak") is not None:
        bucket.delete_key("weibo_alice.bak")
    conn.delete_bucket(settings.S3_BUCKET_CLOUD_BACKUP)

class AAALoginTestCase(unittest.TestCase):
    def setUp(self):
        assert True == settings.SANDBOX
        self.app = main.app.test_client(allow_subdomain_redirects=True)

    def tearDown(self):
        pass

class ApiTestCase(unittest.TestCase):
    def setUp(self):
        assert True == settings.SANDBOX
        self.app = main.app.test_client()

    def tearDown(self):
        pass

    def test_login(self):
        rv = self.app.get("/login/v1.0/")
        assert 302 == rv.status_code
        assert "https://api.weibo.com/oauth2/authorize?" in rv.headers.get("location")
        with main.app.test_request_context("/"):
            redirect_param = "redirect_uri=" + urllib.quote(flask.url_for("api.login_success", _external=True))
            assert redirect_param in rv.headers.get("location")

    def test_login_success(self):
        pass

    def test_backup_version(self):
        api.authenticate = mock.Mock(return_value="weibo_bob")
        rv = self.app.get("/my/backup_version/v1.0/")
        assert 200 == rv.status_code
        assert "-1" == rv.data
        
        api.authenticate = mock.Mock(return_value="weibo_alice")
        rv = self.app.get("/my/backup_version/v1.0/")
        assert 200 == rv.status_code
        assert "1234" == rv.data

        api.authenticate = mock.Mock(return_value="weibo_george")
        rv = self.app.post("/my/backup_version/v1.0/", data=dict(version=111, app_version=100))
        assert 200 == rv.status_code

        api.authenticate = mock.Mock(return_value="weibo_george")
        rv = self.app.get("/my/backup_version/v1.0/")
        assert 200 == rv.status_code
        assert "111" == rv.data

        api.authenticate = mock.Mock(side_effect=lambda:flask.abort(401))
        rv = self.app.get("/my/backup_version/v1.0/")
        assert 401 == rv.status_code
        rv = self.app.post("/my/backup_version/v1.0/", data=(dict(version=111, app_version=100)))
        assert 401 == rv.status_code

    def test_backup_url(self):
        api.authenticate = mock.Mock(return_value="weibo_alice")

        content_length = self.dummy_file_len()
        rv = self.app.get("/my/backup_url/v1.0/%d/" % content_length)
        assert 200 == rv.status_code
        assert "https://" in rv.data

        put_url = rv.data
        self.put_dummy_file(put_url)
        rv = self.app.get("/my/restore_url/v1.0/")
        assert 200 == rv.status_code

        get_url = rv.data
        content = self.get_dummy_file(get_url)
        assert "testtesttest" == content

        api.authenticate = mock.Mock(side_effect=lambda:flask.abort(401))
        rv = self.app.get("/my/backup_url/v1.0/%d/" % content_length)
        assert 401 == rv.status_code
        rv = self.app.get("/my/restore_url/v1.0/")
        assert 401 == rv.status_code

    def dummy_file_len(self):
        path = "api_test_dummy_file.txt"
        return os.path.getsize(path)

    def put_dummy_file(self, url):
        path = "api_test_dummy_file.txt"
        dummy_data = open(path, "rb")
        length = os.path.getsize(path)
        request = urllib2.Request(url, dummy_data)
        request.get_method = lambda: "PUT"
        request.add_header("Content-Length", "%d" % length)
        request.add_header("Content-Type", "application/x-sqlite3")
        urllib2.urlopen(request).read().strip()

    def get_dummy_file(self, url):
        request = urllib2.Request(url)
        request.get_method = lambda: "GET"
        result = urllib2.urlopen(request).read().strip()
        return result

if __name__ == '__main__':
    unittest.main()
