###############################################################################
##### Title:   Resource Assessment Economic Filter(RAEF)
##### Author:  Jason Shapiro
##### Date:    8/23/2017
##### Status:  Working draft 
###############################################################################
#############To Run- click edit- Run All  in RGUI#########################
###############################################################################

################################
##packages 
################################

library(gWidgets)
library(gWidgetstcltk)
library(dplyr)
library(reshape)
library(evaluate)
baseW <- gwindow("Input Package")
lbl_data_frame_name <- glabel(

  "Input Package Folder: ",
  container = baseW
)

obj <- gfilebrowse("Select folder ",type = "selectdir", cont=baseW)
addhandlerchanged(obj, handler=function(h,...) 
	InputFolder1 <<- get(h$obj))
obj <- gbutton(
	text   = "Launch Resource Assessment Economic Filter",
      container=baseW,
      handler = function(h,...)
	{
	setwd(InputFolder1)	




########################
### Starts TIMER 
ATime <<- Sys.time()
#################### 




#################################
## frames and windows 
#################################
win <- gwindow(width= 990)
#win <- ggroup(horizontal= FALSE,use.scrollwindow=TRUE, container = win0)

imageL <<- paste(InputFolder1,"/AuxFiles/Images/bnrglobe3.gif",sep="")
gimage(imageL , container = win)
grp_name <- ggroup(horizontal= TRUE, container = win)
grp2 <- ggroup(horizontal= FALSE,container = win)
tmp <- gframe("Output Working Directory Input", container=grp_name)
input <- gframe("Input Files",horizontal= FALSE,  container=grp_name)
input2 <- gframe("",horizontal= FALSE,container=input)
input3 <- gframe("",horizontal= FALSE, container=input)
input4 <- gframe("",horizontal= FALSE, container=input)
Box0 <- gframe("",horizontal= FALSE,container=grp_name)
BoxS <- gframe("",horizontal= FALSE,  container=grp_name)


####################################
## Input files dialog code
###################################

## econ simulation input
lbl_data_frame_name <- glabel("Econ Filter Simulation Input (File 05_Sim_EF): ",container = input2)
SimFile <<- gfilebrowse( text = "Select a file...", type = "open", container = input2)
addhandlerchanged(SimFile , handler=function(h,...){}) 



lbl_data_frame_name <- glabel(

  "Working Directory: ",
  container = input2
)

obj <- gfilebrowse("Select folder ",type = "selectdir", cont=input2)
addhandlerchanged(obj, handler=function(h,...) 
	wdir1 <<- get(h$obj))

obj <- gbutton(

	text   = "Set working directory",
      container=input2,
      handler = function(h,...)
	{
	setwd(wdir1)
	WD <<- getwd() 
	cat (WD)


	elogFileName <<- paste(WD,"/","RunLog.txt",sep="")
	elog1 <- file(elogFileName, open="wt")
	sink(elog1 , type="message")

	})

lbl_data_frame_name <- glabel("Test Name: ",container = input2)
testname1<<- gedit("test name",width = 13,container = input2)


############################################################################
## Creates error/warning log 
######################################################################




## create continue button 1 - user inputs 
obj <<- gbutton(text = "Continue - User Inputs",container=input2, handler = function(h,...)
	{
	SimFile <<-get(SimFile)
	
#################################
## User input- Intervals dialog  --  after "continue 1 " button clicked 
#################################
	
	input5 <- gframe("",horizontal= FALSE, container=input)
	
	TN1 <<- get(testname1)
	OutF1 <<- paste("EF_02_Output_",TN1,".csv", sep = "")

##############################
## Questions regarding deposit
##############################

lbl_data_frame_name <- glabel("Deposit Type?", container = input5)
	DTy <- gdroplist(c("Flat-bedded/stratiform", "Ore body massive / disseminated", "Vein deposit / steep" ), container = input5)

lbl_data_frame_name <- glabel("Tract Area [sqKm]?", container = input5)
	TA1 <- gedit("Enter Area",width = 15,container = input5)




#########################################
##  Depth interval input
##########################################

	lbl_data_frame_name <- glabel("Assessment Depth Interval",container = input5)   
## min interval
	lbl_data_frame_name <- glabel("Min", container = input5)
	MinTot <<- gedit("",width = 13,container = input5)

## max interval
	lbl_data_frame_name <- glabel("Max", container = input5)
	MaxTot <<- gedit("",width = 13,container = input5)

## number of intervals- which will determine the number of interval inputs 
	lbl_data_frame_name <- glabel("# of Intervals", container = input5)
	NumCat <- gdroplist(c("1","2", "3", "4"), container = input5)
	

## creates continue button 2-  adds the intervals 
obj <- gbutton(text   = "Continue",container=input5, 
	handler = function(h,...)
	{
	DTy <<- get(DTy)
	int1 <<- strtoi(get(NumCat ))
	NumCat <<- strtoi(get(NumCat))
	MinTot <<- strtoi(get(MinTot ))
	MaxTot <<- strtoi(get(MaxTot ))
	TA1 <<- strtoi(get(TA1 ))
	lbl_data_frame_name <- glabel("Enter Min/Max/Factor for each interval",container = input5 )
## lists 
	MinList <<- c()
	MaxList <<- c()
	PVList  <<- c()
	ObjAL <<- c()




## adds intervals based on the number of intervals entered - if statements 


if (int1 == 1)  
	{
	input5b <- gwindow("",horizontal= FALSE)
	ObjMin1 <<- gedit("Min",width = 13,container = input5b )
	ObjMax1 <<- gedit("Max",width = 13,container = input5b )
	ObjPer1 <<- gedit("Fraction",width = 13,container = input5b )
	}

if (int1 == 2) 
	{
	input5b <- gwindow("",horizontal= FALSE)
	lbl_data_frame_name <- glabel("Interval 1", container = input5b )
	ObjMin1 <<- gedit("Min",width = 13,container = input5b)
	ObjMax1 <<- gedit("Max",width = 13,container = input5b)
	ObjPer1 <<- gedit("Fraction",width = 13,container = input5b)
	lbl_data_frame_name <- glabel("Interval 2", container = input5b )
	ObjMin2 <<- gedit("Min",width = 13,container = input5b)
	ObjMax2 <<- gedit("Max",width = 13,container = input5b)
	ObjPer2 <<- gedit("Fraction",width = 13,container = input5b)
	}


if (int1 == 3) 
	{
	input5b <- gwindow("",horizontal= FALSE)
		lbl_data_frame_name <- glabel("Interval 1", container = input5b )
	ObjMin1 <<- gedit("Min",width = 13,container = input5b)
	ObjMax1 <<- gedit("Max",width = 13,container = input5b)
	ObjPer1 <<- gedit("Fraction",width = 13,container = input5b)
		lbl_data_frame_name <- glabel("Interval 2", container = input5b )
	ObjMin2 <<- gedit("Min",width = 13,container = input5b)
	ObjMax2 <<- gedit("Max",width = 13,container = input5b)
	ObjPer2 <<- gedit("Fraction",width = 13,container = input5b)
		lbl_data_frame_name <- glabel("Interval 3", container = input5b )
	ObjMin3 <<- gedit("Min",width = 13,container = input5b)
	ObjMax3 <<- gedit("Max",width = 13,container = input5b)
	ObjPer3 <<- gedit("Fraction",width = 13,container = input5b)
	}

if (int1 == 4) 
	{
	input5b <- gwindow("",horizontal= FALSE)
		lbl_data_frame_name <- glabel("Interval 1", container = input5b )
	ObjMin1 <<- gedit("Min",width = 13,container = input5b)
	ObjMax1 <<- gedit("Max",width = 13,container = input5b)
	ObjPer1 <<- gedit("Fraction",width = 13,container = input5b)
		lbl_data_frame_name <- glabel("Interval 2", container = input5b )
	ObjMin2 <<- gedit("Min",width = 13,container = input5b)
	ObjMax2 <<- gedit("Max",width = 13,container = input5b)
	ObjPer2 <<- gedit("Fraction",width = 13,container = input5b)
		lbl_data_frame_name <- glabel("Interval 3", container = input5b )
	ObjMin3 <<- gedit("Min",width = 13,container = input5b)
	ObjMax3 <<- gedit("Max",width = 13,container = input5b)
	ObjPer3 <<- gedit("Fraction",width = 13,container = input5b)
		lbl_data_frame_name <- glabel("Interval 4", container = input5b )
	ObjMin4 <<- gedit("Min",width = 13,container = input5b)
	ObjMax4 <<- gedit("Max",width = 13,container = input5b)
	ObjPer4 <<- gedit("Fraction",width = 13,container = input5b)
	}


## create continue 3 button - goes to the mine methods and environment choices 


Min2 <<- 0
Max2 <<- 0
Per2 <<- 0

Min3 <<- 0
Max3 <<- 0
Per3 <<- 0

Min4 <<- 0
Max4 <<- 0
Per4 <<- 0

	obj <- gbutton(text   = "Continue - Mine Methods",container=input5b, 
	handler = function(h,...)
	{

## saves the interval information - based on how many intervals
	if (int1 == 1) 
		{
		Min1 <<- strtoi(get(ObjMin1))
		Max1 <<- strtoi(get(ObjMax1))
		Per1 <<- as.double(get(ObjPer1))
		}
	if (int1 == 2) 
		{
		Min1 <<- strtoi(get(ObjMin1))
		Max1 <<- strtoi(get(ObjMax1))
		Per1 <<- as.double(get(ObjPer1))
		Min2 <<- strtoi(get(ObjMin2))
		Max2 <<- strtoi(get(ObjMax2))
		Per2 <<- as.double(get(ObjPer2))
		}
	if (int1 == 3) 
		{
		Min1 <<- strtoi(get(ObjMin1))
		Max1 <<- strtoi(get(ObjMax1))
		Per1 <<- as.double(get(ObjPer1))
		Min2 <<- strtoi(get(ObjMin2))
		Max2 <<- strtoi(get(ObjMax2))
		Per2 <<- as.double(get(ObjPer2))
		Min3 <<- strtoi(get(ObjMin3))
		Max3 <<- strtoi(get(ObjMax3))
		Per3 <<- as.double(get(ObjPer3))		
		}
	if (int1 == 4) 
		{
		Min1 <<- strtoi(get(ObjMin1))
		Max1 <<- strtoi(get(ObjMax1))
		Per1 <<- as.double(get(ObjPer1))
		Min2 <<- strtoi(get(ObjMin2))
		Max2 <<- strtoi(get(ObjMax2))
		Per2 <<- as.double(get(ObjPer2))
		Min3 <<- strtoi(get(ObjMin3))
		Max3 <<- strtoi(get(ObjMax3))
		Per3 <<- as.double(get(ObjPer3))	
		Min4 <<- strtoi(get(ObjMin4))
		Max4 <<- strtoi(get(ObjMax4))
		Per4 <<- as.double(get(ObjPer4))	
		}



 

## creates the environemnt / metrhods dialog
		input5 <- gframe("",horizontal= TRUE, container=Box0 )
	input6 <- gframe("",horizontal= TRUE, container=Box0 )
	input7 <- gframe("",horizontal= TRUE, container=Box0 )
	input66 <- gframe("",horizontal= FALSE, container=input6 )
	input62 <- gframe("",horizontal= FALSE, container=input6 )
## creates - mine method check list - based on the deposit type and the depth levels 

	if ( DTy == "Vein deposit / steep")
		{
		minetypes <<- c("Cut-and-Fill", "Sublevel Longhole", "Vertical Crater Retreat")
		}

	if ( DTy == "Flat-bedded/stratiform")
		{
			if (MinTot <= 200) 
				{
				minetypes <<- c("Open Pit","Room-and-Pillar")
				}
			if (MinTot > 200) 
				{
				minetypes <<- c("Room-and-Pillar")
				}
		}

	if ( DTy == "Ore body massive / disseminated")
		{
		minetypes <<- c("Open Pit", "Block Caving")
		}
	#minetypes <<- c("Open Pit", "Block Caving", "Cut-and-Fill", "Room-and-Pillar", "Shrinkage Stope", "Sublevel Longhole", "Vertical Crater Retreat")
	lbl_data_frame_name <- glabel("Select Mine methods -up to 2",container = input5 )
	MT <<- gcheckboxgroup(minetypes, checked = FALSE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)



## creates mill type check box:

	milltypes <<- c("Autoclave CIL-EW", "CIL-EW", "CIP-EW", "CCD-MC", "Float-Roast-Leach", "Flotation, 1 Product", "Flotation, 2 Product","Flotation, 3 Product", "Gravity", "Heap Leach", "Solvent Extraction") 

	lbl_data_frame_name <- glabel("Select Mill Types ",container = input5 )
	MillTypes <<- 0
	MillType <<- gcheckboxgroup(milltypes, checked = FALSE, horizontal = FALSE, use.table=FALSE,handler = NULL, action = NULL, container = input5)





## creates continue 4 button - submit and run
	obj <- gbutton(text   = "Submit Mine Methods and Mill Type", container=input5, 
	handler = function(h,...)
	{
	MineTypes <<- get(MT )
	#DTy <<- get (DTy)
	MillT <<- get(MillType) 
	MineMethod <<- MineTypes
	## creates environment check box
	
	## creates days of operation choice
	lbl_data_frame_name <- glabel("Days of Operation?",container = input66)
	lbl_data_frame_name <- glabel("Full Time (350), Restricted Time (270)",container = input66 )
	DO <<- c("350", "270")
	days <<- gradio(DO , container=input66)


########################################
### Sets PVD to 0 , for start
############################################
PVD2 <<- 0
PVD3 <<- 0 


################################
### Environemnt choices based on mine type -  Tailings Pond, Dam and Liners
#########################################

## Sets EnvC - 0 as base value 


	if (MineTypes[1] == "Open Pit") 
		{ lbl_data_frame_name <- glabel( "Select Environmental Choices ", container = input62)
	EnvC <<- c("Tailings Pond and Dam", "Liner")
	EnvType<<- gcheckboxgroup(EnvC, checked = FALSE, horizontal = FALSE, use.table=FALSE,
	handler = NULL, action = NULL, container = input62)}


	if (MineMethod[1] == "Block Caving") 
		{ lbl_data_frame_name <- glabel( "Select Environmental Choices ", container = input62)
	EnvC <<- c("Tailings Pond and Dam", "Liner")
	EnvType<<- gcheckboxgroup(EnvC, checked = FALSE, horizontal = FALSE, use.table=FALSE,
	handler = NULL, action = NULL, container = input62)}

	if (MineMethod[1] == "Room-and-Pillar") 
		{ lbl_data_frame_name <- glabel( "Select Environmental Choices ", container = input62)
	EnvC <<- c("Tailings Pond and Dam", "Liner")
	EnvType<<- gcheckboxgroup(EnvC, checked = FALSE, horizontal = FALSE, use.table=FALSE,
	handler = NULL, action = NULL, container = input62)}


	addHandlerClicked(days, handler=function(h,..){})
## creates continue 4 button - submit and run
	obj <- gbutton(text   = "Continue", container=input7, 
	handler = function(h,...)
	{
	ECh <<- get(EnvType)

	

##################################################
### Registering/ using the envrionement choices 
##################################################
##  create TPD variable - 1 if yes to tailings pond or 0 if not  
##  create Liner variable - 1 if yes to liner or 0 if not  
TPD <<- 1
Liner <<- 1
if (is.na(ECh[1]) == "TRUE") { TPD <<- 0}
if (is.na(ECh[2]) == "TRUE") { Liner <<- 0}
if (is.na(ECh[1]) == "TRUE") { Liner <<- 0}


#######################################################
###Marshall Swift Composite CE 1989-2008 avg in 2008$
MSC <<- 1.26
########################################################


####################################################
## Cost inflation factor  - Captial cost and operating cost 
CCIF <<- 1.00
OCIF <<- 1.00
#######################################################



##################################################	
## creats calculation and submission dialog 
#################################################

	EnvT <<- get(EnvType)
	dpy <<- as.double(get(days))

###########################################################
## creates submit button - and runs the processes 
#####################################################
	
##create BoxS1 frame
## Create BoxS1A - will iclude download paramters and submit
## create BoxS1B  -- will include download stats 
BoxS1CC <- gframe("Changes to Defaults",horizontal= FALSE, container=BoxS)

BoxS1A <- gframe("Run Steps",horizontal= FALSE, container=BoxS)

BoxS1B <- gframe("Download Stats",horizontal= FALSE, container=BoxS)
BoxS1C <- gframe("Finish Process?",horizontal= FALSE, container=BoxS)
obj <- gbutton(
	text   = "Change Default MSC (1.26)",
      container= BoxS1CC ,
      handler = function(h,...)
	{
	input5cc <- gwindow("",horizontal= FALSE)
	ObjMSC <<- gedit("1.26",width = 13,container = input5cc )
	obj <- gbutton(
	text   = "Confirm MSC Change",
      container= input5cc ,
      handler = function(h,...)
	{	
	MSC <<- as.double(get(ObjMSC))
	}
	)
	}
	)
obj <- gbutton(
	text   = "Change Operating Cost Inflation Factor(1)",
      container= BoxS1CC ,
      handler = function(h,...)
	{
	input5cc <- gwindow("",horizontal= FALSE)
	ObjOCIF <<- gedit("1",width = 13,container = input5cc )
	obj <- gbutton(
	text   = "Confirm OCIF Change",
      container= input5cc ,
      handler = function(h,...)
	{	
	IF <<- as.double(get(ObjOCIF))
	}
	)
	}
	)
obj <- gbutton(
	text   = "Change Cap Cost Inflation Factor(1)",
      container= BoxS1CC ,
      handler = function(h,...)
	{
	input5cc <- gwindow("",horizontal= FALSE)
	ObjCCIF <<- gedit("1",width = 13,container = input5cc )
	obj <- gbutton(
	text   = "Confirm CCIF Change",
      container= input5cc ,
      handler = function(h,...)
	{	
	IF <<- as.double(get(ObjCCIF))
	}
	)
	}
	)

obj <- gbutton(
	text   = "Download Parameters",
      container= BoxS1A,
      handler = function(h,...)
	{
	date1 <<- Sys.Date()
	date2 <<- format(date1,"%a %b %d %Y")
	time1 <<- Sys.time()
	time2 <<- format(time1, "%X ")
	
	##add econ file siumlation file input addres

	ECh <<- get(EnvType)

	RS1 <- rbind (date2,time2, SimFile, WD, TN1, NumCat, Min1, Max1, Per1, Min2, Max2, Per2, Min3, Max3, Per3, Min4, Max4, Per4, DTy, MineMethod[1], MineMethod[2], MineMethod[3], MillT[1],MillT[2], dpy, ECh[1],ECh[2], MSC, CCIF, OCIF, TA1    )
	rownames(RS1) <- c("Date", "Time", "Econ Filter File", "Working Directory", "Test Name", "Number of Depth Intervals", "Min1", "Max1", "Per1", "Min2", "Max2", "Per2", "Min3", "Max3", "Per3", "Min4", "Max4", "Per4","Deposit Type", "Mine Method 1", "Mine Method 2", "Mine Method 3","Mill Type 1 ", "Mill Type 2 ","Days of Operation", "Environment Choice 1 ","Liner?", "MSC", "Cap Cost Inflation Factor", "Operating Cost Inflation Factor", "Area")
filename <- paste("EF_01_Parameters_",TN1,".csv", sep ="")	
write.csv(RS1, file = filename , row.names=TRUE)
})


##Rcode file names
R0001 <<- paste(InputFolder1,"/AuxFiles/RScripts","/agg1.r", sep="")  
R0002 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CStatsR.r", sep="")  
R0003 <<- paste(InputFolder1,"/AuxFiles/RScripts","/DStatR.r", sep="")  
R0004 <<- paste(InputFolder1,"/AuxFiles/RScripts","/D10R.r", sep="")  
R0005 <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes2int.r", sep="")  
R0005b <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes3int.r", sep="")  
R0005c <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes4int.r", sep="")  
R0005d <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes1int.r", sep="")  
R0006 <<- paste(InputFolder1,"/AuxFiles/RScripts","/dcat1.r", sep="")  

obj <- gbutton(
	text   = "Aggregate Deposits - Sims",
      container= BoxS1B,
   handler = function(h,...)
	{
	   source(R0001)
	})



obj <- gbutton(
	text   = "Contained Stats",
      container= BoxS1B,
   handler = function(h,...)
	{
	  source(R0002) 
	})



obj <- gbutton(
	text   = "Depth Stats",
      container= BoxS1B,
   handler = function(h,...)
	{
 source(R0003)

	})


obj <- gbutton(
	text   = "10 Cat- Depth Stats",
      container= BoxS1B,
   handler = function(h,...)
	{
	
source(R0004)

	})

obj <- gbutton(
	text   = "Depth - Mine Type Stats",
      container= BoxS1B,
   handler = function(h,...)
	{
if (int1 == 2)
{
rapply((evaluate(file(R0005)))) 
}

if (int1 == 3)
{
rapply((evaluate(file(R0005b)))) 
}

if (int1 == 4)
{
rapply((evaluate(file(R0005c)))) 
}

if (int1 == 1)
{
rapply((evaluate(file(R0005d)))) 
}
	})

obj <- gbutton(
	text   = "10 Cat- Depth - Mine Type Stats",
      container= BoxS1B,
   handler = function(h,...)
	{
	
source(R0006)

	})

obj <- gbutton(
	text   = "Finish Process?",
      container= BoxS1C,
   handler = function(h,...)
	{
	file1a <<- paste(TN1,"_Depth10Agg5.csv",sep="")
	file2a <<- paste(TN1,"_DepthCat_Aggregated_Totals.csv",sep="")
	file3a <<- paste(TN1,"_DepthCat10_Agg_Totals8.csv",sep="")

file.remove(file1a)
file.remove(file2a)
file.remove(file3a)

	})



obj <- gbutton(text   = "Submit",container=BoxS1A, 
	handler = function(h,...)
		{

##Reads the SimEF file
	listP <<- ""
	dat1 <<- read.csv(SimFile , header = TRUE)
	NumLines <<- nrow(dat1)
	NumCols <<- ncol(dat1)
	ColNames1 <<- colnames(dat1)
	listGrades1 <<-""



##################################################
## list of all Grades
#################################################
	listGradesI <<- grep("_pct",ColNames1 )
	GradeNum <<- length(listGradesI)
	ListGradeNames<<- c()
	for (xx in listGradesI)
		{
		ListGradeNames<<- c(ListGradeNames,ColNames1[xx])
		}
	x <<- 1



NumGrades0 <<-length(ListGradeNames) ####number of grades 
MineNum001 <<- length(MineTypes) 

DepthM <<- 0	
KoE <<- 0


###############################################################################################
##### printing headings before analysis 
####################################################################################################	

	

## creating name list of contained for heading 
cList00 <<-c()
for( gi in ListGradeNames)
	{
	h00 <-paste("Contained_",gi,sep="")
	h200 <- sub("_pct", 'Tons', h00)
	cList00 <- c(cList00 , h200)
	}


## creating name list of recovered for heading 

rList0 <<-c()
for( gir in ListGradeNames)
	{
	r <<-paste("Recovered_",gir,sep="")
	r2 <- sub("_pct", 'Tons', r)
	rList0 <<- c(rList0 , r2)
	}


### creating names for OreV
G1 <<- 1
OVPECList2 <<- c()
for (gh in ListGradeNames)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	OVPECList2 <<- c(OVPECList2,zG)
	G1 <<- G1 + 1
	}


if (MineNum001 == 1)
{

#### creates a heading list based on the number of greades- if statements 

if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],"OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","NPV_Tract","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1], rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD" , "NPV_Tract","NPV_Area", "BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}


if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],OVPECList2[6],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5], ListGradeNames[6],  cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}

}


if (MineNum001 == 2)
{

#### creates a heading list based on the number of greades- if statements 

if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1], "OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1],  rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract","NPV_Area", "BestMMethod",ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] ,"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3],  cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}


if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract", "NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}




if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],  rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5], OVPECList2[6],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","NPV_Tract","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],ListGradeNames[6],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}

}


write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)


################################################################
## reads each of the lines in the SimEF file- line by line 
###########################################################


while (x < (NumLines + 1))
	{
	NumDep <<- dat1[x,3]

#######################################
############ Checks to see if the record has 0 deposits ,if so sets variables to 0 
#########################################
	if (NumDep == 0) 
		{
		SimIndex <<- dat1[x,2]
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- ""
		listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, NA1)
		write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)
		}
