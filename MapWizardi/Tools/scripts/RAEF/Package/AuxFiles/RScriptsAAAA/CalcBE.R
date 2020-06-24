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
NewCalcName1 <<- paste(TN1,"_NewBEOut10.csv",sep="")
NewCalcName2 <<- paste(TN1,"_NewBEOut10WO0.csv",sep="")

if (exists("MRR_Cu")) {MRR_Cu_2<<- MRR_Cu}
if (!exists("MRR_Cu")) {MRR_Cu_2<<- 0.91}


if (MineNum001 == 1)
	{

#### set column variables 
BC <- MyData$TotKo_y
I <- MyData$Dpy
AJ <- MyData$MlC
BE <- MyData$TotK
J <-  MyData$Life
VP <- MyData$VP_y
D <-  MyData$NumDep
OreValueOld <- MyData$OreV_Tot
Depth <- MyData$Depth
NPV_1 <- MyData$PVD
CUEQ <- MyData$CuEQ
SCR <- MyData$SmeltC
SCR2 <- MyData$SmeltC2
MSC <- MyData$MSC
MetricTons<- MyData$MetricTons
Max1 <-length(BC)  # number of rows in data
Max1 <- Max1 + 1  # since equation will be less than, add 1 to make all rows
MaxVV<<-  MaxTot
MinVV <<- MinTot
Min2 <- (MinTot + 20)
Max2 <- (MaxTot - 20)

################################# Write headers for table 
headers1 <- cbind("NumDep","MetricTons","BE_V","BE_V_Rev","BE_CUEQ_Rev","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 



##write.table(headers1 , file=NewCalcName1 , sep=",", append=TRUE, col.names=FALSE)  


########################### set num1 
Num1<- 1 # set number at stating row point
Max00 <<- Max1 - 1
## for loop
for (Num1 in 1:Max00)   ## for the number of row is less than the max plus 1
	{


	#####################################################
	## Present Value
	#####################################################
	pmt <<- VP[Num1]  # payments - value prod
	rate <<- 0.15   # using .15 rate 
	rate1 <<- 1 + rate  # 1 + rate
	nper <<- J[Num1]   # number of periods-  life 
	P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
	P02 <<-  P01/rate   ## P01/rate
	PV <<- P02 * pmt  # total present value

	####################################################BE_V Equation 
	## first part of equation for OP BE
	BE_OP1 <- (BC[Num1]/(I[Num1]*AJ[Num1]))

	## second part of equation for OP BE
	BE_OP2 <- (BE[Num1]/(I[Num1] * AJ[Num1]*PV))

	##Final equation for BE

	BE_V <- (BE_OP1 + BE_OP2)

	#######################################################BE_G(CUEQ)




	BE_CUEQ <- (100*BE_V)/(MRR_Cu_2*3814)

	#######################################################CUEQDiff

	CUEQ_Diff <- (BE_CUEQ - CUEQ[Num1])/CUEQ[Num1]

	#######################################################Smelting Cost Differential 
	SCD <- 1.26*(CUEQ_Diff*SCR[Num1])

	#######################################################BE_V_Rev
	BE_V_Rev <- (BC[Num1] + SCD) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
 

	#######################################################BE_CUEQ_Rev
	BE_CUEQ_Rev <- (100* BE_V_Rev)/(MRR_Cu_2*3814)






	############################################################################################################################
	############################################################################################################################
	##############################################################################################################Run2 

	####################BE_G(CUEQ)
	BE_CUEQ <- (100*BE_V_Rev)/(MRR_Cu_2*3814)
	####################CUEQDiff
	CUEQ_Diff <- (BE_CUEQ - CUEQ[Num1])/CUEQ[Num1]
	####################Smelting Cost Differential 
	SCD <- 1.26*(CUEQ_Diff*SCR[Num1])
	####################BE_V_Rev
	BE_V_Rev <- (BC[Num1] + SCD) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
	####################BE_CUEQ_Rev
	BE_CUEQ_Rev <- (100* BE_V_Rev)/(MRR_Cu_2*3814)

	############################################################################################################################
	############################################################################################################################
	##############################################################################################################Run3 

	####################BE_G(CUEQ)
	BE_CUEQ <- (100*BE_V_Rev)/(MRR_Cu_2*3814)
	####################CUEQDiff
	CUEQ_Diff <- (BE_CUEQ - CUEQ[Num1])/CUEQ[Num1]
	####################Smelting Cost Differential 
	SCD <- 1.26*(CUEQ_Diff*SCR[Num1])
	####################BE_V_Rev
	BE_V_Rev <- (BC[Num1] + SCD) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
	####################BE_CUEQ_Rev
	BE_CUEQ_Rev <- (100* BE_V_Rev)/(MRR_Cu_2*3814)










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
	BE_List <- cbind( D[Num1],MetricTons[Num1],BE_V,BE_V_Rev,BE_CUEQ_Rev,OreV_Tot_Old,Depth[Num1],NPV_max,CUEQ[Num1],MaxVV,Max2,MinVV,Min2)
	## Write Table 
	
	headers1 <<- rbind(headers1,BE_List)
	NewOutTable<<- headers1
	Num1 <- Num1 + 1

	}  ### Ends while loop for each row 

	
write.table(NewOutTable, file=NewCalcName1, sep=",", append=TRUE, col.names=FALSE)

MyData2 <<- read.csv(file=NewCalcName1 , header=TRUE, sep=",")
MyData2<<-  sqldf('select * from MyData2 where NumDep >0 ')
headers2 <<- cbind("1","NumDep","MetricTons","BE_V","BE_V_Rev","BE_CUEQ_Rev", "OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
write.table(headers2 , file=NewCalcName2, sep=",", append=TRUE, col.names=FALSE)  
write.table(MyData2, file=NewCalcName2, sep=",", append=TRUE, col.names=FALSE)



}  ## ends if mine num 1












if (MineNum001 == 2)
	{

	#### set column variables 
	BC <- MyData$TotKo_y1
	BD <- MyData$TotKo_y2
	I <- MyData$Dpy
	AJ <- MyData$MlC1
	AK <- MyData$MlC2
	VP1 <- MyData$VP_y1
	VP2 <- MyData$VP_y2 
	BE <- MyData$TotK
	BF <- MyData$TotK2 
	J <-  MyData$Life
	D <-  MyData$NumDep
	OreValueOld <- MyData$OreV_Tot
	Depth <- MyData$Depth
	NPV_1 <- MyData$PVD
	NPV_2 <- MyData$PVD2
	CUEQ <- MyData$CuEQ
	SCR <- MyData$SmeltC
	SCR2 <- MyData$SmeltC2
	MSC <- MyData$MSC
	MetricTons<- MyData$MetricTons
	Max1 <-length(BC)  # number of rows in data
	Max1 <- Max1 + 1  # since equation will be less than, add 1 to make all rows
	MaxVV<<-  MaxTot
	MinVV <<- MinTot
	Min2 <- (MinTot + 20)
	Max2 <- (MaxTot - 20)

	################################# Write headers for table 
	headers1 <- cbind("NumDep","MetricTons","BE_V","BE_V_Rev","BE_CUEQ_Rev","OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
	write.table(headers1 , file=NewCalcName1 , sep=",", append=TRUE, col.names=FALSE)  
	
	Max00 <<- Max1 - 1
	########################### set num1 
	Num1<- 1 # set number at stating row point

	## for loop
	for (Num1 in 1:Max00)   ## While the number of row is less than the max plus 1
		{

		####################################################
		# Present Value
		####################################################
		if ( D[Num1] > 0)
			{
			if (VP1[Num1] > VP2[Num1])
				{
				pmt <<- VP1[Num1]
				}
			if (VP1[Num1] < VP2[Num1])
				{
				pmt <<- VP2[Num1]
				}
			}
		if ( D[Num1] == 0)
			{
			pmt <<- 0
			}
		rate <<- 0.15   # using .15 rate 
		rate1 <<- 1 + rate  # 1 + rate
		nper <<- J[Num1]   # number of periods-  life 
		P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
		P02 <<-  P01/rate   ## P01/rate
		PV <<- P02 * pmt  # total present value

		###################################################BE_V Equation 
		# first part of equation for OP BE
		BE_OP1 <- (BC[Num1]/(I[Num1]*AJ[Num1]))

		# second part of equation for OP BE
		BE_OP2 <- (BE[Num1]/(I[Num1] * AJ[Num1]*PV))

		#Final equation for BE

		BE_OP <- (BE_OP1 + BE_OP2)                 ## BE_V
		 
		# first part of equation for OP BE
		BE_BC1 <- (BD[Num1]/(I[Num1]*AK[Num1]))

		# second part of equation for OP BE
		BE_BC2 <- (BF[Num1]/(I[Num1] * AK[Num1]*PV))

		#Final equation for OP BE

		BE_BC <- (BE_BC1 + BE_BC2)
		######################################################BE_G(CUEQ)

		#Open Pit
		BE_CUEQ_OP <- (100*BE_OP)/(MRR_Cu_2*3814)

		#Block Caving
		BE_CUEQ_BC <- (100*BE_BC)/(MRR_Cu_2*3814)
		######################################################CUEQDiff
		#Open Pit
		CUEQ_Diff_OP <- (BE_CUEQ_OP - CUEQ[Num1])/CUEQ[Num1]
		#Block Caving
		CUEQ_Diff_BC <- (BE_CUEQ_BC - CUEQ[Num1])/CUEQ[Num1]


		######################################################Smelting Cost Differential 
		#Open Pit
		SCD_OP <- 1.26*(CUEQ_Diff_OP*SCR[Num1])
		#BlockCaving
		SCD_BC <- 1.26*(CUEQ_Diff_BC*SCR2[Num1])

		######################################################BE_V_Rev
		# Open Pit
		BE_V_Rev_OP <- (BC[Num1] + SCD_OP) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
		# Block Caving
		BE_V_Rev_BC <- (BD[Num1] + SCD_BC) / (I[Num1] * AK[Num1]) + (BF[Num1] / (I[Num1]*AK[Num1]*PV))
	  
		if ( D[Num1] > 0)
			{
			if ( BE_V_Rev_OP < BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_OP
				}
			if ( BE_V_Rev_OP > BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_BC
				}
			}
		if ( D[Num1] == 0)
			{
			BE_V_Rev<<- "NA"
			}
		######################################################BE_CUEQ_Rev
		# Open Pit
		BE_CUEQ_Rev_OP <- (100* BE_V_Rev_OP)/(MRR_Cu_2*3814)
		# Block Caving
		BE_CUEQ_Rev_BC <- (100* BE_V_Rev_BC)/(MRR_Cu_2*3814)
		

		if ( D[Num1] > 0)
			{	
			if ( BE_V_Rev_OP < BE_V_Rev_BC) 
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_OP
				}
			if ( BE_V_Rev_OP >  BE_V_Rev_BC)
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_BC
				}
			}

		if ( D[Num1] == 0)
			{
			BE_CUEQ_Rev<<- "NA"
			}




		#############################################################################################################Run2 
		###################BE_G(CUEQ)
		#Open Pit
		BE_CUEQ_OP <- (100*BE_V_Rev_OP)/(MRR_Cu_2*3814)

		#Block Caving
		BE_CUEQ_BC <- (100*BE_V_Rev_BC)/(MRR_Cu_2*3814)

		###################CUEQDiff
		#Open Pit
		CUEQ_Diff_OP <- (BE_CUEQ_OP - CUEQ[Num1])/CUEQ[Num1]
		#Block Caving
		CUEQ_Diff_BC <- (BE_CUEQ_BC - CUEQ[Num1])/CUEQ[Num1]
		
		###################Smelting Cost Differential 
		#Open Pit
		SCD_OP <- 1.26*(CUEQ_Diff_OP*SCR[Num1])
		#BlockCaving
		SCD_BC <- 1.26*(CUEQ_Diff_BC*SCR2[Num1])

		###################BE_V_Rev
		BE_V_Rev_OP <- (BC[Num1] + SCD_OP) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
		# Block Caving
		BE_V_Rev_BC <- (BD[Num1] + SCD_BC) / (I[Num1] * AK[Num1]) + (BF[Num1] / (I[Num1]*AK[Num1]*PV))
	  
		if ( D[Num1] > 0)
			{
			if ( BE_V_Rev_OP < BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_OP
				}
			if ( BE_V_Rev_OP > BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_BC
				}
			}
		if ( D[Num1] == 0)
			{
			BE_V_Rev<<- "NA"
			}
		###################BE_CUEQ_Rev
		# Open Pit
		BE_CUEQ_Rev_OP <- (100* BE_V_Rev_OP)/(MRR_Cu_2*3814)
		# Block Caving
		BE_CUEQ_Rev_BC <- (100* BE_V_Rev_BC)/(MRR_Cu_2*3814)

		if ( D[Num1] > 0)
			{
			if ( BE_V_Rev_OP < BE_V_Rev_BC) 
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_OP
				}
			if (  BE_V_Rev_OP > BE_V_Rev_BC)
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_BC
				}
			}

		if ( D[Num1] == 0)
			{
			BE_CUEQ_Rev<<- "NA"
			}
		#############################################################################################################Run3 
		###################BE_G(CUEQ)
		#Open Pit
		BE_CUEQ_OP <- (100*BE_V_Rev_OP)/(MRR_Cu_2*3814)

		#Block Caving
		BE_CUEQ_BC <- (100*BE_V_Rev_BC)/(MRR_Cu_2*3814)

		###################CUEQDiff
		#Open Pit
		CUEQ_Diff_OP <- (BE_CUEQ_OP - CUEQ[Num1])/CUEQ[Num1]
		#Block Caving
		CUEQ_Diff_BC <- (BE_CUEQ_BC - CUEQ[Num1])/CUEQ[Num1]
		
		###################Smelting Cost Differential 
		#Open Pit
		SCD_OP <- 1.26*(CUEQ_Diff_OP*SCR[Num1])
		#BlockCaving
		SCD_BC <- 1.26*(CUEQ_Diff_BC*SCR2[Num1])

		###################BE_V_Rev
		BE_V_Rev_OP <- (BC[Num1] + SCD_OP) / (I[Num1] * AJ[Num1]) + (BE[Num1] / (I[Num1]*AJ[Num1]*PV))
		# Block Caving
		BE_V_Rev_BC <- (BD[Num1] + SCD_BC) / (I[Num1] * AK[Num1]) + (BF[Num1] / (I[Num1]*AK[Num1]*PV))
	  
		if ( D[Num1] > 0)
			{
			if ( BE_V_Rev_OP < BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_OP
				}
			if ( BE_V_Rev_OP > BE_V_Rev_BC)
				{
				BE_V_Rev <<- BE_V_Rev_BC
				}
			}
		if ( D[Num1] == 0)
			{
			BE_V_Rev<<- "NA"
			}
		###################BE_CUEQ_Rev
		# Open Pit
		BE_CUEQ_Rev_OP <- (100* BE_V_Rev_OP)/(MRR_Cu_2*3814)
		# Block Caving
		BE_CUEQ_Rev_BC <- (100* BE_V_Rev_BC)/(MRR_Cu_2*3814)

		if ( D[Num1] > 0)
			{
			if ( BE_V_Rev_OP < BE_V_Rev_BC) 
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_OP
				}
			if (  BE_V_Rev_OP > BE_V_Rev_BC)
				{
				BE_CUEQ_Rev <<- BE_CUEQ_Rev_BC
				}
			}

		if ( D[Num1] == 0)
			{
			BE_CUEQ_Rev<<- "NA"
			}
		################################################NPV_max
		if ( D[Num1] > 0)
			{
			if ( NPV_1[Num1] > NPV_2[Num1])
				{
				NPV_max <- NPV_1[Num1]
				}
			if ( NPV_2[Num1] > NPV_1[Num1])
				{
				NPV_max <- NPV_2[Num1]
				}
			}

		if ( D[Num1] == 0)
			{
			NPV_max <- "NA"
			}

		#####################################################Old OLRe Value
		OreV_Tot_Old <<- (OreValueOld[Num1]/0.907185)
		BE_V<- "NA"

		############################################## Print table out
		BE_List <- cbind( D[Num1],MetricTons[Num1],BE_V,BE_V_Rev,BE_CUEQ_Rev,OreV_Tot_Old,Depth[Num1],NPV_max,CUEQ[Num1],MaxVV,Max2,MinVV,Min2 )
				## Write Table 
		write.table(BE_List, file=NewCalcName1, sep=",", append=TRUE, col.names=FALSE)


	} ## ends for loop 

	MyData2 <- read.csv(file=NewCalcName1, header=TRUE, sep=",")
	MyData2<-  sqldf('select * from MyData2 where NumDep >0 ')
	headers2 <- cbind("1","NumDep","MetricTons","BE_V","BE_V_Rev","BE_CUEQ_Rev", "OreValueOld","Depth","NPV_max","CUEQ_Old","MaxV","MaxV2","MinV","MinV2") 
	write.table(headers2 , file=NewCalcName2 , sep=",", append=TRUE, col.names=FALSE)  
	write.table(MyData2, file=NewCalcName2 , sep=",", append=TRUE, col.names=FALSE)
}  ## ends if mine num 2





