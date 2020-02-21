##################################################################################################  Analyze and aggregate depth info  below 






if (GradeNum == 5)
{

if (MineNum001 == 2) 
{


IData2 <<- ITab[2]
IData3 <<- ITab[15]
IData4 <<- ITab[76]
IData5 <<- ITab[77]
IData6 <<- ITab[78]
IData7 <<- ITab[79]
IData8 <<- ITab[80]
IData9 <<- ITab[81]
IData10 <<- ITab[82]
IData11 <<- ITab[83]
IData12 <<- ITab[84]
IData13 <<- ITab[85]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9, IData10, IData11, IData12, IData13 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if minenum == 2 

if (MineNum001 == 1) 
{
### Contained Copper 
IData2 <<- ITab[2]
IData3 <<- ITab[12]
IData4 <<- ITab[58]
IData5 <<- ITab[59]
IData6 <<- ITab[60]
IData7 <<- ITab[61]
IData8 <<- ITab[62]
IData9 <<- ITab[63]
IData10 <<- ITab[64]
IData11 <<- ITab[65]
IData12 <<- ITab[66]
IData13 <<- ITab[67]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9, IData10, IData11 , IData12, IData13 )
data1 = melt(ID0 , id.vars = c("V2","V12"))
good <<- cast(data1, V2 + V12 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V12 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0
} ## ends if mine num001 =1 


if (max(ID3) == 4) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),paste(GN1,"_Con_Depth Cat 4",sep=""), paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),paste(GN2,"_Con_Depth Cat 4",sep=""), paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),paste(GN3,"_Con_Depth Cat 4",sep=""), paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),paste(GN4,"_Con_Depth Cat 4",sep=""), paste(GN5,"_Con_Depth Cat 1",sep=""), paste(GN5,"_Con_Depth Cat 2",sep=""),paste(GN5,"_Con_Depth Cat 3",sep=""),paste(GN5,"_Con_Depth Cat 4",sep=""),paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),paste(GN1,"_Rec_Depth Cat 4",sep=""), paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),paste(GN2,"_Rec_Depth Cat 4",sep=""), paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),paste(GN3,"_Rec_Depth Cat 4",sep=""), paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),paste(GN4,"_Rec_Depth Cat 3",sep=""),paste(GN4,"_Rec_Depth Cat 4",sep=""), paste(GN5,"_Rec_Depth Cat 1",sep=""),paste(GN5,"_Rec_Depth Cat 2",sep=""), paste(GN5,"_Rec_Depth Cat 3",sep=""), paste(GN5,"_Rec_Depth Cat 4",sep=""))}
if (max(ID3) == 3) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),paste(GN4,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN5,"_Rec_Depth Cat 1",sep=""), paste(GN5,"_Rec_Depth Cat 2",sep=""),paste(GN5,"_Rec_Depth Cat 3",sep=""),"NA")}
if (max(ID3) == 2) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN5,"_Rec_Depth Cat 1",sep=""), paste(GN5,"_Rec_Depth Cat 2",sep=""),"NA")}
if (max(ID3) == 1) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), "NA", paste(GN3,"_Con_Depth Cat 1",sep=""), "NA", paste(GN4,"_Con_Depth Cat 1",sep=""), "NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), "NA", paste(GN2,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN5,"_Rec_Depth Cat 1",sep=""),"NA")}
#colnames(good2) <- NamesDC 
filename7 <<- paste(TN1,"_DepthCat_Aggregated_Totals",".csv", sep = "")
write.csv(good2 , file = filename7)
Rsim0<<- read.csv(filename7, header=FALSE,skip=1)
colnames(Rsim0) <- NamesDC 
write.csv(Rsim0, file = filename7)

} ## ends if grade = 5

###############################################

