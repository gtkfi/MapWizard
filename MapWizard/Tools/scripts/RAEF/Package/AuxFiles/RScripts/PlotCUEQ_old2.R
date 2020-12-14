

## packages 
library(MASS)
library(RColorBrewer)
library(Hmisc)
library(pid)
library(akima)
library(zoo)
library(sqldf)


FileName <-"NewBEOut10WO0.csv"
jpeg("CUEQ_MetricTons1.jpg", width = 1000, height = 800,quality = 100)
## uploading data 
MyData <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
MyData$MetricTons <- log10(MyData$MetricTons)        ## log 10 transform of x data

## taking smaller sample of data 
MyData <-  sqldf('select * from MyData where NPV_max > -100000000')
MyData<-  sqldf('select * from MyData where  NPV_max < 100000000')

## saving variables
a = MyData $MetricTons
b = MyData $BE_CUEQ_rev
c = MyData $Depth

MyDatab <- read.csv(file=FileName, header=TRUE, sep=",")
bb = MyDatab $CUEQ_Old

## creates data frame 
df <- data.frame(x=a,y=b,z=c)
x <- df$x
y <- df$y
z <- df$z

## interpolates data to create depth contour lines
fld <- interp(x,y,z,xo=seq(min(x), max(x), length = 40), yo=seq(min(y), max(y), length = 40), linear= TRUE, extrap= TRUE, duplicate= "mean")
par(mar = c(10,10,10,10) + 0.1)
## plots the 2d scatter plot 
plot(a, b, xlab="Ore Tonnage [Log10 t]", ylab="Cut Off Grade [CuEq%]", xlim =c(min(x), max(x) ), ylim = c(min(bb),max(bb)), cex= 0,cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2,xaxt="n", main="Cut Off Grade Vs. Ore Tonnage")
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
bb = MyData $CUEQ_Old
cc = MyData $Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
all<- cbind(xx,yy)
points(all,cex= 0.1, col="Blue",pch=3)

#ggg <<- kde2d(xx,yy)
#contour(ggg$x, ggg$y, ggg$z, lwd=2,labcex= 2, add=TRUE)
####################################################


MyData <- read.csv(file=FileName , header=TRUE, sep=",")

MinD <- min(MyData$Depth)
MaxD <-  max(MyData$Depth)

DiffD <- MaxD - MinD
Div100 <- DiffD / 100
RoundD <- floor(Div100)


IntDMin<- 100* floor(MinD /100)
IntDMax <- 100*floor(MaxD /100)

if ( (MinD / 100) == (IntDMin/ 100))
{
if ( (MaxD / 100) == (IntDMax/ 100))
{

NumDiB4 <- (RoundD - 2)
print (NumDiB4)
## subtract 2 to get regular divsions without min/max
## print divsions numbers 

xy160 <- contourLines(fld$x, fld$y, fld$z, nlevels = NumDiB4)
}}
 
 
if ( ((MinD / 100) != (IntDMin/ 100))| ((MaxD / 100) != (IntDMax/ 100)))
{
NumDiB4 <- (RoundD)
print (NumDiB4)
## else dividsions are set wityhout min/max-  add 2 to get them  ,  but need to round number
xy160 <- contourLines(fld$x, fld$y, fld$z, nlevels = NumDiB4)
}

NumAt <- 100* ceiling(MinD /100)  ### Sets NumAt to 0 min value
MaxD2 <- ((100*floor(MaxD /100)) + 1)  ## sets to 1000 max value plus 1, 1001

while (NumAt < MaxD2)
{
L1 <<-  length(xy160) 
L1 <<- L1 + 1
x1a <- c()
y1a <- c()
Num1L  <- 1
print (NumAt)    ## prints each depth level
DName <<- paste("Depth",NumAt,sep="")

while (Num1L  < L1)  
{
print (Num1L)  ## prints each contour set 

	if (xy160[[Num1L ]]$level == NumAt)
	{
	x1<- xy160[[Num1L]]$x
	y1<- xy160[[Num1L]]$y
	x1a<- c(x1,x1a)
	y1a<- c(y1,y1a)
	}
	xy1a <- cbind(x1a,y1a)
	assign(DName,xy1a, env =.GlobalEnv)
	print (DName)
Num1L <- Num1L + 1      ### ending lines for each set for contour lines 
}
NumAt <- (NumAt + 100)  ### ending lines for each depth level
}

################################################################## 

NumAt <- 100* ceiling(MinD /100)  ### Sets NumAt to 0 min value again
if ( ((MinD / 100) != (IntDMin/ 100))| ((MaxD / 100) != (IntDMax/ 100)))
{
NA1 <- NumAt
}

if ( (MinD / 100) == (IntDMin/ 100))
{
NA1 <- NumAt + 100
}



while (NA1 < MaxD2)
{
AAA <- paste("Depth",NA1,sep="")
BBB <- substring(AAA , 6)

if (!is.null(get(AAA) ))
{
if (nrow(get(AAA)) > 3)
{
smoothingSpline1 = smooth.spline(get(AAA) , spar=0.65)
new1 <- get(AAA)
lines(smoothingSpline1, lwd = 2, col= "Red")
x0 <- (new1 [1,1] + .02)
y0 <- (new1 [1,2] + .02)
text(x0,y0,labels=BBB, font =2)
}
}
NA1 <- NA1+ 100
}
################################################################################



###################################################################################  0

MyData <- read.csv(file=FileName , header=TRUE, sep=",")
## transform data 
MyData$MetricTons <- log10(MyData$MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MyData <-  sqldf('select * from MyData where  NPV_max> -100000000')
MyData<-  sqldf('select * from MyData where NPV_max < 100000000')
MinMin <- MinD + 20
MyData<-  sqldf('select * from MyData where Depth < MinV2')

## saving variables
aa = MyData $MetricTons
bb = MyData $BE_CUEQ_rev
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
text(x0,y0,labels=MinD, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels= MinD, font =2)


###################################################################################  1000
MyData <- read.csv(file=FileName , header=TRUE, sep=",")
## transform data 
MyData$MetricTons<- log10(MyData$MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 

MaxMax <- MaxD - 20
MyData<-  sqldf('select * from MyData where Depth > MaxV2')
MyData<-  sqldf('select * from MyData where Depth < MaxV')
MyData <-  sqldf('select * from MyData where  NPV_max > -200000000')
MyData <-  sqldf('select * from MyData where  Rev_BE_OV< 50')
MyData <-  sqldf('select * from MyData where  MetricTons< 10')

## saving variables
aa = MyData $MetricTons
bb = MyData $BE_CUEQ_rev
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
text(x0,y0,labels=MaxD, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MaxD, font =2)










grid(lwd=1,lty = "dotted",col="Black")







MyDatab <- read.csv(file=FileName, header=TRUE, sep=",")
bb = MyDatab $CUEQ_Old


######################################
hlines <- c(seq(0, max(bb), by = 0.1))
abline(h = hlines, col = "Black", lty = "dotted", lwd = 1)

vlines <- c(seq(0, max(x), by = 0.25))
abline(v = vlines, col = "Black", lty = "dotted", lwd = 1) 


#grid(lwd=1,lty = "dotted",col="Black")
#minor.tick(nx=2, ny=2, tick.ratio=0.5)


legend("topright",inset = 0.025, legend=c("Depth Contour Lines [Meters]", "Simulated Undiscovered Deposits"),
       col=c("red", "blue"), lty=c(1,NA), pch = c(NA,3), lwd= 2, cex=2, bg="White")


dev.off()
dev.off()
dev.off()
dev.off()

#file.remove(FileName)
