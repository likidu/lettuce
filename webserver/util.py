# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : util.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-11 23:18:31>
##-------------------------------------------------------------------
import logging
format = "%(asctime)s %(filename)s:%(lineno)d - %(levelname)s: %(message)s"
formatter = logging.Formatter(format)

consoleHandler = logging.StreamHandler()
consoleHandler.setLevel(logging.INFO)
consoleHandler.setFormatter(formatter)

filehandler = logging.FileHandler("woojuu.log")
filehandler.setLevel(logging.INFO)
filehandler.setFormatter(formatter)

log = logging.getLogger("woojuu_gateway")
log.setLevel(logging.INFO)
log.addHandler(consoleHandler)
log.addHandler(filehandler)
## File : util.py