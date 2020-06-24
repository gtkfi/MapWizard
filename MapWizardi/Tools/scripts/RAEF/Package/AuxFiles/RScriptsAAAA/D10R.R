

#### Creating the 10 categories based on the max and min
DCAT10<<- 0
Div <<- (MaxTot - Min1)/10
Group1 <<- Min1 + Div
Group2 <<- Group1 + Div
Group3 <<- Group2 + Div
Group4 <<- Group3 + Div
Group5 <<- Group4 + Div
Group6 <<- Group5 + Div
Group7 <<- Group6 + Div
Group8 <<- Group7 + Div
Group9 <<- Group8 + Div
Group10 <<- Group9 + Div

NumLinesF <<- nrow(ITab)
xg <<- 1

OutTable123 <<-{}  ## Creates new empty output table variable 




####################################################################################################if MineNum001 == 1
if (GradeNum == 1)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,48]
			Rec1<<- ITab[xg,49]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Rec1)     
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==1





if (GradeNum == 2)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,52]
			Con2<<- ITab[xg,53]
			Rec1<<- ITab[xg,54]
			Rec2<<- ITab[xg,55]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Con2, Rec1, Rec2)    
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==1
	
	
	


if (GradeNum == 3)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,54]
			Con2<<- ITab[xg,55]
			Con3<<- ITab[xg,56]
			Rec1<<- ITab[xg,57]
			Rec2<<- ITab[xg,58]
			Rec3<<- ITab[xg,59]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Con2, Con3, Rec1, Rec2,Rec3)    
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==3
	
	
	
if (GradeNum == 4)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,56]
			Con2<<- ITab[xg,57]
			Con3<<- ITab[xg,58]
			Con4<<- ITab[xg,59]
			Rec1<<- ITab[xg,60]
			Rec2<<- ITab[xg,61]
			Rec3<<- ITab[xg,62]
			Rec4<<- ITab[xg,63]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Con2, Con3,Con4, Rec1, Rec2,Rec3,Rec4)     
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==4
	
	
	
if (GradeNum == 5)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,58]
			Con2<<- ITab[xg,59]
			Con3<<- ITab[xg,60]
			Con4<<- ITab[xg,61]
			Con5<<- ITab[xg,62]
			Rec1<<- ITab[xg,63]
			Rec2<<- ITab[xg,64]
			Rec3<<- ITab[xg,65]
			Rec4<<- ITab[xg,66]
			Rec5<<- ITab[xg,67]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Con2, Con3,Con4,Con5, Rec1, Rec2,Rec3,Rec4,Rec5)     
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==5
	
