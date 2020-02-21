library(data.table)

### UPDATE May 21st 2019 ######### Not delivered to coders yet as of 22.5.2019
# Names of the functions and some internal variables renamed aggr->econ.
# Old names were probably due to messing up the tools (aggregate and economic filter)
##################################

econ_plot<-function(col,mc_res,plotd) {
  library(data.table)
  attr<-gsub(" ", "", names(mc_res), fixed = TRUE)
  names(mc_res)<-attr
  x<-unlist(mc_res[,attr[col],with=FALSE])
  nsim<-max(mc_res[,"Simulation.Index"])
  nax<-which(!is.na(x)) # indicies of simulated deposits with tonnages !=NA for attr[col]
  x[-nax]<-0
  ndat<-length(x)
  plotseq<-seq(1,ndat,100)
  if (max(plotseq)!=ndat) plotseq<-c(plotseq,ndat)
  reord<-order(x,decreasing=TRUE)
  ordx<-x[reord]
  csumx<-cumsum(ordx)
  res_stat<-c(min(x),median(x),mean(x),max(x),sd(x))
  names(res_stat)<-c("Min","Median","Mean","Max","SD")
  pdf(paste(plotd,"\\result_plot.pdf",sep=""))
  jpeg(paste(plotd,"\\result_plot.jpeg",sep=""))
  
  plot(plotseq/ndat,csumx[plotseq]/csumx[ndat],type="l",xlab="Part of ranked deposits accumulated",ylab="Part of mineral resource in deposits")
  title(paste("Mineral deposit size distribution for",substr(attr[col],1,2),",",nsim,"simulations"))
  text(0.4,0.5,paste("Total of",length(x),"simulated deposits"),pos=4)
  for (i in 1:length(res_stat)) {
    text(0.4,(0.4-(i-1)*0.05),paste(names(res_stat[i]),": ",round(res_stat[i],0)),pos=4)
  }
  nPart<-seq(1,ndat)/ndat
  tonPart<-csumx/csumx[ndat]
  graphics.off()


  #same for tiff
  tiff(paste(plotd,"\\result_plot.tiff",sep=""))
  plot(plotseq/ndat,csumx[plotseq]/csumx[ndat],type="l",xlab="Part of ranked deposits accumulated",ylab="Part of mineral resource in deposits")
  title(paste("Mineral deposit size distribution for",substr(attr[col],1,2),",",nsim,"simulations"))
  text(0.4,0.5,paste("Total of",length(x),"simulated deposits"),pos=4)
  for (i in 1:length(res_stat)) {
    text(0.4,(0.4-(i-1)*0.05),paste(names(res_stat[i]),": ",round(res_stat[i],0)),pos=4)
  }
  nPart<-seq(1,ndat)/ndat
  tonPart<-csumx/csumx[ndat]
  graphics.off()
  
  #same for eps
  setEPS()
  postscript(paste(plotd,"\\result_plot.eps",sep=""))
  plot(plotseq/ndat,csumx[plotseq]/csumx[ndat],type="l",xlab="Part of ranked deposits accumulated",ylab="Part of mineral resource in deposits")
  title(paste("Mineral deposit size distribution for",substr(attr[col],1,2),",",nsim,"simulations"))
  text(0.4,0.5,paste("Total of",length(x),"simulated deposits"),pos=4)
  for (i in 1:length(res_stat)) {
    text(0.4,(0.4-(i-1)*0.05),paste(names(res_stat[i]),": ",round(res_stat[i],0)),pos=4)
  }
  nPart<-seq(1,ndat)/ndat
  tonPart<-csumx/csumx[ndat]
  dev.off()
  graphics.off()

  #end
  return(list(nPart,tonPart,nax,reord))
}