######################################
#### Checks to see if Num of deposits > 0
###########################################
	if (NumDep > 0) 
		{
		
###########################################
## saves the key info from the SimEF file 
#########################################
		SimIndex <<- dat1[x,2]
	
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- "FALSE"
############################################
## If zero num deposits-  program says skip 
#############################################
           
	Ton <<- dat1[x,5]

########################################################################################
## Grades ******************************************************************************************************
################################################################################################
	GradeNumM2 <<- GradeNum + 1
	y <<- 1
	z2 <- 6
	while (y < GradeNumM2)
		{

		##assigining the grade values to the grade names
 		assign(ListGradeNames[y], dat1[x,z2] )
		y<<- (y +1)
		z2 <<- z2+1

		}

########################
## Short Tons and Life Calculations
#######################

## ShortTons
	ShortTons <<- (Ton/0.907185)
## Life 	
	Life <<- 0.2 * (ShortTons)^0.25
	MineMethod <<- MineTypes
#############################
## Random number calc for depth
################################
####1 Select a category using the progbabiltiy

	if (int1 == 1) 
		{
		SA <<- sample(c(1:1), size=1, replace=TRUE, prob=c(1))
		}
	if (int1 == 2) 
		{
		SA <<- sample(c(1:2), size=1, replace=TRUE, prob=c(Per1, Per2))
		}

	if (int1 == 3) 
		{
		SA <<- sample(c(1:3), size=1, replace=TRUE, prob=c(Per1, Per2, Per3))
		}

	if (int1 == 4) 
		{
		SA <<- sample(c(1:4), size=1, replace=TRUE, prob=c(Per1, Per2,  Per3, Per4))
		}

###2 find random number based on the category

	if (NumCat == 1) 
	{
	if (SA == 1) { Num <<- sample(c(Min1:Max1), size =1, replace=TRUE )}
	}

	if (NumCat == 2) 
	{
	if (SA == 1) { Num <<- sample(c(Min1:Max1), size =1, replace=TRUE )}
	if (SA == 2) { Num <<- sample(c(Min2:Max2), size =1, replace=TRUE)}
	}

	if (NumCat == 3) 
	{
	if (SA == 1) { Num <<- sample(c(Min1:Max1), size =1, replace=TRUE )}
	if (SA == 2) { Num <<- sample(c(Min2:Max2), size =1, replace=TRUE)}
	if (SA == 3) { Num <<- sample(c(Min3:Max3), size =1, replace=TRUE)}
	}

	if (NumCat == 4) 
	{
	if (SA == 1) { Num <<- sample(c(Min1:Max1), size =1, replace=TRUE )}
	if (SA == 2) { Num <<- sample(c(Min2:Max2), size =1, replace=TRUE)}
	if (SA == 3) { Num <<- sample(c(Min3:Max3), size =1, replace=TRUE)}
	if (SA == 4) { Num <<- sample(c(Min4:Max4), size =1, replace=TRUE)}
	}

## save depth variable 
	Depth <<- Num


#
##
#########
######################
#############################################
############################################################################
########################################################################################################
### if statements for each mine method 
### it will create unique results/ variables for each selected mine method  -  to asllow for comparsion at end 
## if mine method 1 == true dp first set    if is.na(minemethod[1] == "FALSE")
## if mine method 2 == true, do second set  if is.na(minemethod[2] == "FALSE")
## if mine method 3 == true, do third set   if is.na(minemethod[3] == "FALSE")
#########################################################################################################################
#########################################################################
############################################
####################
###########
###
#
##############################################################
###################################  Mine Method 1
#########################################################


MineMethod <<- MineTypes[1]

#######################################################
#### calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
###  calculations based on each mine method 
#####################################################

SR <<- "NA"

if (MineMethod == "Open Pit")
{
DF <<- .05
RF <<- .90
MOTRF <<-  ((1 + DF) * RF )
DepthM <<- (0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel
SR <<- ((2.225 * 4.1 * (DepthM^3 / ShortTons ) - 1))
if (dpy == 350) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/70}
if (dpy == 260) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/52}


	if (Cm < 20000) 
		{ 
		Kc <<- 160000 * Cm^0.515
		Ko <<- 71.0 * Cm^(-0.414)
		MOCpy <<- (Cm * Ko * dpy)  ## OP mine operating costs per year
		}
	if (Cm > 20000) 
		{ 
		Kc <<- 2670 * Cm^0.917
		Ko <<- 5.14 * Cm^(-0.148)
		MOCpy <<- (Cm * Ko * dpy) ## OP mine operating costs per year
		}
}
	if (MineMethod == "Block Caving") 
		{ 
		DF <<- .15
		RF <<- .95
		MOTRF <<-  ((1 + DF) * RF )
		DepthM <<- ( 0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel- usaing same equation at Open Pit
		T <- (ShortTons * RF * (1+ DF))
		if (dpy == 350) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/52}
		KcA <<- 64800 * Cm^0.759
		KcB <<- 371 * Cm + 180 * 3 * DepthM* Cm^.404    ## UG deph captial cost
		Kc <<- KcB + KcA
		KoA <<- ((2343/Cm) + 0.44 * 3.2808 * Depth/Cm + 0.00163 * 3.2808 * Depth)  ## UG deptrh operating costs
		KoB <<- 48.4 *Cm^(-0.217)	
		Ko <<- KoA + KoB
		MOCpy <<- (Cm * Ko * dpy) ## BC mine operating costs per year
		}

	if (MineMethod == "Cut-and-Fill") 
		{ 
		DF <<- .05
		RF <<- .85
		MOTRF <<- ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		Cm <<- T/(Life * dpy)
		Kc <<- 1250000 * Cm^0.644
		Ko <<- 279.9 * Cm^(-0.294)
		}

	if (MineMethod == "Room-and-Pillar") 
		{ 
		DF <<- .05
		RF <<- .85
		MOTRF <<-  ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		Cm <<-(((0.05 + 1) * (MOTRF * ShortTons))^0.75)/70
		
		DCalc001 <<- (0.114*((ShortTons)^(1/3))+Depth)
		if(DCalc001  < 6) { SDepth <<- 6 }
		if(DCalc001 >=6) {SDepth <<-DCalc001}
		KcA <<- 97600 * Cm^0.644   ## UG Room and Pillar capital cost
		KcB <<- 371 * SDepth + 180 * 3.2808 * SDepth * Cm^.404    ## Underground mine depth capital cost
		Kc <<- KcB + KcA ## Room Pillar capital cost
		KoA <<- 35.5 * Cm^(-0.171)  ## RP OC ($/st)
		KoB <<- ((2343/Cm)+0.44*3*Depth/Cm+0.00163*3*Depth) ## UG Depth OC($/st)
		Ko <<- KoA + KoB ### RP Mine Operating ($/st)
		MOCpy <<- (Cm * Ko * dpy)  ## mine operating costs per year
		DepthM  <<- SDepth 
		}

	if (MineMethod == "Shrinkage Stope") 
		{ 
		DF <<- .10
		RF <<- .90
		MOTRF <<- ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		Cm <<- T/(Life * dpy)
		Kc <<- 179000 * Cm^0.620
		Ko <<- 74.9 * Cm^(-0.160)
		}

	if (MineMethod == "Sublevel Longhole") 
		{ 
		DF <<- .15
		RF <<- .85
		MOTRF <<- ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		Cm <<- T/(Life * dpy)
		Kc <<- 115000 * Cm^0.552
		Ko <<- 41.9 * Cm^(-0.181)
		}

	if (MineMethod == "Vertical Crater Retreat") 
		{ 
		DF <<- .10
		RF <<- .90
		MOTRF <<- ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		Cm <<- T/(Life * dpy)
		Kc <<- 45200 * Cm^0.747
		Ko <<- 51.0 * Cm^(-0.206)
		}


