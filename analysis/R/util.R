#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : util.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-04 22:45:22>
##-------------------------------------------------------------------
library(DBI)
library(RMySQL)

################### configuration #################
dbhost="127.0.0.1"
dbuser="root"
dbpwd=""
dbname="wj"
###################################################

## querymysql("select date, amount, notes from expenses where userid='liki' and memo='meal' order by date limit 100;")
querymysql = function(sql, host=dbhost, user=dbuser, password=dbpwd, db=dbname) {
  m <- dbDriver("MySQL")
  conn <- dbConnect(m, host=dbhost, user=dbuser, password=dbpwd, db=dbname)
  res = dbSendQuery(conn, sql)
  dd <- fetch(res, n=-1)
  dbClearResult(res)
  dbDisconnect(conn)
  return(dd)
}

pause = function() {
  print ("Pause, press any key to continue:")
  readline()
}

## File : util.R ends