if (GradeNum == 6)
	{

	xg <<- 1

	if (MineNum001 == 1) ## if start for mine num 1
		{ 

		for( xg in 1:NumLinesF)   ##For each line 
			{
			SimIndex10 <<- ITab[xg,2]
			Depth10 <<- ITab[xg,13]
			Depth10 <<- as.double(Depth10)  
			Depth10 [is.na(Depth10 )] <- 9999999
			Ore10 <<- ITab[xg,5]
			Con1<<- ITab[xg,60]
			Con2<<- ITab[xg,61]
			Con3<<- ITab[xg,62]
			Con4<<- ITab[xg,63]
			Con5<<- ITab[xg,64]
			Con6<<- ITab[xg,65]
			Rec1<<- ITab[xg,66]
			Rec2<<- ITab[xg,67]
			Rec3<<- ITab[xg,68]
			Rec4<<- ITab[xg,69]
			Rec5<<- ITab[xg,70]
			Rec6<<- ITab[xg,71]

			if ( Depth10 == 9999999)  ## if depth is NA , set it to NA
				{
				DCAT10 <<- "NA"
				}

			if ( Depth10 >= 0)
				{
	
				if ( Depth10 <= Group1) ##if depth is less than group 1, set it to category 1
					{
					DCAT10 <<- 1
					}
				}

			if ( Depth10 > Group1)  ## if depth is greater than group 1 and less than group 2, set it to category 2
				{
				if ( Depth10 <= Group2) 
					{
					DCAT10 <<- 2
					}
				}


			if ( Depth10 > Group2) ## if depth is greater than group 2 and less than group 3, set it to category 3
				{
				if ( Depth10 <= Group3) 
					{
					DCAT10 <<- 3
					}
				}

			if ( Depth10 > Group3)
				{
				if ( Depth10 <= Group4) 
					{
					DCAT10 <<- 4
					}
				}


			if ( Depth10 > Group4)
				{
				if ( Depth10 <= Group5) 
					{
					DCAT10 <<- 5
					}
				}

			if ( Depth10 > Group5)
				{
				if ( Depth10 <= Group6) 
					{
					DCAT10 <<- 6
					}
				}

			if ( Depth10 > Group6)
				{
				if ( Depth10 <= Group7) 
					{
					DCAT10 <<- 7
					}
				}

			if ( Depth10 > Group7)
				{
				if ( Depth10 <= Group8) 
					{
					DCAT10 <<- 8
					}
				}

			if ( Depth10 > Group8)
				{
				if ( Depth10 <= Group9) 
					{
					DCAT10 <<- 9
					}
				}

			if ( Depth10 > Group9)
				{
				if ( Depth10 <= Group10) 
					{
					DCAT10 <<- 10
					}
				}

				
			Tab10 <<- cbind(SimIndex10, Ore10, Depth10,DCAT10, Con1, Con2, Con3,Con4,Con5,Con6, Rec1, Rec2,Rec3,Rec4,Rec5,Rec6)     
			OutTable123<<- rbind(OutTable123,Tab10)

			} ## end for each line
						
		filename1000 <<- paste(TN1,"_Depth10Agg6",".csv", sep = "")
		write.table(OutTable123, append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
		} ## end if mine num == 1
	} ## ends if grade num ==6
	
	
	
	########################################################################################################################################################################
	########################################################################################################################################################
	#########################################################################################################################################################






ITab10 <<- read.csv(filename1000, header = FALSE)

CIT10 <<- length(ITab10)

data10 = melt(ITab10 , id.vars = c("V1","V2", "V3", "V4" , "V5"))
good <<- cast(data10 , V2 + V5 ~ variable, sum)
good2 <<- cast(data10 , V2 ~ V5~ variable, sum)


filename10 <<- paste(TN1,"_DepthCat10_Agg_Totals8",".csv", sep = "")
write.csv(good2 , file = filename10)



Rsim<<- read.csv(filename10)


### pivot depth10 contained total stats 
###########################################################################Mean1

if (GradeNum == 4)
	{

##Con1
DataR <<- Rsim[2:11]
DataR2 <<- Rsim[3:11]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans<- rbind(OMeans,OM)
OMeans<- round(OMeans)
yy<- yy + 1
}

###########################################################################Mean2
##Con2
DataR <<- Rsim[13:22]
DataR2 <<- Rsim[14:22]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3
##Con2
DataR <<- Rsim[24:33]
DataR2 <<- Rsim[25:33]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4
##Con2
DataR <<- Rsim[35:44]
DataR2 <<- Rsim[36:44]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5
##Con2
DataR <<- Rsim[46:55]
DataR2 <<- Rsim[47:55]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6
##Con2
DataR <<- Rsim[57:66]
DataR2 <<- Rsim[58:66]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}


###########################################################################Mean7
##Con2
DataR <<- Rsim[68:77]
DataR2 <<- Rsim[69:77]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans7<- rbind(OMeans7,OM)
OMeans7<- round(OMeans7)
yy<- yy + 1
}

###########################################################################Mean8
##Con2
DataR <<- Rsim[79:88]
DataR2 <<- Rsim[80:88]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans8<- rbind(OMeans8,OM)
OMeans8<- round(OMeans8)
yy<- yy + 1
}






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

Name1 <<- paste("Depth_Cat_1_Max:_", Group1,sep="")
Name2 <<- paste("Depth_Cat_2_Max:_", Group2,sep="")
Name3 <<- paste("Depth_Cat_3_Max:_", Group3,sep="")
Name4 <<- paste("Depth_Cat_4_Max:_", Group4,sep="")
Name5 <<- paste("Depth_Cat_5_Max:_", Group5,sep="")
Name6 <<- paste("Depth_Cat_6_Max:_", Group6,sep="")
Name7 <<- paste("Depth_Cat_7_Max:_", Group7,sep="")
Name8 <<- paste("Depth_Cat_8_Max:_", Group8,sep="")
Name9 <<- paste("Depth_Cat_9_Max:_", Group9,sep="")
Name10 <<- paste("Depth_Cat_10_Max:_", Group10,sep="")

