library("dplyr")

source("Simulation.R")
source("NDepositsPmf.R")
source("Metadata.R")
source("GradePdf.R")
source("TonnagePdf.R")
source("TotalTonnagePdf.R")
source("Utilities.R")

mcSimulation <- function(oPmfPath,oTonPath,oGradePath,oMetaPath,summaryOutput, plotPath, TractId){
	
	oPmf <- readRDS(file = oPmfPath)
	oTon <- readRDS(file = oTonPath)
	oGrade <- readRDS(file = oGradePath)
	oMeta <- readRDS(file = oMetaPath)
	oSimulation <- Simulation(oPmf, oTon, oGrade, seed = getSeed(oMeta))
	oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTon, oGrade)
	sink(summaryOutput)
	summary(oTotalTonPdf)
	sink()

	outfile <- paste(plotPath,"/plot.jpeg",sep="")
	jpeg(outfile,width = 800, height = 800, pointsize = 12, quality = 75)
	plot(oTotalTonPdf)
	outfile2 <- paste(plotPath,"/plotMarginals.jpeg",sep="")
	jpeg(outfile2,width = 800, height = 800, pointsize = 12, quality = 75)
	plotMarginals(oTotalTonPdf)

	outfile <- paste(plotPath,"/plot.tiff",sep="")
	tiff(outfile,width = 2048, height = 2048)
	plot(oTotalTonPdf,labelSize=20)
	outfile2 <- paste(plotPath,"/plotMarginals.tiff",sep="")
	tiff(outfile2,width = 2048, height = 2048)
	plotMarginals(oTotalTonPdf,labelSize=20)
	dev.off()

	setEPS()
	postscript(paste(plotPath,"/plot.eps",sep=""))
	plot(oTotalTonPdf,labelSize=6)
	dev.off()
	
	setEPS()
	postscript(paste(plotPath,"/plotMarginals.eps",sep=""))
	plotMarginals(oTotalTonPdf,labelSize=6)
	dev.off()


	
	
	#Create 05_SIM_EF.csv -file
    setwd(plotPath)

	#################################################################
	#### Records simulation data file and temporarily saves it as a csv file.
	#################################################################
	testname1 <- TractId
 	filename2 <<- paste(testname1,"_Datafile",".csv", sep = "")
	print(oSimulation,filename2)

	#################################################################
	## Develops the Simulation result EF file, file EF_5
	#################################################################
	dat = read.csv(filename2, header = TRUE)
	LD <- length(names(dat))   # length of the columns in the data

	#### Saving variables for calcualtion of EF 05 file from the above data file 
	SimI <- dat[1]
	NumD <- dat[2]
	SimDI <- dat[3]
	Ore<- dat[4]
	Gran<-dat[LD]
	G1<- dat[5]
	Grades0<- G1
	Tons0<- (Ore*dat[5]/100)
	g <- 6
	TonsList<-c("Tons5")
	GradesList<-c("G5")

	for (nam in 6:LD)
	{
	print (nam)
	var<- paste("G",nam,sep="")
	print (var)
	assign(var,dat[g])


	######################################
	####calculate the ton for each mineral 
	#######################################
	varTon<- paste("Ton",nam,sep="")
	assign(varTon,((Ore*(get(var)))/100))
	##combine the grades and tons 
	TonsList<-c(TonsList,varTon)

	#########################
	### Saves the grades
	#########################
	GradesList<-c(GradesList,var)
	Grades0 <- cbind(Grades0,get(var))
	names(Grades0)<-GradesList
	Tons0<- cbind(Tons0,get(varTon))
	names(Tons0)<-TonsList
	g <- g + 1
	}

	TbNames <- names(dat)
	TbLen <- length(TbNames)
	MinStop <- TbLen -1 
	minerals<- TbNames[5:MinStop]
	OreN<- TbNames[4]
	NamesMins<- sub('.grade', '', minerals)

	NamesBegin <- TbNames[1:3]
	Gangue <- TbNames[TbLen]
	Gan<- sub('.grade', '', Gangue)


	#######################
	##Creates a joint table 
	#########################
	Cont <- cbind(SimI, NumD, SimDI, Ore,Grades0,Gran,Tons0) 
	lenCont1 <- length(Cont)

	lenMins<- length(NamesMins)
	ContMath <- 5 + lenMins - 1
	ContEndM <- ContMath + 2
	ContBegin <- Cont[1:4]
	ContMins <- Cont[5: ContMath]
	ContMath1 <- ContMath + lenMins
	ContEnd <- Cont [ContEndM: lenCont1]
	NewCont <- cbind(ContBegin,ContMins,ContEnd)
	MinTons<- paste(NamesMins,'_MetricTons')
	OreN<- sub(".tonnage", "_MetricTons",OreN)	
	NamesMins<- paste(NamesMins,"_pct")
	NameList12<- c(NamesBegin,OreN,NamesMins,Gan,MinTons ) 
	lenCont2 <- length(NewCont)
	con9 <- lenCont2 - 1
	colnames(NewCont) <- NameList12 
	NewCont <- NewCont[1:con9 ]

	# save Robject
	saveRDS(NewCont, file = paste(plotPath,"/mcObject.rds",sep=""))

	#############################################################
	## Saving the simulation results - 05 EF file to a csv file
    #############################################################
	filename5<<- paste(testname1,"_05_SIM_EF",".csv", sep = "")
	#filename5<<- paste("Tract","_05_SIM_EF",".csv", sep = "")
	write.csv(NewCont, file = filename5)


