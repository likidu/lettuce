# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-12 23:48:10>
##-------------------------------------------------------------------
import MySQLdb
import config

class WEIBOUSER:
    def __init__(self, userid, accesstoken, expirationdate, refresh_token):
        self.userid = userid
        self.accesstoken = accesstoken
        self.expirationdate = expirationdate
        self.refresh_token = refresh_token

    def save():
        return None

## File : data.py