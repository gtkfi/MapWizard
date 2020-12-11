source("TonnagePdf.R")
source("Utilities.R")
library("ggplot2")

tonnagePdf <- function(dataPath, seed, pdfType, isTruncated, minNDeposits, nRandomSamples, folder) {
  in_data <- read.csv(dataPath)

	# This calls the function TonnagePdf, in file TonnagePdf.R
	outobj<-TonnagePdf(in_data,
					   seed=seed,
					   pdfType=pdfType,
					   isTruncated=isTruncated,
					   minNDeposits=minNDeposits,
                       nRandomSamples <- nRandomSamples)

    saveRDS(outobj, file = paste(folder,"tonnage.rds", sep="\\"))
    outfile <- paste(folder, "tonnage_plot.jpeg", sep = "\\")
    jpeg(outfile, 1024, 1024)
	plotObj <- plot.TonnagePdf(outobj)
	dev.off()

	outfile <- paste(folder, "tonnage_plot.tiff", sep = "\\")
    tiff(outfile, 2048	, 2048 )
    plotObj <- plot.TonnagePdf(outobj)
    dev.off()

	setEPS()
	postscript(paste(folder, "tonnage_plot.eps", sep = "\\"))
	plotObj <- plot.TonnagePdf(outobj)
	dev.off()

    outfile <- paste(folder, "tonnage_summary.txt", sep = "\\")
    sink(outfile)
	summary.TonnagePdf(outobj)
  sink()
  
	return(outobj)
}
args = commandArgs(trailingOnly = TRUE)

# Use the following call, when testing outside MapWizard
#source("../wizardScriptInputs.r")
#args<-wizardScriptInputs("TGwrapper")

dataPath <- args[1]
seed <- args[2]
pdfType <- args[3]
isTruncated <- args[4]
minNDeposits <- args[5]
nRandomSamples <- as.integer(args[6])
folder <- args[7]

tonnage <- tonnagePdf(dataPath, seed, pdfType, isTruncated, minNDeposits, nRandomSamples, folder)