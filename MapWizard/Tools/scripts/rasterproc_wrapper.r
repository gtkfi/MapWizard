#version 0.2
library(raster)

#setwd("D:/Projektit/MAP")
source("rasterproc.r")

args = commandArgs(trailingOnly = TRUE)
# Path to the input raster file
#infile<-"SW/PermissiveTract_MPM/Fuzzy/Output/FuzzyOL.img"
infile<-args[1]

# Make a raster object of the input raster
inras<-raster(infile)

# 1. DELINEATE PERMISSIVE TRACTS
# 2. PLOT MASKED PROSPECTIVITY MAP PDF and IMG raster
# 3. CREATE TRACT SHP FILE
# 4. Plot tract over selected evidence raster.
# CREATES A WARNING IF THE SHAPE FILE WITH THE GIVEN NAME ALREADY EXITS. OVERWRITES ALWAYS.
mima_ras<-raster_stat(inras) # Call to a function raster_stat() providing min and max raster value as a two-element vector c(min,max)
range_ras<-mima_ras[2]-mima_ras[1]
breakval<-c(as.numeric(args[5]))# Set break value to divide the range into two equal parts
# Output files:
outMaskedPdf<-paste(args[2],".pdf",sep="")
outMaskedImg<-paste(args[2],".img",sep="")
outPolyP<-paste(args[3],".shp",sep="")
outPolyF<-args[4]
#outPolyMap<-paste(args[3],".pdf",sep="")
outPolyMap<-args[7]
# Input file
#bgEvid<-"SW/PermissiveTract_MPM/Background/albiteOcc.img"
#bgEvid<-"C:/data/permissivetract/exampleData/BackGroundEvidence/albiteOcc.img"
bgEvid<-args[6]
# Call to the raster masking function raster_mask().
# Input: 
# inras = input raster
# breakval = vector of break values. This has to be within the range of the raster values.
# outMaskedPdf = masked raster pdf file NEEDED ?????????
# outMaskedImg = masked raster img file
# outPolyP = entire path and filename to the output shp file
# outPolyF = output shape file name base (without .shp suffix)
# bgEvid = background evidence raster on which to plot the tract boundaries
# outPolyMap = permissive tract drawn on a selected evidence map
mask_ras<-raster_mask(inras,breakval,outMaskedPdf,outMaskedImg,bgEvid,outPolyMap)

# Compute statistics for a given polygon shape file
#outStatTxt=paste(outPolyP,"_stats.txt",sep="")
#outDistPdf=paste(outPolyP,"_dist.pdf",sep="")
# Input:
# outPolyP = the input polygon shape file
# outStatTxt = output textfile for polygon area statistics
# outDistPfd = output distributions (histogram and culumative)
#pgon_stats<-poly_stat(outPolyP,outStatTxt,outDistPdf)

# Clean up, dissolve and delete small polygons from a given set of polygons
##minarea=100000
##cleanPolyShpP="c:/Temp/PolyClean.shp"
##cleanPolyShpF="c:/Temp/PolyClean"
##outCleanStatTxt="c:/Temp/CleanPolyStat.txt"
##outCleanDistPdf="c:/Temp/CleanPolyDist.pdf"
# Input:
# outPolyP = the input polygon shape file
# minarea = minimum are of saved polygons
# cleanPolyShpP = entire path and filename to output cleaned polygons
# cleanPolyShpF = output cleaned polygons file name base (without .shp suffix)
##pgon_clean<-poly_clean(outPolyP,minarea,cleanPolyShpP,cleanPolyShpF,outCleanStatTxt,outCleanDistPdf)
# Set break values to divide the range into three equal parts
#breakvec<-c(mima_ras[1]+range_ras/3,mima_ras[1]+2*range_ras/3)
##breakvec<-c(as.numeric(args[5]))
##outClassMap<-"c:/Temp/Prosp_discr.pdf"
#outClassMap<-"SW/PermissiveTract_MPM/Delineation/Prosp_discr.pdf"
# Call to the raster classification function raster_class().
# Input: 
# inras = input raster
# breakvec = vector of break values. These have to be within the range of the raster values.
# outClassMap = pdf file path (with filename) to the output image
##class_ras<-raster_class(inras,breakvec,outClassMap)
#print(freq(class_ras))

# Call to the function raster_poly() for generating contours separatin the classes.
# This is for generating a shape file from the discretized raster. This is needed to compute the distribution of permissive polygon areas
# cont<-raster_poly(class_ras,outPolyMap,inBGras_f,tmpout,outPolyShp)

