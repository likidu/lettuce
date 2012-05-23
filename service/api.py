import boto
import constants
import flask
import time
import weibo
from flask import request
from common import app, settings

api = flask.Blueprint("api", __name__)

def setup():
    try:
        import main
        app.logger.info("Setup started.")

        app.logger.info("Setup Amazon Simple DB for cloud backup.")
        conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
        try:
            conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
        except boto.exception.SDBResponseError:
            conn.create_domain(settings.SDB_DOMAIN_BACKUP_VERSION)

        app.logger.info("Setup Amazon S3 for cloud backup.")
        conn = boto.connect_s3(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
        try:
            conn.get_bucket(settings.S3_BUCKET_CLOUD_BACKUP)
        except boto.exception.S3ResponseError:
            conn.create_bucket(settings.S3_BUCKET_CLOUD_BACKUP)

        app.logger.info("Initialization completed successfully.")
        return True
    except Exception as ex:
        app.logger.critical("Unexpected error in initialization: %s" % ex)
        return False

@api.route("/login/v1.0/")
def login():
    client = weibo.APIClient(app_key=settings.WEIBO_APP_KEY, app_secret=settings.WEIBO_APP_SECRET)
    callback = flask.url_for(".login_success", _external=True)
    url = client.get_authorize_url(redirect_uri=callback)
    return flask.redirect(url)

@api.route("/login_success/v1.0/")
def login_success():
    code = request.args.get("code", "")
    client = weibo.APIClient(app_key=settings.WEIBO_APP_KEY, app_secret=settings.WEIBO_APP_SECRET)
    r = client.request_access_token(code)
    client.set_access_token(r.access_token, r.expires_in)
    weibo_user = client.get.account__verify_credentials()
    weibo_id = weibo_user.id
    response = flask.make_response("")
    response.set_cookie("weibo_id", weibo_id)
    response.set_cookie("weibo_access_token", r.access_token)
    response.set_cookie("token_expires_in", r.expires_in)
    return response

@api.route("/my/backup_version/v1.0/", methods=["GET", "POST"])
def backup_version():
    user_id = authenticate()
    if request.method == 'GET':
        return str(get_backup_version(user_id))
    elif request.method == 'POST':
        version = request.form['version']
        app_version = request.form['app_version']
        return post_backup_version(user_id, version, app_version)

@api.route("/my/backup_url/v1.0/", methods=["GET"])
def get_backup_url():
    user_id = authenticate()
    return get_s3_pre_signed_url(user_id, "PUT")

@api.route("/my/restore_url/v1.0/", methods=["GET"])
def get_restore_url():
    user_id = authenticate()
    return get_s3_pre_signed_url(user_id, "GET")

def authenticate():
    try:
        weibo_id = request.cookies["weibo_id"]
        access_token = request.cookie["weibo_access_token"]
        expires_in = request.cookie["token_expires_in"]
        if time.time() > expires_in:
            flask.abort(401)    # Unauthenticated
        else:
            return "weibo_" + weibo_id
    except KeyError:
        flask.abort(401)        # Unauthenticated

def get_backup_version(user_id):
    # The READ here is eventually consistent. That should be fine.
    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
    domain = conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
    item = domain.get_attributes(user_id, constants.ATTR_BACKUP_VERSION)

    return item["backup_version"] if len(item) != 0 else -1

def post_backup_version(user_id, version, app_version):
    item_attrs = { constants.ATTR_BACKUP_VERSION:   version,
                   constants.ATTR_APP_VERSION:      app_version }

    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)

    domain = conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
    success = retry(lambda: domain.put_attributes(user_id, item_attrs), 3)
    if not success:
        flask.abort(500)  # Internal Server Error
    else:
        return ""

def get_s3_pre_signed_url(user_id, method):
    conn = boto.connect_s3(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)

    if method == "PUT":
        return conn.generate_url(
            expires_in = 3600000,
            method = method,
            bucket = settings.S3_BUCKET_CLOUD_BACKUP,
            key = user_id + ".bak",
            headers = { "Content-Type":   "application/x-sqlite3" })
    elif method == "GET":
        return conn.generate_url(
            expires_in = 3600000,
            method = method,
            bucket = settings.S3_BUCKET_CLOUD_BACKUP,
            key = user_id + ".bak")

def is_weibo_user(user_id):
    return user_id[0:6] == 'weibo_'

def get_weibo_id(user_id):
    if is_weibo_user(user_id):
        return user_id[6:]
    else:
        raise ValueError('%s is not a weibo user.' % user_id)

def retry(operation, retry):
    for i in range(retry):
        success = operation()
        if success:
            return True
    return False

if __name__ == "__main__":
    setup()
    api.run()
