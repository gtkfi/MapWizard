


### contained total stats 
###########################################################################Mean
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans<- rbind(OMeans,OM)
OMeans<- round(OMeans)
yy<- yy + 1
}

###############################################################################  MAX
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMaxs <- max(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- max(VN)
OMaxs<- rbind(OMaxs,OM)
OMaxs<- round(OMaxs)
yy<- yy + 1
}



############################################################################### Min
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMins <- min(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- min(VN)
OMins<- rbind(OMins,OM)
OMins<- round(OMins)
yy<- yy + 1
}




############################################################################### Med

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeds <- median(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- median(VN)
OMeds<- rbind(OMeds,OM)
OMeds<- round(OMeds)
yy<- yy + 1
}






############################################################################### STD

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OSTDs<- sd(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- sd(VN)
OSTDs<- rbind(OSTDs,OM)
OSTDs<- round(OSTDs)
yy<- yy + 1
}

###############################################################################Q99s <- quantile(v5, c(.99))

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q99s <- quantile(V1, c(.99))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.99))
Q99s <- rbind(Q99s ,OM)
Q99s <- round(Q99s)
yy<- yy + 1
}
###############################################################################Q90s <- quantile(v5, c(.90))


Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q90s <- quantile(V1, c(.90))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.90))
Q90s <- rbind(Q90s ,OM)
Q90s <- round(Q90s)
yy<- yy + 1
}








###############################################################################Q80s <- quantile(v5, c(.80))
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q80s <- quantile(V1, c(.80))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.80))
Q80s <- rbind(Q80s ,OM)
Q80s <- round(Q80s)
yy<- yy + 1
}




############################################################################### Q70s <- quantile(v5, c(.70))
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q70s <- quantile(V1, c(.70))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.70))
Q70s <- rbind(Q70s ,OM)
Q70s <- round(Q70s)
yy<- yy + 1
}


###############################################################################Q60s <- quantile(v5, c(.60))

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q60s <- quantile(V1, c(.60))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.60))
Q60s <- rbind(Q60s ,OM)
Q60s <- round(Q60s)
yy<- yy + 1
}




###############################################################################Q50s <- quantile(v5, c(.50))


Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q50s <- quantile(V1, c(.50))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.50))
Q50s <- rbind(Q50s ,OM)
Q50s <- round(Q50s)
yy<- yy + 1
}


###############################################################################Q40s <- quantile(v5, c(.40))
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q40s <- quantile(V1, c(.40))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.40))
Q40s <- rbind(Q40s ,OM)
Q40s <- round(Q40s)
yy<- yy + 1
}


###############################################################################Q30s <- quantile(v5, c(.30))
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q30s <- quantile(V1, c(.30))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.30))
Q30s <- rbind(Q30s ,OM)
Q30s <- round(Q30s)
yy<- yy + 1
}


###############################################################################Q20s <- quantile(v5, c(.20))


Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q20s <- quantile(V1, c(.20))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.20))
Q20s <- rbind(Q20s ,OM)
Q20s <- round(Q20s)
yy<- yy + 1
}


###############################################################################Q10s <- quantile(v5, c(.10))

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q10s <- quantile(V1, c(.10))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.10))
Q10s <- rbind(Q10s ,OM)
Q10s <- round(Q10s)
yy<- yy + 1
}
###############################################################################Q01s <- quantile(v5, c(.01))


Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
Q01s <- quantile(V1, c(.01))


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- quantile(VN, c(.01))
Q01s <- rbind(Q01s ,OM)
Q01s <- round(Q01s)
yy<- yy + 1
}


############################################################################### Zero prob and mean 


Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)


zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero <- (zero/total)
print (zero)
print (total)
print (PZero)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
zero <-  length(which(VN==0))
print (zero)
total <- length(which(VN> -1))
print (total)
OM2 <- (zero/total)
print (OM2)
PZero <- rbind(PZero,OM2)
yy<- yy + 1
}

if (GradeNum == 6)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:8]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[9:14]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}
if (GradeNum == 5)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:7]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[8:12]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}

if (GradeNum == 4)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:6]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[7:10]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}
if (GradeNum == 3)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:5]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[6:8]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}
if (GradeNum == 2)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:4]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[5:6]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}
if (GradeNum == 1)
{
Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR <<- Rsim[3:3]
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero1 <- (zero/total)

Rsim<<- read.csv(filename6)
LR <<- length(Rsim)
DataR3 <<- Rsim[4:4]
V1 <<- DataR3[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
zero <-  length(which(V1==0))
total <- length(which(V1> -1))
PZero2 <- (zero/total)
}


## greater than or equal to mean



Rsim<<- read.csv(filename6)
LR <<- length(Rsim)

DataR <<- Rsim[3:LR]
DataR2 <<- Rsim[4:LR]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0

V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
GOLs <-length(which(V1 > mean(V1)))
GEMS <- (GOLs/total)

#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- length(which(VN >= mean(VN))) 
OM2 <- (OM/total)
GEMS <- rbind(GEMS,OM2)
yy<- yy + 1
}

#############################################################################
##Create stats list
StatsList <- cbind(OMeans,OMaxs,OMins,OMeds,OSTDs,Q01s, Q10s, Q20s, Q30s, Q40s, Q50s, Q60s, Q70s, Q80s, Q90s, Q99s, PZero, GEMS)
colnames(StatsList) <- c("Means", "Max", "Min", "Median", "STD", "P99", "P90", "P80", "P70", "P60", "P50", "P40", "P30", "P20", "P10", "P1","Prob of Zero", "Prob >= Mean" )
rownames(StatsList) <- NamesR

# if (GradeNum==6)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V70))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V52))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }
# if (GradeNum==5)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V69))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V51))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }
# if (GradeNum==4)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V68))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V50))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }


# if (GradeNum==3)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V67))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V49))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }


# if (GradeNum==2)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V66))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V48))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }

# if (GradeNum==1)
	# {
	# if (MineNum001==2)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V63))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# if (MineNum001==1)
		# {
		# Pivot5 <-  summarise(group_by(ITab,V2),NPVA = sum(V45))
		# colnames(Pivot5) <- c("SimIndex","NPV_Area")
		# }
	# }
# LR <<- length(Pivot5)

# DataR2 <<- Pivot5[2:LR]
# NamesR2 <<- names(DataR2)
# DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
#V1 <<- DataR2
#V1[is.na(V1)] <- 0
#V1<- unlist(V1)
#V1<- as.numeric(V1)
NR <<- nrow(StatsList)
StatsNPV <<- StatsList[NR]
Pivot5Mean <- StatsNPV/TA1
Pivot5Max<- ""
Pivot5Min<-""
Pivot5Med<- ""
Pivot5Sd<-""

P99<<- ""
P90<<- ""
P80<<- ""
P70<<- ""
P60<<- ""
P50<<- ""
P40<<- ""
P30<<- ""
P20<<- ""
P10<<- ""
P1<<- ""
PZero <<- ""
GEMS <<- ""

StatsListPivot5 <- cbind(Pivot5Mean ,Pivot5Max,Pivot5Min,Pivot5Med,Pivot5Sd, P99, P90, P80, P70, P60, P50, P40, P30, P20, P10, P1, PZero, GEMS)
rownames(StatsListPivot5 ) <- c("NPV_Area")

StatsP5 <<- paste(TN1,"_NPV_Area_Stats",".csv", sep = "")
StatsList <<- rbind(StatsList, StatsListPivot5 )


Stats1 <<- paste("EF_04_Contained_Stats_",TN1,".csv", sep = "")
write.csv(StatsList, file = Stats1, row.names=TRUE)




