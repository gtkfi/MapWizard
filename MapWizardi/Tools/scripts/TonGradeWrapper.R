# This includes the function Utilities.R for checking that the input has enough data and no NULL values
#setwd("C:/Users/jotorppa/Documents/Projects/MAP/WizardScripts")
source("Utilities.R")
source("TonGradePdf.R")
library("ggplot2")

tongradePdf <- function(dataPath, seed, isTruncated, minNDeposits, nRandomSamples, folder) { 
# INPUT
# dataPath: full path to input file (string)
# seed: seed for random number generator (float)
# isTruncated: Truncated the distribution to range [mindat,maxdat]? (TRUE/FALSE)
# minNDeposits: minimum number of deposits required in data (integer)
# nRandomSamples: number of random samples generated for the distribution (integer)
# folder: output folder
  
# OUTPUT
# $gatm: GT input data table
# $isTruncated: Truncated the distribution to range [mindat,maxdat]? (TRUE/FALSE)
# $grades: GT data transformed from perc to numbers, and gangue added (gangue=1-sum, rowwise)
# $resourceNames: element names in GT input table
# $theGatmMean: geometric mean of the metal compositions in input GT data
# $theGatmVar:  variation matrix of the metal compositions in input GT data (variance of log ratios)
# $rs: 2*nRandomSamples samples from the generated joint tonnage-grade distribution
# $theMean: rs geometric mean (log(xi)/log(xj))
# $theVar: rs variation matrix
  

  in_data <- read.csv(dataPath)
  # This calls the function TonGradePdf, in file TonGradePdf.R
  outobj <- TonGradePdf(in_data,
                       seed = seed,
                       isTruncated = isTruncated,
                       minNDeposits = minNDeposits,
                       nRandomSamples <- nRandomSamples)
  saveRDS(outobj, file = paste(folder,"tongrade.rds", sep="\\"))

# Grade, tonnage and tongrade plots
  for (si in c("grade","tonnage","tongrade")) {
    outfile <- paste(folder,paste(si,"_plot.jpeg",sep=""), sep = "\\")
    jpeg(outfile, 1024, 1024)
  	plotObj <- plot.TonGradePdf(outobj,si)
    dev.off()
  	outfile <- paste(folder,paste(si,"_plot.tiff",sep=""), sep = "\\")
    tiff(outfile, 2048	, 2048 )
    plotObj <- plot.TonGradePdf(outobj,si,labelSize=20)
    dev.off()
  	setEPS()
  	postscript(paste(folder,paste(si,"_plot.eps",sep=""), sep = "\\"))
  	plotObj <- plot.TonGradePdf(outobj,si,labelSize=7)
  	dev.off()
  }
  
  for (si in c("grade","tonnage")) {
  	outfile <- paste(folder, paste(si,"_summary.txt",sep=""), sep = "\\")
  	sink(outfile)
    summary.TonGradePdf(outobj,si)
  }
}

args = commandArgs(trailingOnly = TRUE)
dataPath <- args[1]
seed <- args[2]
isTruncated <- args[4]
minNDeposits <- as.double(args[5])
nRandomSamples <- as.integer(args[6])
folder <- args[7]
tongrade <- tongradePdf(dataPath, seed, isTruncated, minNDeposits, nRandomSamples, folder)