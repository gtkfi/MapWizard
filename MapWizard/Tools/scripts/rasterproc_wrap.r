library(raster)
source("C:/data/pT/rasterproc.r")

args = commandArgs(trailingOnly = TRUE)
# Path to the input raster file
#infile<-"c:/Temp/mapWizard/PermissiveTract/Output/fuzzy.img"
infile<-args[1]
#outClassMap<-"c:/Temp/mapWizard/PermissiveTract/Output/FuzzyOL_discr.pdf"
outClassMap<-args[2]
#outPolyMap<-"c:/Temp/mapWizard/PermissiveTract/Output/FuzzyOL_poly.pdf"
outPolyMap<-args[3]

# Make a raster object of the input raster
inras<-raster(infile)

# Call to a function raster_stat() providing min and max raster value as a two-element vector c(min,max)
mima_ras<-raster_stat(inras)
range_ras<-mima_ras[2]-mima_ras[1]

# Set break values to divide the range into three equal parts
#breakv<-c(mima_ras[1]+2*range_ras/3)
breakv<-c(as.numeric(args[4]))
print(breakv)

# Call to the raster classification function raster_class().
# Input: 
# inras = input raster
# breakv = vector of break values. These have to be within the range of the raster values.
class_ras<-raster_class(inras,breakv,outClassMap)

# Call to the function raster_poly() for generating contours separatin the classes.
# SHOULD THE BACKGROUND RASTER BE GIVEN AS INPUT HERE, TOO...?
cont<-raster_poly(class_ras,outPolyMap)

print(freq(class_ras))