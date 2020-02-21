
######## NEED FOR UPDATE ?????? ############
# Check for raster_mask() function, wheter it is meaningful to write everyting for each trial input breakvalue #######
############################################

# Library of GIS raster and vector data processing functions
#
# raster_stat() returns the min and max value for the given input raster
#
# raster_mask()
# Masks out raster values below the given input breakvalue. Plots the masked input raster and
# tract polygon on a given back ground raster as pdf and the mask polygon as a shp file.
#
# poly_stat(_line) computes polygon area statistics, and outputs as a csv table and cumulative distribution plot.
# _clean version plots a line plot, the other plots a point plot. Alternatives.
#
# poly_clean removes polygons of size below the given area threshold. Outputs a cleaned polygon shape file
# and polygon area statistics as a csv table and cumulative distribution plot
#
# raster_class()
# discretizes raster values to classes defined by input breakvalues. Classes are assigned values 1,2,3,...
#

library(raster)
library(rgdal)
library(rgeos)
library(sp)
library(smoothr)
library(RColorBrewer)

library(stars)

raster_stat<-function(inras) {
  getValues(inras)
  stats<-c()
  stats[1]<-cellStats(inras,stat="min",na.rm=TRUE)
  stats[2]<-cellStats(inras,stat="max",na.rm=TRUE)
  return(stats)
}

raster_mask<-function(inras,breakv,outf_maskPdf,outf_maskImg,outShpD,outShpF,bgEvid,outPolyMap) {
##########################################
# This could be checked in UI ####### ????????????
  inras_val<-raster_stat(inras)
  if(breakv<inras_val[1]|breakv>inras_val[2]) {
    stop("Breakvalue is not in the range of the raster values")
  }
##########################################
  xlimits<-ylimits<-c()
  extras<-extent(inras)
  xlimits[1]<-attributes(extras)$xmin
  xlimits[2]<-attributes(extras)$xmax
  ylimits[1]<-attributes(extras)$ymin
  ylimits[2]<-attributes(extras)$ymax
  rangex<-xlimits[2]-xlimits[1]
  rangey<-ylimits[2]-ylimits[1]
# plot the masked input raster as a pdf image and save as raster
  pdf(outf_maskPdf,width=7,height=7*rangey/rangex)
  plot(inras,zlim=c(breakv,inras_val[2]),col=topo.colors(10),xlim=xlimits,ylim=ylimits,cex.axis=0.7,legend=F)
  graphics.off()
  inras[inras<breakv]<-NA
  writeRaster(inras,filename=outf_maskImg,format="HFA",overwrite=TRUE)
# plot the mask polygon as a shape file
  inras[is.na(inras)==FALSE]<-1
  polyext<-rasterToPolygons(inras,dissolve=TRUE)
  if (file.exists(paste(dirname(outShpD),"/",outShpF,".shp",sep=""))) file.remove(paste(dirname(outShpD),"/",outShpF,".shp",sep=""))
  writeOGR(polyext,dsn=outShpD,layer=outShpF,driver="ESRI Shapefile",verbose=TRUE)
  pdf(outPolyMap,width=7,height=7*rangey/rangex)
  bgras<-raster(bgEvid)
  bgras_masked<-mask(bgras,polyext)
  plot(bgras,col=topo.colors(10,alpha=0.1),cex.axis=0.7,legend=F)
  plot(bgras_masked,col=topo.colors(10),add=T,legend=F)
  graphics.off()
}

poly_stat_line<-function(inPolyShp,outStatTxt,outDist) {
  # Output unit km2
  # Input polygon unit m2
  polyg<-shapefile(inPolyShp)
  disa_polyg<-disaggregate(polyg)
  poly_areas<-area(disa_polyg)/1000000
  ar_stat<-c(min(poly_areas),median(poly_areas),mean(poly_areas),max(poly_areas),sd(poly_areas),quantile(poly_areas,prob=c(0.1,0.25,0.5,0.75,0.9)))
  names(ar_stat)<-c("Min","Median","Mean","Max","SD","Q0.1","Q0.25","Q0.5","Q0.75","Q0.9")
  write.csv(file=outStatTxt,t(ar_stat),row.names=FALSE)
  pdf(outDist)
  polyHist<-hist(poly_areas,breaks=1000,plot=F)
  area_class<-cut(poly_areas,polyHist$breaks,include.lowest=T)
  sumarea<-tapply(poly_areas,area_class,sum)
  sumarea[is.na(sumarea)==T]<-0
  csum<-cumsum(sumarea)
  perc_sum<-csum/csum[length(csum)]
  plot(polyHist$mids,perc_sum,log="x",type="l",ylab="Part of cumulative area",xlab=expression("Polygon area / km"^2),
       main="Cumulative area as a function of polygon area")
  rars<-round(ar_stat,2)
  for (i in 1:length(ar_stat)) {
    text(min(polyHist$mids),(0.9-(i-1)*0.04),substitute(paste(nar,": ",ar," ",km^2),list(nar=names(ar_stat)[i],ar=rars[i])),pos=4)
  }
  graphics.off()
}

