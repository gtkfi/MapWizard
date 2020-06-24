# Library of GIS raster and vector data processing functions
#
# raster_stat()
# Computes raster statistics (min,max)
#
# raster_mask()
# Masks out raster values below the given input breakvalue. Plots the masked input raster as pdf and the mask polygon as a shp file.
#
# raster_class()
# discretizes raster values to classes defined by input breakvalues. Classes are assigned values 1,2,3,...
#


library(raster)
library(rgdal)
library(rgeos)
library(sp)
library(smoothr)

# For polygonizing raster one of the following
library(stars)
#install.packages("SW/Libraries/fasteraster_1.0.4.tar.gz",repos=NULL)
#library(fasteraster)
#source("SW/Libraries/polygonizer.R") # Requires installation of OSgeo4W (https://trac.osgeo.org/osgeo4w/)
##

raster_stat<-function(inras) {
  getValues(inras)
  stats<-c()
  stats[1]<-cellStats(inras,stat="min",na.rm=TRUE)
  stats[2]<-cellStats(inras,stat="max",na.rm=TRUE)
  return(stats)
}

raster_mask<-function(inras,breakv,outf_maskPdf,outf_maskImg,outShpD,outShpF,bgEvid,outPolyMap) {
  inras_val<-raster_stat(inras)
  xlimits<-ylimits<-c()
  extras<-extent(inras)
  xlimits[1]<-attributes(extras)$xmin
  xlimits[2]<-attributes(extras)$xmax
  ylimits[1]<-attributes(extras)$ymin
  ylimits[2]<-attributes(extras)$ymax
  if(breakv<inras_val[1]|breakv>inras_val[2]) {
    stop("Breakvalue is not in the range of the raster values")
  }
# plot the masked input raster as a pdf image and save as raster
  pdf(outf_maskPdf)
  plot(inras,zlim=c(breakv,inras_val[2]),col=rainbow(1000),useRaster=TRUE,xlim=xlimits,ylim=ylimits)
  inras[inras<breakv]<-NA
  writeRaster(inras,filename=outf_maskImg,format="HFA",overwrite=TRUE)
# plot the mask polygon as a shape file
  inras[is.na(inras)==FALSE]<-1
  polyext<-rasterToPolygons(inras,dissolve=TRUE)
  if (file.exists(paste(dirname(outShpD),"/",outShpF,".shp",sep=""))) file.remove(paste(dirname(outShpD),"/",outShpF,".shp",sep=""))
  writeOGR(polyext,dsn=outShpD,layer=outShpF,driver="ESRI Shapefile",verbose=TRUE)
  pdf(outPolyMap)
  bgras<-raster(bgEvid)
  plot(bgras)
  plot(polyext,add=TRUE)
  graphics.off()
}

poly_stat<-function(inPolyShp,outStatTxt,outDist) {
  polyg<-shapefile(inPolyShp)
  disa_polyg<-disaggregate(polyg)
  poly_areas<-area(disa_polyg)
  ar_stat<-c(min(poly_areas),median(poly_areas),mean(poly_areas),max(poly_areas),sd(poly_areas),quantile(poly_areas,prob=c(0.1,0.25,0.5,0.75,0.9)))
  names(ar_stat)<-c("Min","Median","Mean","Max","SD","Q0.1","Q0.25","Q0.5","Q0.75","Q0.9")
  write.csv(file=outStatTxt,t(ar_stat),row.names=FALSE)
  pdf(outDist)
  par(mfrow=c(2,1))
  polyHist<-hist(poly_areas,breaks=1000,plot=T)
  area_class<-cut(poly_areas,polyHist$breaks,include.lowest=T)
  sumarea<-tapply(poly_areas,area_class,sum)
  plot(sumarea)
  graphics.off()
}

poly_clean<-function(inPolyShp,minarea,outPolyShpP,outPolyShpF,outStatTxt,outDist) {
  graphics.off()
# Compute initial areas, and remove small polygons, write cleaned shape file
  polyg<-shapefile(inPolyShp)
  disa_polyg<-disaggregate(polyg)
  poly_areas<-area(disa_polyg)
  if (minarea>min(poly_areas)) {
    small_p<-which(poly_areas<minarea)
    disa_polyg<-disa_polyg[-small_p,]
  }
  disa_polyg<-fill_holes(disa_polyg,minarea)
  if (file.exists(paste(dirname(outPolyShpP),"/",outPolyShpF,".shp",sep=""))) file.remove(paste(dirname(outPolyShpP),"/",outPolyShpF,".shp",sep=""))
  writeOGR(disa_polyg,dsn=outPolyShpP,layer=outPolyShpF,driver="ESRI Shapefile",verbose=TRUE)
  pdf(paste(dirname(outPolyShpP),"/",outPolyShpF,".pdf",sep=""))
  plot(disa_polyg)
  header <-paste("Minimum area",toString(minarea / 1000000),"km2")
  mtext(header)
  # Compute area statistics of the cleaned polygons, write output stat file and genereate stat plots
  poly_areas<-area(disa_polyg)
  ar_stat<-c(min(poly_areas),median(poly_areas),mean(poly_areas),max(poly_areas),sd(poly_areas),quantile(poly_areas,prob=c(0.1,0.25,0.5,0.75,0.9)))
  names(ar_stat)<-c("Min","Median","Mean","Max","SD","Q0.1","Q0.25","Q0.5","Q0.75","Q0.9")
  write.csv(file=outStatTxt,t(ar_stat),row.names=FALSE)
  pdf(outDist)
  par(mfrow=c(2,1))
  polyHist<-hist(poly_areas,breaks=1000,plot=T)
  area_class<-cut(poly_areas,polyHist$breaks,include.lowest=T)
  sumarea<-tapply(poly_areas,area_class,sum)
  plot(sumarea)
  graphics.off()
}

raster_class<-function(inras,breakv,outf) {
  outras<-inras
  inras_val<-values(inras)
  if(min(breakv)<min(inras_val,na.rm=TRUE)|max(breakv)>max(inras_val,na.rm=TRUE)) {
    stop("Breakvalues are not in the range of the raster values")
  }
  lb<-length(breakv)
  outras[inras<=breakv[1]]<-1
  if (lb>1) {
    for (i in 2:lb) {
      outras[inras<=breakv[i]&inras>breakv[i-1]]<-i
    }
  }
  outras[inras>breakv[lb]]<-lb+1
  colt<-rainbow(length(breakv)+1)
  pdf(outf)
  image(outras,col=colt)
#  plot(outras,col=colt)
  graphics.off()
  return(outras)
}