if (GradeNum == 4)
{

if (MineNum001 == 2) 
{

IData2 <<- ITab[2]
IData3 <<- ITab[15]
IData4 <<- ITab[74]
IData5 <<- ITab[75]
IData6 <<- ITab[76]
IData7 <<- ITab[77]
IData8 <<- ITab[78]
IData9 <<- ITab[79]
IData10 <<- ITab[80]
IData11 <<- ITab[81]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9, IData10, IData11 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if mine num 2

if (MineNum001 == 1) 
{
IData2 <<- ITab[2]
IData3 <<- ITab[12]
IData4 <<- ITab[56]
IData5 <<- ITab[57]
IData6 <<- ITab[58]
IData7 <<- ITab[59]
IData8 <<- ITab[60]
IData9 <<- ITab[61]
IData10 <<- ITab[62]
IData11 <<- ITab[63]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9, IData10, IData11 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0
}  ## ends if mine num 1

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)
GN4 <<-  ListGradeNames[4]
GN4 <- sub("._pct","", GN4)

if (max(ID3) == 4) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),paste(GN1,"_Con_Depth Cat 4",sep=""), paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),paste(GN2,"_Con_Depth Cat 4",sep=""), paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),paste(GN3,"_Con_Depth Cat 4",sep=""), paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),paste(GN4,"_Con_Depth Cat 4",sep=""),paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),paste(GN1,"_Rec_Depth Cat 4",sep=""), paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),paste(GN2,"_Rec_Depth Cat 4",sep=""), paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),paste(GN3,"_Rec_Depth Cat 4",sep=""), paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),paste(GN4,"_Rec_Depth Cat 3",sep=""),paste(GN4,"_Rec_Depth Cat 4",sep=""))}
if (max(ID3) == 3) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),paste(GN4,"_Rec_Depth Cat 3",sep=""),"NA")}
if (max(ID3) == 2) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""), paste(GN4,"_Rec_Depth Cat 2",sep=""),"NA")}
if (max(ID3) == 1) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), "NA", paste(GN3,"_Con_Depth Cat 1",sep=""), "NA", paste(GN4,"_Con_Depth Cat 1",sep=""), "NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), "NA", paste(GN2,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN4,"_Rec_Depth Cat 1",sep=""),"NA")}
#colnames(good2) <- NamesDC 
filename7 <<- paste(TN1,"_DepthCat_Aggregated_Totals",".csv", sep = "")
write.csv(good2 , file = filename7)
Rsim0<<- read.csv(filename7, header=FALSE,skip=1)
colnames(Rsim0) <- NamesDC 
write.csv(Rsim0, file = filename7)
} ## ends if grade = 4


#########################


if (GradeNum == 3)
{



if (MineNum001 == 2) 
{

IData2 <<- ITab[2]
IData3 <<- ITab[15]
IData4 <<- ITab[72]
IData5 <<- ITab[73]
IData6 <<- ITab[74]
IData7 <<- ITab[75]
IData8 <<- ITab[76]
IData9 <<- ITab[77]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0
} ## ends if mine num 2 

if (MineNum001 == 1) 
{
IData2 <<- ITab[2]
IData3 <<- ITab[12]
IData4 <<- ITab[54]
IData5 <<- ITab[55]
IData6 <<- ITab[56]
IData7 <<- ITab[57]
IData8 <<- ITab[58]
IData9 <<- ITab[59]
ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 , IData8, IData9 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0
} ## ends if mine num 1


GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)

if (max(ID3) == 4) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),paste(GN1,"_Con_Depth Cat 4",sep=""), paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),paste(GN2,"_Con_Depth Cat 4",sep=""), paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),paste(GN3,"_Con_Depth Cat 4",sep=""),paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),paste(GN1,"_Rec_Depth Cat 4",sep=""), paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),paste(GN2,"_Rec_Depth Cat 4",sep=""), paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),paste(GN3,"_Rec_Depth Cat 4",sep=""))}
if (max(ID3) == 3) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),paste(GN3,"_Rec_Depth Cat 3",sep=""),"NA")}
if (max(ID3) == 2) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""), paste(GN3,"_Rec_Depth Cat 2",sep=""),"NA")}
if (max(ID3) == 1) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), "NA", paste(GN3,"_Con_Depth Cat 1",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), "NA", paste(GN2,"_Rec_Depth Cat 1",sep=""),"NA", paste(GN3,"_Rec_Depth Cat 1",sep=""),"NA"}
#colnames(good2) <- NamesDC 
filename7 <<- paste(TN1,"_DepthCat_Aggregated_Totals",".csv", sep = "")
write.csv(good2 , file = filename7)
Rsim0<<- read.csv(filename7, header=FALSE,skip=1)
colnames(Rsim0) <- NamesDC 
write.csv(Rsim0, file = filename7)
} ## ends if grade = 3


###########################################



