library(akima)
library(zoo)
library(sqldf)

JpegName <<- paste(TN1,"_OV_MetricTons.jpg",sep="")

jpeg(JpegName, width = 1000, height = 800,quality = 100)







FileName <-NewCalcName2 
FileData2 <- read.csv(file=NewCalcName2 , header=TRUE, sep=",")
FileData2$MetricTons <- log10(FileData2$MetricTons)  ## log 10 transform of x data
## saving variables
a2 = FileData2 $MetricTons
b2 = FileData2 $BE_V_Rev
c2 = FileData2 $Depth
d2 = FileData2 $OreValueOld
## creates data frame 
df2 <- data.frame(x=a2,y=b2,z=c2)
x2 <- df2$x
y2 <- df2$y
z2 <- df2$z

############################################# Creating empty plot figure with units 
par(mar = c(10,10,10,10) + 0.1)
Title1 <- paste("Cut Off Ore Value Vs. Ore Tonnage - ",TN1,sep=" ") 


yy2 <<- max(d2)
if (max(d2)> 100)
	{
	yy2 <<-100
	}



plot(a2, b2, xlab="Ore Tonnage [Log10 t]", ylab="Cut Off Ore Value [2008$/t]", xlim =c(min(x2,na.rm = TRUE), max(x2,na.rm = TRUE) ), ylim = c(0,yy2), cex= 0,cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2,xaxt="n", main=Title1)
aty <- axTicks(2)
atx <- axTicks(1)

labels <- sapply(atx,function(i)
            as.expression(bquote(10^ .(i)))
          )
axis(at=atx,1,labels=labels, cex.axis=1.5)

################################### plotting all orig points

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


FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")
FileData3$MetricTons <- log10(FileData3$MetricTons)  ## log 10 transform of x data

##################################################################### Drawing grid lines 

grid(lwd=1,lty = "dotted",col="Black")


MyDatab <- read.csv(file=FileName, header=TRUE, sep=",")
bb = MyDatab $OreValueOld

hlines <- c(seq(0, max(bb), by = 5))
abline(h = hlines, col = "Black", lty = "dotted", lwd = 1)

vlines <- c(seq(0, max(x), by = 0.25))
abline(v = vlines, col = "Black", lty = "dotted", lwd = 1) 


#grid(lwd=1,lty = "dotted",col="Black")
#minor.tick(nx=2, ny=2, tick.ratio=0.5)

####################################################### Setting Max/Mins
MinD <- min(FileData3$Depth)
MaxD <-  max(FileData3$Depth)
DiffD <- MaxD - MinD

##if #intervals is greater 10 - set division by 200 but if greater 10 do previous interval + 100 - keep doing it untiul number is less than or equal to 10 , also always a contour at 0 ,  always do  min line at 0 also 
Div100 <- DiffD / 100
Start <- 100
Divide1 <- Start
while (Div100 > 10)
{
if (Div100 > 10)
{
Divide1 <- (Start + 100)
Div100 <- DiffD / (Divide1 )
}
}



RoundD <- floor(Div100)

IntDMin<- 100* floor(MinD /100)
IntDMax <- 100*floor(MaxD /100)

############################################################ Setting Num of Divisons  
if ( (MinD / 100) == (IntDMin/ 100))
{
if ( (MaxD / 100) == (IntDMax/ 100))
{

NumDiB4 <- (RoundD - 2)
#print (NumDiB4)
## subtract 2 to get regular divsions without min/max
## print divsions numbers 

}}

if ( ((MinD / 100) != (IntDMin/ 100))| ((MaxD / 100) != (IntDMax/ 100)))
{
NumDiB4 <- (RoundD)
#print (NumDiB4)

}

########################################################### Setting celing and floor values

NumAt <- 100* ceiling(MinD /100)  ### Sets NumAt to 0 min value
MaxD2 <- ((100*floor(MaxD /100)) )  ## sets to 1000 max value plus 1, 1001


############################################################  Making Depth level groups
NumAt <- (NumAt + Divide1)
while (NumAt < MaxD2)
{
NumAtU<- NumAt - 1
NumAtA<- NumAt + 1
#print (NumAt)    ## prints each depth level
DName <<- paste("Depth",NumAt,sep="")
#print (DName)

newdata00 <- FileData3 [FileData3$Depth==NumAt  | FileData3$Depth==NumAtU | FileData3$Depth==NumAtA,]


## saving variables
aa = newdata00$MetricTons
bb = newdata00$BE_V_Rev
cc = newdata00$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.20)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=NumAt , font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=NumAt , font =2)
NumAt <- (NumAt + Divide1)  ### ending lines for each depth level
}
################################################################### Developing Max line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MaxV <- FileData3$MaxV[1]
NumAtU<- MaxV - 1

