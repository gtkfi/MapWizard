#library("MapMark4")
source("NDepositsPmf.R")

deposits <- function(type, depCsvPath, summaryOutputFile, description, plotPath,csvPath,trackID){

	if (type == "NegBinomial")
	{
		pmf <- read.csv(depCsvPath)
		#NDepositsPmf <- function( type, pmf.args, outProbFile, TrID, description="")
		oPmf <- NDepositsPmf("NegBinomial", list(nDepEst=pmf),csvPath,trackID,description)
	}
	else if (type == "CustomMark4")
	{
		pmf <- read.csv(depCsvPath)
		nlist<- (pmf[,1])
		rel6<- (pmf[,2])
            #nlist<-c(0,1,2,3,4,5,6,8,10,15,20)
            #rel6<-c(0,10,30,60,80,100,70,40,10,5,1)
	      oPmf <- NDepositsPmf("CustomMark4",list(nDeposits=nlist, relProbabilities=rel6),csvPath,trackID,description)
	}
	else if (type == "CustomMark3")
	{
		N_data <- read.csv(depCsvPath, header=FALSE)
		dat <- N_data[,1]
		#N_data<-c(1,5,13,16,21)
		#message(dat)
		oPmf <- NDepositsPmf("CustomMark3",list(nDepEst=dat),csvPath,trackID,description)
	}


    #saveRDS(oPmf, file = "c:/temp/oPmf.rds")
    saveRDS(oPmf, file = paste(plotPath, "oPmf.rds", sep = "\\"))
	#summary(oPmf)
	sink(summaryOutputFile)
	summary(oPmf)
	sink()
	outfile <- paste(plotPath,"/plot.jpeg",sep="")
	jpeg(outfile,width = 800, height = 800, pointsize = 12, quality = 75)
	#graphics.off()
	plot(oPmf)
	dev.off()

	#same for tiff
	outfile <- paste(plotPath,"/plot.tiff",sep="")
	tiff(outfile,width = 1024, height = 1024)# ,pointsize = 12, quality = 75
	#graphics.off()
	plot(oPmf, labelSize=20)
	dev.off()

	#eps output
	setEPS()
	postscript(paste(plotPath,"/plot.eps",sep=""))
	plot(oPmf)
	dev.off()

}
args = commandArgs(trailingOnly = TRUE)
deposits(args[1],args[2],args[3],args[4],args[5],args[6],args[7])