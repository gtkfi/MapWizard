

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
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V60),ConMo = sum(V61), ConAu = sum(V62),ConAg = sum(V63),Con5 = sum(V64),Con6 = sum(V65),RecCu = sum(V66),RecMo = sum(V67), RecAu = sum(V68),RecAg = sum(V69),Rec5 = sum(V70),Rec6 = sum(V71), PVD = sum(V51))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V78),ConMo = sum(V79), ConAu = sum(V80),ConAg = sum(V81),Con5 = sum(V82),Con6 = sum(V83),RecCu = sum(V84),RecMo = sum(V85), RecAu = sum(V86),RecAg = sum(V87),Rec5 = sum(V88),Rec6 = sum(V89),PVD = sum(V69))
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
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V58),ConMo = sum(V59), ConAu = sum(V60),ConAg = sum(V61),Con5 = sum(V62),RecCu = sum(V63),RecMo = sum(V64), RecAu = sum(V65),RecAg = sum(V66),Rec5 = sum(V67), PVD = sum(V50))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V76),ConMo = sum(V77), ConAu = sum(V78),ConAg = sum(V79),Con5 = sum(V80),RecCu = sum(V81),RecMo = sum(V82), RecAu = sum(V83),RecAg = sum(V84),Rec5 = sum(V85),PVD = sum(V68))
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
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V56),ConMo = sum(V57), ConAu = sum(V58),ConAg = sum(V59),RecCu = sum(V60),RecMo = sum(V61), RecAu = sum(V62),RecAg = sum(V63),PVD = sum(V49))
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
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V54),ConMo = sum(V55), ConAu = sum(V56),RecCu = sum(V57),RecMo = sum(V58), RecAu = sum(V59),PVD = sum(V48))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V72),ConMo = sum(V73), ConAu = sum(V74),RecCu = sum(V75),RecMo = sum(V76), RecAu = sum(V77),PVD = sum(V66))
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
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V52),ConMo = sum(V53),RecCu = sum(V54),RecMo = sum(V55),PVD = sum(V47))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V70),ConMo = sum(V71),RecCu = sum(V72),RecMo = sum(V73),PVD = sum(V65))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN2,"_Con"), paste(GN1,"_Rec"),  paste(GN2,"_Rec"),"NPV_Tract")
}


if (GradeNum == 1)
{
GN1 <<-  ListGradeNames[1]
GN1 <- sub("._pct","", GN1)

if (MineNum001 == 1)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V48), RecCu = sum(V49),PVD = sum(V44))
}
if (MineNum001 == 2)
{
Pivot <- summarise(group_by(ITab,V2),Ore= sum(V5), ConCu = sum(V66),RecCu = sum(V67),PVD = sum(V62))
}
colnames(Pivot) <- c("SimIndex","Ore",paste(GN1,"_Con"), paste(GN1,"_Rec"),"NPV_Tract")
}


filename6 <<- paste("EF_03_Aggregated_Totals_",TN1,"",".csv", sep = "")
write.csv(Pivot , file = filename6)


