#!/usr/bin/R
##-------------------------------------------------------------------
## @copyright 2013
## File : report.R
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-04>
## Updated: Time-stamp: <2013-04-24 22:23:07>
##-------------------------------------------------------------------
source("./util.R")

categorydrawplot = function(userid, category, summary) {
  png(file="myplot.png", bg="white")
  sql = sprintf("select date, amount, notes from expenses where userid='%s' and memo='%s' order by date limit 1000;",
    userid, category)
  ## TODO: be more generic
  xlabel="Date (YY-MM-DD)"
  ylabel="Amount (Yuan)"
  dd = querymysql(sql)
  dd$date<-as.Date(dd$date, "%Y-%m-%d")
  kmeancount = min(10, length(dd$amount))
    
  plot(amount~date, dd, xaxt="n", type="p", col="blue",
       xlab=xlabel, ylab=ylabel, main=summary, yaxs="i")

  axis(1, dd$date, format(dd$date, "%y-%m-%d"), cex.axis = .7)
  if (category == "meal") {
  ## TODO position overlap
    axis(2, as.integer(summary(dd$amount)))
  }
  abline(dd$amount, dd$date) ## TODO

  ## group notes by kmeans
  data <- cbind(dd$date, dd$amount)
  # TODO defensive code data invalidation
  (cl <- kmeans(data, kmeancount)) 
  points(cl$centers, col = 1:2, pch = 8, cex = 2)

  par(col="brown")
  ## Add lines for the changes
  lines(cl$centers[sort.list(cl$centers[,1]), ])
  par(col="black")
  ## ## Ft line
  ## par(col="green")
  ## fit<-lm(amount~date, dd)
  ## abline(fit)
  ## par(col="black")

  dev.off()
}

categorydrawboxplot = function(userid, category, summary) {
  sql = sprintf("select left(date,7) as date, amount from expenses where userid='%s' and memo='%s' and date>'2012-09-01' order by date desc limit 1000;",
    userid, category)
  dd = querymysql(sql)
  boxplot(amount~date, data=dd, col="lightblue", main=summary)
}

categorydrawhist = function(userid, category, summary) {
  ## TODO: be more generic
  sql = sprintf("select date, amount, notes from expenses where userid='%s' and memo='%s' order by date limit 1000;",
    userid, category)
  xlabel="Amount (Yuan)"
  ylabel="Frequency (Counts)"

  dd = querymysql(sql)

  uh<-hist(dd$amount, breaks=30)
  plot(uh, ylim=c(0, 300), col="lightblue", xlab=xlabel, ylab=ylabel, main=summary)
  text(uh$mids, uh$counts+4, label=c(uh$counts))

  ## TODO: no hard code here
  axis(1, c(10, 20, 30, 40))

  ## TODO: normal curve over histogram
  ## lines(density(dd$amount, bw=30), col = "blue")

  ## m<-mean(dd$amount)
  ## std<-sqrt(var(dd$amount))
  ## curve(dnorm(x, mean=m, sd=std), col="blue", lwd=2, add=TRUE)

}

## sql="select category, sum(amount) as amount from expenses where userid='denny' and date like '2013-03%' and category not like 'assets%' group by category, left(date, 7) order by sum(amount) desc limit 20;"
drawexpensepie = function(sql, summary) {
  ## TODO: be more generic
  dd = querymysql(sql)

  ## TODO: show chinese characters
  ## TODO: combine category with little expense
  ## TODO: show numbers
  pie(dd$amount, labels=dd$category, main=summary)
}

## File : meal.R ends