NamesD <<- c(Name1,Name2,Name3, Name4, Name5, Name6, Name7, Name8, Name9, Name10)

#OMeans <<- OMeans/2
#OMeans5 <<- OMeans5/2
#OMeans2 <<- OMeans2/2
#OMeans6 <<- OMeans6/2
#OMeans3 <<- OMeans3/2
#OMeans7 <<- OMeans7/2
#OMeans4 <<- OMeans4/2
#OMeans8 <<- OMeans8/2

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans7,OMeans4,OMeans8)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means"),  paste(GN3,"_Con","_","Means"),  paste(GN3,"_Rec","_","Means"), paste(GN4,"_Con","_","Means"),  paste(GN4,"_Rec","_","Means")  )
rownames(StatsList2) <- NamesD

} ## ends if grade num 4







if (GradeNum == 3)
{



### pivot depth10 contained total stats 
###########################################################################Mean1
##Con1
DataR <<- Rsim[2:11]
DataR2 <<- Rsim[3:11]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans<- rbind(OMeans,OM)
OMeans<- round(OMeans)
yy<- yy + 1
}

###########################################################################Mean2


##Con2
DataR <<- Rsim[13:22]
DataR2 <<- Rsim[14:22]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3


##Con2
DataR <<- Rsim[24:33]
DataR2 <<- Rsim[25:33]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4



##Con2
DataR <<- Rsim[35:44]
DataR2 <<- Rsim[36:44]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



###########################################################################Mean5


##Con2
DataR <<- Rsim[46:55]
DataR2 <<- Rsim[47:55]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans5<- rbind(OMeans5,OM)
OMeans5<- round(OMeans5)
yy<- yy + 1
}

###########################################################################Mean6



##Con2
DataR <<- Rsim[57:66]
DataR2 <<- Rsim[58:66]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans6<- rbind(OMeans6,OM)
OMeans6<- round(OMeans6)
yy<- yy + 1
}







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

Name1 <<- paste("Depth_Cat_1_Max:_", Group1,sep="")
Name2 <<- paste("Depth_Cat_2_Max:_", Group2,sep="")
Name3 <<- paste("Depth_Cat_3_Max:_", Group3,sep="")
Name4 <<- paste("Depth_Cat_4_Max:_", Group4,sep="")
Name5 <<- paste("Depth_Cat_5_Max:_", Group5,sep="")
Name6 <<- paste("Depth_Cat_6_Max:_", Group6,sep="")
Name7 <<- paste("Depth_Cat_7_Max:_", Group7,sep="")
Name8 <<- paste("Depth_Cat_8_Max:_", Group8,sep="")
Name9 <<- paste("Depth_Cat_9_Max:_", Group9,sep="")
Name10 <<- paste("Depth_Cat_10_Max:_", Group10,sep="")

NamesD <<- c(Name1,Name2,Name3, Name4, Name5, Name6, Name7, Name8, Name9, Name10)

#OMeans <<- OMeans/2
#OMeans5 <<- OMeans5/2
#OMeans2 <<- OMeans2/2
#OMeans6 <<- OMeans6/2
#OMeans3 <<- OMeans3/2
#OMeans7 <<- OMeans7/2
#OMeans4 <<- OMeans4/2
#OMeans8 <<- OMeans8/2

StatsList2 <- cbind(OMeans,OMeans5, OMeans2,OMeans6, OMeans3,OMeans4)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means"),  paste(GN3,"_Con","_","Means"),  paste(GN3,"_Rec","_","Means") )
rownames(StatsList2) <- NamesD

} ## ends if grade num = 3





if (GradeNum == 2)
{
### pivot depth10 contained total stats 
###########################################################################Mean1

##Con1
DataR <<- Rsim[2:11]
DataR2 <<- Rsim[3:11]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans<- rbind(OMeans,OM)
OMeans<- round(OMeans)
yy<- yy + 1
}

