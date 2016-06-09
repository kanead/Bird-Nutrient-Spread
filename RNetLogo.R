#################################################################
## NETLOGO NUTRIENT SPREAD MODEL 16 July 2015                  ##
#################################################################
#################################################################
## Load Library and create path to model 
#################################################################
library(RNetLogo)
library(spatstat)
library(MASS)
library(RColorBrewer)
library(gplots)
library(BaylorEdPsych)

NLStart("C:/Program Files (x86)/NetLogo 5.2.1")
nl.path <- "C:/Program Files (x86)/NetLogo 5.2.1"
model.path <- "/models/Sample Models/Biology/nutrient transfer mode Simplifed.nlogo"
NLLoadModel(paste(nl.path,model.path,sep=""))
## the model should set the number of ticks for the nutrients to die as 100
#################################################################
## set model parameters
#################################################################
NLCommand("set N-vultures 0") ## 50
NLCommand("set N-hyenas 30") ## 30
NLCommand("set v-vulture 0.00667") ## 0.00667
NLCommand("set v-hyena 0.00111") ## 0.00111
#################################################################
## Loop the model run
#################################################################
nutrients <- list()
NLCommand("setup")
# run for N days:
for (day in 1:1000) {
  NLCommand("repeat 43200 [go]") ## length of the day
  agent_set <- NLGetAgentSet(c("who", "xcor", "ycor"),
                             "nutrients")
  names(agent_set) <- c("who", "xcor", "ycor")
  agent_set$day = day
  nutrients[[day]] <- agent_set
}
#################################################################
## Calculate metrics associated with nutrients 
#################################################################
vultureNutrients<-nutrients
# nutrientcoords<-as.data.frame(nutrients[10]) 
vultureNutrientsDF<-do.call(rbind.data.frame, vultureNutrients)

## can save results to .csv
# setwd("C:/Users/akane/Desktop/Science/Manuscripts/Nutrients and Birds/data")
write.csv(vultureNutrientsDF, file = "hyNoTerr10.csv")

# countNutrients<-by(vultureNutrientsDF[, 1], vultureNutrientsDF$day, length)

#################################################################
## create a 2D heat map of the nutrients
#################################################################
## http://stackoverflow.com/questions/7073315/how-do-i-create-a-continuous-density-heatmap-of-2d-scatter-data-in-r
## http://www.r-bloggers.com/5-ways-to-do-2d-histograms-in-r/
# vultures and hyenas 
nutrientMap<-read.csv("Vul_Hy.csv", header = T, sep = ",")
# hyenas 
hyenaMap<-read.csv("Hyena.csv", header = T, sep = ",")
# vultures
vulMap<-read.csv("Vulture.csv", header = T, sep = ",")

##### OPTION 1: package 'gplots' #######
par(mfrow=c(1,3))
# vultures and hyenas 
df <- data.frame(nutrientMap$xcor,nutrientMap$ycor)
# Color housekeeping
rf <- colorRampPalette(rev(brewer.pal(11,'RdBu')))
r <- rf(32)
h2 <- hist2d(df, nbins=110, col=r, FUN=function(x) log10(length(x)))

#hyenas 
dfhy <- data.frame(hyenaMap$xcor,hyenaMap$ycor)
# Color housekeeping
rfhy <- colorRampPalette(rev(brewer.pal(11,'RdBu')))
rhy <- rf(32)
h2hy <- hist2d(dfhy, nbins=110, xlim = c(40,180), ylim = c(40,180), col=rhy, FUN=function(x) log10(length(x)))

# vultures 
dfvul <- data.frame(vulMap$xcor,vulMap$ycor)
# Color housekeeping
rfvul <- colorRampPalette(rev(brewer.pal(11,'RdBu')))
rfvul <- rf(32)
h2vul <- hist2d(dfvul, nbins=110, xlim = c(40,180), ylim = c(40,180), col=rhy, FUN=function(x) log10(length(x)))

##### OPTION 2: package 'hexbin' #######
# vultures and hyenas 
hexbinplot(nutrientMap.ycor~nutrientMap.xcor, data=df, colramp=rf, trans=log, inv=exp ,main="Vultures and Hyenas",xlab = "x coordinates", ylab="y coordinates", xlim = c(30,190), ylim = c(30,190))
# hyenas
hexbinplot(hyenaMap.ycor~hyenaMap.xcor, data=dfhy, colramp=rf, trans=log, inv=exp, main="Hyenas",xlab = "x coordinates", ylab="y coordinates", xlim = c(30,190), ylim = c(30,190))
# vultures
hexbinplot(vulMap.ycor~vulMap.xcor, data=dfvul, colramp=rf, trans=log, inv=exp, main="Vultures",xlab = "x coordinates", ylab="y coordinates", xlim = c(30,190), ylim = c(30,190))

## all nutrient data - used to get a panel plot for hexbin
allNuts <- read.csv("allNutData.csv", header = T,sep = ",")
head(allNuts)

