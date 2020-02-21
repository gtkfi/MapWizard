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
 	filename2 <<- paste(testname1,"Datafile",".csv", sep = "")
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
	#filename5<<- paste(testname1,"_05_SIM_EF",".csv", sep = "")
	filename5<<- paste("Tract","_05_SIM_EF",".csv", sep = "")
	write.csv(NewCont, file = filename5)

	# save Robject
}
args = commandArgs(trailingOnly = TRUE)
mcSimulation(args[1],args[2],args[3],args[4],args[5],args[6],args[7])