FileData3a<- FileData3 [FileData3$Depth==MaxV | FileData3$Depth==NumAtU,]



## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.6)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=MaxV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MaxV, font =2)

################################################################### Developing Min line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MinV <- FileData3$MinV[1]
NumAtA<- MinV + 1

FileData3a<- FileData3 [FileData3$Depth==MinV | FileData3$Depth==NumAtA,]




## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.60)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx))
y0 <- (min(yy) )
text(x0,y0,labels=MinV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MinV, font =2)



####################################################################### Writing legend 
legend("topright",inset = 0.025, legend=c("Depth Contour Lines [Meters]", "Simulated Undiscovered Deposits"),
       col=c("red", "blue"), lty=c(1,NA), pch = c(NA,3), lwd= 2, cex=2, bg="White")

dev.off()
#dev.off()
#dev.off()
#dev.off()



TiffName <<- paste(TN1,"_OV_MetricTons.tiff",sep="")
tiff(TiffName, width = 1000, height = 800)
FileName <-NewCalcName2 
FileData2 <- read.csv(file=NewCalcName2 , header=TRUE, sep=",")
FileData2$MetricTons <- log10(FileData2$MetricTons)  ## log 10 transform of x data
## saving variables
a2 = FileData2 $MetricTons
b2 = FileData2 $BE_V_Rev
c2 = FileData2 $Depth
d2 = FileData2 $OreValueOld
## creates data frame 
df2 <- data.frame(x=a2,y=b2,z=c2)
x2 <- df2$x
y2 <- df2$y
z2 <- df2$z

############################################# Creating empty plot figure with units 
par(mar = c(10,10,10,10) + 0.1)
Title1 <- paste("Cut Off Ore Value Vs. Ore Tonnage - ",TN1,sep=" ") 


yy2 <<- max(d2)
if (max(d2)> 100)
	{
	yy2 <<-100
	}



plot(a2, b2, xlab="Ore Tonnage [Log10 t]", ylab="Cut Off Ore Value [2008$/t]", xlim =c(min(x2,na.rm = TRUE), max(x2,na.rm = TRUE) ), ylim = c(0,yy2), cex= 0,cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2,xaxt="n", main=Title1)
aty <- axTicks(2)
atx <- axTicks(1)

labels <- sapply(atx,function(i)
            as.expression(bquote(10^ .(i)))
          )
axis(at=atx,1,labels=labels, cex.axis=1.5)

################################### plotting all orig points

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


FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")
FileData3$MetricTons <- log10(FileData3$MetricTons)  ## log 10 transform of x data

##################################################################### Drawing grid lines 

grid(lwd=1,lty = "dotted",col="Black")


MyDatab <- read.csv(file=FileName, header=TRUE, sep=",")
bb = MyDatab $OreValueOld

hlines <- c(seq(0, max(bb), by = 5))
abline(h = hlines, col = "Black", lty = "dotted", lwd = 1)

vlines <- c(seq(0, max(x), by = 0.25))
abline(v = vlines, col = "Black", lty = "dotted", lwd = 1) 


#grid(lwd=1,lty = "dotted",col="Black")
#minor.tick(nx=2, ny=2, tick.ratio=0.5)

####################################################### Setting Max/Mins
MinD <- min(FileData3$Depth)
MaxD <-  max(FileData3$Depth)
DiffD <- MaxD - MinD

##if #intervals is greater 10 - set division by 200 but if greater 10 do previous interval + 100 - keep doing it untiul number is less than or equal to 10 , also always a contour at 0 ,  always do  min line at 0 also 
Div100 <- DiffD / 100
Start <- 100
Divide1 <- Start
while (Div100 > 10)
{
if (Div100 > 10)
{
Divide1 <- (Start + 100)
Div100 <- DiffD / (Divide1 )
}
}



RoundD <- floor(Div100)

IntDMin<- 100* floor(MinD /100)
IntDMax <- 100*floor(MaxD /100)