econ_stat<-function(perType,perc,mc_res,econp_res,elcol,outdir) {
  perc<-perc/100.0
  ncol_oreton<-5 # Column index of the ore metric tons column
  elcol<-c(5,elcol)
  numcol<-length(elcol)
  nPart<-econp_res[[1]] # Cumulative number of deposits
  tonPart<-econp_res[[2]] # Cumulative portion of tonnages
  nax<-econp_res[[3]] # indicies of simulated deposits with tonnages != NA for attr[col]
  reord<-econp_res[[4]] # Iindices of simulated deposits arranged in decreasing order of tonnages
  attr<-gsub(" ", "", names(mc_res), fixed = TRUE) # Remove whitespace from header names
  names(mc_res)<-attr
  tmp<-which(attr=="Simulation.Index")
  simind<-unlist(mc_res[,attr[tmp],with=FALSE])
  ordsimi<-simind[reord] # Order simulation indices with decreasing tonnage
  ele<-unlist(mc_res[,attr[elcol],with=FALSE])
  ele<-matrix(ele,ncol=numcol)
  ele[-nax,]<-0
  elesel<-ele[reord,]
  if (perType==1) { # If the percentages refer to number of deposits
    elesel[nPart>perc,]<-0
  }
  if (perType==2) { # If the percentages refer to mineral resources
    elesel[tonPart>perc,]<-0
  }
  isim<-as.integer(levels(factor(ordsimi)))
  tonsim<-matrix(rep(0,length(isim)*numcol),ncol=dim(elesel)[2])
  for (j in 1:length(isim)) {
    isimele<-elesel[ordsimi==isim[j],]
    if (length(elesel[ordsimi==isim[j],1])>1) {
        tonsim[j,]<-apply(isimele,2,function(x) sum(x))
    } else {
      tonsim[j,]<-isimele
    }
  }
  ton.std<-apply(tonsim,2,function(x) sd(x))
  ton.mea<-apply(tonsim,2,function(x) mean(x))
  ton.max<-apply(tonsim,2,function(x) max(x))
  ton.min<-apply(tonsim,2,function(x) min(x))
  ton.q<-apply(tonsim,2,function(x) quantile(x,probs=c(0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99)))
  p_zero<-rep(length(which(tonsim[,1]==0))/length(isim),numcol)
  p_gt_mean<-c()
  for (i in 1:numcol) {
    p_gt_mean[i]<-length(which(tonsim[,i]>=ton.mea[i]))/length(isim)
  }
  outdat<-rbind(ton.mea,ton.max,ton.min,ton.q[6,],ton.std,ton.q,p_zero,p_gt_mean)
  outdat<-t(outdat)
  colnames(outdat)<-c("Means","Max","Min","Median","STD","P99","P90","P80","P70","P60","P50","P40","P30","P20","P10","P1","Prob of Zero","Prob>=Mean")
  colnames(tonsim)<-attr[elcol]
  write.csv(tonsim,paste(outdir[2],"/eco_tonnages.csv",sep=""))
  write.csv(outdat,paste(outdir[2],"/eco_tonnage_stat.csv",sep=""),row.names=attr[elcol])
  pdf(paste(outdir[1],"/eco_ton_histogram.pdf",sep=""))
  jpeg(paste(outdir[1],"/eco_ton_histogram.jpeg",sep=""))
  apply(tonsim,2,function(x) hist(x))

  tiff(paste(outdir[1],"/eco_ton_histogram.tiff",sep=""))
  apply(tonsim,2,function(x) hist(x))

  setEPS()
  postscript(paste(outdir[1],"/eco_ton_histogram.eps",sep=""))
  apply(tonsim,2,function(x) hist(x))
  dev.off()
  graphics.off()

}



args = commandArgs(trailingOnly = TRUE)
mc_res<-fread(args[1])
perType<-as.numeric(args[2])
perc<-as.numeric(args[3])
outd<-c(args[4],args[4])
col<- as.numeric(args[5])
# plotting directory if needed
plotd<-args[4]

# Call econ_plot() for plotting the cumulative distribution of resources
#print("agg_plot....")
econp_res<-econ_plot(col,mc_res,plotd)
elcol<-as.integer(unlist(strsplit(args[6], split=",")))
econ_res<-econ_stat(perType,perc,mc_res,econp_res,elcol,outd)
#VERSION 1.2