###########################################################################Mean2


##Con2
DataR <<- Rsim[13:22]
DataR2 <<- Rsim[14:22]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}

###########################################################################Mean3


##Con2
DataR <<- Rsim[24:33]
DataR2 <<- Rsim[25:33]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans3<- rbind(OMeans3,OM)
OMeans3<- round(OMeans3)
yy<- yy + 1
}

###########################################################################Mean4


##Con2
DataR <<- Rsim[35:44]
DataR2 <<- Rsim[36:44]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans4<- rbind(OMeans4,OM)
OMeans4<- round(OMeans4)
yy<- yy + 1
}



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

Name1 <<- paste("Depth_Cat_1_Max:_", Group1,sep="")
Name2 <<- paste("Depth_Cat_2_Max:_", Group2,sep="")
Name3 <<- paste("Depth_Cat_3_Max:_", Group3,sep="")
Name4 <<- paste("Depth_Cat_4_Max:_", Group4,sep="")
Name5 <<- paste("Depth_Cat_5_Max:_", Group5,sep="")
Name6 <<- paste("Depth_Cat_6_Max:_", Group6,sep="")
Name7 <<- paste("Depth_Cat_7_Max:_", Group7,sep="")
Name8 <<- paste("Depth_Cat_8_Max:_", Group8,sep="")
Name9 <<- paste("Depth_Cat_9_Max:_", Group9,sep="")
Name10 <<- paste("Depth_Cat_10_Max:_", Group10,sep="")

NamesD <<- c(Name1,Name2,Name3, Name4, Name5, Name6, Name7, Name8, Name9, Name10)


StatsList2 <- cbind(OMeans, OMeans2, OMeans3,OMeans4)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means"),  paste(GN2,"_Con","_","Means"), paste(GN2,"_Rec","_","Means")  )
rownames(StatsList2) <- NamesD

} ## ends if grade num = 2


if (GradeNum == 1)
{
### pivot depth10 contained total stats 
###########################################################################Mean1


##Con1
DataR <<- Rsim[2:11]
DataR2 <<- Rsim[3:11]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans<- rbind(OMeans,OM)
OMeans<- round(OMeans)
yy<- yy + 1
}

###########################################################################Mean2


##Con2
DataR <<- Rsim[13:22]
DataR2 <<- Rsim[14:22]
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
#print (g)
#print (yy)
VN <- DataR2[yy]
VN<- unlist(VN)
VN<- as.numeric(VN)
OM <- mean(VN)
OMeans2<- rbind(OMeans2,OM)
OMeans2<- round(OMeans2)
yy<- yy + 1
}


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

Name1 <<- paste("Depth_Cat_1_Max:_", Group1,sep="")
Name2 <<- paste("Depth_Cat_2_Max:_", Group2,sep="")
Name3 <<- paste("Depth_Cat_3_Max:_", Group3,sep="")
Name4 <<- paste("Depth_Cat_4_Max:_", Group4,sep="")
Name5 <<- paste("Depth_Cat_5_Max:_", Group5,sep="")
Name6 <<- paste("Depth_Cat_6_Max:_", Group6,sep="")
Name7 <<- paste("Depth_Cat_7_Max:_", Group7,sep="")
Name8 <<- paste("Depth_Cat_8_Max:_", Group8,sep="")
Name9 <<- paste("Depth_Cat_9_Max:_", Group9,sep="")
Name10 <<- paste("Depth_Cat_10_Max:_", Group10,sep="")

NamesD <<- c(Name1,Name2,Name3, Name4, Name5, Name6, Name7, Name8, Name9, Name10)


StatsList2 <- cbind(OMeans, OMeans2)
colnames(StatsList2) <- c(paste(GN1,"_Con","_","Means"), paste(GN1,"_Rec","_","Means")  )
rownames(StatsList2) <- NamesD

} ## ends if grade num = 1




Stats1 <<- paste("EF_06_10Depth_Stats_",TN1,".csv", sep = "")
write.csv(StatsList2, file = Stats1, row.names=TRUE)

