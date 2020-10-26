# Generates EF05 - EF08 outputs form the total tonnage model.

TotTonOutCMT<-function(simdat,filename5,filename6,filename7,filename8) {

  ################### Develops the Simulation result EF file, file EF_5 #####################
  dat = as.data.frame(simdat)
  LD <- length(names(dat))   # length of the columns in the data
  
  # Saving variables for calcualtion of EF 05 file from the above data file
  SimI <- dat[1]
  NumD <- dat[2]
  SimDI <- dat[3]
  CTons <- dat[4]
  
  #Creates a joint table
  Cont <- cbind(SimI, NumD, SimDI,CTons)
  lenCont1 <- length(Cont)
  
  NamesOrig <- names(dat)
  NamesOrig <- sub("tonnage","MetricTons", NamesOrig )
  NameList12<- NamesOrig
  colnames(Cont ) <- NameList12

  # Saving the simulation results - 05 EF file to a csv file.
  write.csv(Cont, file = filename5)

  
  ################################## Develops the simulation EF Statistics file EF_6 ###################################33
  Rsim<- Cont
  v4NA <- na.omit(Rsim[4])
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  
  ## Create means for each variable
  OMeans <- mean(v5)
  ## sim model max
  OMaxs <- max(v5)
  ## sim model min
  OMins <- min(v5)
  ## sim model median
  OMeds <- median(v5)
  ## sim model standard deviations
  OSds <- sd(v5)
  ## sim model Q99s
  Q99s <- quantile(v5, c(.99))
  ## sim model Q90s
  Q90s <- quantile(v5, c(.90))
  ## sim model Q80s
  Q80s <- quantile(v5, c(.80))
  ## sim model Q70s
  Q70s <- quantile(v5, c(.70))
  ## sim model Q60s
  Q60s <- quantile(v5, c(.60))
  ## sim model Q50s
  Q50s <- quantile(v5, c(.50))
  ## sim model Q40s
  Q40s <- quantile(v5, c(.40))
  ## sim model Q30s
  Q30s <- quantile(v5, c(.30))
  ## sim model Q20s
  Q20s <- quantile(v5, c(.20))
  ## sim  model Q10s
  Q10s <- quantile(v5, c(.10))
  ## Sim model Q01s
  Q01s <- quantile(v5, c(.01))
  
  ##Create stats list
  StatsList <- cbind(OMeans,OMaxs,OMins,OMeds,OSds,Q01s, Q10s, Q20s, Q30s, Q40s, Q50s, Q60s, Q70s, Q80s, Q90s, Q99s)
  colnames(StatsList) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1")
  namelist5 <- names(Rsim)
  rownames(StatsList) <- namelist5[4]
  ##Downlaod Sim stats to csv file
  write.csv(StatsList, file = filename6, row.names=TRUE)
  
  
  ####################### Develops the simulation EF file EF_7 ###########################
  cols<- names(Cont)
  
  newtab<- Cont[1]  #creating a newtable so it can use consistent variable name
  xy<- 1
  LCont <- length(Cont)
  
  NewT <-Cont[1:3]
  NameT1 <- names(Cont[4])
  NewT <- cbind(NewT,Cont[4])
  colnames(NewT)<-c("SimIndex","NumDeposits","SimDepIndex","Tons1")
  Tb <- summarise(group_by(NewT,SimIndex),NumDep = mean(NumDeposits), Tons1 = sum(Tons1))
  
  ## Setting table column names
  TbNames <- names(dat)
  countNNN <- length(TbNames)
  NamesTT<- sub('.tonnage', '_mT', TbNames )
  NamesNew <- c(NamesTT[1:2],NamesTT[4])
  colnames(Tb) <- NamesNew

  ## Writes aggregated sim contained totals csv file
  write.csv(Tb, file = filename7)

  ###################### Develops the simulation EF file EF_8 #########################
  Rsim<- Tb
  n8 <<- ncol(Rsim)
  namelist4 <- names(Rsim)
  Rsim[is.na(Rsim)] <- 0
  
  v4NA <- na.omit(Rsim[3])
  v5<- unlist(v4NA)
  v5<- as.numeric(v5)
  
  ## Create means for each variable
  OMeans <- mean(v5)
  ## contained model max
  OMaxs <- max(v5)
  ## contained model min
  OMins <- min(v5)
  ## contained model med
  OMeds <- median(v5)
  ## contained model STD
  OSds <- sd(v5)
  ## contained model Q99s
  Q99s <- quantile(v5, c(.99))
  ## Contained model Q90s
  Q90s <- quantile(v5, c(.90))
  ## Contained model Q80s
  Q80s <- quantile(v5, c(.80))
  ## Contained model Q70s
  Q70s <- quantile(v5, c(.70))
  ## Contained model Q60s
  Q60s <- quantile(v5, c(.60))
  ## contained model Q50s
  Q50s <- quantile(v5, c(.50))
  ## Contained  model Q40s
  Q40s <- quantile(v5, c(.40))
  ## Contained model Q30s
  Q30s <- quantile(v5, c(.30))
  ## Contained model Q20s
  Q20s <- quantile(v5, c(.20))
  ## Contained model Q10s
  Q10s <- quantile(v5, c(.10))
  ## Contained model Q01s
  Q01s <- quantile(v5, c(.01))
  ## Calculating percent zero
  zero <-  length(which(Rsim[3]==0))
  total <- length(which(Rsim[3]> -1))
  PZero <- (zero/total)
  ## Calculating greater than or equal to mean
  GOL <- length(which(v5 > mean(v5)))
  GEMS <- (GOL/total)
  
  ##Create stats list
  StatsList <- cbind(OMeans,OMaxs,OMins,OMeds,OSds,Q01s, Q10s, Q20s, Q30s, Q40s, Q50s, Q60s, Q70s, Q80s, Q90s, Q99s, PZero,GEMS)
  colnames(StatsList) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1","Prob of Zero", "Prob >= Mean" )
  ### Setting row names for stats table
  rownames(StatsList) <- 'Resource_MetricTons'
  
  ##Downloading stats table to csv file
  write.csv(StatsList, file = filename8, row.names=TRUE)
}