if (GradeNum == 2)
{

if (MineNum001 == 2) 
{


IData2 <<- ITab[2]
IData3 <<- ITab[15]
IData4 <<- ITab[70]
IData5 <<- ITab[71]
IData6 <<- ITab[72]
IData7 <<- ITab[73]

ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if mine num 2 

if (MineNum001 == 1) 
{


IData2 <<- ITab[2]
IData3 <<- ITab[12]
IData4 <<- ITab[52]
IData5 <<- ITab[53]
IData6 <<- ITab[54]
IData7 <<- ITab[55]

ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 , IData6, IData7 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if mine num 1


GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)


if (max(ID3) == 4) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),paste(GN1,"_Con_Depth Cat 4",sep=""), paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),paste(GN2,"_Con_Depth Cat 4",sep=""),paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),paste(GN1,"_Rec_Depth Cat 4",sep=""), paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),paste(GN2,"_Rec_Depth Cat 4",sep=""))}
if (max(ID3) == 3) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),paste(GN2,"_Rec_Depth Cat 3",sep=""),"NA")}
if (max(ID3) == 2) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),"NA", paste(GN2,"_Rec_Depth Cat 1",sep=""), paste(GN2,"_Rec_Depth Cat 2",sep=""),"NA")}
if (max(ID3) == 1) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), "NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), "NA", paste(GN2,"_Rec_Depth Cat 1",sep=""),"NA")}
#colnames(good2) <- NamesDC 
filename7 <<- paste(TN1,"_DepthCat_Aggregated_Totals",".csv", sep = "")
write.csv(good2 , file = filename7)
Rsim0<<- read.csv(filename7, header=FALSE,skip=1)
colnames(Rsim0) <- NamesDC 
write.csv(Rsim0, file = filename7)

} ## ends if grade = 2




#############################################################

if (GradeNum == 1)
{


if (MineNum001 == 2) 
{

IData2 <<- ITab[2]
IData3 <<- ITab[15]
IData4 <<- ITab[66]
IData5 <<- ITab[67]

ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if mine num 2 

if (MineNum001 == 1) 
{

IData2 <<- ITab[2]
IData3 <<- ITab[12]
IData4 <<- ITab[48]
IData5 <<- ITab[49]

ID0 <<- cbind(IData2 ,IData3 , IData4, IData5 )
data1 = melt(ID0 , id.vars = c("V2","V15"))
good <<- cast(data1, V2 + V15 ~ variable, sum)
good2 <<- cast(data1, V2 ~ V15 ~ variable, sum)
ID3 <<- IData3
ID3[is.na(ID3)] <- 0

} ## ends if mine num 1 

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)


if (max(ID3) == 4) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),paste(GN1,"_Con_Depth Cat 4",sep=""), paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),paste(GN2,"_Con_Depth Cat 4",sep=""), paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),paste(GN3,"_Con_Depth Cat 4",sep=""), paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),paste(GN4,"_Con_Depth Cat 4",sep=""),paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),paste(GN1,"_Rec_Depth Cat 4",sep=""))}
if (max(ID3) == 3) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),paste(GN1,"_Con_Depth Cat 3",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),paste(GN2,"_Con_Depth Cat 3",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),paste(GN3,"_Con_Depth Cat 3",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),paste(GN4,"_Con_Depth Cat 3",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),paste(GN1,"_Rec_Depth Cat 3",sep=""),"NA")}
if (max(ID3) == 2) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""), paste(GN1,"_Con_Depth Cat 2",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), paste(GN2,"_Con_Depth Cat 2",sep=""),"NA", paste(GN3,"_Con_Depth Cat 1",sep=""), paste(GN3,"_Con_Depth Cat 2",sep=""),"NA", paste(GN4,"_Con_Depth Cat 1",sep=""), paste(GN4,"_Con_Depth Cat 2",sep=""),"NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), paste(GN1,"_Rec_Depth Cat 2",sep=""),"NA")}
if (max(ID3) == 1) { NamesDC <<- c("SimIndex",paste(GN1,"_Con_Depth Cat 1",sep=""),"NA", paste(GN2,"_Con_Depth Cat 1",sep=""), "NA", paste(GN3,"_Con_Depth Cat 1",sep=""), "NA", paste(GN4,"_Con_Depth Cat 1",sep=""), "NA",paste(GN1,"_Rec_Depth Cat 1",sep=""), "NA")}
#colnames(good2) <- NamesDC 
filename7 <<- paste(TN1,"_DepthCat_Aggregated_Totals",".csv", sep = "")
write.csv(good2 , file = filename7)
Rsim0<<- read.csv(filename7, header=FALSE,skip=1)
colnames(Rsim0) <- NamesDC 
write.csv(Rsim0, file = filename7)

} ## ends if grade = 1





