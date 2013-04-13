# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : server.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-13 09:48:27>
##-------------------------------------------------------------------
from flask import Flask
from flask import render_template
from flask import make_response
from flask import request

import config
from util import log
import data

app = Flask(__name__)

@app.route("/")
def index():
    return config.HELLO_STRING

################# public backend api ###########################
@app.route("/weibo_assign", methods=['POST'])
def weibo_assign():
    # TODO defensive check
    if data.save_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refresh_token"]) \
        is True:
        content = "ok"
    else:
        content = "error"

    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/weibo_revoke", methods=['POST'])
def weibo_revoke():
    if data.delete_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refresh_token"]) \
        is True:
        content = "ok"
    else:
        content = "error"

    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/backup", methods=['POST'])
def backup_db():
    if data.auth_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refresh_token"]) \
        is True:
        content = "ok"
    else:
        content = "error"

    content = '''<xml>
  <status>%s</status>
  <message>%s</message>
</xml>
''' % ("ok", "ok")
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/restore", methods=['POST'])
def restore_db():
    if data.auth_user(request.values["userid"], request.values["accesstoken"],\
                      request.values["expirationdate"], request.values["refresh_token"]) \
        is True:
        content = "ok"
    else:
        content = "error"

    content = '''<xml>
  <status>%s</status>
  <message>%s</message>
  <data>%s</data>
</xml>
''' % ("ok", "ok", "data")

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

################################################################

if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0", port = int(config.FLASK_SERVER_PORT))
## File : server.py