############################################################ Setting Num of Divisons  
if ( (MinD / 100) == (IntDMin/ 100))
{
if ( (MaxD / 100) == (IntDMax/ 100))
{

NumDiB4 <- (RoundD - 2)
#print (NumDiB4)
## subtract 2 to get regular divsions without min/max
## print divsions numbers 

}}

if ( ((MinD / 100) != (IntDMin/ 100))| ((MaxD / 100) != (IntDMax/ 100)))
{
NumDiB4 <- (RoundD)
#print (NumDiB4)

}

########################################################### Setting celing and floor values

NumAt <- 100* ceiling(MinD /100)  ### Sets NumAt to 0 min value
MaxD2 <- ((100*floor(MaxD /100)) )  ## sets to 1000 max value plus 1, 1001


############################################################  Making Depth level groups
NumAt <- (NumAt + Divide1)
while (NumAt < MaxD2)
{
NumAtU<- NumAt - 1
NumAtA<- NumAt + 1
#print (NumAt)    ## prints each depth level
DName <<- paste("Depth",NumAt,sep="")
#print (DName)

newdata00 <- FileData3 [FileData3$Depth==NumAt  | FileData3$Depth==NumAtU | FileData3$Depth==NumAtA,]


## saving variables
aa = newdata00$MetricTons
bb = newdata00$BE_V_Rev
cc = newdata00$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.20)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=NumAt , font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=NumAt , font =2)
NumAt <- (NumAt + Divide1)  ### ending lines for each depth level
}
################################################################### Developing Max line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MaxV <- FileData3$MaxV[1]
NumAtU<- MaxV - 1

FileData3a<- FileData3 [FileData3$Depth==MaxV | FileData3$Depth==NumAtU,]



## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.6)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=MaxV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MaxV, font =2)

################################################################### Developing Min line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MinV <- FileData3$MinV[1]
NumAtA<- MinV + 1

FileData3a<- FileData3 [FileData3$Depth==MinV | FileData3$Depth==NumAtA,]




## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.60)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx))
y0 <- (min(yy) )
text(x0,y0,labels=MinV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MinV, font =2)



####################################################################### Writing legend 
legend("topright",inset = 0.025, legend=c("Depth Contour Lines [Meters]", "Simulated Undiscovered Deposits"),
       col=c("red", "blue"), lty=c(1,NA), pch = c(NA,3), lwd= 2, cex=2, bg="White")

dev.off()
#dev.off()
#dev.off()
#dev.off()

EPSName <<- paste(TN1,"_OV_MetricTons.eps",sep="")
setEPS()
postscript(EPSName, width= 20, height= 20)
FileName <-NewCalcName2 
FileData2 <- read.csv(file=NewCalcName2 , header=TRUE, sep=",")
FileData2$MetricTons <- log10(FileData2$MetricTons)  ## log 10 transform of x data
## saving variables
a2 = FileData2 $MetricTons
b2 = FileData2 $BE_V_Rev
c2 = FileData2 $Depth
d2 = FileData2 $OreValueOld
## creates data frame 
df2 <- data.frame(x=a2,y=b2,z=c2)
x2 <- df2$x
y2 <- df2$y
z2 <- df2$z

############################################# Creating empty plot figure with units 
par(mar = c(10,10,10,10) + 0.1)
Title1 <- paste("Cut Off Ore Value Vs. Ore Tonnage - ",TN1,sep=" ") 


yy2 <<- max(d2)
if (max(d2)> 100)
	{
	yy2 <<-100
	}



plot(a2, b2, xlab="Ore Tonnage [Log10 t]", ylab="Cut Off Ore Value [2008$/t]", xlim =c(min(x2,na.rm = TRUE), max(x2,na.rm = TRUE) ), ylim = c(0,yy2), cex= 0,cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2,xaxt="n", main=Title1)
aty <- axTicks(2)
atx <- axTicks(1)

labels <- sapply(atx,function(i)
            as.expression(bquote(10^ .(i)))
          )
axis(at=atx,1,labels=labels, cex.axis=1.5)

################################### plotting all orig points

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


FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")
FileData3$MetricTons <- log10(FileData3$MetricTons)  ## log 10 transform of x data

##################################################################### Drawing grid lines 

grid(lwd=1,lty = "dotted",col="Black")


MyDatab <- read.csv(file=FileName, header=TRUE, sep=",")
bb = MyDatab $OreValueOld

hlines <- c(seq(0, max(bb), by = 5))
abline(h = hlines, col = "Black", lty = "dotted", lwd = 1)