######################################################### Stats Starts below 
########################################################################################################################################################################################################################


if (GradeNum == 4)
{


if (max(ID3) == 4) ### if 4 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:6]
DataR2 <<- Rsim[4:6]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[8:11]
DataR2 <<- Rsim[9:11]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[13:16]
DataR2 <<- Rsim[14:16]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[18:21]
DataR2 <<- Rsim[19:21]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[23:26]
DataR2 <<- Rsim[24:26]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[28:31]
DataR2 <<- Rsim[29:31]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}


###########################################################################Mean7
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[33:36]
DataR2 <<- Rsim[34:36]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans7 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans7<- rbind(OMeans7,OM)
OMeans7<- round(OMeans7)
yy<- yy + 1
}

###########################################################################Mean8
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[38:41]
DataR2 <<- Rsim[39:41]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans8 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans8<- rbind(OMeans8,OM)
OMeans8<- round(OMeans8)
yy<- yy + 1
}


} ## ends if 4 intervals 

########################################################################################################################################################################################################################


if (max(ID3) == 3)
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:5]
DataR2 <<- Rsim[4:5]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7:9]
DataR2 <<- Rsim[8:9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[11:13]
DataR2 <<- Rsim[12:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[15:17]
DataR2 <<- Rsim[16:17]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[19:21]
DataR2 <<- Rsim[20:21]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[23:25]
DataR2 <<- Rsim[24:25]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}


###########################################################################Mean7
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[27:29]
DataR2 <<- Rsim[28:29]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans7 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans7<- rbind(OMeans7,OM)
OMeans7<- round(OMeans7)
yy<- yy + 1
}

###########################################################################Mean8
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[31:33]
DataR2 <<- Rsim[32:33]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans8 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans8<- rbind(OMeans8,OM)
OMeans8<- round(OMeans8)
yy<- yy + 1
}


} ## ends if 3 intervals 


if (max(ID3) == 2)  ## starts if 2 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:4]
DataR2 <<- Rsim[4:4]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[6:7]
DataR2 <<- Rsim[7:7]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[9:10]
DataR2 <<- Rsim[10:10]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[12:13]
DataR2 <<- Rsim[13:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[15:16]
DataR2 <<- Rsim[16:16]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[18:19]
DataR2 <<- Rsim[19:19]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}


###########################################################################Mean7
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[21:22]
DataR2 <<- Rsim[22:22]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans7 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans7<- rbind(OMeans7,OM)
OMeans7<- round(OMeans7)
yy<- yy + 1
}




###########################################################################Mean8
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[24:25]
DataR2 <<- Rsim[25:25]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans8 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans8<- rbind(OMeans8,OM)
OMeans8<- round(OMeans8)
yy<- yy + 1
}


} ## ends if 2 intervals 




if (max(ID3) == 1)  ## starts if 1 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3]
NamesR <<- names(DataR)


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans <- mean(V1)

###########################################################################Mean2
Rsim<<- read.csv(filename7)

##Con2
DataR <<- Rsim[5]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)
###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)

###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[11]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[13]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


###########################################################################Mean7
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[15]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans7 <- mean(V1)


###########################################################################Mean8
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[17]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans8 <- mean(V1)

} ## ends if 1 intervals 

#############################################################################
##Create stats list

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)
GN4 <<-  ListGradeNames[4]
GN4 <- sub("._pct","", GN4)


if (max(ID3) == 4) 
{ 
Name4<<- paste("Depth_Cat_4_" , Min4, "-", Max4,"_",Per4,sep="")
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 
if (max(ID3) == 3) 
{ 
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 

if (max(ID3) == 2) 
{ 
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 1) 
{ 
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 4) { NamesD <<- c(Name1,Name2,Name3, Name4)}
if (max(ID3) == 3) { NamesD <<- c(Name1,Name2,Name3)}
if (max(ID3) == 2) { NamesD <<- c(Name1,Name2)}
if (max(ID3) == 1) { NamesD <<- c(Name1)}

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans7,OMeans4,OMeans8)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means"),  paste(GN3,"_Con","_","Means"),  paste(GN3,"_Rec","_","Means"), paste(GN4,"_Con","_","Means"),  paste(GN4,"_Rec","_","Means")  )
rownames(StatsList2) <- NamesD

Stats1 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
write.csv(StatsList2, file = Stats1, row.names=TRUE)


} ## ends if grade = 4





