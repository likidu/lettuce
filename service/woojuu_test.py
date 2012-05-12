import os
import boto
import woojuu
import unittest
import conf.default as settings
import urllib2

def setUpModule():
    assert True == settings.SANDBOX
    woojuu.app.config['TESTING'] = True

    # TODO: Replace real account with sandbox account
    # TODO: Replace real S3 bucket with sandbox bucket
    woojuu.setup()

    woojuu.app.test_client().post("/backup_version/v1.0/weibo_alice/",data = dict(
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

class WoojuuTestCase(unittest.TestCase):
    def setUp(self):
        assert True == settings.SANDBOX
        self.app = woojuu.app.test_client()

    def tearDown(self):
        pass

    def test_backup_version(self):
        rv = self.app.get("/backup_version/v1.0/weibo_bob/")
        assert 200 == rv.status_code
        assert "-1" == rv.data
        
        rv = self.app.get("/backup_version/v1.0/weibo_alice/")
        assert 200 == rv.status_code
        assert "1234" == rv.data

        rv = self.app.post("/backup_version/v1.0/weibo_george/", data=dict(version=111, app_version=100))
        assert 200 == rv.status_code

        rv = self.app.get("/backup_version/v1.0/weibo_george/")
        assert 200 == rv.status_code
        assert "111" == rv.data

    def test_backup_url(self):
        content_length = self.dummy_file_len()
        rv = self.app.get("/backup_url/v1.0/weibo_alice/%d/" % content_length)
        assert 200 == rv.status_code
        assert "https://" in rv.data

        put_url = rv.data
        self.put_dummy_file(put_url)
        rv = self.app.get("/restore_url/v1.0/weibo_alice/")
        assert 200 == rv.status_code

        get_url = rv.data
        content = self.get_dummy_file(get_url)
        assert "testtesttest" == content

    def dummy_file_len(self):
        path = "woojuu_test_dummy_file.txt"
        return os.path.getsize(path)

    def put_dummy_file(self, url):
        path = "woojuu_test_dummy_file.txt"
        dummy_data = open(path, "rb")
        length = os.path.getsize(path)
        request = urllib2.Request(url, dummy_data)
        request.get_method = lambda: "PUT"
        #request.add_header("Cache-Control", "no-cache")
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