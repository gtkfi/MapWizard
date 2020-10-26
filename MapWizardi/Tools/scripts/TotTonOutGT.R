# Generates EF05 - EF08 outputs form the grade and total tonnage model.

TotTonOutGT<-function(simdat,filename5,filename6,filename7,filename8) {
  
  ###################################### Develops the Simulation result EF file, file EF_5 #################################
  dat = as.data.frame(simdat)
  print(dat[1:10,])
# In dat, the grades are in range [0,1], i.e., NOT in percentages
  LD <- length(names(dat))   # length of the columns in the data

## Saving variables for calcualtion of EF 05 file from the above data file 
  SimI <- dat[1]
  NumD <- dat[2]
  SimDI <- dat[3]
  Ore<- dat[4]
  Gran<-dat[LD]
  G1<- dat[5]
  Grades0<- G1
  Tons0<- Ore*dat[5]
  g <- 6
  TonsList<-c("Tons5")
  GradesList<-c("G5")

  for (nam in 6:LD) {
    print (nam)
    var<- paste("G",nam,sep="")
    print (var)
    assign(var,dat[g])
    ##calculate the ton for each mineral 
    varTon<- paste("Ton",nam,sep="")
    assign(varTon,(Ore*(get(var))))
    ##combine the grades and tons 
    TonsList<-c(TonsList,varTon)
    ### Saves the grades
    GradesList<-c(GradesList,var)
    Grades0 <- cbind(Grades0,get(var))
    names(Grades0)<-GradesList
    Tons0<- cbind(Tons0,get(varTon))
    names(Tons0)<-TonsList
    g <- g + 1
  }
  
  TbNames <- names(dat)
  TbLen <- length(TbNames)
  MinStop <- TbLen -1 
  minerals<- TbNames[5:MinStop]
  OreN<- TbNames[4]
  NamesMins<- sub('.grade', '', minerals)
  
  NamesBegin <- TbNames[1:3]
  Gangue <- TbNames[TbLen]
  Gan<- sub('.grade', '', Gangue)
  
  ##Creates a joint table 
  Cont <- cbind(SimI, NumD, SimDI, Ore,Grades0*100,Gran,Tons0)
  lenCont1 <- length(Cont)
  lenMins<- length(NamesMins)
  ContMath <- 5 + lenMins - 1
  ContEndM <- ContMath + 2
  ContBegin <- Cont[1:4]
  ContMins <- Cont[5: ContMath]
  ContMath1 <- ContMath + lenMins
  ContEnd <- Cont [ContEndM: lenCont1]
  NewCont <- cbind(ContBegin,ContMins,ContEnd)
  MinTons<- paste(NamesMins,'_MetricTons')
  OreN<- sub(".tonnage", "_MetricTons",OreN)
  NamesMins<- paste(NamesMins,"_pct")
  NameList12<- c(NamesBegin,OreN,NamesMins,Gan,MinTons ) 
  lenCont2 <- length(NewCont)
  con9 <- lenCont2 - 1 # gangue ton not included
  colnames(NewCont) <- NameList12 
  NewCont <- NewCont[1:con9 ]
  
  ## Saving the simulation results - 05 EF file to a csv file.
  write.csv(NewCont, file = filename5)
  
  
  ################################# Generating EF 06 file  ##################################
  ## Simulation EF Stats 
  Rsim<-NewCont
  namelist4 <- names(Rsim)
  v4NA <- na.omit(Rsim[4])
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  ## Create means for each variable 
  OMeans <- mean(v5)
  OMaxs <- max(v5)
  OMins <- min(v5)
  OMeds <- median(v5)
  OSds <- sd(v5)
  for (g in c(5:length(namelist4))) {
    v4NA <- na.omit(Rsim[g])
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OMean <- mean(v5)
    OMeans<- rbind(OMeans,OMean)
    OMax <- max(v5)
    OMaxs<- rbind(OMaxs,OMax)
    OMin <- min(v5)
    OMins<- rbind(OMins,OMin)
    OMed <- median(v5)
    OMeds<- rbind(OMeds,OMed)
    OSd <- sd(v5)
    OSds <- rbind(OSds,OSd)
  }
  ## Sim model quantiles 99,90,80,70,60,50,40,30,20,10,1
  qval<-c(.01,.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant<-list()
  for (iq in 1:length(qval)) {
    v4NA <- na.omit(Rsim[4])
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    quant[[iq]] <- quantile(v5, qval[iq])
    for (g in c(5:length(namelist4))){
      v4NA <- na.omit(Rsim[g])
      v5<- unlist(v4NA)
      v5<- as.numeric(v5)
      OM <- quantile(v5, qval[iq])
      quant[[iq]] <- rbind(quant[[iq]],OM)
    }
  }
  
  ##Create stats list
  qdf<-as.data.frame(quant)
  StatsList6 <- cbind(OMeans,OMaxs,OMins,OMeds,OSds,qdf)
  colnames(StatsList6) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1")
  namelist6 <- names(Rsim[,4:length(namelist4)])
  rownames(StatsList6) <- namelist6
  
  ##Downlaod Sim stats to csv file
  write.csv(StatsList6, file = filename6, row.names=TRUE)
  
  
  ################################## Generating EF 07 file ################################# 
  
  ## Aggregation pivot calculation, based on number of grades-   Contained Totals 
  ## make a pivot table 
  cols<- names(Cont)
  
  newtab<- Cont[1]  #creating a newtable so it can use consistent variable name
  xy<- 1
  LCont <- length(Cont)
  
  NewT <-Cont[1:4]
  ## If statements based on number of grades- columns
  
  NewT<-cbind(NewT,Cont[(LCont-(LCont-7)/2):LCont])
  colnames(NewT)<-c("SimIndex","NumDeposits","SimDepIndex","Ore",
                    paste("Tons",seq(1:((LCont-7)/2+1)),sep=""))
  Tb <- summarise(group_by(NewT,SimIndex),NumDep = mean(NumDeposits),
                  Ore = sum(Ore))
  for (it in seq(1,((LCont-7)/2+1))) {
#    ton_it<-get(paste("Tons",it,sep=""))
    ton_it<-paste("Tons",it,sep="")
    Tb<-cbind(Tb,summarise(group_by(NewT,SimIndex),sum(get(ton_it)))[,2])
  }

  nrc <- length(Tb) 
  nc <- nrc -1
  Tb <- Tb[1:nc]
  
## Setting table column names
  TbNames <- names(dat)
  TbLen <- length(TbNames)
  TbLen<- TbLen -1
  TbStart<- TbNames[1:2]
  TbEnd<-TbNames[4:TbLen]
  TbNames <- c(TbStart,TbEnd)
  
  countNNN <- length(TbNames)
  NamesTT<- TbNames[3]
  Names1 <- TbNames[1:2]
  Names3 <- TbNames[4:countNNN]
  Names3<- sub('.grade', '_mT', Names3)
  NamesTT<- sub('.tonnage', '_mT', NamesTT)
  
  NamesNew <- c(Names1,NamesTT,Names3)
  colnames(Tb) <- NamesNew 
  
  #### Writes aggregated sim contained totals csv file
  write.csv(Tb, file = filename7)
  
################################## Generating EF 08 file ################################# 

  Rsim<- Tb
  n8 <<- ncol(Rsim)
  namelist4 <- names(Rsim)
  Rsim[is.na(Rsim)] <- 0
  
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  ## Create means for each variable 
  OMeans <- mean(v5)
  for (g in c(4:n8)) {
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- mean(v5)
    OMeans<- rbind(OMeans,OM)
  }
  ## contained model max 
  yy <- 1
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  OMaxs <- max(v5)
  for (g in c(4:n8)){
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- max(v5)
    OMaxs<- rbind(OMaxs,OM)
  }
  ## contained model min 
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  OMins <- min(v5)
  for (g in c(4:n8)){
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- min(v5)
    OMins<- rbind(OMins,OM)
  }
  ## contained model med 
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  OMeds <- median(v5)
  for (g in c(4:n8)){
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- median(v5)
    OMeds<- rbind(OMeds,OM)
  }
  ## contained model STD Rsim<- read.csv(filename6)
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  OSds <- sd(v5)
  for (g in c(4:n8)){
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- sd(v5)
    OSds <- rbind(OSds,OM)
  }
  ## Sim model quantiles 99,90,80,70,60,50,40,30,20,10,1
  qval<-c(.01,.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant<-list()
  for (iq in 1:length(qval)) {
    v4NA <- Rsim[3]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    quant[[iq]] <- quantile(v5, qval[iq])
    for (g in c(4:n8)){
      v4NA <- Rsim[g]
      v5<- unlist(v4NA)
      v5<- as.numeric(v5)
      OM <- quantile(v5, qval[iq])
      quant[[iq]] <- rbind(quant[[iq]],OM)
    }
  }
  ## Calculating percent zero
  #zero prob and mean
  zero <-  length(which(Rsim[3]==0))
  total <- length(which(Rsim[3]> -1))
  print(zero)
  print(total)
  PZero <- (zero/total)
  ## create > mean  for each variable 
  v4NA <- Rsim[3]
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  GOL <- length(which(v5 > mean(v5))) 
  GEMS <- (GOL/total)
  for (g in c(4:n8)) {
    v4NA <- Rsim[g]
    v5<- unlist(v4NA)
    v5<- as.numeric(v5)
    OM <- length(which(v5 >= mean(v5))) 
    OM2 <- (OM/total)
    GEMS <- rbind(GEMS,OM2)
  }
  
  ##Create stats list
  qdf<-as.data.frame(quant)
  StatsList <- cbind(OMeans,OMaxs,OMins,OMeds,OSds,qdf, PZero,GEMS)
  colnames(StatsList) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1","Prob of Zero", "Prob >= Mean" )
  
  ### Setting row names for stats table
  TbNames <- names(dat)
  TbLen <- length(TbNames)
  TbNames<-TbNames[4:(TbLen-1)]
  Names8<-paste(TbNames[1:(TbLen-4)],'_MetricTons',sep="")
  rownames(StatsList) <- Names8
  
  #######################################
  ##Downloading stats table to csv file
  ######################################
  write.csv(StatsList, file = filename8, row.names=TRUE)

}








