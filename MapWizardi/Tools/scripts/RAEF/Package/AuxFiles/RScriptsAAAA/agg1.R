

library (reshape2)
library (reshape)
ITab <<- read.csv(OutF1,skip = 1, header = FALSE)





if (GradeNum == 6)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)
GN4 <<-  ListGradeNames[4]
GN4 <- sub("._pct","", GN4)
GN5 <<-  ListGradeNames[5]
GN5 <- sub("._pct","", GN5)
GN6 <<-  ListGradeNames[6]
GN6 <- sub("._pct","", GN6)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V60)),ConMo = sum(as.numeric(V61)), ConAu = sum(as.numeric(V62)),ConAg = sum(as.numeric(V63)),Con5 = sum(as.numeric(V64)),Con6 = sum(as.numeric(V65)),RecCu = sum(as.numeric(V66)),RecMo = sum(as.numeric(V67)), RecAu = sum(as.numeric(V68)),RecAg = sum(as.numeric(V69)),Rec5 = sum(as.numeric(V70)),Rec6 = sum(as.numeric(V71)), PVD = sum(as.numeric(V51)))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V78)),ConMo = sum(as.numeric(V79)), ConAu = sum(as.numeric(V80)),ConAg = sum(as.numeric(V81)),Con5 = sum(as.numeric(V82)),Con6 = sum(as.numeric(V83)),RecCu = sum(as.numeric(V84)),RecMo = sum(as.numeric(V85)), RecAu = sum(as.numeric(V86)),RecAg = sum(as.numeric(V87)),Rec5 = sum(as.numeric(V88)),Rec6 = sum(as.numeric(V89)),PVD = sum(as.numeric(V69)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"),  paste(GN3,"_Con"), paste(GN4,"_Con"),  paste(GN5,"_Con"),  paste(GN6,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"), paste(GN3,"_Rec"),  paste(GN4,"_Rec"), paste(GN5,"_Rec"),  paste(GN6,"_Rec"), "NPV_Tract")
}


if (GradeNum == 5)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)
GN4 <<-  ListGradeNames[4]
GN4 <- sub("._pct","", GN4)
GN5 <<-  ListGradeNames[5]
GN5 <- sub("._pct","", GN5)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V58)),ConMo = sum(as.numeric(V59)), ConAu = sum(as.numeric(V60)),ConAg = sum(as.numeric(V61)),Con5 = sum(as.numeric(V62)),RecCu = sum(as.numeric(V63)),RecMo = sum(as.numeric(V64)), RecAu = sum(as.numeric(V65)),RecAg = sum(as.numeric(V66)),Rec5 = sum(as.numeric(V67)), PVD = sum(as.numeric(V50)))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V76)),ConMo = sum(as.numeric(V77)), ConAu = sum(as.numeric(V78)),ConAg = sum(as.numeric(V79)),Con5 = sum(as.numeric(V80)),RecCu = sum(as.numeric(V81)),RecMo = sum(as.numeric(V82)), RecAu = sum(as.numeric(V83)),RecAg = sum(as.numeric(V84)),Rec5 = sum(as.numeric(V85)),PVD = sum(as.numeric(V68)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"),  paste(GN3,"_Con"), paste(GN4,"_Con"),  paste(GN5,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"), paste(GN3,"_Rec"),  paste(GN4,"_Rec"), paste(GN5,"_Rec"),"NPV_Tract")
}





if (GradeNum == 4)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)
GN4 <<-  ListGradeNames[4]
GN4 <- sub("._pct","", GN4)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V56)),ConMo = sum(as.numeric(V57)), ConAu = sum(as.numeric(V58)),ConAg = sum(as.numeric(V59)),RecCu = sum(as.numeric(V60)),RecMo = sum(as.numeric(V61)), RecAu = sum(as.numeric(V62)),RecAg = sum(as.numeric(V63)),PVD = sum(as.numeric(V49)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"),  paste(GN3,"_Con"), paste(GN4,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"), paste(GN3,"_Rec"),  paste(GN4,"_Rec"),"NPV_Tract")
}



if (GradeNum == 3)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)
GN3 <<-  ListGradeNames[3]
GN3 <- sub("._pct","", GN3)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V54)),ConMo = sum(as.numeric(V55)), ConAu = sum(as.numeric(V56)),RecCu = sum(as.numeric(V57)),RecMo = sum(as.numeric(V58)), RecAu = sum(as.numeric(V59)),PVD = sum(as.numeric(V48)))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V72)),ConMo = sum(as.numeric(V73)), ConAu = sum(as.numeric(V74)),RecCu = sum(as.numeric(V75)),RecMo = sum(as.numeric(V76)), RecAu = sum(as.numeric(V77)),PVD = sum(as.numeric(V66)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"),  paste(GN3,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"), paste(GN3,"_Rec"),"NPV_Tract")
}



if (GradeNum == 2)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)
GN2 <<-  ListGradeNames[2]
GN2 <- sub("._pct","", GN2)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V52)),ConMo = sum(as.numeric(V53)),RecCu = sum(as.numeric(V54)),RecMo = sum(as.numeric(V55)),PVD = sum(as.numeric(V47)))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V70)),ConMo = sum(as.numeric(V71)),RecCu = sum(as.numeric(V72)),RecMo = sum(as.numeric(V73)),PVD = sum(as.numeric(V65)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"),"NPV_Tract")
}


if (GradeNum == 1)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V48)), RecCu = sum(as.numeric(V49)),PVD = sum(as.numeric(V44)))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(as.numeric(V5)), ConCu = sum(as.numeric(V66)),RecCu = sum(as.numeric(V67)),PVD = sum(as.numeric(V62)))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN1,"_Rec"),"NPV_Tract")
}


filename6 <<- paste("EF_03_Aggregated_Totals_",TN1,"",".csv", sep = "")
write.csv(Pivot , file = filename6)


