# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : app.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-20 11:29:59>
##-------------------------------------------------------------------
from flask import Flask
from flask import request
from app import app


# import data
import hashlib

app = Flask(__name__)
app.config.from_pyfile('config_dev.py')

@app.route("/")
def home():
	return "Hello World"

@app.route("/wechat", methods=['GET'])
def wechat_auth():
	echostr = request.args.get('echostr')
	if _verification(request) and echostr is not None:
		return echostr
	return "access verification fail"


def _verification(request):
	token = app.config["API_TOKEN"]
	signature = request.args.get('signature')
	timestamp = request.args.get('timestamp')
	nonce = request.args.get('nonce')
	s = [timestamp, nonce, token]
	s.sort()
	s = ''.join(s)
	if hashlib.sha1(s).hexdigest() == signature:
		return True
	return False

################# public backend api ###########################
# sample: "http://0.0.0.0:8082/add_expense?userid=denny&expense=40,超大杯星巴焦糖玛奇朵"
# @app.route("/add_expense", methods=['GET'])
# def add_expense():
# 	userid = request.args.get('userid', '')
# 	msg = request.args.get('expense', '')
# 	(date, category, amount, branding, comment) = data.split_expense_word(msg)
# 	print date, category, amount, branding, comment
# 	if (amount != -1) and (category != "") and (branding != ""):
# 		tips = "这是一点提示" # TODO to be implemented
# 		content = "恩,记好了:%s,消费%d元。类别:%s, 品牌:%s。原内容:%s。你知道吗, %s。" % \
# 			(date[0:10], amount, category, branding, comment, tips)
# 	else:
# 		content = "记录识别失败。原内容:%s。" % (comment)
# 	resp = make_response(content, 200)
# 	resp.headers['Content-type'] = 'application/json; charset=utf-8'
# 	return resp
#
# # sample: "http://0.0.0.0:8082/view_history?userid=denny"
# @app.route("/view_history", methods=['GET'])
# def view_history():
# 	content = "今日消费:0元 本周消费:425元 本月消费:1730元"
# 	resp = make_response(content, 200)
# 	resp.headers['Content-type'] = 'application/json; charset=utf-8'
# 	return resp
#
# @app.route("/share", methods=['GET'])
# def view_history():
# 	content = "多谢分享"
# 	resp = make_response(content, 200)
# 	resp.headers['Content-type'] = 'application/json; charset=utf-8'
# 	return resp
#
# @app.route("/view_share", methods=['GET'])
# def view_history():
# 	content = "大家都买了XXX"
# 	resp = make_response(content, 200)
# 	resp.headers['Content-type'] = 'application/json; charset=utf-8'
# 	return resp
#
# ## bypass cross domain security
# @app.after_request
# def after_request(response):
# 	response.headers.add('Access-Control-Allow-Origin', '*') # TODO: to be more secured
# 	response.headers.add('Access-Control-Allow-Methods', 'GET')
# 	response.headers.add('Access-Control-Allow-Headers', 'X-Requested-With')
# 	return response

################################################################

################# private functions ############################

################################################################

if __name__ == "__main__":
	# app.run(host="0.0.0.0", port = int(config.FLASK_SERVER_PORT))
	app.run()
## File : app.py
