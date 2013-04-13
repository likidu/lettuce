#!/bin/bash
##-------------------------------------------------------------------
## @copyright 2013
## File : test.sh
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11>
## Updated: Time-stamp: <2013-04-13 09:46:25>
##-------------------------------------------------------------------

SERVER="127.0.0.1"
PORT="8081"

######################## NORMAL TEST ######################################
echo -e "\nTest weibo assign:"
curl -d "userid=denny&accesstoken='3'&expirationdate='2013-04-12 17:30'&refresh_token='token1'" http://$SERVER:$PORT/weibo_assign

echo -e "\nTest db backup:"
curl -d "userid=denny&accesstoken='3'&expirationdate='2013-04-12 17:30'&refresh_token='token1'" http://$SERVER:$PORT/backup

echo -e "\nTest db restore:"
curl -d "userid=denny&accesstoken='3'&expirationdate='2013-04-12 17:30'&refresh_token='token1'" http://$SERVER:$PORT/restore

##########################################################################
## File : test.sh ends