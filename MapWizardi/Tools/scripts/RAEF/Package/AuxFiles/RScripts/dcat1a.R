
##############################################################################


InFile <<- paste(wdir1, "/",OutF1,sep="")
Out1 <<- read.csv(InFile )


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


NumLinesF <<- nrow(Out1)
xg <<- 1



if (GradeNum == 6)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[71])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[53])
}

} ##Ends if grade num 6



if (GradeNum == 5)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[70])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[52])
}

} ##Ends if grade num 5



if (GradeNum == 4)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[69])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[51])
}

} ##Ends if grade num 4


if (GradeNum == 3)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[68])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[50])
}

} ##Ends if grade num 3




if (GradeNum == 2)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[67])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[49])
}

} ##Ends if grade num 2



if (GradeNum == 1)
{

if (MineNum001 == 2)
{
Data0 <<- cbind(Out1[16],Out1[64])
}

if (MineNum001 == 1)
{
Data0 <<- cbind(Out1[13],Out1[46])
}

} ##Ends if grade num 1



C2 <<- "Depth"
C3 <<- "Dcat10"
C4 <<- "MT"
Css <<- cbind (C2, C3, C4)
filename1000 <<- paste(TN1,"_Depth10MMFF.csv",sep="")
write.table(Css , append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
for( xg in 1:NumLinesF )
{
MM1 <<- Data0[xg,2]
Depth10  <<- Data0[xg,1]
Depth10 [is.na(Depth10 )] <- 9999999

if ( Depth10 == 9999999)
	{
	DCAT10 <<- "NA"
	}

if ( Depth10 >= 0)
	{
	
		if ( Depth10 <= Group1)
		{
		DCAT10 <<- 1
		}
	}

if ( Depth10 > Group1)
	{
	if ( Depth10 <= Group2) 
		{
		DCAT10 <<- 2
		}
	}


if ( Depth10 > Group2)
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

MM1 <<- toString(MM1)
if (MM1 ==  "") {MM1 <<- "Blank"}
Tab10 <<- cbind(Depth10,DCAT10,MM1) 


write.table(Tab10 , append = TRUE,sep = ",",file = filename1000,   col.names = FALSE )
}
