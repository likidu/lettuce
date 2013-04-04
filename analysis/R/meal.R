#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : meal.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-04 16:39:14>
##-------------------------------------------------------------------
source("./util.R")

sql ="select date, amount, notes from expenses where userid='liki' and memo='meal' order by date limit 1000;"
sql ="select date, amount, notes from expenses where userid='denny' and memo='dennymeal' order by date limit 1000;"

## drawplot(sql)
drawplot = function(sql) {
  dd = querymysql(sql)
  plot(amount~date, dd, xaxt="n", type="p", xlab="day", main="wj", yaxs="i")
  dd$date<-as.Date(dd$date, "%Y-%m-%d")
  axis(1, dd$date, format(dd$date, "%m %d"), cex.axis = .7)
  axis(2, as.integer(summary(dd$amount)))

  plot(dd$amount~dd$date)
  abline(dd$amount, dd$date)
}

## drawhist(sql)
drawhist = function(dd) {
  dd = querymysql(sql)
  uh<-hist(dd$amount, breaks=30)
  plot(uh, ylim=c(0, 300), col="lightgray", xlab="", main="Histogram of u")
  text(uh$mids, uh$counts+2, label=c(uh$counts))

  lines(density(dd$amount), col = "blue")
}

## File : meal.R ends
