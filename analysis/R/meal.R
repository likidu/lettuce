#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : meal.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-05 00:27:41>
##-------------------------------------------------------------------
source("./util.R")

drawplot = function(sql, summary) {
  ## TODO: be more generic
  xlabel="Date (YY-MM-DD)"
  ylabel="Amount (Yuan)"
  dd = querymysql(sql)
  dd$date<-as.Date(dd$date, "%Y-%m-%d")
  
  plot(amount~date, dd, xaxt="n", type="p", col="blue",
       xlab=xlabel, ylab=ylabel, main=summary, yaxs="i")

  axis(1, dd$date, format(dd$date, "%y-%m-%d"), cex.axis = .7)
  axis(2, as.integer(summary(dd$amount)))
  abline(dd$amount, dd$date)

  ## group notes by kmeans
  data <- cbind(dd$date, dd$amount)
  # TODO defensive code data invalidation
  (cl <- kmeans(data, 3)) 
  points(cl$centers, col = 1:2, pch = 8, cex = 2)

}

drawhist = function(sql, summary) {
  ## TODO: be more generic
  xlabel="Amount (Yuan)"
  ylabel="Frequency (Counts)"

  dd = querymysql(sql)

  uh<-hist(dd$amount, breaks=30)
  plot(uh, ylim=c(0, 300), col="lightblue", xlab=xlabel, ylab=ylabel, main=summary)
  text(uh$mids, uh$counts+4, label=c(uh$counts))

  axis(1, c(10, 20, 30, 40))

  ## TODO: normal curve over histogram
  ## lines(density(dd$amount, bw=30), col = "blue")

  ## m<-mean(dd$amount)
  ## std<-sqrt(var(dd$amount))
  ## curve(dnorm(x, mean=m, sd=std), col="blue", lwd=2, add=TRUE)

}

## File : meal.R ends