### environment type equations 
#############################################
### Calcualtes Mill equations 
###########################################
## cpacity mill
if (dpy == 350) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 52)}
###Cml <<- ShortTons/dpy  - old Cml


### mill type equations 
	MillNum<<- 1   ## base number for mill num,ber temproarily  ***********************************

	if (MillT == "Autoclave CIL-EW") 
		{ 
		KcM <<- 96500 * Cml^0.770
		KoM <<- 78.1 * Cml^(-0.196)
		MillNum <<- 2
		
		}	

	if (MillT == "CIL-EW") 
		{ 
		KcM <<- 50000 * Cml^0.745
		KoM <<- 84.2 * Cml^(-0.281)
		}	

	if (MillT == "CIP-EW") 
		{ 
		KcM <<- 372000 * Cml^0.540
		KoM <<- 105 * Cml^(-0.303)
		}	

	if (MillT == "CCD-MC") 
		{ 
		KcM <<- 414000 * Cml^0.584
		KoM <<- 128 * Cml^(-0.300)
		MillNum <<- 2
		}	

	if (MillT == "Float-Roast-Leach") 
		{ 
		KcM <<- 481000 * Cml^0.552
		KoM <<- 101 * Cml^(-0.246)
		MillNum <<- 5
		}	

	if (MillT == "Flotation, 1 Product") 
		{ 
		KcM <<- 92600 * Cml^0.667
		KoM <<- 121 * Cml^(-0.335)
		MillNum <<- 8
		}
	
	if (MillT == "Flotation, 2 Product") 
		{ 
		KcM <<- 82500 * Cml^0.702
		KoM <<- 149 * Cml^(-0.356)
		MillNum <<- 9 
		}	

	if (MillT == "Flotation, 3 Product") 
		{ 
		KcM <<- 83600 * Cml^0.708
		KoM <<- 153 * Cml^(-0.344)
		MillNum <<- 11
		}	

	if (MillT == "Gravity") 
		{ 
		KcM <<- 135300 * Cml^0.529
		KoM <<- 67.8 * Cml^(-0.364)
		}	

	if (MillT == "Heap Leach") 
		{ 
		KcM <<- 296500 * Cml^0.512
		KoM <<- 31.5 * Cml^(-0.223)
		MillNum <<- 4
		}	

	if (MillT == "Solvent Extraction") 
		{ 
		KcM <<- 14600 * Cml^0.596
		KoM <<- 3.0 * Cml^(-0.145)
		}	


