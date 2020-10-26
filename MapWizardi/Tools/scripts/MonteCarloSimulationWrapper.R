library("dplyr")

source("Simulation.R")
source("NDepositsPmf.R")
source("Metadata.R")
source("GradePdf.R")
source("TonnagePdf.R")
source("TonGradePdf.R") # Changed: added
source("TotalTonnagePdf.R")
source("TotTonOutCMT.R")
source("TotTonOutGT.R")
source("Utilities.R")

mcSimulation <- function(oPmfPath,oTonPath,oGradePath,oTonGradePath,oMetaPath,summaryOutput, plotPath, TractId){ # Changed: added oTonGradePath

	print(oTonPath)
	print(oGradePath)		
	print(oTonGradePath)
	oPmfIn <- readRDS(file = oPmfPath)
	
	#Check if oTonPath is available
	tonAvailable <- !identical(oTonPath,"NA")
	if(tonAvailable)
	{
	 print("tonAvailable") 
	 oTonIn <- readRDS(file = oTonPath)
	}
	else {
	 print("ton NOT Available")
	 oTonIn <- NA
	}
	
	#Check if oGradePath is available
	gradeAvailable <- !identical(oGradePath,"NA")
	if(gradeAvailable)
	{
	 print("gradeAvailable")
	 oGradeIn <- readRDS(file = oGradePath)
	}
	else {
	 print("grade NOT Available")
	 oGradeIn <- NA
	}

	#Check if oTonGradePath is available
	tongradeAvailable <- !identical(oTonGradePath,"NA")
	if(tongradeAvailable)
	{
	 print("tonGradeAvailable")
	 oTonGradeIn <- readRDS(file = oTonGradePath)
	}
	else {
	 print("tonGrade NOT Available")
	 oTonGradeIn <- NA
	}

	#oMetaIn <- readRDS(file = oMetaPath)
	

	#1) ONLY oTonGrade
	if (tongradeAvailable)
	{
	  print("Joint grade and tonnage")
	 oSimulation <- Simulation(oPmf=oPmfIn, oTonGradePdf=oTonGradeIn, seed = 123) # Changed: added oTonGrade
	 oTotalTonPdf <- TotalTonnagePdf(oSimulation=oSimulation,  oPmf=oPmfIn, oTonGradePdf=oTonGradeIn) # Changed: added oTonGrade
	}

	#2) ONLY oTon oSimulation <- Simulation(oPmf=oPmfIn, oTonGradePdf=oTonGradeIn, seed = getSeed(oMetaIn)) # Changed: added oTonGrade
	if (tonAvailable & !gradeAvailable)
	{
	 print("Only tonnage")
	 oSimulation <- Simulation(oPmf=oPmfIn, oTonPdf=oTonIn, seed = 123) # Changed: added oTonGrade
	 oTotalTonPdf <- TotalTonnagePdf(oSimulation=oSimulation,  oPmf=oPmfIn, oTonPdf=oTonIn) # Changed: added oTonGrade
	}

	#3) oTon & oGrade oSimulation <- Simulation(oPmf=oPmfIn, oTonGradePdf=oTonGradeIn, seed = getSeed(oMetaIn)) # Changed: added oTonGrade
	if (tonAvailable && gradeAvailable)
	{
    print("Grade and tonnage")
	  oSimulation <- Simulation(oPmf=oPmfIn, oTonPdf=oTonIn, oGradePdf=oGradeIn, seed = 123) # Changed: added oTonGrade
	  oTotalTonPdf <- TotalTonnagePdf(
	  oSimulation=oSimulation,  oPmf=oPmfIn, oTonPdf=oTonIn, oGradePdf=oGradeIn) # Changed: added oTonGrade
	}

	sink(summaryOutput)
	summary(oTotalTonPdf)
	sink()

	graphics.off()
	outfile <- paste(plotPath,"/plot.jpeg",sep="")
	jpeg(outfile,width = 800, height = 800, pointsize = 12, quality = 75)
	plot(oTotalTonPdf)
	graphics.off()
	outfile2 <- paste(plotPath,"/plotMarginals.jpeg",sep="")
	jpeg(outfile2,width = 800, height = 800, pointsize = 12, quality = 75)
	plotMarginals(oTotalTonPdf)
	graphics.off()

	outfile <- paste(plotPath,"/plot.tiff",sep="")
	tiff(outfile,width = 2048, height = 2048)
	plot(oTotalTonPdf,labelSize=20)
	graphics.off()
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

	#################################################################
	#### Records simulation data file and temporarily saves it as a csv file.
	#################################################################
	testname1 <- TractId
	#filename2 <<- paste(testname1,"_Datafile",".csv", sep = "")
	filename2 <<- paste(plotPath,"/",testname1,"_Datafile",".csv", sep = "")
	print(oSimulation,filename2) # grades are in percentages
	filename5<<- paste(testname1,"_05_SIM_EF",".csv", sep = "")
	filename6 <<- paste(testname1,"_06_SIM_EF_Stats",".csv", sep = "")
	filename7 <<- paste(testname1,"_07_SIM_Contained_Totals",".csv", sep = "")
	filename8 <<-paste(testname1,"_08_SIM_Contained_Stats",".csv", sep = "")

	setwd(plotPath)
		
############   Changed from here on ########################
	
# Create 05_SIM_EF.csv, 06_SIM_EF_Stats.csv, 07_SIM_EF_Contained_Totals.csv and files
	if (tongradeAvailable|gradeAvailable) {	 
	  print("Generate grade and tonnage EF outputs")
	  TotTonOutGT(oSimulation$deposits,filename5,filename6,filename7,filename8)
	} else if (tonAvailable&!gradeAvailable) {
	  print("Generate tonnage EF outputs")
	  TotTonOutCMT(oSimulation$deposits,filename5,filename6,filename7,filename8)
	} else {
# Return error. Is this needed?
	}
}

args = commandArgs(trailingOnly = TRUE)
print(paste0("args:", args))
print(paste0("args[1]:",args[1]))
print(paste0("args[2]:",args[2]))
print(paste0("args[3]:",args[3]))
print(paste0("# of args:",length(args)))
#mcSimulation(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8])
mcSimulation(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8])