#########################################################################################################################################################################################################################
######################################################### grade 3 
########################################################################################################################################################################################################################


if (GradeNum == 3)
{


if (max(ID3) == 4) ### if 4 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:6]
DataR2 <<- Rsim[4:6]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[8:11]
DataR2 <<- Rsim[9:11]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con3
DataR <<- Rsim[13:16]
DataR2 <<- Rsim[14:16]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[18:21]
DataR2 <<- Rsim[19:21]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Rec2
DataR <<- Rsim[23:26]
DataR2 <<- Rsim[24:26]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Rec3
DataR <<- Rsim[28:31]
DataR2 <<- Rsim[29:31]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}

} ## ends if 4 intervals 

########################################################################################################################################################################################################################


if (max(ID3) == 3)
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:5]
DataR2 <<- Rsim[4:5]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7:9]
DataR2 <<- Rsim[8:9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con3
DataR <<- Rsim[11:13]
DataR2 <<- Rsim[12:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[15:17]
DataR2 <<- Rsim[16:17]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Rec2
DataR <<- Rsim[19:21]
DataR2 <<- Rsim[20:21]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Rec3
DataR <<- Rsim[23:25]
DataR2 <<- Rsim[24:25]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}

} ## ends if 3 intervals 


if (max(ID3) == 2)  ## starts if 2 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:4]
DataR2 <<- Rsim[4:4]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[6:7]
DataR2 <<- Rsim[7:7]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con3
DataR <<- Rsim[9:10]
DataR2 <<- Rsim[10:10]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[12:13]
DataR2 <<- Rsim[13:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Rec2
DataR <<- Rsim[15:16]
DataR2 <<- Rsim[16:16]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Rec3
DataR <<- Rsim[18:19]
DataR2 <<- Rsim[19:19]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}


} ## ends if 2 intervals 



if (max(ID3) == 1)  ## starts if 1 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3]
NamesR <<- names(DataR)


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans <- mean(V1)

###########################################################################Mean2
Rsim<<- read.csv(filename7)

##Con2
DataR <<- Rsim[5]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)
###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)

###########################################################################Mean5
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[11]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans5 <- mean(V1)

###########################################################################Mean6
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[13]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans6 <- mean(V1)

} ## ends if 1 intervals 

#############################################################################
##Create stats list

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)



if (max(ID3) == 4) 
{ 
Name4<<- paste("Depth_Cat_4_" , Min4, "-", Max4,"_",Per4,sep="")
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 
if (max(ID3) == 3) 
{ 
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 

if (max(ID3) == 2) 
{ 
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 1) 
{ 
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 4) { NamesD <<- c(Name1,Name2,Name3, Name4)}
if (max(ID3) == 3) { NamesD <<- c(Name1,Name2,Name3)}
if (max(ID3) == 2) { NamesD <<- c(Name1,Name2)}
if (max(ID3) == 1) { NamesD <<- c(Name1)}

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans7,OMeans4,OMeans8)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means"),  paste(GN3,"_Con","_","Means"),  paste(GN3,"_Rec","_","Means") )
rownames(StatsList2) <- NamesD

Stats1 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
write.csv(StatsList2, file = Stats1, row.names=TRUE)


} ## ends if grade = 3



#########################################################################################################################################################################################################################
######################################################### grade 2
########################################################################################################################################################################################################################


if (GradeNum == 2)
{


if (max(ID3) == 4) ### if 4 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:6]
DataR2 <<- Rsim[4:6]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[8:11]
DataR2 <<- Rsim[9:11]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[13:16]
DataR2 <<- Rsim[14:16]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec2
DataR <<- Rsim[18:21]
DataR2 <<- Rsim[19:21]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}


} ## ends if 4 intervals 

########################################################################################################################################################################################################################


if (max(ID3) == 3)
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:5]
DataR2 <<- Rsim[4:5]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7:9]
DataR2 <<- Rsim[8:9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Rec 1
DataR <<- Rsim[11:13]
DataR2 <<- Rsim[12:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec2
DataR <<- Rsim[15:17]
DataR2 <<- Rsim[16:17]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}

} ## ends if 3 intervals 


if (max(ID3) == 2)  ## starts if 2 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:4]
DataR2 <<- Rsim[4:4]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[6:7]
DataR2 <<- Rsim[7:7]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con3
DataR <<- Rsim[9:10]
DataR2 <<- Rsim[10:10]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[12:13]
DataR2 <<- Rsim[13:13]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}


} ## ends if 2 intervals 



