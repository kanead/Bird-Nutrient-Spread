##------------ NETLOGO NUTRIENT SPREAD MODEL 16 July 2015 -----------------##

##-----------------------------------------------------------------------
## Load Library and create path to model 
##-----------------------------------------------------------------------
library(RNetLogo)

NLStart("C:/Program Files/NetLogo 5.0", nl.version=5)
nl.path <- "C:/Program Files/NetLogo 5.0"

model.path <- "/models/Sample Models/Biology/nutrient transfer model diffusion.nlogo"
NLLoadModel(paste(nl.path,model.path,sep=""))
##-----------------------------------------------------------------------
## set model parameters
##-----------------------------------------------------------------------
NLCommand("set N-vultures 0")
NLCommand("set N-carcasses 10")
NLCommand("set N-hyenas 100")
NLCommand("set v-hyena 0")
NLCommand("setup")
NLCommand("go") ## iterates the model by one tick only

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

##---------------------------------------------------------------
## This speeds up the model greatly 
##---------------------------------------------------------------

nutrients <- list()

NLCommand("setup")

# run for N days:
for (day in 1:5) {
  NLCommand("repeat 36000 [go]")
  agent_set <- NLGetAgentSet(c("who", "xcor", "ycor"),
                             "nutrients")
  names(agent_set) <- c("who", "xcor", "ycor")
  agent_set$day = day
  nutrients[[day]] <- agent_set
  # NLCommand("create-next-day")
}


#ifelse-value(nutrients => 1)




