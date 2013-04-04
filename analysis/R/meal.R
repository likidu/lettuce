#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : meal.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-04 22:39:52>
##-------------------------------------------------------------------
source("./util.R")

drawplot = function(sql, summary) {
  ## TODO: be more generic
  xlabel="Date"
  ylabel="Amount (Yuan)"
  dd = querymysql(sql)
  dd$date<-as.Date(dd$date, "%Y-%m-%d")
  plot(amount~date, dd, xaxt="n", type="p", xlab=xlabel, ylab=ylabel, main=summary, yaxs="i")
  axis(1, dd$date, format(dd$date, "%y-%m-%d"), cex.axis = .7)
  axis(2, as.integer(summary(dd$amount)))
  abline(dd$amount, dd$date)
}

drawhist = function(sql, summary) {
  ## TODO: be more generic
  xlabel="Amount (Yuan)"
  ylabel="Frequency"
  dd = querymysql(sql)
  uh<-hist(dd$amount, breaks=30)
  plot(uh, ylim=c(0, 300), col="lightgray", xlab=xlabel, ylab=ylabel, main=summary)
  text(uh$mids, uh$counts+2, label=c(uh$counts))
  axis(1, c(10, 20, 30, 40))
  lines(density(dd$amount), col = "blue")
}

## File : meal.R ends