vlines <- c(seq(0, max(x), by = 0.25))
abline(v = vlines, col = "Black", lty = "dotted", lwd = 1) 


#grid(lwd=1,lty = "dotted",col="Black")
#minor.tick(nx=2, ny=2, tick.ratio=0.5)

####################################################### Setting Max/Mins
MinD <- min(FileData3$Depth)
MaxD <-  max(FileData3$Depth)
DiffD <- MaxD - MinD

##if #intervals is greater 10 - set division by 200 but if greater 10 do previous interval + 100 - keep doing it untiul number is less than or equal to 10 , also always a contour at 0 ,  always do  min line at 0 also 
Div100 <- DiffD / 100
Start <- 100
Divide1 <- Start
while (Div100 > 10)
{
if (Div100 > 10)
{
Divide1 <- (Start + 100)
Div100 <- DiffD / (Divide1 )
}
}



RoundD <- floor(Div100)

IntDMin<- 100* floor(MinD /100)
IntDMax <- 100*floor(MaxD /100)

############################################################ Setting Num of Divisons  
if ( (MinD / 100) == (IntDMin/ 100))
{
if ( (MaxD / 100) == (IntDMax/ 100))
{

NumDiB4 <- (RoundD - 2)
#print (NumDiB4)
## subtract 2 to get regular divsions without min/max
## print divsions numbers 

}}

if ( ((MinD / 100) != (IntDMin/ 100))| ((MaxD / 100) != (IntDMax/ 100)))
{
NumDiB4 <- (RoundD)
#print (NumDiB4)

}

########################################################### Setting celing and floor values

NumAt <- 100* ceiling(MinD /100)  ### Sets NumAt to 0 min value
MaxD2 <- ((100*floor(MaxD /100)) )  ## sets to 1000 max value plus 1, 1001


############################################################  Making Depth level groups
NumAt <- (NumAt + Divide1)
while (NumAt < MaxD2)
{
NumAtU<- NumAt - 1
NumAtA<- NumAt + 1
#print (NumAt)    ## prints each depth level
DName <<- paste("Depth",NumAt,sep="")
#print (DName)

newdata00 <- FileData3 [FileData3$Depth==NumAt  | FileData3$Depth==NumAtU | FileData3$Depth==NumAtA,]


## saving variables
aa = newdata00$MetricTons
bb = newdata00$BE_V_Rev
cc = newdata00$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.20)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=NumAt , font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=NumAt , font =2)
NumAt <- (NumAt + Divide1)  ### ending lines for each depth level
}
################################################################### Developing Max line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MaxV <- FileData3$MaxV[1]
NumAtU<- MaxV - 1

FileData3a<- FileData3 [FileData3$Depth==MaxV | FileData3$Depth==NumAtU,]



## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.6)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx) + .02)
y0 <- (min(yy) + .02)
text(x0,y0,labels=MaxV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MaxV, font =2)

################################################################### Developing Min line

FileName <-NewCalcName2 
FileData3 <- read.csv(file=FileName, header=TRUE, sep=",")

## transform data 
FileData3 $MetricTons<- log10(FileData3 $MetricTons)        ## log 10 transform of x data
## taking smaller sample of data 
MinV <- FileData3$MinV[1]
NumAtA<- MinV + 1

FileData3a<- FileData3 [FileData3$Depth==MinV | FileData3$Depth==NumAtA,]




## saving variables
aa = FileData3a$MetricTons
bb = FileData3a$BE_V_Rev
cc = FileData3a$Depth

## creates data frame 
df <- data.frame(x=aa,y=bb,z=cc)
xx <- df$x
yy <- df$y
zeros<- cbind(xx,yy)

smoothingSpline0 = smooth.spline(zeros, spar=.60)
lines(smoothingSpline0,col="Red", lwd = 2)
x0 <- (max(xx))
y0 <- (min(yy) )
text(x0,y0,labels=MinV, font =2)
tx <- min(xx) 
ty <- max(yy)
x00 <- (tx)
y00 <- (ty)
text(x00,y00,labels=MinV, font =2)



####################################################################### Writing legend 
legend("topright",inset = 0.025, legend=c("Depth Contour Lines [Meters]", "Simulated Undiscovered Deposits"),
       col=c("red", "blue"), lty=c(1,NA), pch = c(NA,3), lwd= 2, cex=2, bg="White")

dev.off()
#dev.off()
#dev.off()
#dev.off()








