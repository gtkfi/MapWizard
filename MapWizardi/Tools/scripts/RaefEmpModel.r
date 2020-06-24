#Modified Empirical Model script from USGS RAEF
#Modified by Sakari Hautala 07.04.2020, to run from command prompt instead of RGUI.
#original script info:
        ###############################################
        ### Script to obtain empircal data
        ### Version:  8/15/18
        ############################################### 



library(gWidgets)
library(gWidgetstcltk)
library(dplyr)
library(reshape)
library(evaluate)


args = commandArgs(trailingOnly = TRUE)


MM4File<<-args[1] #     SIM file                           #<<- gfilebrowse( text = "Select a Sim file...", type = "open", container = EmpWindow )                  ### browse for the Simulation ef file - SimFile 
GTMEmp<<-args[2]# GTM file                    #<<- gfilebrowse( text = "Select a GTM Model...", type = "open", container = EmpWindow )                  ### browse for the Simulation ef file - SimFile 
InputFolder2<<-args[3]#output directory
TestNameEmp <<-args[4] # test/run name


	#MM4File <<- svalue(MM4File)
	MM4 <- read.csv(file=MM4File , header=TRUE, sep=",")
	setwd(InputFolder2)	
	#GTMEmp <<- svalue(GTMEmp)	
	#TestNameEmp <<- svalue(TestNameEmp )
	GTMEmpFile<- read.csv(file=GTMEmp, header=TRUE, sep=",")
	CountCols1 <<- ncol(GTMEmpFile) 
	CountCN <<- CountCols1 - 3
	GLen <<- nrow(GTMEmpFile)
	





## Step 3:  Print heading line for output
CountCC <<- 6
CNameList0 <<- c()
Colnames1 <<- colnames(MM4)
for (cns in 1:CountCN)
	{
	print (cns)
	CCCName <<- Colnames1[CountCC]
	CCCName <<- gsub("._pct"," _pct",CCCName)
	CNameList0 <<- cbind(CNameList0,CCCName)
	CountCC <<- CountCC + 1
	}
	
ConNameList0 <<- c()
for (cont1 in CNameList0)
	{

	NewConName <<- gsub(" _pct"," _MetricTons",cont1)
	ConNameList0 <<- cbind(ConNameList0,NewConName)
	}
	

	

	
Heading1 <<- c("Simulation.Index", "Number.of.Deposits","Sim.Deposit.Index","Ore_mT",CNameList0,"gangue",ConNameList0 )

#write.table(Heading1, "EmpOut3.csv", row.names=F, col.names=F, sep=",")

## Create empty table with dimenssions from data 
TotalCols <<- (CountCN+ CountCN + 5)
TotalRows <<- nrow(MM4)
TableMain<<- matrix(, nrow = TotalRows, ncol = TotalCols)

## Step 4:  for statement -  for each line in the EF 5 file 
CountEFRow <<- 1
CountE1 <<- 1
for (EFrow in 1:nrow(MM4))
{
	## Step 4a: create variables for SimIndex,SimDepIndex,NumDep, and grades for each commodity (empty)
	EFRow0 <<- CountE1
	SimIndex <<- ""
	SimDepIndex <<- ""
	NumDep <<- 0
	
	## Step 4b: save the index/deposit info from from MM4 05 file to output file (left side)
	SimIndex <<- MM4[CountEFRow,2]
	SimDepIndex <<- MM4[CountEFRow,4]
	NumDep <<- MM4[CountEFRow,3]
	
	C1Values1 <<- c()
	ConValues <<- c()
	## Step 4c:  If there is a NA/ zero deposit - create each grade variable as zero
	if (NumDep == 0)
		{
		for (C2 in CNameList0)
			{
		
			CV01 <<- "NA"
			C1Values1 <<- cbind(C1Values1,CV01)
			}
		OreT <<-  "NA"
		for (C2 in CNameList0)
			{
		
			CV01 <<- "NA"
			ConValues <<- cbind(ConValues,CV01)
			}
		Gan <<-  "NA"
		NumDep <<- 0
		}
	
	## Step 4d:  If there is more than zero deposits then run below
	if (NumDep > 0)
		{
		## Step 4da: Run random selection of GTM Model input row selection (1:number of rows- GTM)
		 RowRSelect <<- sample(1:GLen,1,replace = TRUE)
		 
		## Step 4daa: Copy the grade variables in GTM model- using the random specified row index number
		Ccount <<- 4
		for (C1 in CNameList0)
			{
			
			
			assign(C1, GTMEmpFile[RowRSelect,Ccount], env = .GlobalEnv)
			Ccount <<- Ccount + 1
			}
				## Create list of grade values from the specific selected row 	
	
		for (C2 in CNameList0)
			{
		
			CV01 <<- svalue(C2)
			C1Values1 <<- cbind(C1Values1,CV01)
			}
		OreT <<-  GTMEmpFile[RowRSelect,3]
		
		for (C2 in C1Values1)
			{
				
			CV01 <<- ((C2 * OreT)/100)
			ConValues <<- cbind(ConValues,CV01)
			}
		Gan <<-  0
		}
		

	##Save Ore and Gangue
	

	
	
	
	

		
	## Step 4e:  Create row of variables using above information
	PrintRow1 <<- c(SimIndex,NumDep,SimDepIndex,OreT,C1Values1,Gan,ConValues)
	
	## Step 4f:  Print row of variables in a new csv file (allow writable- so this is a loop)
	##write(PrintRow1,file = "EmpOut3.csv",append=TRUE,sep=",")

	TableMain[CountE1,] <- PrintRow1
	
	## Step 4g: create CountEF Row count up
	CountEFRow <<- (CountEFRow + 1)
	CountE1 <<- (CountE1 + 1)
	}
	

colnames(TableMain)<- Heading1

FileNameNewEmp <<- paste(TestNameEmp,"_EmpTable.csv",sep="")
Heading2 <<- cbind("EFRow0","Simulation.Index", "Number.of.Deposits","Sim.Deposit.Index","Ore_mT",CNameList0,"gangue",ConNameList0 )
write.table(Heading2,FileNameNewEmp, row.names=F, col.names=F, sep=",")


write.table(TableMain,file=FileNameNewEmp,sep=",",col.names=FALSE,append=TRUE) 
