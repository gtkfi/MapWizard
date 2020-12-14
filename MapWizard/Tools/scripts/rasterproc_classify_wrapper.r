#version 0.2
library(raster)

source("rasterproc.r")

args = commandArgs(trailingOnly = TRUE)
# Path to the input raster file
infile<-args[1]
#inras<-raster(infile)
#breakv<-args[2]
breakv<-as.numeric(unlist(strsplit(args[2], split=",")))
outf_Img<-args[3]
outf_Pdf<-args[4]
# Make a raster object of the input raster
raster_class(infile,breakv,outf_Img,outf_Pdf) 