######################################################################################################
#####################################
#######
#

##CREATE LIST OF GRADE NAMES USING CV LISTnames 

GCVList <<- c() 
for (u in ListGradeNames) 
{

gcv1 <<- sub("._pct", "", u )
GCVList <<- c(GCVList , gcv1) 
}


####################################################################################################################
###  Metallogical Recovery Rate for each commdoity -  inputs table -  using mill type choice
#################################################################




FileinMR <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/MillR.csv", sep="")  
MillRR <<- read.csv(FileinMR )   ## input table with grades, metal recovery 

CRList <<- c() 
for (u in ListGradeNames) 
{
z9<<- paste ("CMMRR",u,sep="")
CRList <<- c(CRList, z9) 

}


un <<- 1
for (h9 in CRList)
{
assign(h9, MillRR[un,MillNum], env = .GlobalEnv)  
un <<- un + 1

}

#### make MR use list

MRUseList <<- c()
for (COA in  CRList)
{
for (z7 in GCVList)
{
g777 <<- paste("CMMRR",z7,"._pct",sep="")
if (COA == g777 )
{
MRValue000 <<- get(COA)
MRValue000 <<- as.double(MRValue000)
assign(g777, MRValue000,env = .GlobalEnv)
MRUseList <<- c(MRUseList,g777)
}
}
}



####################################################################################################################
###  Commodity values input -  inputs table -  using mill type choice
#################################################################


## crate variable names for the CV List Table Commodity Value
FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
CVS <<- read.csv(FileinCV , header= FALSE)   ## input table with commodity values
un <<- 1
CVList <<- c() 
for (u in CVS[1,]) 
{

z7777 <<- paste ("CV_",u,sep="")
a1 <<-CVS[2,un]
a2  <<- get(a1)
a3 <<- matrix(unlist(a2))
a4 <<- as.double(a3)

assign(z7777, a4, env = .GlobalEnv)  
CVList <<- c(CVList , z7777) 
un <<- un + 1
}




## create names to use based on equal of grade names and cv names above 

CVUseList <<- c()
 for (u0000 in CVList) 
{
for (z5 in GCVList)
{

gg00 <<- paste("CV_",z5,sep="")

if (u0000 == gg00)
{
h000 <<- get(u0000)
assign(gg00, h000, env = .GlobalEnv)  
CVUseList <<- c(CVUseList , gg00) 
}
}
}


###################################################
## Records grades 
##################################################
GradeData <<- read.csv(SimFile)
unn <<- 6
for (uuu in ListGradeNames) 
{
assign(uuu, GradeData[x,unn], env = .GlobalEnv)
unn <<- unn + 1
}


##############################################
### ValuePerEachComoodity in Ore -Rob Equation 
################################################
G1 <<- 1
OVPECList <<- c()
for (gh in CVUseList)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	VPEC <<- ( 0.90715 * (get(CVUseList[G1])) * get(MRUseList[G1]) * (get(ListGradeNames[G1]) / 100) )
	assign(zG,VPEC, env =.GlobalEnv)
	OVPECList <<- c(OVPECList,zG)
	G1 <<- G1 + 1
	}


########################################
#### Value of Ore Calculation 
#############################################\

un <<- 1
OreGradeV <<- c() 
for (u in ListGradeNames) 
{
z<<- paste ("OGV",u,sep="")
OreGradeV <<- c(OreGradeV , z) 
un <<- un + 1
}

numL <<- 1
for (gg9 in OreGradeV) 
{
a <<- MRUseList[numL]
f <<- get(a)
b <<- CVUseList[numL] 
c0 <<- ListGradeNames[numL]

g <<- get(b)
d <<- get(c0)
e <<- (d /100) 
MATH1 <<-(f * g * e) 
assign(gg9, MATH1, env = .GlobalEnv)
numL <<- numL + 1
}


OreV <<- 0
OreV1  <<- 0
for (gg99 in OreGradeV) 
{
OreV1 <<- OreV1 + get(gg99)
}

OreV <<-  0.90715 * OreV1 


###############################################
## Calculating CuEQ%   
##############################################

C000 <<- CVList[1] 
c111 <<- get(C000)
c1010 <<- as.double(c111)
c222 <<- get(CMMRRCu._pct)
CuEQ <<- (100 * (1/0.90715)* OreV / ( c222 * c1010) )


######################################################
 ## mill operating costs per year
#############################################
MillOCpy <<- (Cml * KoM * dpy)