###07_SIM_Contained_Totals -code from MAPMARK
	
#################################################################
#### Aggregation pivot calculcaiton, based on number of grades-   Contained Totals
#################################################################
## make a pivot table
cols<- names(Cont)

newtab<- Cont[1]  #creaitng a newtable so it can use consistent variable name
xy<- 1
LCont <- length(Cont)


NewT <-Cont[1:3]
NameT1 <- names(Cont[4])
#####################################################
## If statements based on number of grades- columns
####################################################

NewT <- cbind(NewT,Cont[4])
colnames(NewT)<-c("SimIndex","NumDeposits","SimDepIndex","Tons1")
Tb <- summarise(group_by(NewT,SimIndex),NumDep = mean(NumDeposits), Tons1 = sum(Tons1))




##############################
## Setting table column names
#############################
TbNames <- names(dat)

countNNN <- length(TbNames)
NamesTT<- sub('.tonnage', '_mT', TbNames )

NamesNew <- c(NamesTT[1:2],NamesTT[4])

colnames(Tb) <- NamesNew

####################################################
#### Writes aggregated sim contained totals csv file
########################################################

filename6 <<- paste(testname1,"_07_SIM_Contained_Totals",".csv", sep = "")
write.csv(Tb, file = filename6)


###06_SIM_EF_Stats -code from MAPMARK

#################################################################
## Simulation EF Stats
#################################################################
## sim model Stats
Rsim<- read.csv(filename5) ### reads in the sim data results- ef 5 file


v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)

#####################################
## Create means for each variable
##################################
OMeans <- mean(v5)


#################################################################
## sim model max
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
####################################
## Create max for each variable
####################################
OMaxs <- max(v5)


#################################################################
## sim model min
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###############################
## Create min for each variable
##############################
OMins <- min(v5)


#################################################################
## sim model median
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## Create median for each variable
########################################
OMeds <- median(v5)
#################################################################

## sim model standard deviations
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)

####################################
## Create standard deviation for each variable
#############################################
OSds <- sd(v5)



#################################################################
## sim model Q99s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 99 percentile for each variable
##########################################
Q99s <- quantile(v5, c(.99))



#################################################################
## sim model Q90s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 90 percentile for each variable
##########################################
Q90s <- quantile(v5, c(.90))



#################################################################
## sim model Q80s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 80 percentile for each variable
##########################################
Q80s <- quantile(v5, c(.80))
#################################################################




## sim model Q70s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 70 percentile for each variable
##########################################
Q70s <- quantile(v5, c(.70))
#################################################################




## sim model Q60s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 60 percentile for each variable
##########################################
Q60s <- quantile(v5, c(.60))
#################################################################





## sim model Q50s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 50 percentile for each variable
##########################################
Q50s <- quantile(v5, c(.50))
#################################################################






## sim model Q40s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 40 percentile for each variable
##########################################
Q40s <- quantile(v5, c(.40))
#################################################################






## sim model Q30s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 30 percentile for each variable
##########################################
Q30s <- quantile(v5, c(.30))
#################################################################





## sim model Q20s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 20 percentile for each variable
##########################################
Q20s <- quantile(v5, c(.20))





#################################################################
## sim  model Q10s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 10 percentile for each variable
##########################################
Q10s <- quantile(v5, c(.10))





#################################################################
## Sim model Q01s
Rsim<- read.csv(filename5)
v4NA <- na.omit(Rsim[5])
v5<- unlist(v4NA)
v5<- as.numeric(v5)
###########################################
## 01 percentile for each variable
##########################################
Q01s <- quantile(v5, c(.01))

#################################################################
##Create stats list
#################################################################
StatsList <- cbind(OMeans,OMaxs,OMins,OMeds,OSds,Q01s, Q10s, Q20s, Q30s, Q40s, Q50s, Q60s, Q70s, Q80s, Q90s, Q99s)
colnames(StatsList) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1")

#Rsim<- read.csv(GTM)
namelist5 <- names(Rsim)
rownames(StatsList) <- namelist5[5]


##############################################
##Downlaod Sim stats to csv file
############################################
Stats1 <<- paste(testname1,"_06_SIM_EF_Stats",".csv", sep = "")
write.csv(StatsList, file = Stats1, row.names=TRUE)




}

args = commandArgs(trailingOnly = TRUE)
mcSimulation(args[1],args[2],args[3],args[4],args[5],args[6],args[7])



