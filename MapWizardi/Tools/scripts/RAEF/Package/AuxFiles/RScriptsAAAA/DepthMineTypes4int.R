InFile <<- paste(wdir1, "/",OutF1,sep="")
Out1 <<- read.csv(InFile )


if (GradeNum == 6)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[71])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[53])
}

} ##Ends if grade num 6



if (GradeNum == 5)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[70])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[52])
}

} ##Ends if grade num 5



if (GradeNum == 4)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[69])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[51])
}

} ##Ends if grade num 4


if (GradeNum == 3)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[68])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[50])
}

} ##Ends if grade num 3




if (GradeNum == 2)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[67])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[49])
}

} ##Ends if grade num 2



if (GradeNum == 1)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[15],Out1[64])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[12],Out1[46])
}

} ##Ends if grade num 1




mylist <- split(Data0 , Data0$Dcat)
Dcat1 <<- mylist[[1]]
Dcat2 <<- mylist[[2]]
Dcat3 <<- mylist[[3]]
Dcat4 <<- mylist[[4]]

GenCount <<- count(Data0,BestMMethod) 
Blank <<- 0
BCG <<- 0
NG <<- 0
OPG <<- 0
RPG <<- 0
VCRG <<- 0

gencountnrow <<- nrow(GenCount)

if (gencountnrow > 0)
{

if( GenCount[1,1] == "")
{ 
Blank <<- GenCount[1,2]
}
if( GenCount[1,1] == "Block Caving")
{ 
BCG <<- GenCount[1,2]
}
if( GenCount[1,1] == "None")
{
NG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Open Pit")
{
OPG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[1,2] 
}
if( GenCount[1,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[1,2] 
}
}




if (gencountnrow > 1)
{

if( GenCount[2,1] == "")
{ 
Blank <<- GenCount[2,2]
}
if( GenCount[2,1] == "Block Caving")
{ 
BCG <<- GenCount[2,2]
}
if( GenCount[2,1] == "None")
{
NG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Open Pit")
{
OPG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[2,2] 
}
if( GenCount[2,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[2,2] 
}
}

if (gencountnrow > 2)
{

if( GenCount[3,1] == "")
{ 
Blank <<- GenCount[3,2]
}
if( GenCount[3,1] == "Block Caving")
{ 
BCG <<- GenCount[3,2]
}
if( GenCount[3,1] == "None")
{
NG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Open Pit")
{
OPG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[3,2] 
}
if( GenCount[3,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[3,2] 
}
}

if (gencountnrow > 3)
{
if( GenCount[4,1] == "")
{ 
Blank <<- GenCount[4,2]
}
if( GenCount[4,1] == "Block Caving")
{ 
BCG <<- GenCount[4,2]
}
if( GenCount[4,1] == "None")
{
NG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Open Pit")
{
OPG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Room-and-Pillar")
{
RPG  <<- GenCount[4,2] 
}
if( GenCount[4,1] == "Vertical Crater Retreat")
{
VCRG  <<- GenCount[4,2] 
}
}


## End gen count 

## count 4
Dcat4count <<- count(Dcat4 , BestMMethod)
BC4 <<- 0
N4 <<- 0
OP4 <<- 0
RP4 <<- 0
VCR4 <<- 0

dcat4nrow <<- nrow(Dcat4count)

if (dcat4nrow > 0)
{
if( Dcat4count [1,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [1,2]
}
if( Dcat4count [1,1] == "None")
{
N4 <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Open Pit")
{
OP4  <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [1,2] 
}
if( Dcat4count [1,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [1,2] 
}
}


if (dcat4nrow > 1)
{
if( Dcat4count [2,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [2,2]
}
if( Dcat4count [2,1] == "None")
{
N4 <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Open Pit")
{
OP4  <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [2,2] 
}
if( Dcat4count [2,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [2,2] 
}
}


if (dcat4nrow > 2)
{
if( Dcat4count [3,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [3,2]
}
if( Dcat4count [3,1] == "None")
{
N4 <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Open Pit")
{
OP4  <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [3,2] 
}
if( Dcat4count [3,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [3,2] 
}
}

if (dcat4nrow > 3)
{
if( Dcat4count[4,1] == "Block Caving")
{ 
BC4 <<- Dcat4count [4,2]
}
if( Dcat4count [4,1] == "None")
{
N4 <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Open Pit")
{
OP4  <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Room-and-Pillar")
{
RP4  <<- Dcat4count [4,2] 
}
if( Dcat4count [4,1] == "Vertical Crater Retreat")
{
VCR4  <<- Dcat4count [4,2] 
}
}
## End count 4 

## count 3
Dcat3count <<- count(Dcat3 , BestMMethod)
BC3 <<- 0
N3 <<- 0
OP3 <<- 0
RP3 <<- 0
VCR3 <<- 0

dcat3nrow <<- nrow(Dcat3count)

if (dcat3nrow > 0)
{
if( Dcat3count [1,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [1,2]
}
if( Dcat3count [1,1] == "None")
{
N3 <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Open Pit")
{
OP3  <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [1,2] 
}
if( Dcat3count [1,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [1,2] 
}
}


if (dcat3nrow > 1)
{
if( Dcat3count [2,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [2,2]
}
if( Dcat3count [2,1] == "None")
{
N3 <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Open Pit")
{
OP3  <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [2,2] 
}
if( Dcat3count [2,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [2,2] 
}
}


if (dcat3nrow > 2)
{
if( Dcat3count [3,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [3,2]
}
if( Dcat3count [3,1] == "None")
{
N3 <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Open Pit")
{
OP3  <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [3,2] 
}
if( Dcat3count [3,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [3,2] 
}
}




if (dcat3nrow > 3)
{
if( Dcat3count [4,1] == "Block Caving")
{ 
BC3 <<- Dcat3count [4,2]
}
if( Dcat3count [4,1] == "None")
{
N3 <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Open Pit")
{
OP3  <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Room-and-Pillar")
{
RP3  <<- Dcat3count [4,2] 
}
if( Dcat3count [4,1] == "Vertical Crater Retreat")
{
VCR3  <<- Dcat3count [4,2] 
}
}
## End count 3 


## count 2
Dcat2count <<- count(Dcat2 , BestMMethod)
BC2 <<- 0
N2 <<- 0
OP2 <<- 0
RP2 <<- 0
VCR2 <<- 0


dcat2nrow <<- nrow(Dcat2count)

if (dcat2nrow > 0)
{

if( Dcat2count [1,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [1,2]
}
if( Dcat2count [1,1] == "None")
{
N2 <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Open Pit")
{
OP2  <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [1,2] 
}
if( Dcat2count [1,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [1,2] 
}
}


if (dcat2nrow > 1)
{

if( Dcat2count [2,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [2,2]
}
if( Dcat2count [2,1] == "None")
{
N2 <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Open Pit")
{
OP2  <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [2,2] 
}
if( Dcat2count [2,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [2,2] 
}
}

if (dcat2nrow > 2)
{
if( Dcat2count [3,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [3,2]
}
if( Dcat2count [3,1] == "None")
{
N2 <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Open Pit")
{
OP2  <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [3,2] 
}
if( Dcat2count [3,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [3,2] 
}
}


if (dcat2nrow > 3)
{

if( Dcat2count [4,1] == "Block Caving")
{ 
BC2 <<- Dcat2count [4,2]
}
if( Dcat2count [4,1] == "None")
{
N2 <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Open Pit")
{
OP2  <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Room-and-Pillar")
{
RP2  <<- Dcat2count [4,2] 
}
if( Dcat2count [4,1] == "Vertical Crater Retreat")
{
VCR2  <<- Dcat2count [4,2] 
}
}
## End count 2 


## count 1
Dcat1count <<- count(Dcat1 , BestMMethod)
BC1b <<- 0
N1b <<- 0
OP1b <<- 0
RP1b <<- 0
VCR1b <<- 0

dcat1nrow <<- nrow(Dcat1count)

if (dcat1nrow > 0)
{
if( Dcat1count [1,1] == "Block Caving")
{ 
BC1b <<- Dcat1count [1,2]
}
if( Dcat1count [1,1] == "None")
{
N1b <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Open Pit")
{
OP1b  <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Room-and-Pillar")
{
RP1b  <<- Dcat1count [1,2] 
}
if( Dcat1count [1,1] == "Vertical Crater Retreat")
{
VCR1b  <<- Dcat1count [1,2] 
}
}

if (dcat1nrow > 1)
{
if( Dcat1count [2,1] == "Block Caving")
{ 
BC1b <<- Dcat1count [2,2]
}
if( Dcat1count [2,1] == "None")
{
N1b <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Open Pit")
{
OP1b  <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Room-and-Pillar")
{
RP1b  <<- Dcat1count [2,2] 
}
if( Dcat1count [2,1] == "Vertical Crater Retreat")
{
VCR1b  <<- Dcat1count [2,2] 
}
}

if (dcat1nrow > 2)
{
if( Dcat1count [3,1] == "Block Caving")
{ 
BC1b <<- Dcat1count [3,2]
}
if( Dcat1count [3,1] == "None")-

{
N1b <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Open Pit")
{
OP1b  <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Room-and-Pillar")
{
RP1b  <<- Dcat1count [3,2] 
}
if( Dcat1count [3,1] == "Vertical Crater Retreat")
{
VCR1b  <<- Dcat1count [3,2] 
}
}

if (dcat1nrow > 3)
{
if( Dcat1count [4,1] == "Block Caving")
{ 
BC1b <<- Dcat1count [4,2]
}
if( Dcat1count [4,1] == "None")
{
N1b <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Open Pit")
{
OP1b  <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Room-and-Pillar")
{
RP1b  <<- Dcat1count [4,2] 
}
if( Dcat1count [4,1] == "Vertical Crater Retreat")
{
VCR1b  <<- Dcat1count [4,2] 
}
}

OPG <<- as.numeric(OPG)
BCG <<- as.numeric(BCG)
NG <<- as.numeric(NG)
RPG <<- as.numeric(RPG)
VCRG <<- as.numeric(VCRG)


OP1 <<- as.numeric(OP1b)
BC1 <<- as.numeric(BC1b)
N1 <<- as.numeric(N1b)
RP1 <<- as.numeric(RP1b)
VCR1 <<- as.numeric(VCR1b)


TotalG1 <<-  (OPG + BCG + NG + RPG + VCRG)
Total11 <<-  (OP1 + BC1 + N1 + RP1 + VCR1)
Total21 <<-  (OP2 + BC2 + N2 + RP2 + VCR2)
Total31 <<-  (OP3 + BC3 + N3 + RP3 + VCR3)
Total41 <<-  (OP4 + BC4 + N4 + RP4 + VCR4)

OPGPer <<- ((OPG/TotalG1)*100)
OP1Per <<- ((OP1/Total11)*100)
OP2Per <<- ((OP2/Total21)*100)
OP3Per <<- ((OP3/Total31)*100)
OP4Per <<- ((OP4/Total41)*100)

BCGPer <<- ((BCG/TotalG1)*100)
BC1Per <<- ((BC1b/Total11)*100)
BC2Per <<- ((BC2/Total21)*100)
BC3Per <<- ((BC3/Total31)*100)
BC4Per <<- ((BC4/Total41)*100)


RPGPer <<- ((RPG/TotalG1)*100)
RP1Per <<- ((RP1/Total11)*100)
RP2Per <<- ((RP2/Total21)*100)
RP3Per <<- ((RP3/Total31)*100)
RP4Per <<- ((RP4/Total41)*100)


VCRGPer <<- ((VCRG/TotalG1)*100)
VCR1Per <<- ((VCR1/Total11)*100)
VCR2Per <<- ((VCR2/Total21)*100)
VCR3Per <<- ((VCR3/Total31)*100)
VCR4Per <<- ((VCR4/Total41)*100)

NGPer <<- ((NG/TotalG1)*100)
N1Per <<- ((N1/Total11)*100)
N2Per <<- ((N2/Total21)*100)
N3Per <<- ((N3/Total31)*100)
N4Per <<- ((N4/Total41)*100)


NamesD <<- c("Total","Open Pit","Block Caving","Room and Pillar","Vertical Crater Retreat", "None","Blank","Open Pit Percent","Block Caving Percent","Room and Pillar Percent","Vertical Crater Retreat Percent", "None Percent")

Row1 <<- cbind(TotalG1, OPG,BCG,RPG,VCRG, NG,Blank,OPGPer,BCGPer,RPGPer,VCRGPer, NGPer  )
Row2 <<- cbind(Total11, OP1,BC1,RP1,VCR1, N1,Blank,OP1Per,BC1Per,RP1Per,VCR1Per, N1Per  )
Row3 <<- cbind(Total21, OP2,BC2,RP2,VCR2, N2,Blank,OP2Per,BC2Per,RP2Per,VCR2Per, N2Per  )
Row4 <<- cbind(Total31, OP3,BC3,RP3,VCR3, N3,Blank,OP3Per,BC3Per,RP3Per,VCR3Per, N3Per  )
Row5 <<- cbind(Total41, OP4,BC4,RP4,VCR4, N4,Blank,OP4Per,BC4Per,RP4Per,VCR4Per, N4Per  )

names(Row2) <- names(Row1) 
names(Row3) <- names(Row2) 
names(Row4) <- names(Row3) 
names(Row5) <- names(Row4)

DataNew22 <<- rbind(NamesD, Row1, Row2 ,Row3, Row4, Row5)

NamesR <<- c("Info","General",paste("Depth Level 1_", Max1,"_Meters",sep="") ,paste("Depth Level 2_", Max2,"_Meters",sep=""),paste("Depth Level 3_", Max3,"_Meters",sep=""),paste("Depth Level 4_", Max4,"_Meters",sep=""))


rownames(DataNew22) <- NamesR
#colnames(DataNew22) <- NamesD
zp<<-DataNew22[,12]
rowszp<<-length(zp)
ProbOfZero<<-zp[3:rowszp]
ProbOfZero<<- as.numeric(ProbOfZero)
ProbOfZero<<- round(ProbOfZero, digits = 2)
Stats1 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
oldfile<<- read.csv(Stats1)
newoutput<<- cbind(oldfile,ProbOfZero)

oldnames<<- colnames(StatsList2)
newnames<<- c("Depth",oldnames,"ProbOfZero")
colnames(newoutput)<- newnames
filenameOut12367 <<- paste("EF_05_Depth_Stats_",TN1,".csv", sep = "")
write.table(newoutput,sep = ",",file = filenameOut12367, col.names = TRUE,row.names = FALSE)