########################################################
###  Calculation on the smelting cost 
########################################################
SmeltC <<- (0.26 * (2000 * ShortTons * (CuEQ/100) *  RF * CMMRRCu._pct) / Life)


#####################################################
##  Total operating Costs Per Year
############################################################

TotalOCpy <<- (MSC * OCIF * (SmeltC + MOCpy + MillOCpy))


##################################################
#### Calcualtes environment costs 
##################################################


## Tailings Pond
			
			if (Life < 7.5) 
				{ 
				TpKt <<- 17
				}
			if ( Life > 7.5)
				{ 
					if (Life  < 15)
						{
						TpKt <<- 32
						}
				}
			if ( Life > 15)
				{ 
				TpKt <<- 62
				}
			


		TpAtp <<- TpKt *(Cml/1000)
		TpDl <<- 4 * (43560 * TpAtp)^0.5
		TpKoE <<- 146000 + 1783 * TpAtp
		
 
## Dam 

	 
		if ( Life < 7.5) 
			{
			DKt <<- 17
			}
		if ( Life > 7.5)
			 { 
			if (Life  < 15)
				{ 
				DKt <<- 32
				}
			}
		if ( Life > 15)
			 { 
			 DKt <<- 62
			 }
		DAtp <<- DKt * (Cml/1000)
		DDl <<- 4 * (43560 * DAtp)^0.5
		DKoE <<- 161 * DDl
	

## Liner 
	
		if ( Life < 7.5)
			{ 
			LKt <<- 17
			}
		if ( Life > 7.5)
			{ 
			if (Life  < 15)
				{ 
				LKt <<- 32
				}
			 }
		if ( Life > 15)
			 { 
			 LKt <<- 62
			 }
		LAtp <<- LKt *(Cml/1000)
		LDl <<- 4 * (43560 * LAtp)^0.5
		LKoE <<- 5 * LDl +  35790 * LAtp
	




#########################################################
##  Total Capital costs
########################################################

TKC <<- (( Kc + TPD*(TpKoE + DKoE) + (Liner * LKoE) + KcM) * MSC * CCIF) ## Total capital costs 
TKCpst <<- TKC/ ShortTons #### Total capital costs per short ton


#####################################################
##  Value Prod $/a
#####################################################

VP <<- ((OreV * Cml * dpy) - TotalOCpy)




#####################################################
## Present Value
#####################################################
pmt <<- VP  # payments - value prod
rate <<- 0.15   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate

PV <<- P02 * pmt  # total present value



##########################################################
## Present Value Deposit
##########################################################
PVD <<- PV - TKC 


### Ends method 1 calcualtion  
#############################################################################################################################################################################################################################
####
#####
###################
####################################
##########################################################
###############################################################################
###############################################################################################################
## Mine Method 2 calcualtion  
###############################################################################################################


