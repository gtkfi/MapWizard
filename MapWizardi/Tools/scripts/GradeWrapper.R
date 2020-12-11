# This includes the function TonnagePdf.R and Utilities.R (The latter checks that the input has enough data and no NULL values)
source("GradePdf.R")
#source("TonnagePdf.R") # Changed: ei tarvi tonnage paketissa
source("Utilities.R")
library("ggplot2")

#gradePdf <- function(dataPath, seed, pdfType, isTruncated, minNDeposits, nRandomSamples, folder, wd) {
gradePdf <- function(dataPath, seed, pdfType, isTruncated, minNDeposits, nRandomSamples, folder) { # Changed: wd pois
    
    in_data <- read.csv(dataPath)
    # This calls the function TonnagePdf, in file TonnagePdf.R
    outobj <- GradePdf(in_data,
                       seed = seed,
                       pdfType = pdfType,
                       isTruncated = isTruncated,
                       minNDeposits = minNDeposits,
                       nRandomSamples <- nRandomSamples)

    saveRDS(outobj, file = paste(folder,"grade.rds", sep="\\"))
    outfile <- paste(folder, "grade_plot.jpeg", sep = "\\")
    jpeg(outfile, 1024, 1024)
	plotObj <- plot.GradePdf(outobj)
    dev.off()

	outfile <- paste(folder, "grade_plot.tiff", sep = "\\")
    tiff(outfile, 2048	, 2048 )
    plotObj <- plot.GradePdf(outobj,labelSize=20)
    dev.off()

	setEPS()
	postscript(paste(folder, "grade_plot.eps", sep = "\\"))
	plotObj <- plot.GradePdf(outobj,labelSize=7)
	dev.off()
    outfile <- paste(folder, "grade_summary.txt", sep = "\\")
    sink(outfile)
    summary.GradePdf(outobj)

    return(outobj)
}
args = commandArgs(trailingOnly = TRUE)

dataPath <- args[1]
seed <- args[2]
pdfType <- args[3]
isTruncated <- args[4]
minNDeposits <- args[5]
nRandomSamples <- as.integer(args[6])
folder <- args[7]
# wd <- args[8] # Changed: voi poistaa

grade <- gradePdf(dataPath, seed, pdfType, isTruncated, minNDeposits, nRandomSamples, folder)