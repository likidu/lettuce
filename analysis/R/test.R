#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : test.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-04 22:11:23>
##-------------------------------------------------------------------
source("./meal.R")

sql ="select date, amount, notes from expenses where userid='denny' and memo='dennymeal' order by date limit 1000;"

drawplot(sql)
pause()
drawhist(sql)

## File : test.R ends