if (!is.na(MineTypes[2]))
	{
	MineMethod2 <<- MineTypes[2]


#######################################################
#### calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
###  calculations based on each mine method 
#####################################################

SR2 <<- "NA"
MOCpy2 <<- 0
if (MineMethod2 == "Open Pit")
{
DF2 <<- .05
RF2 <<- .90
MOTRF2 <<-((1 + DF2) * RF2 )
DepthM2 <<- (0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel
SR2 <<- ((2.225 * 4.1 * (DepthM2^3 / ShortTons ) - 1))
if (dpy == 350) { Cm2 <<- (((SR2 + 1) * (MOTRF2  * ShortTons))^0.75)/70}
if (dpy == 260) { Cm2 <<- (((SR2 + 1) * (MOTRF2  * ShortTons))^0.75)/52}


	if (Cm2 < 20000) 
		{ 
		Kc2 <<- 160000 * Cm2^0.515
		Ko2 <<- 71.0 * Cm2^(-0.414)
		MOCpy2 <<- (Cm2 * Ko2 * dpy)  ## OP mine operating costs per year
		}
	if (Cm2 > 20000) 
		{ 
		Kc2 <<- 2670 * Cm2^0.917
		Ko2 <<- 5.14 * Cm2^(-0.148)
		MOCpy2 <<- (Cm2 * Ko2 * dpy) ## OP mine operating costs per year
		}
}



	if (MineMethod2 == "Block Caving") 
		{ 
		DF2 <<- .15
		RF2 <<- .95
		MOTRF2 <<- ((1 + DF2) * RF2 )
		DepthM2 <<- ( 0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel- usaing same equation at Open Pit
		T2 <- (ShortTons * RF2 * (1 + DF2))
		if (dpy == 350) { Cm2 <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm2 <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/52}
		KcA2<<- 64800 * Cm2^0.759
		KcB2<<- 371 * Cm2 + 180 * 3 * DepthM2 * Cm2^.404
		Kc2 <<- KcA2 + KcB2
		KoA2 <<- ((2343/Cm2) + 0.44 * 3.2808 * Depth/Cm2 + 0.00163 * 3.2808 * Depth)
		KoB2 <<-  48.4 * Cm2^(-0.217)
		Ko2 <<- KoA2 + KoB2
		MOCpy2 <<- (Cm2 * Ko2 * dpy)
		}

	if (MineMethod2 == "Cut-and-Fill") 
		{ 
		DF2 <<- .05
		RF2 <<- .85
		MOTRF2 <<- ((1 + DF2) * RF2 )
		T2 <- (ShortTons * RF2 * (1 + DF2))
		Cm2 <<- T2/(Life * dpy)
		Kc2 <<- 1250000 * Cm2^0.644
		Ko2 <<- 279.9 * Cm2^(-0.294)
		}

	if (MineMethod2 == "Room-and-Pillar") 
		{ 
		DF2 <<- .05
		RF2 <<- .85
		MOTRF2 <<-  ((1 + DF2) * RF2 )
		T2 <- (ShortTons * RF2 * (1+ DF2))
		Cm2 <<-(((0.05 + 1) * (MOTRF2 * ShortTons))^0.75)/70
		DCalc001 <<- (0.114*((ShortTons)^(1/3))+Depth)
		if(DCalc001  < 6) { SDepth <<- 6 }
		if(DCalc001 >=6) {SDepth <<-DCalc001}
		KcA2 <<- 97600 * Cm2^0.644   ## UG Room and Pillar capital cost
		KcB2 <<- 371 * SDepth + 180 * 3.2808 * SDepth * Cm2^.404    ## Underground mine depth capital cost
		Kc2 <<- KcB2 + KcA2 ## Room Pillar capital cost
		KoA2 <<- 35.5 * Cm2^(-0.171)  ## RP OC ($/st)
		KoB2 <<- ((2343/Cm2)+0.44*3*Depth/Cm2+0.00163*3*Depth) ## UG Depth OC($/st)
		Ko2 <<- KoA2 + KoB2 ### RP Mine Operating ($/st)
		MOCpy2 <<- (Cm2 * Ko2 * dpy)  ## mine operating costs per year
		DepthM  <<- SDepth
		}

	if (MineMethod2 == "Shrinkage Stope") 
		{ 
		DF2 <<- .10
		RF2 <<- .90
		MOTRF2 <<- ((1 + DF2) * RF2 )
		T2 <- (ShortTons * RF2 * (1+ DF2))
		Cm2 <<- T2/(Life * dpy)
		Kc2 <<- 179000 * Cm2^0.620
		Ko2 <<- 74.9 * Cm2^(-0.160)
		}

	if (MineMethod2 == "Sublevel Longhole") 
		{ 
		DF2 <<- .15
		RF2 <<- .85
		MOTRF2 <<- ((1 + DF2) * RF2 )
		T2 <- (ShortTons * RF2 * (1 + DF2))
		Cm2 <<- T2/(Life * dpy)
		Kc2 <<- 115000 * Cm2^0.552
		Ko2 <<- 41.9 * Cm2^(-0.181)
		}

	if (MineMethod2 == "Vertical Crater Retreat") 
		{ 
		DF2 <<- .10
		RF2 <<- .90
		MOTRF2 <<-((1 + DF2) * RF2 )
		T2 <- (ShortTons * RF2 * (1 + DF2))
		Cm2 <<- T2/(Life * dpy)
		Kc2 <<- 45200 * Cm2^0.747
		Ko2 <<- 51.0 * Cm2^(-0.206)
		}


### environment type equations 
#############################################
### Calcualtes Mill equations 
###########################################
## cpacity mill
if (dpy == 350) { (Cml2 <<- (( MOTRF2  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml2 <<- (( MOTRF2  * ShortTons)^ 0.75) / 52)}
###Cml <<- ShortTons/dpy  - old Cml


### mill type equations 
	MillNum2<<- 1   ## base number for mill num,ber temproarily  ***********************************

	if (MillT == "Autoclave CIL-EW") 
		{ 
		KcM2 <<- 96500 * Cml2^0.770
		KoM2 <<- 78.1  * Cml2^(-0.196)
		MillNum2 <<- 2
		
		}	

	if (MillT == "CIL-EW") 
		{ 
		KcM2 <<- 50000 * Cml2^0.745
		KoM2 <<- 84.2  * Cml2^(-0.281)
		}	

	if (MillT == "CIP-EW") 
		{ 
		KcM2 <<- 372000 * Cml2^0.540
		KoM2 <<- 105 * Cml2^(-0.281)
		}	

	if (MillT == "CCD-MC") 
		{ 
		KcM2 <<- 414000 * Cml2^0.584
		KoM2 <<- 128 * Cml2^(-0.300)
		MillNum2 <<- 2
		}	

	if (MillT == "Float-Roast-Leach") 
		{ 
		KcM2 <<- 481000 * Cml2^0.552
		KoM2 <<- 101 * Cml2^(-0.246)
		MillNum2 <<- 5
		}	

	if (MillT == "Flotation, 1 Product") 
		{ 
		KcM2 <<- 92600 * Cml2^0.667
		KoM2 <<- 121 * Cml2^(-0.336)
		MillNum2 <<- 8
		}
	
	if (MillT == "Flotation, 2 Product") 
		{ 
		KcM2 <<- 82500 * Cml2^0.702
		KoM2 <<- 149 * Cml2^(-0.356)
		MillNum2 <<- 9 
		}	

	if (MillT == "Flotation, 3 Product") 
		{ 
		KcM2 <<- 83600 * Cml2^0.708
		KoM2 <<- 153 * Cml2^(-0.344)
		MillNum2 <<- 10
		}	

	if (MillT == "Gravity") 
		{ 
		KcM2 <<- 135300 * Cml2^0.529
		KoM2 <<- 87.8 * Cml2^(-0.364)
		}	

	if (MillT == "Heap Leach") 
		{ 
		KcM2 <<- 296500 * Cml2^0.512
		KoM2 <<- 31.5 * Cml2^(-0.223)
		MillNum2 <<- 4
		}	

	if (MillT == "Solvent Extraction") 
		{ 
		KcM2 <<- 14600 * Cml2^0.596
		KoM2 <<- 3.0 * Cml2^(-0.145)
		}	



######################################################
 ## mill operating costs per year
#############################################
MillOCpy2 <<- (Cml2 * KoM2 * dpy)


########################################################
###  Calculation on the smelting cost 
########################################################
SmeltC2 <<- (0.26 * (2000 * ShortTons * (CuEQ/100) *  RF2 * CMMRRCu._pct ) / Life)



#####################################################
##  Total operating Costs Per Year   Mine Method 2
############################################################

TotalOCpy2 <<- (MSC * OCIF * (SmeltC2 + MOCpy2 + MillOCpy2))

##################################################
#### Calcualtes environment costs 
##################################################


## Tailings Pond
			
			if (Life < 7.5) 
				{ 
				TpKt2 <<- 17
				}
			if ( Life > 7.5)
				{ 
					if (Life  < 15)
						{
						TpKt2 <<- 32
						}
				}
			if ( Life > 15)
				{ 
				TpKt2 <<- 62
				}
			


		TpAtp2 <<- TpKt2 *(Cml2/1000)
		TpDl2 <<- 4 * (43560 * TpAtp2)^0.5
		TpKoE2 <<- 146000 + 1783 * TpAtp2
		
 
## Dam 

	 
		if ( Life < 7.5) 
			{
			DKt2 <<- 17
			}
		if ( Life > 7.5)
			 { 
			if (Life  < 15)
				{ 
				DKt2 <<- 32
				}
			}
		if ( Life > 15)
			 { 
			 DKt2 <<- 62
			 }
		DAtp2 <<- DKt2 * (Cml2/1000)
		DDl2 <<- 4 * (43560 * DAtp2)^0.5
		DKoE2 <<- 161 * DDl2
	

## Liner 
	
		if ( Life < 7.5)
			{ 
			LKt2 <<- 17
			}
		if ( Life > 7.5)
			{ 
			if (Life  < 15)
				{ 
				LKt2 <<- 32
				}
			 }
		if ( Life > 15)
			 { 
			 LKt2 <<- 62
			 }
		LAtp2 <<- LKt2 *(Cml2/1000)
		LDl2 <<- 4 * (43560 * LAtp2)^0.5
		LKoE2 <<- 5 * LDl2 +  35790 * LAtp2
	




#########################################################
##  Total Capital costs   Mine Method 2
########################################################

TKC2 <<- (( Kc2 + TPD*(TpKoE2 + DKoE2) + (Liner * LKoE2) + KcM2) * MSC * CCIF) ## Total capital costs 
TKCpst2 <<- TKC2/ ShortTons #### Total capital costs per short ton


#####################################################
##  Value Prod $/a
#####################################################

VP2 <<- ((OreV * Cml2 * dpy) - TotalOCpy2)

#####################################################
## Present Value  Mine Method 2
#####################################################
pmt <<- VP2  # payments - value prod
rate <<- 0.15   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate

PV2 <<- P02 * pmt  # total present value



##########################################################
## Present Value Deposit  Mine Method 2
##########################################################
PVD2 <<- PV2 - TKC2 



	}  ## ends the Mine Method 2 calculation 

#########################################################################################################################################################################################################################

####
#####
###################
####################################
##########################################################
###############################################################################
###############################################################################################################
## Mine Method 3 calcualtion  
###############################################################################################################


if (!is.na(MineTypes[3]))
	{
	MineMethod3 <<- MineTypes[3]

#######################################################
#### calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
###  calculations based on each mine method 
#####################################################

SR3 <<- "NA"
MOCpy3 <<- 0
if (MineMethod3 == "Open Pit")
{
DF3 <<- .05
RF3 <<- .90
MOTRF3 <<- ((1 + DF3) * RF3 )
DepthM3 <<- (0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel
SR3 <<- ((2.225 * 4.1 * (DepthM3^3 / ShortTons ) - 1))
if (dpy == 350) { Cm3 <<- (((SR3 + 1) * (MOTRF3  * ShortTons))^0.75)/70}
if (dpy == 260) { Cm3 <<- (((SR3 + 1) * (MOTRF3  * ShortTons))^0.75)/52}


	if (Cm3 < 20000) 
		{ 
		Kc3 <<- 160000 * Cm3^0.515
		Ko3 <<- 71.0 * Cm3^(-0.414)
		MOCpy3 <<- (Cm3 * Ko3 * dpy)  ## OP mine operating costs per year
		}
	if (Cm3 > 20000) 
		{ 
		Kc3 <<- 2670 * Cm3^0.917
		Ko3 <<- 5.14 * Cm3^(-0.148)
		MOCpy3 <<- (Cm3 * Ko3 * dpy) ## OP mine operating costs per year
		}
}

	if (MineMethod3 == "Block Caving") 
		{ 
		DF3 <<- .15
		RF3 <<- .95
		MOTRF3 <<-((1 + DF3) * RF3 )
		DepthM3 <<- ( 0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel- usaing same equation at Open Pit
		T3 <- (ShortTons * RF3 * (1 + DF3))
		if (dpy == 350) { Cm3 <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm3 <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/52}
		KcA3 <<- 64800 * Cm3^0.759
		KcB3 <<- 371 * Cm3 + 180 * 3 * DepthM3 * Cm3^.404
		Kc3 <<- KcA3 + KcB3
		KoA3 <<- ((2343/Cm3) + 0.44 * 3.2808 * Depth/ Cm3 + 0.00163 * 3.2808 * Depth)
		KoB3 <<- 48.4 * Cm3^(-0.217)
		Ko3 <<- KoA3 + KoB3
		MOCpy3 <<- (Cm3 * Ko3 * dpy) ## OP mine operating costs per year
		}

	if (MineMethod3 == "Cut-and-Fill") 
		{ 
		DF3 <<- .05
		RF3 <<- .85
		MOTRF3 <<-((1 + DF3) * RF3 )
		T3 <- (ShortTons * RF3 * (1 + DF3))
		Cm3 <<- T3/(Life * dpy)
		Kc3 <<- 1250000 * Cm3^0.644
		Ko3 <<- 279.9 * Cm3^(-0.294)
		}

	if (MineMethod3 == "Room-and-Pillar") 
		{ 
		DF3 <<- .05
		RF3 <<- .85
		MOTRF3 <<-  ((1 + DF3) * RF3 )
		T3 <- (ShortTons * RF3 * (1+ DF3))
		Cm3 <<-(((0.05 + 1) * (MOTRF3 * ShortTons))^0.75)/70
		DCalc001 <<- (0.114*((ShortTons)^(1/3))+Depth)
		if(DCalc001  < 6) { SDepth <<- 6 }
		if(DCalc001 >=6) {SDepth <<-DCalc001}
		KcA3 <<- 97600 * Cm3^0.644   ## UG Room and Pillar capital cost
		KcB3 <<- 371 * SDepth + 180 * 3.2808 * SDepth * Cm3^.404    ## Underground mine depth capital cost
		Kc3 <<- KcB3 + KcA3 ## Room Pillar capital cost
		KoA3 <<- 35.5 * Cm3^(-0.171)  ## RP OC ($/st)
		KoB3 <<- ((2343/Cm3)+0.44*3*Depth/Cm3+0.00163*3*Depth) ## UG Depth OC($/st)
		Ko3 <<- KoA3 + KoB3 ### RP Mine Operating ($/st)
		MOCpy3 <<- (Cm3 * Ko3 * dpy)  ## mine operating costs per year
		DepthM  <<- SDepth
		}

	if (MineMethod3 == "Shrinkage Stope") 
		{ 
		DF3 <<- .10
		RF3 <<- .90
		MOTRF3 <<-((1 + DF3) * RF3 )
		T3 <- (ShortTons * RF3 * (1+ DF3))
		Cm3 <<- T3/(Life * dpy)
		Kc3 <<- 179000 * Cm3^0.620
		Ko3 <<- 74.9 * Cm3^(-0.160)
		}
      
	if (MineMethod3 == "Sublevel Longhole") 
		{ 
		DF3 <<- .15
		RF3 <<- .85
		MOTRF3 <<- ((1 + DF3) * RF3 )
		T3 <- (ShortTons * RF3 * (1 + DF3))
		Cm3 <<- T3/(Life * dpy)
		Kc3 <<- 115000 * Cm3^0.552
		Ko3 <<- 41.9 * Cm3^(-0.181)
		}

	if (MineMethod3 == "Vertical Crater Retreat") 
		{ 
		DF3 <<- .10
		RF3 <<- .90
		MOTRF3 <<- ((1 + DF3) * RF3 )
		T3 <- (ShortTons * RF3 * (1 + DF3))
		Cm3 <<- T3/(Life * dpy)
		Kc3 <<- 45200 * Cm3^0.747
		Ko3 <<- 51.0 * Cm3^(-0.206)
		}


### environment type equations 
#############################################
### Calcualtes Mill equations 
###########################################
## cpacity mill

if (dpy == 350) { (Cml3 <<- (( MOTRF3  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml3 <<- (( MOTRF3  * ShortTons)^ 0.75) / 52)}



### mill type equations 
	MillNum3<<- 1   ## base number for mill number temproarily  ***********************************

	if (MillT == "Autoclave CIL-EW") 
		{ 
		KcM3 <<- 96500 * Cml3^0.770
		KoM3 <<- 78.1  * Cml3^(-0.196)
		MillNum3 <<- 2
		
		}	

	if (MillT == "CIL-EW") 
		{ 
		KcM3 <<- 50000 * Cml3^0.745
		KoM3 <<- 84.2  * Cml3^(-0.281)
		}	

	if (MillT == "CIP-EW") 
		{ 
		KcM3 <<- 372000 * Cml3^0.540
		KoM3 <<- 105 * Cml3^(-0.281)
		}	

	if (MillT == "CCD-MC") 
		{ 
		KcM3 <<- 414000 * Cml3^0.584
		KoM3 <<- 128 * Cml3^(-0.300)
		MillNum3 <<- 2
		}	

	if (MillT == "Float-Roast-Leach") 
		{ 
		KcM3 <<- 481000 * Cml3^0.552
		KoM3 <<- 101 * Cml3^(-0.246)
		MillNum3 <<- 5
		}	

	if (MillT == "Flotation, 1 Product") 
		{ 
		KcM3 <<- 92600 * Cml3^0.667
		KoM3 <<- 121 * Cml3^(-0.336)
		MillNum3 <<- 8
		}
	
	if (MillT == "Flotation, 2 Product") 
		{ 
		KcM3 <<- 82500 * Cml3^0.702
		KoM3 <<- 149 * Cml3^(-0.356)
		MillNum3 <<- 9 
		}	

	if (MillT == "Flotation, 3 Product") 
		{ 
		KcM3 <<- 83600 * Cml3^0.708
		KoM3 <<- 153 * Cml3^(-0.344)
		MillNum3 <<- 10
		}	

	if (MillT == "Gravity") 
		{ 
		KcM3 <<- 135300 * Cml3^0.529
		KoM3 <<- 87.8 * Cml3^(-0.364)
		}	

	if (MillT == "Heap Leach") 
		{ 
		KcM3 <<- 296500 * Cml3^0.512
		KoM3 <<- 31.5 * Cml3^(-0.223)
		MillNum3 <<- 4
		}	

	if (MillT == "Solvent Extraction") 
		{ 
		KcM3 <<- 14600 * Cml3^0.596
		KoM3 <<- 3.0 * Cml3^(-0.145)
		}	



######################################################
 ## mill operating costs per year
#############################################

MillOCpy3 <<- (Cml3 * KoM3 * dpy)


########################################################
###  Calculation on the smelting cost 
########################################################

SmeltC3 <<- (0.26 * (2000 * ShortTons * (CuEQ/100) *  RF3 * CMMRRCu._pct ) / Life)



#####################################################
##  Total operating Costs Per Year   Mine Method 3
############################################################

TotalOCpy3 <<- (MSC * OCIF * (SmeltC3 + MOCpy3 + MillOCpy3))




##################################################
#### Calcualtes environment costs 
##################################################


## Tailings Pond
			
			if (Life < 7.5) 
				{ 
				TpKt3 <<- 17
				}
			if ( Life > 7.5)
				{ 
					if (Life  < 15)
						{
						TpKt3 <<- 32
						}
				}
			if ( Life > 15)
				{ 
				TpKt3 <<- 62
				}
			


		TpAtp3 <<- TpKt3 *(Cml3/1000)
		TpDl3 <<- 4 * (43560 * TpAtp3)^0.5
		TpKoE3 <<- 146000 + 1783 * TpAtp3
		
 
## Dam 

	 
		if ( Life < 7.5) 
			{
			DKt3 <<- 17
			}
		if ( Life > 7.5)
			 { 
			if (Life  < 15)
				{ 
				DKt3 <<- 32
				}
			}
		if ( Life > 15)
			 { 
			 DKt3 <<- 62
			 }
		DAtp3 <<- DKt3 * (Cml3/1000)
		DDl3 <<- 4 * (43560 * DAtp3)^0.5
		DKoE3 <<- 161 * DDl3
	

## Liner 
	
		if ( Life < 7.5)
			{ 
			LKt3 <<- 17
			}
		if ( Life > 7.5)
			{ 
			if (Life  < 15)
				{ 
				LKt3 <<- 32
				}
			 }
		if ( Life > 15)
			 { 
			 LKt3 <<- 62
			 }
		LAtp3 <<- LKt3 *(Cml3/1000)
		LDl3 <<- 4 * (43560 * LAtp3)^0.5
		LKoE3 <<- 5 * LDl3 +  35790 * LAtp3
	

#########################################################
##  Total Capital costs   Mine Method 3
########################################################

TKC3 <<- (( Kc3 + TPD*(TpKoE3 + DKoE3) + (Liner * LKoE3) + KcM3) * MSC * CCIF) ## Total capital costs 
TKCpst3 <<- TKC3/ ShortTons #### Total capital costs per short ton


#####################################################
##  Value Prod $/a
#####################################################

VP3 <<- ((OreV * Cml3 * dpy) - TotalOCpy3)

#####################################################
## Present Value  Mine Method 3 -- Production
#####################################################

pmt <<- VP3  # payments - value prod
rate <<- 0.15   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P03 <<-  P01/rate   ## P01/rate

PV3 <<- P03 * pmt  # total present value



##########################################################
## Present Value Deposit  Mine Method 3
##########################################################

PVD3 <<- PV3 - TKC3



}  ## ends the Mine Method 3 calculation 

################################################################################################################################################################################################################


############################################################################################
### Contained Grade Results 
###############################################################################################
CList <<- c()
for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Contained_",u1,sep="")
d1 <- (Ton * (get(u)/100))
assign(z, d1, env = .GlobalEnv) 
CList <<- c(CList,z)
}


###############################################################################################
## find best method and record it as BestMethod -  if none- "None"
###############################################################################################
#######################################
################  IF MINE NUM=3 
###################################

if (MineNum001 == 3)
{ 


if (PVD < 0 ) {PVDa <<- 0}
if (PVD2 < 0 ) {PVDb <<- 0}
if (PVD3 < 0 ) {PVDc <<- 0}

if (PVD > 0)   {PVDa <<- PVD}
if (PVD2 > 0 ) {PVDb <<- PVD2}
if (PVD3 > 0 ) {PVDc <<- PVD3}


if (PVD == 0 ) {PVDa <<- 0}
if (PVD2 == 0 ) {PVDb <<- 0}
if (PVD3 == 0 ) {PVDc <<- 0}


if (PVDa > PVDb)  { if (PVDa > PVDc)  {BestMMethod<<-  MineTypes[1]}}
if (PVDb > PVDa)  { if (PVDb > PVDc) {BestMMethod<<-  MineTypes[2]}}
if (PVDc > PVDa)  { if (PVDc > PVDb) {BestMMethod<<-  MineTypes[3]}}
if (PVDa == 0) { if (PVDb == 0) { if (PVDc ==0) {BestMMethod<<- "None" } } }

################################################################################
### PVD Max
################################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes[1])
{
PVDMax <<- PVD
}


if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes[2])
		{
		PVDMax <<- PVD2
		}
	}

if(!is.na(BestMMethod))
	{
	 if (BestMMethod ==  MineTypes[3]) 
		{
		PVDMax <<- PVD3
		}
	}

if(!is.na(BestMMethod) )
	{
	 if (BestMMethod ==  "None") 
		{
		PVDMax <<- 0
		}
	}

} ## ends if mine num 3


#######################################
################  IF MINE NUM=2 
###################################

if (MineNum001 == 2)
{

if (PVD < 0 ) {PVDa <<- 0}
if (PVD2 < 0 ) {PVDb <<- 0}

if (PVD > 0)   {PVDa <<- PVD}
if (PVD2 > 0 ) {PVDb <<- PVD2}


if (PVD == 0 ) {PVDa <<- 0}
if (PVD2 == 0 ) {PVDb <<- 0}

if (PVDa > PVDb)  {BestMMethod<<-  MineTypes[1]}
if (PVDb > PVDa)  {BestMMethod<<-  MineTypes[2]}
if (PVDa == 0) { if (PVDb == 0)  {BestMMethod<<- "None" } }

################################################################################
### PVD Max
################################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes[1])
{
PVDMax <<- PVD
}


if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes[2])
		{
		PVDMax <<- PVD2
		}
	}


if(!is.na(BestMMethod) )
	{
	 if (BestMMethod ==  "None") 
		{
		PVDMax <<- 0
		}
	}

} ## ends if mine num 2


#######################################
################  IF MINE NUM=1 
###################################

if (MineNum001 == 1)
{

if (PVD < 0 ) {PVDa <<- 0}


if (PVD > 0)   {PVDa <<- PVD}



if (PVD == 0 ) {PVDa <<- 0}


BestMMethod<<-  MineTypes[1]

if (PVDa == 0){BestMMethod<<- "None" } 

################################################################################
### PVD Max
################################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes[1])
{
PVDMax <<- PVD
}

} ## ends if mine num 2


#########################################################################################
### Recovered data
########################################################################################

CN <- 1

if (BestMMethod == "Open Pit")
{
RList00 <<- c()
RF <<- .90
for (u in ListGradeNames) 
{


u1 <- sub("_pct", 'Tons', u)
z0 <<- paste ("Recovered_",u1,sep="")
Gradev <<- get(u)

MRRa <<- MRUseList[CN]  
MRRv <<- get(MRRa)  ## Records MRR value for the current grade
UUU <<- get(u)

d299 <<- (RF * MRRv * UUU * (Ton/100) )
assign(z0, d299, env = .GlobalEnv) 
RList00 <<- c(RList00 ,z0) 
CN =CN + 1
}  #ends for grades

}  #ends if open pit recovered data


CN <- 1
if (BestMMethod == "Block Caving")
{
RList00 <- c()
RF <<- .95
for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Recovered_",u1,sep="")
Gradev <<- get(u)

MRRa <<- MRUseList[CN]  
MRRv <<- get(MRRa)  ## Records MRR value for the current grade


d2 <- (RF * MRRv * get(u) * (Ton/100) )
assign(z, d2, env = .GlobalEnv) 
RList00 <- c(RList00 ,z)
CN =CN + 1
}  #ends for grades

}  #ends if open pit recovered data



CN <- 1

if (BestMMethod == "Room-and-Pillar")
{
RList00 <- c()
RF <<- .85
for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Recovered_",u1,sep="")
Gradev <<- get(u)

MRRa <<- MRUseList[CN]  
MRRv <<- get(MRRa)  ## Records MRR value for the current grade


d2 <- (RF * MRRv * get(u) * (Ton/100) )
assign(z, d2, env = .GlobalEnv) 
RList00 <- c(RList00 ,z)
CN =CN + 1
}  #ends for grades

}  #ends if open pit recovered data




CN <- 1
if (BestMMethod == "None")

{
RList00 <- c()
for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Recovered_",u1,sep="")
d2 <- 0
assign(z, d2, env = .GlobalEnv) 
RList00 <- c(RList00 ,z)
CN =CN + 1
}  #ends for grades

}  #ends if open pit recovered data


