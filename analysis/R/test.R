#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : test.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-05 12:16:06>
##-------------------------------------------------------------------
source("./report.R")

## TODO more functional programming to prevent code duplication
categorydrawplot("denny", "meal", "[Denny] Dinners in restaurant")
pause()

categorydrawboxplot("denny", "meal", "[Denny] Monthly comparision for dinners in restaurant")
pause()

categorydrawhist("denny", "meal", "[Denny] Frequency for dinners in restaurant")
pause()

categorydrawplot("denny", "fruit", "[Denny] Fruit expenses")
pause()

categorydrawplot("liki", "meal", "[Liki] Dinners in restaurant")
pause()

categorydrawboxplot("liki", "meal", "[Liki] Monthly comparision for dinners in restaurant")
pause()

categorydrawhist("liki", "meal", "[Liki] Frequency for dinners in restaurant")
pause()

## categorydrawplot("denny", "salary", "[Denny] salary")
## pause()

## categorydrawhist("denny", "salary", "[Denny] salary")
## pause()

sql="select category, sum(amount) as amount from expenses where userid='denny' and date like '2013-03%' and category not like 'assets%' group by category, left(date, 7) order by sum(amount) desc limit 20;"
drawexpensepie(sql, "[Denny] Monthly Expenses Composition for 2013-03")
pause()

## File : test.R ends
