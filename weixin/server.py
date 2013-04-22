# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : server.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-22 17:12:08>
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
# sample: "http://0.0.0.0:8082/add_expense?userid=denny&expense=40,超大杯星巴焦糖玛奇朵"
@app.route("/add_expense", methods=['GET'])
def add_expense():
    userid = request.args.get('userid', '')
    msg = request.args.get('expense', '')
    (date, category, amount, branding, comment) = data.split_expense_word(msg)
    print date, category, amount, branding, comment
    if (amount != -1) and (category != "") and (branding != ""):
        # TODO: set source_expenseid and category correctly
        if data.insert_expense(userid, "000", amount, category, date, comment):
            tips = "这是一点提示" # TODO to be implemented
            content = "恩,记好了:%s,消费%d元。类别:%s, 品牌:%s。原内容:%s。你知道吗, %s。" % \
                      (date[0:10], amount, category, branding, comment, tips)
        else:
            content = "数据插入失败。原内容:%s。" % (comment)
            log.error("user(%s) add_expense fail, content:%s" % (userid, content))
    else:
        content = "记录识别失败。原内容:%s。" % (comment)
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

# sample: "http://0.0.0.0:8082/view_history?userid=denny"
@app.route("/view_history", methods=['GET'])
def view_history():
    content = "今日消费:0元 本周消费:425元 本月消费:1730元"
    resp = make_response(content, 200)
    resp.headers['Content-type'] = 'application/json; charset=utf-8'
    return resp

@app.route("/share", methods=['GET'])
def share_history():
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
