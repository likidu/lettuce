# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : server.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-28 17:51:29>
##-------------------------------------------------------------------
from flask import Flask, request
from flask import make_response
from flask import render_template
from werkzeug.utils import secure_filename

import os
import config
from util import log
import data

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['UPLOAD_FOLDER'] = config.UPLOAD_FOLDER

@app.route("/")
def index():
    return config.HELLO_STRING

################# public backend api ###########################
@app.route("/weibo_assign", methods=['POST'])
def weibo_assign():
    # TODO defensive check
    if data.save_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refreshtoken"]) \
        is False:
        return handle_error("500", "server error")
    else:
        content = '''<xml>
  <status>%s</status>
  <message>%s</message>
</xml>
''' % ("200", "ok")
        resp = make_response(content, 200)
        resp.headers['Content-type'] = 'application/json; charset=utf-8'
        return resp

@app.route("/weibo_revoke", methods=['POST'])
def weibo_revoke():
    if data.delete_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refreshtoken"]) \
        is False:
        return handle_error("500", "server error")
    else:
        content = "ok"
        resp = make_response(content, 200)
        resp.headers['Content-type'] = 'application/json; charset=utf-8'
        return resp

@app.route("/backup", methods=['POST'])
def backup_db():
    userid = request.form['WeiboAccount[WeiboAccountUserId]']
    expirationdate = request.form['WeiboAccount[WeiboAccountExpirationDate]']
    accesstoken = request.form['WeiboAccount[WeiboAccountAccessToken]']
    refreshtoken = "" # TODO
    if data.auth_user(userid, accesstoken, expirationdate, refreshtoken) \
        is False:
        return handle_error("500", "server error")

    file = request.files['file']
    if file and _allowed_file(file.filename):
        filename = "%s_%s" % (userid, secure_filename(file.filename))
        file.save(os.path.join(os.getcwd(), app.config['UPLOAD_FOLDER'], filename))
        print "Uploaded %s" % filename
    content = '''<xml>
  <status>%s</status>
  <message>%s</message>
</xml>
''' % ("200", "ok")

    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/restore", methods=['POST'])
def restore_db():
    if data.auth_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refreshtoken"]) \
        is False:
        return handle_error("500", "server error")
    else:
        content = '''<xml>
  <status>%s</status>
  <message>%s</message>
  <data>%s</data>
</xml>
''' % ("200", "ok", "data")

        resp = make_response(content, 200)
        resp.headers['Content-type'] = 'application/xml; charset=utf-8'
        return resp

## bypass cross domain security
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*') # TODO: to be more secured
    response.headers.add('Access-Control-Allow-Methods', 'GET')
    response.headers.add('Access-Control-Allow-Headers', 'X-Requested-With')
    return response

################################################################

################# private functions ############################
def handle_error(errcode, errmsg):
    content = '''<xml>
    <status>%s</status>
  <message>%s</message>
</xml>
''' % (errcode, errmsg)
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/xml; charset=utf-8'
    return resp

def _allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1] \
            in config.ALLOWED_EXTENSIONS

################################################################

if __name__ == "__main__":
    app.run(host="0.0.0.0", port = int(config.FLASK_SERVER_PORT))
## File : server.py
