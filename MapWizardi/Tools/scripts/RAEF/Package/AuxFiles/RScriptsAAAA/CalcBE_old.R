library(MASS)
library(RColorBrewer)
library(Hmisc)
library(pid)
library(akima)
library(zoo)
library(sqldf)


FileName1 <- "EF_02_Output_"
FileName2 <- ".csv"
FileName1 <<- paste(FileName1 , TN1 , FileName2 , sep= "")


MyData <- read.csv(file=FileName1, header=TRUE, sep=",")


if (MineNum001 == 2)
	{

#### set column variables 
BC <- MyData$TotKo_y1
BD <- MyData$TotKo_y2
I <- MyData$Dpy
AJ <- MyData$MlC1
AK <- MyData$MlC2
BE <- MyData$TotK
BF <- MyData$TotK2 
J <-  MyData$Life
D <-  MyData$NumDep
OreValueOld <- MyData$OreV_Tot
Depth <- MyData$Depth
NPV_1 <- MyData$PVD
NPV_2 <- MyData$PVD2
CUEQ <- MyData$CuEQ
MaxVV<<-  MaxTot
MinVV <<- MinTot
Min2 <- (MinTot + 20)
Max2 <- (MaxTot - 20)
MetricTons<- MyData$MetricTons
##  creating loop 
Max1 <-length(BC)  # number of rows in data
Max1 <- Max1 + 1  # since equation will be less than, add 1 to make all rows
################################# Write headers for table 
headers1 <- cbind("NumDep","MetricTons","BE_OP","BE_BC","BE_OP_rev","BE_BC_rev","BE_CUEQ_OP_rev","BE_CUEQ_BC_rev","BE_CUEQ_rev", "Rev_BE_OV","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
write.table(headers1 , file="NewBEOut10.csv", sep=",", append=TRUE, col.names=FALSE)  


########################### set num1 
Num1<- 1 # set number at stating row point

## while loop
while (Num1 < Max1)   ## While the number of row is less than the max plus 1
{
print (Num1)

#####################################################
## Present Value
#####################################################
pmt <<- 1  # payments - value prod
rate <<- 0.15   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- J[Num1]   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate
PV <<- P02 * pmt  # total present value

####################################################BE Open Pit Equation 
## first part of equation for OP BE
BE_OP1 <- (BC[Num1]/(I[Num1]*AJ[Num1]))

## second part of equation for OP BE
BE_OP2 <- (BE[Num1]/(I[Num1] * AJ[Num1]*PV))

##Final equation for OP BE

BE_OP <- (BE_OP1 + BE_OP2)


############################################# BE Block Caving Equation
## first part of equation for OP BE
BE_BC1 <- (BD[Num1]/(I[Num1]*AK[Num1]))

## second part of equation for OP BE
BE_BC2 <- (BF[Num1]/(I[Num1] * AK[Num1]*PV))

##Final equation for OP BE

BE_BC <- (BE_BC1 + BE_BC2)

############################################### BE Revise OP

BE_OP_rev <-  (( BC[Num1] + BE_OP ) / ( I[Num1] * AJ[Num1]) + (BE[Num1] / ( I[Num1] * AJ[Num1] * (PV))))

############################################### BE Revise BC

BE_BC_rev <-  (( BD[Num1] + BE_BC ) / ( I[Num1] * AK[Num1]) + (BF[Num1] / ( I[Num1] * AK[Num1] * (PV))))

############################################### OP CUEQ Revise 
BE_CUEQ_OP_rev <- (100 * BE_OP_rev)/ (0.91 * 3814)

############################################### BC CUEQ Revise 
BE_CUEQ_BC_rev <- (100 * BE_BC_rev)/ (0.91 * 3814)

############################################## Rev BE CUEQ

if ( D[Num1] > 0)
{
if ( BE_OP_rev < BE_BC_rev)
{
BE_CUEQ_rev <<- BE_CUEQ_OP_rev
}
if ( BE_OP_rev > BE_BC_rev)
{
BE_CUEQ_rev <<- BE_CUEQ_BC_rev 
}
}

if ( D[Num1] == 0)
{
BE_CUEQ_rev<<- "NA"
}



############################################## Rev BE OV

if ( D[Num1] > 0)
{
if ( BE_OP_rev < BE_BC_rev)
{
Rev_BE_OV <<- BE_OP_rev
Rev_BE_OV <<- (Rev_BE_OV / 0.907185)
}
if ( BE_OP_rev > BE_BC_rev)
{
Rev_BE_OV <<- BE_BC_rev
Rev_BE_OV <<- (Rev_BE_OV / 0.907185)
}
}

if ( D[Num1] == 0)
{
Rev_BE_OV <<- "NA"
}

#################################################NPV_max
if ( D[Num1] > 0)
{
if (NPV_1[Num1] > NPV_2[Num1])
{
NPV_max <- NPV_1[Num1]
}
if (NPV_1[Num1] < NPV_2 [Num1])
{
NPV_max <- NPV_2[Num1]
}
}

if ( D[Num1] == 0)
{
NPV_max <- "NA"
}

######################################################Old OLRe Value
OreV_Tot_Old <<- (OreValueOld[Num1]/0.907185)


############################################## Print table out
BE_List <- cbind( D[Num1],MetricTons[Num1],BE_OP,BE_BC,BE_OP_rev,BE_BC_rev,BE_CUEQ_OP_rev,BE_CUEQ_BC_rev,BE_CUEQ_rev, Rev_BE_OV,OreV_Tot_Old,Depth[Num1],NPV_max,CUEQ[Num1],MaxVV,Max2,MinVV,Min2 )
## Write Table 
write.table(BE_List, file="NewBEOut10.csv", sep=",", append=TRUE, col.names=FALSE)
Num1 <- Num1 + 1
}
MyData2 <- read.csv(file="NewBEOut10.csv", header=TRUE, sep=",")
MyData2<-  sqldf('select * from MyData2 where NumDep >0 ')
headers2 <- cbind("1","NumDep","MetricTons","BE_OP","BE_BC","BE_OP_rev","BE_BC_rev","BE_CUEQ_OP_rev","BE_CUEQ_BC_rev","BE_CUEQ_rev", "Rev_BE_OV","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
write.table(headers2 , file="NewBEOut10WO0.csv", sep=",", append=TRUE, col.names=FALSE)  
write.table(MyData2, file="NewBEOut10WO0.csv", sep=",", append=TRUE, col.names=FALSE)

}  ## #####################################################################################################ends if mine num 2






if (MineNum001 == 1)
	{

#### set column variables 
BC <- MyData$TotKo_y
I <- MyData$Dpy
AJ <- MyData$MlC
BE <- MyData$TotK
J <-  MyData$Life
D <-  MyData$NumDep
OreValueOld <- MyData$OreV_Tot
Depth <- MyData$Depth
NPV_1 <- MyData$PVD
CUEQ <- MyData$CuEQ
MetricTons<- MyData$MetricTons
##  creating loop 
Max1 <-length(BC)  # number of rows in data
Max1 <- Max1 + 1  # since equation will be less than, add 1 to make all rows

MaxVV<<-  MaxTot
MinVV <<- MinTot
Min2 <- (MinTot + 20)
Max2 <- (MaxTot - 20)
################################# Write headers for table 
headers1 <- cbind("NumDep","MetricTons","BE","BE_rev","BE_CUEQ_rev","BE_CUEQ_rev", "Rev_BE_OV","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
write.table(headers1 , file="NewBEOut10.csv", sep=",", append=TRUE, col.names=FALSE)  


########################### set num1 
Num1<- 1 # set number at stating row point

## while loop
while (Num1 < Max1)   ## While the number of row is less than the max plus 1
{
print (Num1)

#####################################################
## Present Value
#####################################################
pmt <<- 1  # payments - value prod
rate <<- 0.15   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- J[Num1]   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate
PV <<- P02 * pmt  # total present value

####################################################BE Open Pit Equation 
## first part of equation for OP BE
BE_OP1 <- (BC[Num1]/(I[Num1]*AJ[Num1]))

## second part of equation for OP BE
BE_OP2 <- (BE[Num1]/(I[Num1] * AJ[Num1]*PV))

##Final equation for OP BE

BE_OP <- (BE_OP1 + BE_OP2)



############################################### BE Revise OP

BE_OP_rev <-  (( BC[Num1] + BE_OP ) / ( I[Num1] * AJ[Num1]) + (BE[Num1] / ( I[Num1] * AJ[Num1] * (PV))))


############################################### OP CUEQ Revise 
BE_CUEQ_OP_rev <- (100 * BE_OP_rev)/ (0.91 * 3814)


############################################## Rev BE CUEQ

if ( D[Num1] > 0)
{

BE_CUEQ_rev <<- BE_CUEQ_OP_rev
}
if ( D[Num1] == 0)
{
BE_CUEQ_rev<<- "NA"
}



############################################## Rev BE OV

if ( D[Num1] > 0)
{

Rev_BE_OV <<- BE_OP_rev
Rev_BE_OV <<- (Rev_BE_OV / 0.907185)
}

if ( D[Num1] == 0)
{
Rev_BE_OV <<- "NA"
}

#################################################NPV_max
if ( D[Num1] > 0)
{
NPV_max <- NPV_1[Num1]
}

if ( D[Num1] == 0)
{
NPV_max <- "NA"
}

######################################################Old OLRe Value
OreV_Tot_Old <<- (OreValueOld[Num1]/0.907185)


############################################## Print table out
BE_List <- cbind( D[Num1],MetricTons[Num1],BE_OP,BE_OP_rev,BE_CUEQ_OP_rev,BE_CUEQ_rev, Rev_BE_OV,OreV_Tot_Old,Depth[Num1],NPV_max,CUEQ[Num1],MaxVV,Max2,MinVV,Min2 )
## Write Table 
write.table(BE_List, file="NewBEOut10.csv", sep=",", append=TRUE, col.names=FALSE)
Num1 <- Num1 + 1
}


MyData2 <- read.csv(file="NewBEOut10.csv", header=TRUE, sep=",")
MyData2<-  sqldf('select * from MyData2 where NumDep >0 ')
headers2 <- cbind("1","NumDep","MetricTons","BE_OP","BE_OP_rev","BE_CUEQ_OP_rev","BE_CUEQ_rev", "Rev_BE_OV","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
write.table(headers2 , file="NewBEOut10WO0.csv", sep=",", append=TRUE, col.names=FALSE)  
write.table(MyData2, file="NewBEOut10WO0.csv", sep=",", append=TRUE, col.names=FALSE)
}  ## ends if mine num 1
















