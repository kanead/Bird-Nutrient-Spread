##############################################################################
## Plotting Carrion Leftover after African and Asian Vulture Declines
##############################################################################
# clear everything
rm(list=ls()) 
require(lattice)
require(ggplot2)
setwd("C:/Users/akane/Desktop/Science/Manuscripts/Nutrients and Birds/data")
dir()
##############################################################################
mydata<-read.csv("africa_asia_vultures.csv", header=T,sep=",")
head(mydata)
names(mydata)

asiabefore<-(mydata$before_t[mydata$area=="asia"])
asiaafter<-(mydata$after_t[mydata$area=="asia"])
africabefore<-(mydata$before_t[mydata$area=="africa"])
africaafter<-(mydata$after_t[mydata$area=="africa"])

par(mfrow=c(1,2))
par(mar=c(2,4,2,5))

africaData<-matrix(c(africabefore,africaafter), nrow=2, byrow=T)
# colnames(africaData)<-c("G.a.", "N.m.", "N.p.", "G.r.", "T.o.", "G.c.", "T.t.", "G. b.")
colnames(africaData)<-c("G. africanus", "N. monachus", "N. percnopterus", "G. rueppellii", "T. occipitalis", "G. coprotheres", "T. tracheliotos", "G. barbatus")
# rownames(africaData)<-c("Africa before","Africa after")
barplot(africaData,beside = T, axis.lty = 1, space=c(0.0,0.2),  lwd = 2, xlab="Species", ylab="Carrion consumed per year (tonnes)")

asiaData<-matrix(c(asiabefore,asiaafter), nrow=2, byrow=T)
colnames(asiaData)<-c("G.be.", "G.i.", "S.c.", "G.t.")
# rownames(africaData)<-c("Asia before","Asia after")
barplot(asiaData,beside = T, xlab="Species")

legend("topright", 
       legend = c("Before", "After"), 
       fill = c("black", "grey"), bty = "n")
##############################################################################
## Log10 version of plot 
##############################################################################
par(mfrow=c(1,2))
par(mar=c(2,4,2,5))

logasiabefore<-(log10(mydata$before_t[mydata$area=="asia"]))
logasiaafter<-(log10(mydata$after_t[mydata$area=="asia"]))
logafricabefore<-(log10(mydata$before_t[mydata$area=="africa"]))
logafricaafter<-(log10(mydata$after_t[mydata$area=="africa"]))
par(mfrow=c(1,2))

logafricaData<-matrix(c(logafricabefore,logafricaafter), nrow=2, byrow=T)
colnames(logafricaData)<-c("G.a.", "N.m.", "N.p.", "G.r.", "T.o.", "G.c.", "T.t.", "G. b.")
# rownames(africaData)<-c("Africa before","Africa after")
barplot(logafricaData,beside = T, xlab="Species", axis.lty = 1, ylab="Log 10 Carrion consumed per year (tonnes)")

logasiaData<-matrix(c(logasiabefore,logasiaafter), nrow=2, byrow=T)
colnames(logasiaData)<-c("G.be.", "G.i.", "S.c.", "G.t.")
# rownames(africaData)<-c("Asia before","Asia after")
barplot(logasiaData,beside = T, axis.lty = 1, xlab="Species")

legend("topright", 
       legend = c("Before", "After"), 
       fill = c("black", "grey"), bty = "n")



expression("sub-title"[2])
## Decreasing switches order of data
# asiabefore<-sort(mydata$before_t[mydata$area=="asia"], decreasing = T)
# asiaafter<-sort(mydata$after_t[mydata$area=="asia"], decreasing = T)
# africabefore<-sort(mydata$before_t[mydata$area=="africa"], decreasing = T)
# africaafter<-sort(mydata$after_t[mydata$area=="africa"], decreasing = T)


#africabefore<-mydata$before_t[mydata$area=="africa"]
#africabefore<-sort(mydata$before_t[mydata$area=="africa"], decreasing = F)
#africabefore<-(mydata$before_t[mydata$area=="africa"])
#logafricabefore<-log10(mydata$before_t[mydata$area=="africa"])

## create a vector of vulture species names 
## first African
#africanvuls <- c("G. barbatus", "T. tracheliotos", "G. coprotheres", "T. occipitalis", 
#"G. rueppellii", "N. percnopterus", "N. monachus", "G. africanus")

## Initials 
afin <- c("G. b.", "T. t.", "G. c.", "T. o.", "G. r.", "N. p.", "N. m.", "G. a.")

## then Asian
#asianvuls <- c("G. tenuirostris", "S. calvus", "G. indicus", "G. bengalensis")
asin <- c("G. t.", "S. c.", "G. i.", "G. be.")

## Create a 4 panel plot
par(mfrow=c(2,2))

## Plot with numbers for species names - Africa before
barplot(africabefore, main="Africa Today", xlab="Species", ylab="Carrion per Year (tonnes)", 
        names.arg=afin, border="black")

## Plot Africa after
barplot(africaafter, main="Africa After", xlab="Species", ylab="Carrion per Year (tonnes)", 
        names.arg=afin, border="black")

## Plot with numbers for species names - Asia before
barplot(asiabefore, main="Asia Before", xlab="Species", ylab="Carrion per Year (tonnes)", 
        names.arg=asin, border="black")

## Plot Asia after
barplot(asiaafter, main="Asia After", xlab="Species", ylab="Carrion per Year (tonnes)", 
        names.arg=asin, border="black")

##----------------------------------------------------------------------------------------------------
## Other options
##----------------------------------------------------------------------------------------------------
## Simple Plot 
#barplot(africabefore, main="Africa Today", xlab="Species", ylab="Tonnes of Carrion per Year", 
#names.arg=africanvuls, border="black")

## Plot with rotated labels
#par(mar = c(7, 4, 4, 2) + 0.1)
#x <- barplot(africabefore, xaxt="n")
#labs <- africanvuls
#text(cex=0.9, x=x-.1, y=-1.25, labs, xpd=T, srt=45, pos=2.5)

## Plot with numbers for species names
#barplot(africabefore, main="Africa Today", xlab="Species", ylab="Tonnes of Carrion per Year", 
#names.arg=c(1:8), border="black")

## Plot with log values for carrion
#barplot(logafricabefore, main="Africa Today", xlab="Species", ylab="Log Tonnes of Carrion per Year", 
#names.arg=c(1:8), border="black")


