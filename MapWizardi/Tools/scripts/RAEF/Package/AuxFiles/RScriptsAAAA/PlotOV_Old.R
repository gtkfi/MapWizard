## packages 
library(MASS)
library(RColorBrewer)
library(Hmisc)
library(pid)
library(akima)
library(zoo)
library(sqldf)

FileName <-"NewBEOut10WO0.csv"
jpeg("OreV_MetricTonsR1.jpg", width = 1000, height = 800,quality = 100)
## uploading data 

MyData <- read.csv(file=FileName , header=TRUE, sep=",")

## transform data 
MyData$MetricTons <- log10(MyData$MetricTons)        ## log 10 transform of x data

## taking smaller sample of data 
MyData <-  sqldf('select * from MyData where NPV_max > -100000000')
MyData<-  sqldf('select * from MyData where  NPV_max < 100000000')

## saving variables
a = MyData $MetricTons
b = MyData $Rev_BE_OV
c = MyData $Depth


## creates data frame 
df <- data.frame(x=a,y=b,z=c)
x <- df$x
y <- df$y
z <- df$z

## interpolates data to create depth contour lines
fld <- interp(x,y,z,xo=seq(min(x), max(x), length = 40), yo=seq(min(y), max(y), length = 40), linear= TRUE, extrap= TRUE, duplicate= "mean")

## plots the 2d scatter plot 
par(mar = c(10,10,10,10) + 0.1)
plot(a, b, xlab="Ore Tonnage [Log10 t]", ylab="Ore Value [2008$/t]  ", xlim =c(min(x), max(x) ), ylim = c(min(y),max(y)), cex= 0,cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2, xaxt="n", main="Cut Off Ore Value Vs. Ore Tonnage")
aty <- axTicks(2)
atx <- axTicks(1)
labels <- sapply(atx,function(i)
            as.expression(bquote(10^ .(i)))
          )
axis(at=atx,1,labels=labels, cex.axis=1.5)




################### plotting all orig points
MyData <- read.csv(file=FileName, header=TRUE, sep=",")
## transform data 
MyData$MetricTons <- log10(MyData$MetricTons)   
aa = MyData $MetricTons
bb = MyData $OreValueOld
cc = MyData $Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
all<- cbind(xx,yy)
points(all,cex= 0.1, col="Blue",pch=3)

######################################################################

xy160 <- contourLines(fld$x, fld$y, fld$z)  

xy160 <- contourLines(fld$x, fld$y, fld$z, nlevels = 12)


## 1

x1<- xy160[[5]]$x
y1<- xy160[[5]]$y
xy1<- cbind(x1,y1)

smoothingSpline1 = smooth.spline(xy1, spar=0.65)
#plot(xy1)
lines(smoothingSpline1, lwd = 2, col= "Red")
x0 <- (x1[1] + .02)
y0 <- (y1[1] + .02)
text(x0,y0,labels="   100", font =2)
tx <- min(x1) 
ty <- max(y1)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   100", font =2)

## 2

x2<- xy160[[10]]$x
y2<- xy160[[10]]$y
xy2<- cbind(x2,y2)

smoothingSpline2 = smooth.spline(xy2, spar=0.7)
#plot(xy2)
lines(smoothingSpline2, lwd = 2 ,col= "Red")
x0 <- (x2[1] + .02)
y0 <- (y2[1] + .02)
text(x0,y0,labels="   200", font =2)
tx <- min(x2) 
ty <- max(y2)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
#text(x00,y00,labels="   200")

## 3

x3<- xy160[[11]]$x
y3<- xy160[[11]]$y
xy3<- cbind(x3,y3)

smoothingSpline3 = smooth.spline(xy3, spar=0.7)
#plot(xy3)
lines(smoothingSpline3, lwd = 2,col= "Red")
x0 <- (x3[1] + .02)
y0 <- (y3[1] + .02)
text(x0,y0,labels="   300", font =2)
tx <- min(x3) 
ty <- max(y3)
x00 <- (tx - .02225)
y00 <- (ty)
text(x00,y00,labels="   300", font =2)


## 4

x4<- xy160[[12]]$x
y4<- xy160[[12]]$y
xy4<- cbind(x4,y4)

smoothingSpline4 = smooth.spline(xy4, spar=0.7)
#plot(xy4)
lines(smoothingSpline4, lwd = 2,col= "Red")
x0 <- (x4[1] + .02)
y0 <- (y4[1] + .02)
text(x0,y0,labels="   400", font =2)
tx <- min(x4) 
ty <- max(y4)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
#text(x00,y00,labels="   400")

