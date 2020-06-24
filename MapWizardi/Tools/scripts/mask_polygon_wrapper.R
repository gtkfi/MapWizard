#version 0.2
library(raster)

source("rasterproc.r")

args = commandArgs(trailingOnly = TRUE)
infile<-args[1]
inras<-raster(infile)
inPolyShp<-args[2]
outf_maskImg<-args[3]
outf_maskPdf<-args[4]

mrwp<-mask_raster_with_polygon(inras,inPolyShp,outf_maskImg,outf_maskPdf)
