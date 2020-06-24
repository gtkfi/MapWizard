#version 0.2
library(raster)

source("rasterproc.r")

args = commandArgs(trailingOnly = TRUE)
infile<-args[1]
outCsv=args[2]

# Make a raster object of the input raster
inras<-raster(infile)
mima_ras<-raster_stat(inras) # Call to a function raster_stat() providing min and max raster value as a two-element vector c(min,max)
write.table(matrix(mima_ras, nrow=1),file=outCsv, row.names =FALSE, col.names = FALSE,sep = ",")
print((mima_ras))