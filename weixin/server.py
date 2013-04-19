# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : server.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-19 09:57:20>
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
@app.route("/add_expense", methods=['GET'])
def add_expense():
    content = "恩,记好了:2013/4/18,消费37元,星巴克,超大杯焦糖玛奇朵。你知道吗, 今天一共有56人买过了咖啡。"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/view_history", methods=['GET'])
def view_history():
    content = "今日消费:0元 本周消费:425元 本月消费:1730元"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/share", methods=['GET'])
def view_history():
    content = "多谢分享"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/view_share", methods=['GET'])
def view_history():
    content = "大家都买了XXX"
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