## 5

x5<- xy160[[13]]$x
y5<- xy160[[13]]$y
xy5<- cbind(x5,y5)

smoothingSpline5 = smooth.spline(xy5, spar=0.7)
#plot(xy5)
lines(smoothingSpline5, lwd = 2,col= "Red")
x0 <- (x5[1] + .02)
y0 <- (y5[1] + .02)
text(x0,y0,labels="   500", font =2)
tx <- min(x5) 
ty <- max(y5)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   500", font =2)

## 6

x6<- xy160[[14]]$x
y6<- xy160[[14]]$y
xy6<- cbind(x6,y6)

smoothingSpline6 = smooth.spline(xy6, spar=0.7)
#plot(xy6)
lines(smoothingSpline6, lwd = 2,col= "Red")
x0 <- (x6[1] + .02)
y0 <- (y6[1] + .02)
text(x0,y0,labels="   600", font =2)
tx <- min(x6) 
ty <- max(y6)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
#text(x00,y00,labels="   600")

## 7

x7<- xy160[[15]]$x
y7<- xy160[[15]]$y
xy7<- cbind(x7,y7)

smoothingSpline7 = smooth.spline(xy7, spar=0.7)
#plot(xy7)
lines(smoothingSpline7, lwd = 2,col= "Red")
x0 <- (x7[1] + .02)
y0 <- (y7[1] + .02)
text(x0,y0,labels="   700", font =2)
tx <- min(x7) 
ty <- max(y7)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   700", font =2)

##8

x8<- xy160[[16]]$x
y8<- xy160[[16]]$y
xy8<- cbind(x8,y8)

smoothingSpline8 = smooth.spline(xy8, spar=0.7)
#plot(xy8)
lines(smoothingSpline8, lwd = 2,col= "Red")

x0 <- (x8[1] + .02)
y0 <- (y8[1] + .02)
text(x0,y0,labels="   800", font =2)
tx <- min(x8) 
ty <- max(y8)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
#text(x00,y00,labels="   800", font =2)

##9

x9<- xy160[[17]]$x
y9<- xy160[[17]]$y
xy9<- cbind(x9,y9)

smoothingSpline9 = smooth.spline(xy9, spar=0.7)
#plot(xy9)
lines(smoothingSpline9,col="Red", lwd = 2)

x0 <- (x9[1] + .02)
y0 <- (y9[1] + .02)
text(x0,y0,labels="   900", font =2)
tx <- min(x9) 
ty <- max(y9)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   900", font =2)





MyData <- read.csv(file=FileName , header=TRUE, sep=",")
## transform data 
MyData$MetricTons <- log10(MyData$MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MyData <-  sqldf('select * from MyData where  NPV_max> -100000000')
MyData<-  sqldf('select * from MyData where NPV_max < 100000000')
MyData<-  sqldf('select * from MyData where Depth < 20')

## saving variables
aa = MyData $MetricTons
bb = MyData $Rev_BE_OV
cc = MyData $Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.9)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels="   0", font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   0", font =2)


MyData <- read.csv(file=FileName , header=TRUE, sep=",")
## transform data 
MyData$MetricTons<- log10(MyData$MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MyData<-  sqldf('select * from MyData where Depth > 980')
MyData<-  sqldf('select * from MyData where Depth < 1000')
MyData <-  sqldf('select * from MyData where  NPV_max > -200000000')
MyData <-  sqldf('select * from MyData where  Rev_BE_OV< 50')
MyData <-  sqldf('select * from MyData where  MetricTons< 10')

## saving variables
aa = MyData $MetricTons
bb = MyData $Rev_BE_OV
cc = MyData $Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.9)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels="   1000", font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx - .02225)
y00 <- (ty + 0.25)
text(x00,y00,labels="   1000", font =2)
hlines <- c(seq(5, max(y), by = 5))
abline(h = hlines, col = "Black", lty = "dotted", lwd = 1)

vlines <- c(seq(0, max(x), by = 0.25))
abline(v = vlines, col = "Black", lty = "dotted", lwd = 1) 


grid(lwd=1,lty = "dotted",col="Black")
minor.tick(nx=2, ny=2, tick.ratio=0.5)



legend("topright",inset = 0.025, legend=c("Depth Contour Lines [Meters]", "Simulated Undiscovered Deposits"),
       col=c("red", "blue"), lty=c(1,NA), pch = c(NA,3), lwd= 2, cex=2, bg="White")


dev.off()

#file.remove(FileName)









