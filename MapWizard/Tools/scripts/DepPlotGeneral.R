# Plotting function:
#======================================================
plotlines<-function(header,area,p10,p50,p90,folder) {
  
# area: common x values for all the plotted lines
# p10,p50 and p90: y-values for the three plotted lines

  outfile <- paste(folder,"plot.jpeg",sep="")	
  jpeg(outfile,width = 960, height = 960, pointsize = 12, quality = 100)
  
# Define plot x and y tick label lcations based on area and deposit amount
# Use also for axis ranges.
  lg_fl_area<-floor(log10(min(area)))
  lg_ce_area<-ceiling(log10(max(area)))
  lg_fl_nocc<-floor(log10(min(p90)))
  lg_ce_nocc<-ceiling(log10(max(p10)))
  xpos<-c(1 %o% 10^(lg_fl_area:lg_ce_area))
  ypos<-c(1 %o% 10^(lg_fl_nocc:lg_ce_nocc))

# Plot the probability 10% line and define axis labels and range
  plot(area,p10,type="l",lty=1,log="xy",col=4,main=header,xlab=expression("Tract area" ~ (km^{2})),ylab="Number of deposits",
     xaxt="n",yaxt="n",xlim=c(10^lg_fl_area,10^lg_ce_area),ylim=c(10^lg_fl_nocc,10^lg_ce_nocc))
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted")
# Define tick labels 
  axis(1,at=xpos,labels=sprintf("%d",xpos))
  axis(2,at=ypos,labels=ypos)
# Plot p* lines
  lines(area,p50,col=1)
  lines(area,p90,col=2)


#Plot existing deposits
  indat<-"IndataGeneral.csv"
  datmat<-read.csv(file=indat,header=FALSE,sep=";")
  dimdat<-dim(datmat)
  datarea<-as.numeric(gsub(" ","",datmat[,4],fixed=TRUE))
  nocc<-as.numeric(datmat[,5])
  colpts<-rep(datmat[,2])
  message(colpts)
  points(datarea,nocc,col=colpts,pch=16)
 
# Legend
  legend ("bottomright",  c("Podiform chromite","Cyprus m. sulfide","kuroko m. sulfide","Porphyry copper","Climax porphyry Mo","Franciscan Mn","Cuban Mn","low sulfide qtz-gold","Placer gold","Tungsten vein","p10","p50","p90"),col=c(1,2,3,4,4,1,2),lty=c(NA, NA, NA,NA,NA,NA,NA,NA,NA,NA,1,1,1), pch=c(16, 16, 16,16,16,16,16,16,16,16,NA,NA, NA))
  dev.off()
}
# ==============================================================
# End of plotting function


# Calculate values to plot, and call plotting function defined above.

plotcalculate<-function(medTons,a,b,c,t10n2,sxy,N,m_loga,m_logmedTons,std_loga,slogMedTons,min_area,max_area,NKnown,folder,headerText) {
  area<-seq(min_area,max_area,length.out=2)
  std_loga<-std_loga
  m_loga<-m_loga
  dimdat<-N
if(NKnown > 0)
{
  logN10 <-(a+b*log10(area)+c*log10(medTons))+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/((dimdat[1]-1)*std_loga*slogMedTons))
  logN50 <- a+b*log10(area)+c*log10(medTons)
  varN <- ((logN10-logN50)/t10n2)^2 
  logNexp <- logN50 + (varN)/2
  nEXP <- 10^(logNexp)
  logN50 <- log10(nEXP-NKnown)- varN/2
  p90<-10^(logN50-t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/((dimdat[1]-1)*std_loga*slogMedTons)))
  p50<-10^(logN50)
  p10<-10^(logN50+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/((dimdat[1]-1)*std_loga*slogMedTons)))
else {
  p90<-10^((a+b*log10(area)+c*log10(medTons))-t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/((dimdat[1]-1)*std_loga*slogMedTons)))
  p50<-10^(a+b*log10(area)+c*log10(medTons))
  p10<-10^((a+b*log10(area)+c*log10(medTons))+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/((dimdat[1]-1)*std_loga*slogMedTons)))
}
# ---------------------------------------------------------------
  plotlines(headerText,area,p10,p50,p90,folder)
}
