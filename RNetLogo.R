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

mean(r)
#Quadrat-based methods
grid(50,50,lty=1)

xt<-cut(x,seq(-25,25,1))
yt<-cut(y,seq(-25,25,1))

count<-as.vector(table(xt,yt))
table(count)