GList <- c()
for (u in ListGradeNames) 
{
z<<- paste(u,"Grade",sep="")

assign(z,get(u) , env = .GlobalEnv) 
GList <<- c(GList ,z)
}


### confirming save of values for print out 


if(NumGrades0 == 1)
	{
Grade0001 <-  get(ListGradeNames[1])
Con0001 <- get(cList0[1])
Rec0001 <- get(rList0[1])
OVPEC1 <- get(OVPECList[1])
	}


if(NumGrades0 == 2)
	{
Grade0001 <-  get(ListGradeNames[1])
Grade0002 <-  get(ListGradeNames[2])


	
Con0001 <- get(CList[1])
Con0002 <- get(CList[2])


Rec0001 <- get(RList00[1])
Rec0002 <- get(RList00[2])


OVPEC1 <- get(OVPECList[1])
OVPEC2 <- get(OVPECList[2])



if (OVPEC1 > OVPEC2) 
{	
OH<<- OVPECList[1]
}

if (OVPEC2 > OVPEC1) 
{	
OH<<- OVPECList[2]
}

if (OVPEC1 < OVPEC2) 
{	
OL<<- OVPECList[1]
}

if (OVPEC2 < OVPEC1) 
{	
OL<<- OVPECList[2]
}

	}


if(NumGrades0 == 3)
	{
Grade0001 <-  get(ListGradeNames[1])
Grade0002 <-  get(ListGradeNames[2])
Grade0003 <-  get(ListGradeNames[3])

	
Con0001 <- get(CList[1])
Con0002 <- get(CList[2])
Con0003 <- get(CList[3])


Rec0001 <- get(RList00[1])
Rec0002 <- get(RList00[2])
Rec0003 <- get(RList00[3])


OVPEC1 <- get(OVPECList[1])
OVPEC2 <- get(OVPECList[2])
OVPEC3 <- get(OVPECList[3])



if (OVPEC1 > OVPEC2) 
{	
if(OVPEC1 > OVPEC3 )
{
OH<<- OVPECList[1]
}}

if (OVPEC2 > OVPEC1) 
{	
if(OVPEC2 > OVPEC3 )
{
OH<<- OVPECList[2]
}}
if (OVPEC3 > OVPEC1) 
{	
if(OVPEC3 > OVPEC2 )
{
OH<<- OVPECList[3]
}}


if (OVPEC1 < OVPEC2) 
{	
if(OVPEC1 < OVPEC3 )
{
OL<<- OVPECList[1]
}}

if (OVPEC2 < OVPEC1) 
{	
if(OVPEC2 < OVPEC3 )
{
OL<<- OVPECList[2]
}}
if (OVPEC3 < OVPEC1) 
{	
if(OVPEC3 < OVPEC2 )
{
OL<<- OVPECList[3]
}}

	}



