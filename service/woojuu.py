from flask import abort, Flask, request
import logging
import boto
import constants
import conf.default as settings

app = Flask(__name__)
app.config.from_object("conf.default")

if __name__ == "__main__":
    import os
    if "WOOJUU_MODE" in os.environ:
        if os.environ["WOOJUU_MODE"].lower() == "production":
            import conf.prod as settings
            app.config.from_object("conf.prod")

def setup():
    try:
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

@app.route("/backup_version/v1.0/<user_id>/", methods=['GET', 'POST'])
def backup_version(user_id):
    authenticate(user_id)
    if request.method == 'GET':
        return get_backup_version(user_id)
    elif request.method == 'POST':
        version = request.form['version']
        app_version = request.form['app_version']
        return post_backup_version(user_id, version, app_version)

@app.route("/backup_url/v1.0/<user_id>/<content_length>/", methods=["GET"])
def get_backup_url(user_id, content_length):
    authenticate(user_id)
    return get_s3_pre_signed_url(user_id, "PUT", content_length)

@app.route("/restore_url/v1.0/<user_id>/", methods=["GET"])
def get_restore_url(user_id):
    authenticate(user_id)
    return get_s3_pre_signed_url(user_id, "GET")

def authenticate(user_id):
    logging.info("authenticating. user_id: %s.", user_id)
    if is_weibo_user(user_id):
        weibo_id = get_weibo_id(user_id)
        request_token = request.args.get('weibo_request_token')

        # TODO: Verify request token with Weibo
        if False:
            logging.info("Authentication failed.")
            abort(401)
    else:
        logging.info("Not a weibo user. user_id: %s.", user_id)
        # 404: Only weibo user is supported.
        abort(404)

def get_backup_version(user_id):
    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)

    # The READ here is eventually consistent.
    domain = conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
    item = domain.get_attributes(user_id, constants.ATTR_BACKUP_VERSION)

    if len(item) != 0:
        return str(item["backup_version"])
    else:
        return str(-1)

def post_backup_version(user_id, version, app_version):
    item_attrs = { constants.ATTR_BACKUP_VERSION:   version,
                   constants.ATTR_APP_VERSION:      app_version }

    conn = boto.connect_sdb(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)

    domain = conn.get_domain(settings.SDB_DOMAIN_BACKUP_VERSION)
    success = retry(lambda: domain.put_attributes(user_id, item_attrs), 3)
    if not success:
        abort(500)  # Internal Server Error
    else:
        return ""

def get_s3_pre_signed_url(user_id, method, content_length = 0):
    """

    """
    conn = boto.connect_s3(settings.AWS_KEY_ID, settings.AWS_SECRET_KEY)

    if method == "PUT":
        return conn.generate_url(
            expires_in = 3600000,
            method = method,
            bucket = settings.S3_BUCKET_CLOUD_BACKUP,
            key = user_id + ".bak",
            headers = {
                "Content-Length": "%s" % content_length,
                "Content-Type":   "application/x-sqlite3" })
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
    app.run()