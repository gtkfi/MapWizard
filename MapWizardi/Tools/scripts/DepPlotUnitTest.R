# TÄSTÄ ALKAA PLOTTAUSFUNKTIO
# ==============================================================
plotlines<-function(header,area,p10,p50,p90,folder,indataFile, indataHeader) {
  
# area: common x values for all the plotted lines
# p10,p50 and p90: y-values for the three plotted lines

# Jos haluat tiedostoon, niin ota seuraavasta rivistä kommentti pois, ja muuta polku.
  outfile <- paste(folder,"plot.jpeg",sep="")
 # message(folder)		
  jpeg(outfile,width = 800, height = 800, pointsize = 12, quality = 75)
  
# Määritetään plotin x ja y tick labelien paikat plotattavien pinta-alojen ja deposit määrien perusteella 
# (muuten ne tulee rumasti). Käytetään näitä myös akseleiden rangen määrittämisessä.
  lg_fl_area<-floor(log10(min(area)))
  lg_ce_area<-ceiling(log10(max(area)))
  lg_fl_nocc<-floor(log10(min(p90)))
  lg_ce_nocc<-ceiling(log10(max(p10)))
  xpos<-c(1 %o% 10^(lg_fl_area:lg_ce_area))
  ypos<-c(1 %o% 10^(lg_fl_nocc:lg_ce_nocc))
  graphics.off()
# Plotataan probability 10% suora ja määritetään akselien otsikot ja range
  plot(area,p10,type="l",lty=1,log="xy",col=4,main=header,xlab=expression("Tract area" ~ (km^{2})),ylab="Number of deposits",
     xaxt="n",yaxt="n",xlim=c(10^lg_fl_area,10^lg_ce_area),ylim=c(10^lg_fl_nocc,10^lg_ce_nocc))
# Määritetään tick labels 
  axis(1,at=xpos,labels=sprintf("%d",xpos))
  axis(2,at=ypos,labels=ypos)
# Plotataan p* viivat
  lines(area,p50,col=1)
  lines(area,p90,col=2)

#Plotataan olemassaolevat esiintymät
  indat<-indataFile
  datmat<-read.csv(file=indat,header=FALSE,sep=";")
  dimdat<-dim(datmat)
  datarea<-as.numeric(gsub(" ","",datmat[,3],fixed=TRUE))
  nocc<-as.numeric(datmat[,4])
  points(datarea,nocc,col=1,pch=16)

# Legenda
  legend ("bottomright",c(indataHeader,"p10","p50","p90"),col=c(1,4,1,2),lty=c(NA,1,1,1),pch=c(16,NA,NA,NA))
 # dev.off()
}
# ==============================================================
# TÄHÄN PÄÄTTYY PLOTTAUSFUNKTIO


# Seuraavassa lasketaan plotattavat arvot, ja kutsutaan ylläolevaa plottausfunktiota

# Input tiedosto, jossa PorCu density plotin data, eli 33 x 7 matriisi
#indat<-"D:/Projektit/MAP/SW/TestData/DepositDensityTool/PorCu_data.csv"

plotcalculate<-function(a,b,t10n2,sxy,N,m_loga,std_loga,min_area,max_area,NKnown,folder,headerText,indataFile,indataHeader) {

#inpar<-c()
# PorCu parameters
#inpar[1]<--1.042 # a
#inpar[2]<-0.431 # b
#inpar[3]<-0.239 # sxy
#inpar[4]<-0.9 # probability for t-dist
#inpar[5]<-31 # n freedom for t-dist
#inpar[6]<-1.188 # std_loga
#inpar[7]<-2.615 # m_loga
#inpar[8]<-109 # N
#inpar[9]<-1000 #min area 
#inpar[10]<-1000000 #max area


# Luetaan data CSV-tiedostosta.
#datmat<-read.csv(file=indat,header=TRUE,sep=",")
# Datamatriisin dimensiot
#dimdat<-dim(datmat)
# Koska datassa on string arvoja, lukee read.csv koko taulukon stringiksi.
# Pitää muuttaa numeeriseksi ne joita käytetään laskuissa, eli pinta-ala ja deposittien määrä.
# Poistetaan myös whitespace,jota esiintyy isoissa luvuissa (pinta-alat).
#datarea<-as.numeric(gsub(" ","",datmat[,3],fixed=TRUE))
#nocc<-as.numeric(datmat[,4])
# Määritetään deposit typelle arvo plotin väritystä varten. Lähinnä tärkeä jos plotataan se general tapaus, jossa monta eri
# esiintymätyyppiä, että saadaan ne eri väreillä. colpts vektori sisältää värin kullekin plotattavalle pisteelle
#Deptype<-3
#colpts<-rep(Deptype,dimdat[1])

# Seuraavat rivit on niiden plotattavien viivojen laskemista varten, mutta nehän sulla jo on koodattu.
# Lasken tossa vain alku ja loppupisteen 2-elementtisiin vektoreihin area (x-arvo) ja p* (y-arvo).
# ---------------------------------------------------------------
# t10n2<-qt(tdist,ftdist)
#area<-seq(min(datarea),max(datarea),length.out=2)
  area<-seq(min_area,max_area,length.out=2)
  std_loga<-std_loga
  m_loga<-m_loga
  dimdat<-N
if(NKnown > 0)
{
  logN10 <- (a+b*log10(area))+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/(dimdat[1]*std_loga))
  logN50 <- (a+b*log10(area))
  varN <- ((logN10-logN50)/t10n2)^2 
  logNexp <- logN50 + (varN)/2
  nEXP <- 10^(logNexp)
  logN50 <- log10(nEXP-NKnown)- varN/2
  p90<-10^(logN50 -t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/(dimdat[1]*std_loga)))
  p50<-10^(logN50)
  p10<-10^(logN50+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/(dimdat[1]*std_loga)))
  #message(p10)
  #message(p50)
  #message(p90)		
}
else {
  p90<-10^(a+b*log10(area)-t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/(dimdat[1]*std_loga)))
  p50<-10^(a+b*log10(area))
  p10<-10^(a+b*log10(area)+t10n2*sxy*sqrt(1+1/dimdat[1]+(m_loga-log10(area))^2/(dimdat[1]*std_loga)))
  #message(p10)
  #message(p50)
  #message(p90)
}
# ---------------------------------------------------------------
  plotlines(headerText,area,p10,p50,p90,folder,indataFile,indataHeader)
}

#plotcalculate<-function(a,b,t10n2,sxy,N,m_loga,std_loga,min_area,max_area, NKnown, folder)
#-0.585;0.385;;1.306;0.338;38;2.637;;0.526;;Mosier, D.L., Singer, D.A. & Berger, V.I. 2007. Volcanogenic Massive Sulfide Deposit Density. U.S. Geological Survey, Scientific Investigations Report 2007-5082. 15 p.
plotcalculate(-0.585,0.385,1.306,0.338,38,2.637,0.526,10,100000,0,'c:/temp/mapWizard/output/DepositDensity/','PorCu','C:/TFS2/Muut/MapWizardi/Tools/scripts/indataVMS.csv','VMS tracts')