if(NumGrades0 == 4)
	{
Grade0001 <-  get(ListGradeNames[1])
Grade0002 <-  get(ListGradeNames[2])
Grade0003 <-  get(ListGradeNames[3])
Grade0004 <-  get(ListGradeNames[4])
	
Con0001 <- get(CList[1])
Con0002 <- get(CList[2])
Con0003 <- get(CList[3])
Con0004 <- get(CList[4])

Rec0001 <<- get(RList00[1])
Rec0002 <<- get(RList00[2])
Rec0003 <<- get(RList00[3])
Rec0004 <<- get(RList00[4])

OVPEC1 <- get(OVPECList[1])
OVPEC2 <- get(OVPECList[2])
OVPEC3 <- get(OVPECList[3])
OVPEC4 <- get(OVPECList[4])


if (OVPEC1 > OVPEC2) 
{	
if(OVPEC1 > OVPEC3 )
{
if(OVPEC1 > OVPEC4 )
{
OH<<- OVPECList[1]
}}}

if (OVPEC2 > OVPEC1) 
{	
if(OVPEC2 > OVPEC3 )
{
if(OVPEC2 > OVPEC4 )
{
OH<<- OVPECList[2]
}}}
if (OVPEC3 > OVPEC1) 
{	
if(OVPEC3 > OVPEC2 )
{
if(OVPEC3 > OVPEC4 )
{
OH<<- OVPECList[3]
}}}

if (OVPEC4 > OVPEC1) 
{	
if(OVPEC4 > OVPEC3 )
{
if(OVPEC4 > OVPEC2 )
{
OH<<- OVPECList[4]
}}}




if (OVPEC1 < OVPEC2) 
{	
if(OVPEC1 < OVPEC3 )
{
if(OVPEC1 < OVPEC4 )
{
OL<<- OVPECList[1]
}}}

if (OVPEC2 < OVPEC1) 
{	
if(OVPEC2 < OVPEC3 )
{
if(OVPEC2 < OVPEC4 )
{
OL<<- OVPECList[2]
}}}
if (OVPEC3 < OVPEC1) 
{	
if(OVPEC3 < OVPEC2 )
{
if(OVPEC3 < OVPEC4 )
{
OL<<- OVPECList[3]
}}}

if (OVPEC4 < OVPEC1) 
{	
if(OVPEC4 < OVPEC3 )
{
if(OVPEC4 < OVPEC2 )
{
OL<<- OVPECList[4]
}}}



	}


if(NumGrades0 == 5)
	{
Grade0001 <-  get(ListGradeNames[1])
Grade0002 <-  get(ListGradeNames[2])
Grade0003 <-  get(ListGradeNames[3])
Grade0004 <-  get(ListGradeNames[4])
Grade0005 <-  get(ListGradeNames[5])	

Con0001 <- get(cList0[1])
Con0002 <- get(cList0[2])
Con0003 <- get(cList0[3])
Con0004 <- get(cList0[4])
Con0005 <- get(cList0[5])

Rec0001 <- get(RList00[1])
Rec0002 <- get(RList00[2])
Rec0003 <- get(RList00[3])
Rec0004 <- get(RList00[4])
Rec0005 <- get(RList00[5])
	}

if(NumGrades0 == 5)
	{
Grade0001 <-  get(ListGradeNames[1])
Grade0002 <-  get(ListGradeNames[2])
Grade0003 <-  get(ListGradeNames[3])
Grade0004 <-  get(ListGradeNames[4])
Grade0005 <-  get(ListGradeNames[5])	
Grade0006 <-  get(ListGradeNames[6])	
Con0001 <- get(cList0[1])
Con0002 <- get(cList0[2])
Con0003 <- get(cList0[3])
Con0004 <- get(cList0[4])
Con0005 <- get(cList0[5])
Con0006 <- get(cList0[6])
Rec0001 <- get(rList0[1])
Rec0002 <- get(rList0[2])
Rec0003 <- get(rList0[3])
Rec0004 <- get(rList0[4])
Rec0005 <- get(rList0[5])
Rec0006 <- get(rList0[6])
	}



## length of mine types choices



################################################################################
### NPV_Tract / Area
################################################################################

NPV_Area <<- (PVDMax / TA1 )


#####################################################################################################
## ADDING FINAL RECORD
###################################################################################################

	DCAT <<- SA


if (MineNum001 == 1)
	{

### creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 , Con0001 ,Con0002 ,Con0003 , Rec0001 ,Rec0002 ,Rec0003)
	}


if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area, BestMMethod, Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}


if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillT, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5,OVPEC6, OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Grade0006,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 ,Con0006, Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}

	} #end if minenum ==1 




if (MineNum001 == 2)
	{

### creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003, Con0001 ,Con0002 ,Con0003, Rec0001 ,Rec0002 ,Rec0003)
	}


if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}


if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes[1], MineTypes[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillT, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OVPEC6 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005,Grade0006, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Con0006 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}

	} #end if minenum ==2







### print/ save each line to the csv 
	
	write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)


	}  ## ends if statement if greater than 0
x <<- (x + 1)

BTime <<- Sys.time()
	}  ##ends while statement for each line 
	} )## ends submit button 
	} )## ends continue 4
	})
	} )## ends continue 3
	} )## ends continue 2
	} )## ends continue 1
OutF22 <<- paste("EF_07_TotalTime_",TN1,".txt", sep = "")
TotalTime1 <<- BTime - ATime 
DecTime <<- "Difference in Time (Minutes)"
write(DecTime , file=OutF22, append=TRUE)
write(TotalTime1 , file=OutF22, append=TRUE)

#######################
## Saves the amount of time program took
#####################################

#ITab <<- read.csv(OutF1)
# sink()
	}) ### end base