hexbinplot(ycor ~ xcor | as.factor(species), data=allNuts, trans=log, inv=exp,
           , panel = function(x,y, ...) {
             panel.hexbinplot(x,y,  ...)
           }
           , xlim = c(30, 190), ylim = c(30, 190)
           , xlab = "x coordinates"
           , ylab = "y coordinates"
           , colramp = rf
          # , strip = strip.custom(factor.levels = as.character(key$batterName))
)
#################################################################
## function for nearest neighbour distance and mean nnd
#################################################################
## subset the data
vulNuts<-subset(allNuts, species=="vulture")
hyNuts<-subset(allNuts, species=="hyena")
bothNuts<-subset(allNuts, species=="both")

meanNearNeigbDist <- function(x) {
  nndistxy<-nndist(x)
  meanNNDist<- mean(nndistxy)
  return(meanNNDist)
}

## apply the function to find mean nearest neighbour distance by day

## both
meannndistListBoth<-by(bothNuts[, 2:3], bothNuts$day, meanNearNeigbDist)
mean(meannndistListBoth)
sd(meannndistListBoth)
## hyenas
meannndistListHy<-by(hyNuts[, 2:3], hyNuts$day, meanNearNeigbDist)
mean(meannndistListHy)
sd(meannndistListHy)
## vultures
meannndistListVul<-by(vulNuts[, 2:3], vulNuts$day, meanNearNeigbDist)
mean(meannndistListVul)
sd(meannndistListVul)

## save that data
nndistListBothSave<-cbind(meannndistListBoth)
write.csv(nndistListBothSave, file = "nnBoth.csv", row.names = F)

nndistListVulSave<-cbind(meannndistListVul)
write.csv(nndistListVulSave, file = "nnVul.csv", row.names = F)

nndistListHySave<-cbind(meannndistListHy)
write.csv(nndistListHySave, file = "nnHyena.csv", row.names = F)

## ANOVA for mean nearest neighbour distance 
nnData <- read.csv("nnDistAll.csv",header = T,sep = ",")
hist(nnData$nndist[nnData$species=="both"])
hist(nnData$nndist[nnData$species=="vulture"])
hist(nnData$nndist[nnData$species=="hyena"])
m1 <- aov(nnData$nndist~nnData$species)
summary(m1)
# Posthoc Tukey test 
posthoc <- TukeyHSD(m1)
posthoc
plot(posthoc)
posthoc$`nnData$species` [,"p adj"]
# Returns eta squared and partial eta squared values for aov objects. Eta-squared ( ) is a measure of effect size for use in ANOVA. 
# is analogous to R2 from multiple linear regression. = SSbetween / SStotal = SSB / SST = proportion of variance in Y explained 
# by X = Non-linear correlation coefficient. Ranges between 0 and 1.
EtaSq(m1)

boxplot(nnData$nndist~nnData$species, pch = 16, xlab = "species present", ylab = "mean nutrient nearest neighbour distance")

## raw nearest neighbour distance 

## both
nndistListBoth<-by(bothNuts[, 2:3], bothNuts$day, nndist)
## hyenas
nndistListHy<-by(hyNuts[, 2:3], hyNuts$day, meanNearNeigbDist)
mean(nndistListHy)
sd(nndistListHy)
## vultures
nndistListVul<-by(vulNuts[, 2:3], vulNuts$day, meanNearNeigbDist)
mean(nndistListVul)
sd(nndistListVul)
#################################################################
## End of Working Code
#################################################################
nndistListDF<-do.call(rbind.data.frame, nndistList)

x <- vultureNutrientsDF$xcor[vultureNutrientsDF$day==1]
y <- vultureNutrientsDF$ycor[vultureNutrientsDF$day==1]

## nearest neighbour distance function from package spatstat
dist <- nndist(x,y) 
mean(dist) ## mean nn dist

## Plot the data on a grid
plot(x, y, pch = 16, xlim=c(0,220), ylim=c(0,220))
grid(110,110,lty=1)
xt<-cut(x,seq(0,220,1))
yt<-cut(y,seq(0,220,1))

## count the number of nutrients per patch 
count<-as.vector(table(xt,yt))
table(count)
sum(table(count))


##-----------------------------------------------------------------------
## runs the model for nruns ticks and then collects data on vulturecoords
##-----------------------------------------------------------------------
 
 nruns <- 1 
 hyenacoords <- list()
 for(i in 1:nruns) {
 NLCommand("go")
hyenacoords [[i]] <- NLGetAgentSet(c("who","xcor","ycor"), "hyenas")}

## we can then extract the x and y coords of the hyenas and work out the
## nearest neighbor distance of the hyenas (Crawley R book Chapter 24) 

hyenacoords<-as.data.frame(hyenacoords) 
class(hyenacoords)
names(hyenacoords)
x <- hyenacoords$xcor
y <- hyenacoords$ycor

length(x)
length(y)

## x<-runif(100)
## y<-runif(100)
plot(x, y, pch = 16)