if (max(ID3) == 1)  ## starts if 1 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3]
NamesR <<- names(DataR)


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans <- mean(V1)

###########################################################################Mean2
Rsim<<- read.csv(filename7)

##Con2
DataR <<- Rsim[5]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)

###########################################################################Mean3
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[7]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans3 <- mean(V1)
###########################################################################Mean4
Rsim<<- read.csv(filename7)


##Con2
DataR <<- Rsim[9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans4 <- mean(V1)

} ## ends if 1 intervals 

#############################################################################
##Create stats list

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)



if (max(ID3) == 4) 
{ 
Name4<<- paste("Depth_Cat_4_" , Min4, "-", Max4,"_",Per4,sep="")
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 
if (max(ID3) == 3) 
{ 
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 

if (max(ID3) == 2) 
{ 
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 1) 
{ 
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 4) { NamesD <<- c(Name1,Name2,Name3, Name4)}
if (max(ID3) == 3) { NamesD <<- c(Name1,Name2,Name3)}
if (max(ID3) == 2) { NamesD <<- c(Name1,Name2)}
if (max(ID3) == 1) { NamesD <<- c(Name1)}

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans7,OMeans4,OMeans8)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means") )
rownames(StatsList2) <- NamesD

Stats1 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
write.csv(StatsList2, file = Stats1, row.names=TRUE)


} ## ends if grade = 3

#########################################################################################################################################################################################################################
######################################################### grade 1
########################################################################################################################################################################################################################


if (GradeNum == 1)
{


if (max(ID3) == 4) ### if 4 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:6]
DataR2 <<- Rsim[4:6]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[8:11]
DataR2 <<- Rsim[9:11]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}
} ## ends if 4 intervals 

########################################################################################################################################################################################################################


if (max(ID3) == 3)
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:5]
DataR2 <<- Rsim[4:5]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[7:9]
DataR2 <<- Rsim[8:9]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

} ## ends if 3 intervals 


if (max(ID3) == 2)  ## starts if 2 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3:4]
DataR2 <<- Rsim[4:4]
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

###########################################################################Mean2
Rsim<<- read.csv(filename7)


##Rec1
DataR <<- Rsim[6:7]
DataR2 <<- Rsim[7:7]
NamesR <<- names(DataR)
NamesR2 <<- names(DataR2)
DataR2[is.na(DataR2)] <- 0


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)


#for each variable 
yy <- 1

for (g in NamesR2){
print (g)
print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

} ## ends if 2 intervals 



if (max(ID3) == 1)  ## starts if 1 intervals 
{

### pivot 2 contained total stats 
###########################################################################Mean1
Rsim<<- read.csv(filename7)


##Con1
DataR <<- Rsim[3]
NamesR <<- names(DataR)


### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans <- mean(V1)

###########################################################################Mean2
Rsim<<- read.csv(filename7)

##Con2
DataR <<- Rsim[5]
NamesR <<- names(DataR)

### Create mean value for first contained number 
V1 <<- DataR[1]
V1[is.na(V1)] <- 0
V1<- unlist(V1)
V1<- as.numeric(V1)
OMeans2 <- mean(V1)
} ## ends if 1 intervals 

#############################################################################
##Create stats list

GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)




if (max(ID3) == 4) 
{ 
Name4<<- paste("Depth_Cat_4_" , Min4, "-", Max4,"_",Per4,sep="")
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 
if (max(ID3) == 3) 
{ 
Name3 <<- paste("Depth_Cat_3_" , Min3, "-", Max3,"_",Per3,sep="")
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 

if (max(ID3) == 2) 
{ 
Name2 <<- paste("Depth_Cat_2_" , Min2, "-", Max2,"_",Per2,sep="")
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 1) 
{ 
Name1 <<- paste("Depth_Cat_1_" , Min1, "-", Max1,"_",Per1,sep="")
} 


if (max(ID3) == 4) { NamesD <<- c(Name1,Name2,Name3, Name4)}
if (max(ID3) == 3) { NamesD <<- c(Name1,Name2,Name3)}
if (max(ID3) == 2) { NamesD <<- c(Name1,Name2)}
if (max(ID3) == 1) { NamesD <<- c(Name1)}

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans7,OMeans4,OMeans8)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means") )
rownames(StatsList2) <- NamesD

Stats1 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
write.csv(StatsList2, file = Stats1, row.names=TRUE)


} ## ends if grade = 1

