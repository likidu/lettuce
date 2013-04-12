#!/bin/bash
##-------------------------------------------------------------------
## @copyright 2013
## File : test.sh
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11>
## Updated: Time-stamp: <2013-04-12 23:36:02>
##-------------------------------------------------------------------

SERVER="127.0.0.1"
PORT="8081"

######################## NORMAL TEST ######################################
curl -d "userid=denny&accesstoken='3'&expirationDate='2013-04-12 17:30'&refresh_token='token1'" http://$SERVER:$PORT/weibo_assign

##########################################################################
## File : test.sh ends