distance <- function(x1,y1,x2,y2) sqrt((x2-x1)^2 + (y2-y1)^2)
r<-numeric(length(x))
nn<-numeric(length(x))
d<-numeric(length(x))
for (i in 1:length(x)) {
for (k in 1:length(x)) d[k]<-distance(x[i],y[i],x[k],y[k])
r[i]<-min(d[-i])
nn[i]<-which(d==min(d[-i]))
}

for (i in 1:length(x)) lines(c(x[i],x[nn[i]]),c(y[i],y[nn[i]]))

mean(r) ## nearest neighbour distance

##-----------------------------------------------------------------------
## Wrap this into a function where we just need to specify no. of ticks 
##-----------------------------------------------------------------------
run.model <- function(nruns){
NLCommand("setup")
 hyenacoords <- list()
 for(i in 1:nruns) {
 NLCommand("go")
hyenacoords [[i]] <- NLGetAgentSet(c("who","xcor","ycor"), "hyenas")}
}

run.model(5) ## will run the model for 5 ticks 

##-----------------------------------------------------------------------
## Setup a model similar to the above that collects coord data on nutrients
##-----------------------------------------------------------------------
nruns <- 999 
NLCommand("setup")
for (i in 1:nruns)NLCommand("go")
nutrientcoords <- list()
nutrientcoords[[i]] <- NLGetAgentSet(c("who","xcor","ycor"), "nutrients")
nutrientcoords[[i]]
nutrientcoords<-as.data.frame(nutrientcoords[[nruns]]) 

x <- nutrientcoords$xcor
y <- nutrientcoords$ycor
length(x)
length(y)

##-----------------------------------------------------------------------
## Alternative way to run model based on number of days 
##-----------------------------------------------------------------------

NLCommand("setup")
NLDoCommandWhile("day < 10",  "go")
nutrientcoords <- list()
nutrientcoords[[i]] <- NLGetAgentSet(c("who","xcor","ycor"), "nutrients")
nutrientcoords[[i]]
nutrientcoords<-as.data.frame(nutrientcoords[[nruns]]) 

##---------------------------------------------------------------------
## Calculate mean nearest neighbour distance
##---------------------------------------------------------------------
distance <- function(x1,y1,x2,y2) sqrt((x2-x1)^2 + (y2-y1)^2)
r<-numeric(length(x))
nn<-numeric(length(x))
d<-numeric(length(x))
for (i in 1:length(x)) {
for (k in 1:length(x)) d[k]<-distance(x[i],y[i],x[k],y[k])
r[i]<-min(d[-i])
nn[i]<-which(d==min(d[-i]))
}

plot(x, y, pch = 16)
for (i in 1:length(x)) lines(c(x[i],x[nn[i]]),c(y[i],y[nn[i]]))

mean(r) ## this calculates mean nearest neighbour distance

##---------------------------------------------------------------------
## Quadrat-based methods
##---------------------------------------------------------------------
grid(50,50,lty=1)

xt<-cut(x,seq(-25,25,1))
yt<-cut(y,seq(-25,25,1))

count<-as.vector(table(xt,yt))
table(count)

##-----------------------------------------------------------------------
## WORKING MODEL
##-----------------------------------------------------------------------
library(RNetLogo)
library(spatstat)
NLStart("C:/Program Files/NetLogo 5.0")
## specifying the nl.version=5 throws an error so I've deleted this
nl.path <- "C:/Program Files/NetLogo 5.0"

model.path <- "/models/Sample Models/Biology/nutrient transfer model diffusion.nlogo"
NLLoadModel(paste(nl.path,model.path,sep=""))

# set numbers and parameters 
NLCommand("set N-vultures 0")
NLCommand("set N-carcasses 10")
NLCommand("set N-hyenas 20")
NLCommand("set v-hyena 0.1")

# setup model
NLCommand("setup")


NLCommand("setup")
NLDoCommandWhile("day < 1",  "go")
nutrientcoords <- list()
nutrientcoords <- NLGetAgentSet(c("who","xcor","ycor"), "nutrients")
nutrientcoords
nutrientcoords<-as.data.frame(nutrientcoords) 

x <- nutrientcoords$xcor
y <- nutrientcoords$ycor

## nearest neighbour distance function from package spatstat
dist <- nndist(x,y) 
mean(dist) ## mean nn dist

plot(x, y, pch = 16)
for (i in 1:length(x)) lines(c(x[i],x[nn[i]]),c(y[i],y[nn[i]]))

## the above is essentially this function from Crawley
# distance <- function(x1,y1,x2,y2) sqrt((x2-x1)^2 + (y2-y1)^2)
# r<-numeric(length(x))
# nn<-numeric(length(x))
# d<-numeric(length(x))
# for (i in 1:length(x)) {
# for (k in 1:length(x)) d[k]<-distance(x[i],y[i],x[k],y[k])
# r[i]<-min(d[-i])
# nn[i]<-which(d==min(d[-i]))
# }
## this calculates mean nearest neighbour distance
# mean(r)

