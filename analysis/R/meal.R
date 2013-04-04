library(DBI)
library(RMySQL)
m <- dbDriver("MySQL")
conn <- dbConnect(m, host="127.0.0.1", user="root", password="", db="wj")

sql="select date, amount, notes from expenses where userid='liki' and memo='meal' order by date limit 100;"
res = dbSendQuery(conn, sql)

dd <- fetch(res, n=-1)
dd

dd$date<-as.Date(dd$date, "%Y-%m-%d")

plot(amount~date, dd, xaxt="n", type="p", xlab="day", main="wj", yaxs="i")
axis(1, dd$date, format(dd$date, "%m %d"), cex.axis = .7)
axis(2, as.integer(summary(dd$amount)))

sql="select date, amount, notes from expenses where userid='denny' and memo='dennymeal' order by date limit 100;"

dd$date<-as.integer(dd$date)
plot(dd$amount~dd$date)
abline(dd$amount, dd$date)

hist(dd$amount, breaks=30)

uh<-hist(dd$amount, breaks=30)
plot(uh, ylim=c(0, 300), col="lightgray", xlab="", main="Histogram of u")
text(uh$mids, uh$counts+2, label=c(uh$counts))

lines(density(dd$amount), col = "blue")
