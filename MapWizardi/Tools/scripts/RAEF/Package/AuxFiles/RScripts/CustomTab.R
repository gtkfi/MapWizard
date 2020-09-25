CustomWindow <- gwindow("Customize")  
CW1 <- ggroup(horizontal= FALSE, container = CustomWindow )
CW2 <- ggroup(horizontal= FALSE, container = CW1 )
CW3 <- ggroup(horizontal= TRUE, container = CW1 )

newmrr <- paste(InputFolder1,"/AuxFiles/ValueTabs/MillR.csv",sep="")
Mrr1 <- read.csv(file=newmrr, header=TRUE, sep=",")
lbl_data_frame_name <- glabel("Please select a mill option for each commodity", container = CustomWindow )
lbl_data_frame_name <- glabel("You can only select up to 2 mill types", container = CustomWindow )

obj <- gbutton(                                                                                      
	text   = "Open Mill Metallurgical Recovery Rate Table",
      container=CustomWindow ,
      handler = function(h,...)
	{ 
#View(Mrr1)

	 obj <- gtable(Mrr1, container=CustomWindow )
 })

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
lbl_data_frame_name <- glabel(gn1, container = CW2 )	

if (gn1 == "Cu")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","SX_EW","User Define","None")	
gnV <- paste(gn1,"Mill",sep="")												  
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}

if (gn1 == "Au")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","CCD", "CIP", "Au Heap Leach", "Au Float/Roast/Leach", "Au Free Milling","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)

}

if (gn1 == "Ag")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","CCD", "CIP", "Au Heap Leach", "Au Float/Roast/Leach","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}

if (gn1 == "Mo")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}

if (gn1 == "Ni")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}

if (gn1 == "Zi")
{
CMills <- c("Select a mill option","3-Product","2-Product","1-Product","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}

if (gn1 != "Zi" & gn1 !="Ni" & gn1 !="Mo"& gn1 !="Cu" & gn1 !="Au" & gn1 !="Ag")
{
CMills <- c("Select a mill option","User Define","None")															  
gnV <- paste(gn1,"Mill",sep="")
assign(gnV,gcombobox(CMills, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = CW2 ), env = .GlobalEnv)
}
MillCList <-c(MillCList, gnV)
}

obj <- gbutton(                                                                                      
	text   = "Submit Mill Options",
      container=CustomWindow ,
      handler = function(h,...)
	{ 
		for (cvb in MillCList)
			{
			CMValue1 <- get(cvb)
			assign(cvb,get(CMValue1), env = .GlobalEnv)
			}
 	dispose(CustomWindow )
	})


