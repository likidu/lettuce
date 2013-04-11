#!/bin/bash
##-------------------------------------------------------------------
## @copyright 2013
## File : test.sh
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11>
## Updated: Time-stamp: <2013-04-11 22:57:47>
##-------------------------------------------------------------------

SERVER="127.0.0.1"
PORT="8081"

######################## NORMAL TEST ######################################
curl -d "a=test&b=3" http://$SERVER:$PORT/weibo_uri
curl "http://$SERVER:$PORT/weibo_uri?a=test&b=3"
##########################################################################
## File : test.sh ends