poly_stat<-function(inPolyShp,outStatTxt,outDist) {
  # Output unit km2
  # Input polygon unit m2
  polyg<-shapefile(inPolyShp)
  disa_polyg<-disaggregate(polyg)
  poly_areas<-area(disa_polyg)/1000000
  ar_stat<-c(min(poly_areas),median(poly_areas),mean(poly_areas),max(poly_areas),sd(poly_areas),quantile(poly_areas,prob=c(0.1,0.25,0.5,0.75,0.9)))
  names(ar_stat)<-c("Min","Median","Mean","Max","SD","Q0.1","Q0.25","Q0.5","Q0.75","Q0.9")
  write.csv(file=outStatTxt,t(ar_stat),row.names=FALSE)
  pdf(outDist)
  poly_areas<-poly_areas[order(poly_areas)]
  poly_areas[is.na(poly_areas)==T]<-0
  csum<-cumsum(poly_areas)
  perc_sum<-csum/csum[length(csum)]
  plot(poly_areas,perc_sum,log="x",type="p",ylab="Part of cumulative area",xlab=expression("Polygon area / km"^2),
       main="Cumulative area as a function of polygon area")
  rars<-round(ar_stat,2)
  for (i in 1:length(ar_stat)) {
    text(min(poly_areas),(0.9-(i-1)*0.04),substitute(paste(nar,": ",ar," ",km^2),list(nar=names(ar_stat)[i],ar=rars[i])),pos=4)
  }
  graphics.off()
}


poly_clean<-function(inPolyShp,minarea,outPolyShpP,outPolyShpF,outStatTxt,outDist) {
  # minarea unit km2
  # Input polygon unit m2
  graphics.off()
# Compute initial areas, and remove small polygons, write cleaned shape file
  polyg<-shapefile(inPolyShp)
  disa_polyg<-disaggregate(polyg)
  poly_areas<-area(disa_polyg)/1000000
  small_p<-which(poly_areas<minarea)
  disa_polyg<-disa_polyg[-small_p,]
  disa_polyg<-fill_holes(disa_polyg,minarea*1000000) # Polygon unit is m2 and minarea unit is km2
  if (file.exists(paste(dirname(outPolyShpP),"/",outPolyShpF,".shp",sep=""))) file.remove(paste(dirname(outPolyShpP),"/",outPolyShpF,".shp",sep=""))
  writeOGR(disa_polyg,dsn=outPolyShpP,layer=outPolyShpF,driver="ESRI Shapefile",verbose=TRUE)
# Compute area statistics of the cleaned polygons, write output stat file and genereate stat plots
  poly_areas<-area(disa_polyg)/1000000
  ar_stat<-c(min(poly_areas),median(poly_areas),mean(poly_areas),max(poly_areas),sd(poly_areas),quantile(poly_areas,prob=c(0.1,0.25,0.5,0.75,0.9)))
  names(ar_stat)<-c("Min","Median","Mean","Max","SD","Q0.1","Q0.25","Q0.5","Q0.75","Q0.9")
  write.csv(file=outStatTxt,t(ar_stat),row.names=FALSE)
  pdf(outDist)
  poly_areas<-poly_areas[order(poly_areas)]
  poly_areas[is.na(poly_areas)==T]<-0
  csum<-cumsum(poly_areas)
  perc_sum<-csum/csum[length(csum)]
  plot(poly_areas,perc_sum,log="x",type="p",ylab="Part of cumulative area",xlab=expression("Polygon area / km"^2),
       main="Cumulative area as a function of polygon area")
  rars<-round(ar_stat,2)
  text(min(poly_areas),0.95,substitute(paste("Polygons with area below ",ma," km "^2," removed"),list(ma=minarea/1000000)),pos=4)
  for (i in 1:length(ar_stat)) {
    text(min(poly_areas),(0.9-(i-1)*0.04),substitute(paste(nar,": ",ar," ",km^2),list(nar=names(ar_stat)[i],ar=rars[i])),pos=4)
  }
  graphics.off()
}

raster_class<-function(inras_f,breakv,outf_Img,outf_Pdf) {
  ####################################################
  # This could be checked in UI ??????????????
  inras<-raster(inras_f)
  inras_val<-raster_stat(inras)
  if(length(which(breakv<inras_val[1]))>0|length(which(breakv>inras_val[2]))>0) {
    stop("Breakvalue is not in the range of the raster values")
  }
  #####################################################
  xlimits<-ylimits<-c()
  extras<-extent(inras)
  xlimits[1]<-attributes(extras)$xmin
  xlimits[2]<-attributes(extras)$xmax
  ylimits[1]<-attributes(extras)$ymin
  ylimits[2]<-attributes(extras)$ymax
  rangex<-xlimits[2]-xlimits[1]
  rangey<-ylimits[2]-ylimits[1]
  outras<-inras
  lb<-length(breakv)
  outras[inras<=breakv[1]]<-1
  if (lb>1) {
    for (i in 2:lb) {
      outras[inras<=breakv[i]&inras>breakv[i-1]]<-i
    }
  }
  outras[inras>breakv[lb]]<-lb+1
  colt<-rainbow(length(breakv)+1)
  # plot the input raster as a pdf image and save as ERDAS imagine raster
  print(rangey)
  print(rangex)
  print(outf_Pdf)
  pdf(outf_Pdf,width=7,height=7*rangey/rangex)
  plot(outras,col=colt)
  graphics.off()
  writeRaster(outras,filename=outf_Img,format="HFA",overwrite=TRUE)
  return(outras)
}
