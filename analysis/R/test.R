#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : test.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-04 22:40:22>
##-------------------------------------------------------------------
source("./meal.R")

sql ="select date, amount, notes from expenses where userid='liki' and memo='meal' order by date limit 1000;"
drawplot(sql, "[Liki] Dinners in restaurant")
pause()

drawhist(sql, "[Liki] Frequency for dinners in restaurant")
pause()

sql ="select date, amount, notes from expenses where userid='denny' and memo='dennymeal' order by date limit 1000;"
drawplot(sql, "[Denny] Dinners in restaurant")
pause()

drawhist(sql, "[Denny] Frequency for dinners in restaurant")
pause()

## File : test.R ends
