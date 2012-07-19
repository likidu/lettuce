import boto
import constants
import flask
import time
import weibo
from flask import request, session
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
    client = weibo.APIClient(app_key=settings.WEIBO_APP_KEY, app_secret=settings.WEIBO_APP_SECRET, redirect_uri=settings.WEIBO_CALLBACK_URL_V1_0)
    url = client.get_authorize_url()
    return flask.redirect(url)

# FIXME use session instead of cookie
@api.route("/login_success/v1.0/")
def login_success():
    code = request.args.get("code", "")
    if len(code) == 0:
        flask.abort(500)

    client = weibo.APIClient(app_key=settings.WEIBO_APP_KEY, app_secret=settings.WEIBO_APP_SECRET, redirect_uri=settings.WEIBO_CALLBACK_URL_V1_0)
    r = client.request_access_token(code)
    client.set_access_token(r.access_token, r.expires_in)
    weibo_user = client.get.account__get_uid()
    # Actually uid is already in r, but it's not a documented behavior
    # So we bother a explicit call
    weibo_id = weibo_user.uid
    session['weibo_id'] = weibo_id;
    session['weibo_access_token'] = r.access_token
    session['token_expires_in'] = r.expires_in
    session.permanent = True
    session.modified = True

    return ''

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
        weibo_id = session.get("weibo_id", None)
        access_token = session.get("weibo_access_token", None)
        expires_in = session.get("token_expires_in", None)

        if weibo_id and expires_in and expires_in > time.time():
            return "weibo_" + weibo_id

        session.clear()
        session.permanent = False
        session.modified = True

        flask.abort(401)

    except KeyError:
        flask.abort(401)        # Unauthenticated


# TODO We may need to consider using UUID as item.name instread of weibo_userid
def get_backup_version(user_id):
    # The READ here is eventually consistent. That should be fine.
    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)
    domain = conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
    item = domain.get_attributes(user_id, constants.ATTR_BACKUP_VERSION)

    return item.get(constants.ATTR_BACKUP_VERSION, -1)

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

def retry(operation, retry):
    for i in range(retry):
        success = operation()
        if success:
            return True
    return False

if __name__ == "__main__":
    setup()
    api.run()
