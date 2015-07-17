##------------ NETLOGO NUTRIENT SPREAD MODEL 16 July 2015 -----------------##

library(RNetLogo)

NLStart("C:/Program Files/NetLogo 5.0", nl.version=5)
nl.path <- "C:/Program Files/NetLogo 5.0"

model.path <- "/models/Sample Models/Biology/nutrient transfer model diffusion.nlogo"
NLLoadModel(paste(nl.path,model.path,sep=""))

## set model parameters

NLCommand("set N-vultures 0")

NLCommand("set N-carcasses 10")

NLCommand("set N-hyenas 100")

NLCommand("set v-hyena 0")

NLCommand("setup")

# NLCommand("go") ## iterates the model by one tick only

## runs the model for 100 ticks and then collects data on vulturecoords
 nruns <- 1 
 hyenacoords <- list()
 for(i in 1:nruns) {
 NLCommand("go")
hyenacoords [[i]] <- NLGetAgentSet(c("who","xcor","ycor"), "hyenas")}

class(hyenacoords)
str(hyenacoords)

hyenacoords<-as.data.frame(hyenacoords) 
class(hyenacoords)
names(hyenacoords)
x <- hyenacoords$xcor
y <- hyenacoords$ycor

length(x)
length(y)

plot(x, y, pch = 16)


## x<-runif(100)
## y<-runif(100)
plot(x, y, pch = 16)


distance <- function(x1,y1,x2,y2) sqrt((x2-x1)^2 + (y2-y1)^2)
r<-numeric(100)
nn<-numeric(100)
d<-numeric(100)
for (i in 1:100) {
for (k in 1:100) d[k]<-distance(x[i],y[i],x[k],y[k])
r[i]<-min(d[-i])
nn[i]<-which(d==min(d[-i]))
}

for (i in 1:100) lines(c(x[i],x[nn[i]]),c(y[i],y[nn[i]]))

topd <- 1-25
rightd <- 1-25
leftd <- 1+25
bottomd <- 1+25

edge <- pmin(topd, rightd, leftd, bottomd)

sum(edge<r)

id<-which(edge<r)
points(x[id], y[id], col="red",cex=1.5)

mean(r)


