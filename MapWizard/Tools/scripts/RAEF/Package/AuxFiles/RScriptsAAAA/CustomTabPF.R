
newmrr <- paste(InputFolder1,"/AuxFiles/ValueTabs/MillR.csv",sep="")
Mrr1 <- read.csv(file=newmrr, header=TRUE, sep=",")


	listP <<- ""
	dat1 <<- read.csv(SimFile , header = TRUE)
	NumLines <<- nrow(dat1)
	NumCols <<- ncol(dat1)
	ColNames1 <<- colnames(dat1)
	listGrades1 <<-""




	listGradesI <<- grep("_pct",ColNames1 )                                                                 ### records the column names of the SimFile that reads "_pct" , grade names in a list - listGradesI
	GradeNum <<- length(listGradesI)												  ### records the number of grades in the list-  GradeNum
	ListGradeNames<<- c()                                                                                   ### creates Grade names list - ListGradeNames 
	for (xx in listGradesI)                                                                                 ### for each grade in the list, add the name to the grade name list - ListGradeNames 
		{
		ListGradeNames<<- c(ListGradeNames,ColNames1[xx])
		}
	x <<- 1



MillCList <- c()
MillType5List <- c()
for (gn in ListGradeNames)
{
gn1 <- sub("._pct","",gn)
print (gn1)

if (gn1 == "Cu")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","SX_EW","User Define","None")	
gnV <- paste(gn1,"Mill",sep="")												  
}

if (gn1 == "Au")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","CCD", "CIP", "Au Heap Leach", "Au Float/Roast/Leach", "Au Free Milling","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")


}

if (gn1 == "Ag")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","CCD", "CIP", "Au Heap Leach", "Au Float/Roast/Leach","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
}

if (gn1 == "Mo")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
}

if (gn1 == "Ni")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
}

if (gn1 == "Zi")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
}

if (gn1 != "Zi" & gn1 !="Ni" & gn1 !="Mo"& gn1 !="Cu" & gn1 !="Au" & gn1 !="Ag")
{
CMills <- c("Select a mill option","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
}
MillCList <-c(MillCList, gnV)
}

countMMM <<- 37
for (millC in MillCList)
	{
	MillCCC<<- as.character(InputParTab[countMMM,3])
	assign(millC ,MillCCC, env = .GlobalEnv)
	print (MillCCC)
	countMMM <<- countMMM  + 1
	}







		for (cvb in MillCList)
			{
			CMValue1 <- svalue(cvb)
			assign(cvb,svalue(CMValue1), env = .GlobalEnv)
			}
 



