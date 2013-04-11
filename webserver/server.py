# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : server.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-11 22:59:01>
##-------------------------------------------------------------------
from flask import Flask
from flask import render_template
from flask import make_response
from flask import request

import config

app = Flask(__name__)

@app.route("/")
def index():
    return "莴苣记账本!"

################# public backend api ###########################
## sample: http://127.0.0.1:8081/api_get_post?id=ffa72494d91aeb2e1153b64ac7fb961f
@app.route("/weibo_uri", methods=['GET', 'POST'])
def weibo_ack():
    if request.method == "POST":
        print request.form.keys()

    if request.method == "GET":
        print request.args.keys()

    content = "ok"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp
    
@app.route("/backup", methods=['POST'])
def backup_db():
    print request.args

    content = "ok"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/restore", methods=['GET'])
def restore_db():
    print request.args

    content = "ok"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
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
