
#######################################################################
## Title:   Resource Assessment Economic Filter(RAEF)
## Author:  Jason Shapiro
## Date:    2/05/2019
#######################################################################
############# To Run- click edit- Run All  in RGui ####################
#######################################################################

#######################################################################
## Uploads required R packages 
#######################################################################

library(gWidgets)
library(gWidgetstcltk)
library(dplyr)
library(reshape)
library(evaluate)

#######################################################################
## RAEF Package and startup dialog launch
#######################################################################

baseW <- gwindow("RAEF Startup")                                                                       ### opens new window 
lbl_data_frame_name <- glabel(                                                                          
  "Input Package Folder: ",
  container = baseW
)


obj <- gfilebrowse("Select folder ",type = "selectdir", cont=baseW)                                     ### browse for file 
addhandlerchanged(obj, handler=function(h,...) 
	InputFolder1 <<- svalue(h$obj))


                                                              
lbl_data_frame_name <- glabel(                                                                          
  "Input Pre Set Parameters (If Applicable) ",
  container = baseW
)

obj44 <- gfilebrowse("Input PreSet Parameters",type = "open", cont=baseW)                                     ### browse for file 
addhandlerchanged(obj44, handler=function(h,...) 
	PreSetFile <<- svalue(h$obj44))

#######################################################################
#######################################################################
## Without Pre-set Parameters (GUI) Mode 
#######################################################################
#######################################################################

obj <- gbutton(                                                                                         ### creates button for the launch RAEF pacakge 
	text   = "Launch with GUI Option",
      container=baseW,
      handler = function(h,...)
	{
	setwd(InputFolder1)	
	rm(list=ls(all=TRUE))  ### removes all variables to defualt level 

#######################################################################
## Set default values
#######################################################################

#######################################################################
## Frames and windows 
#######################################################################

win <- gwindow(width= 990)                                                                              ### opens main dialog for the RAEF GUI
imageL <<- paste(InputFolder1,"/AuxFiles/Images/bnrglobe3.gif",sep="")                                  ### USGS banner - adds to the dialog 
gimage(imageL , container = win)

## groups and frames inside the main dialog -to organize 
grp_name <- ggroup(horizontal= TRUE, container = win)
grp2 <- ggroup(horizontal= FALSE,container = win)
tmp <- gframe("Output Working Directory Input", container=grp_name)
input <- gframe("Input Files",horizontal= FALSE,  container=grp_name)
input2 <- gframe("",horizontal= FALSE,container=input)
input3 <- gframe("",horizontal= FALSE, container=input)
input4 <- gframe("",horizontal= FALSE, container=input)
Box0 <- gframe("",horizontal= FALSE,container=grp_name)
BoxS <- gframe("",horizontal= FALSE,  container=grp_name)


sb <- gstatusbar("status text", container=win)



#######################################################################
## Input files dialog code
#######################################################################

## econ simulation input
svalue(sb) <- "select input files and directory"
lbl_data_frame_name <- glabel("Econ Filter Simulation Input (File 05_Sim_EF): ",container = input2)     
SimFile <<- gfilebrowse( text = "Select a file...", type = "open", container = input2)                  ### browse for the Simulation ef file - SimFile 
addhandlerchanged(SimFile , handler=function(h,...){}) 

lbl_data_frame_name <- glabel(                                                                         

  "Working Directory: ",
  container = input2
)

obj <- gfilebrowse("Select folder ",type = "selectdir", cont=input2)                                    ### browse for the working directory- where the output files will be saved - wdir1                
addhandlerchanged(obj, handler=function(h,...) 
	wdir1 <<- svalue(h$obj))

obj <- gbutton(                                                                                         ### creates button to set working directory 

	text   = "Set working directory",
      container=input2,
      handler = function(h,...)
	{
	setwd(wdir1)                                                                                     
	WD <<- getwd()                                                                                    ### changes the working directory -wdir1 and WD
	cat (WD)


	elogFileName <<- paste(WD,"/","RunLog.txt",sep="")                                                ### creates error log for the running. 
	
	svalue(sb) <- "working directory set"

	})

lbl_data_frame_name <- glabel("Run Name: ",container = input2)                                         ### creates text box for user to enter test name - testname1 
testname1<<- gedit("run name",width = 13,container = input2)                                          

## Ceate continue button 1 - user inputs 
obj <<- gbutton(text = "Continue - User Inputs",container=input2, handler = function(h,...)             ### Creates button to save and continue the process to the next step
	{
	svalue(sb) <- "user input set"
	SimFile <<-svalue(SimFile)												  ### Saves the SimFile variable 																															
	
#######################################################################
## User input- Intervals dialog  --  after "continue 1 " button clicked 
#######################################################################
	
	input5 <- gframe("",horizontal= FALSE, container=input)                                           ### Creates new frame 
	
	TN1 <<- svalue(testname1)                                                                         ### Saves the test name -  TN1
	OutF1 <<- paste("EF_02_Output_",TN1,".csv", sep = "")								  ### Creates file name for the output file -  EF_02_Output_"TN1".csv

#######################################################################
## Questions regarding deposit
#######################################################################
          
lbl_data_frame_name <- glabel("Deposit Type Geometry", container = input5)                                      ### Creates drop down list for the deposit types -   DTy
	DTy <- gdroplist(c("Flat-bedded/stratiform", "Ore body massive / disseminated", "Vein deposit / steep" ), container = input5)

lbl_data_frame_name <- glabel("Tract Area [sqKm]", container = input5)                                 ### Creates text box for the tract area - TA1
	TA1 <- gedit("Enter Area",width = 15,container = input5)

#######################################################################
## General Depth input
#######################################################################
	lbl_data_frame_name <- glabel("Assessment Depth Interval [meters]",container = input5)   
## Min interval
	lbl_data_frame_name <- glabel("Min [meters]", container = input5)
	MinTot <<- gedit("",width = 13,container = input5)								  ### Creates text box to enter the mininum depth level - MinTot

## Max interval
	lbl_data_frame_name <- glabel("Max [meters]", container = input5)
	MaxTot <<- gedit("",width = 13,container = input5)                                                ### Creates text box to enter the maxinum depth level - MaxTot

## Number of intervals- which will determine the number of interval inputs 
	lbl_data_frame_name <- glabel("# of Intervals", container = input5)
	NumCat <- gdroplist(c("1","2", "3", "4"), container = input5)                                     ### Creates drop down list for the number of depth intervals (max 4) - NumCat
	

## Creates continue button 2-  adds the intervals 
obj <- gbutton(text   = "Continue",container=input5,                                                    ### Creates button to continue process and launch the depth intervals process 
	handler = function(h,...)
	{
	DTy <<- svalue(DTy)												        ### Saves deposit type result - DTy
	int1 <<- strtoi(svalue(NumCat ))                                                                  ### Saves number of intervals - int1
	NumCat <<- strtoi(svalue(NumCat))
	MinTot <<- strtoi(svalue(MinTot ))                                                                ### Saves overal depth information -  MinTot, MaxTot
	MaxTot <<- strtoi(svalue(MaxTot ))
	TA1 <<- strtoi(svalue(TA1 ))                                                                      ### Saves tract area-  TA1

#######################################################################
## Depth Interval input
#######################################################################

	lbl_data_frame_name <- glabel("Enter Min/Max/Fraction for each interval",container = input5 )
																	  ### Creates lists of the depth interval information  
	MinList <<- c()
	MaxList <<- c()
	PVList  <<- c()
	ObjAL <<- c()

																	  ### adds intervals based on the number of intervals entered - if statements 
																	  ### below is the interval input -  min, max, and fraction of the depth intervals using text boxes

if (int1 == 1)  ## If 1 interval
	{
	input5b <- gwindow("",horizontal= FALSE)
	ObjMin1 <<- gedit("Min",width = 13,container = input5b )
	ObjMax1 <<- gedit("Max",width = 13,container = input5b )
	ObjPer1 <<- gedit("Fraction",width = 13,container = input5b )
	}

if (int1 == 2) ## If 2 intervals
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

if (int1 == 3) ## If 3 intervals
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

if (int1 == 4) ## If 4 intervals 
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

Min2 <<- 0
Max2 <<- 0
Per2 <<- 0

Min3 <<- 0
Max3 <<- 0
Per3 <<- 0

Min4 <<- 0
Max4 <<- 0
Per4 <<- 0
																       ### create continue 3 button - goes to the mine methods and environment choices 
	obj <- gbutton(text   = "Continue",container=input5b, 
	handler = function(h,...)
	{
                 															 ### saves the interval information - based on how many intervals
	if (int1 == 1) 
		{
		Min1 <<- strtoi(svalue(ObjMin1))
		Max1 <<- strtoi(svalue(ObjMax1))
		Per1 <<- as.double(svalue(ObjPer1))
		}

	if (int1 == 2) 
		{
		Min1 <<- strtoi(svalue(ObjMin1))
		Max1 <<- strtoi(svalue(ObjMax1))
		Per1 <<- as.double(svalue(ObjPer1))
		Min2 <<- strtoi(svalue(ObjMin2))
		Max2 <<- strtoi(svalue(ObjMax2))
		Per2 <<- as.double(svalue(ObjPer2))
		}

	if (int1 == 3) 
		{
		Min1 <<- strtoi(svalue(ObjMin1))
		Max1 <<- strtoi(svalue(ObjMax1))
		Per1 <<- as.double(svalue(ObjPer1))
		Min2 <<- strtoi(svalue(ObjMin2))
		Max2 <<- strtoi(svalue(ObjMax2))
		Per2 <<- as.double(svalue(ObjPer2))
		Min3 <<- strtoi(svalue(ObjMin3))
		Max3 <<- strtoi(svalue(ObjMax3))
		Per3 <<- as.double(svalue(ObjPer3))		
		}

	if (int1 == 4) 
		{
		Min1 <<- strtoi(svalue(ObjMin1))
		Max1 <<- strtoi(svalue(ObjMax1))
		Per1 <<- as.double(svalue(ObjPer1))
		Min2 <<- strtoi(svalue(ObjMin2))
		Max2 <<- strtoi(svalue(ObjMax2))
		Per2 <<- as.double(svalue(ObjPer2))
		Min3 <<- strtoi(svalue(ObjMin3))
		Max3 <<- strtoi(svalue(ObjMax3))
		Per3 <<- as.double(svalue(ObjPer3))	
		Min4 <<- strtoi(svalue(ObjMin4))
		Max4 <<- strtoi(svalue(ObjMax4))
		Per4 <<- as.double(svalue(ObjPer4))	
		}

#######################################################################
## Mine Type based on the deposit geometry and deposit depth 
#######################################################################

																	   ### creates the environemnt / methods dialog
	input5 <- gframe("",horizontal= FALSE, container=Box0 )
	input6 <- gframe("",horizontal= TRUE, container=Box0 )
	input7 <- gframe("",horizontal= TRUE, container=Box0 )
	input66 <- gframe("",horizontal= FALSE, container=input6 )
	input62 <- gframe("",horizontal= FALSE, container=input6 )
																	   
                                                                                                         


	if ( DTy == "Vein deposit / steep")                                                                
		{
		minetypes <<- c("Mine Method: Vertical Crater Retreat")
		lbl_data_frame_name <- glabel("Mine Method: Vertical Crater Retreat",container = input5 )
		}

	if ( DTy == "Flat-bedded/stratiform")                                                              
		{	
		minetypes <<- c("Mine Method is based on depth to the top of the deposit, if depth >= 61m: Room and Pillar, if depth < 61m: Open Pit")
		lbl_data_frame_name <- glabel("Mine Method is based on depth to the top of the deposit,",container = input5 )
		lbl_data_frame_name <- glabel("if depth >= 61m: Room and Pillar, if depth < 61m: Open Pit",container = input5 )
		}

	if ( DTy == "Ore body massive / disseminated")                                                     
		{
		minetypes <<-c("Mine Method is based on depth to the top of the deposit, if depth >= 61m: Block Caving, if depth < 61m: Open Pit")
		lbl_data_frame_name <- glabel("Mine Method is based on depth to the top of the deposit,",container = input5 )
		lbl_data_frame_name <- glabel("if depth >= 61m: Block Caving, if depth < 61m: Open Pit",container = input5 )
		}
	
	
																	   ### creates check box for multiple mine type selection - (currently up to 2) - MT
	##MT <<- gcheckboxgroup(minetypes, checked = FALSE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)


MillNum1 <- 11

#######################################################################
##  Mill Type selection  
#######################################################################

## Read Through grades in input data to make list of commodity names
## Variable name SimFile is the econ filter input 
## ListCNames is the name of the list of all the commodities

dat1 <- read.csv(file=SimFile, header=TRUE, sep=",")
ColNames1 <<- colnames(dat1)
listGradesI <<- grep("_pct",ColNames1 )
ListCNames<<- c()
for (xx in listGradesI)
	{
	CName <<-  sub("._pct","",ColNames1[xx])
	ListCNames<<- c(ListCNames,CName )
	}
x <<- 1 

## Calculate number of commodities 
CountCN <<- length(ListCNames)

#######################################################################
## Create MRR list for all commodities (before sepearaiton
#######################################################################

FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/MillR.csv", sep="")  
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- nrow (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value

MRWMax <- MRl + 1


NewListMRR <- c()

for (nameC in ListCNames )
{
	MRw <<- 2  ## start at row 2
	MRWMax <- MRl + 1

	while (MRw < MRWMax )
	{
		
		MRn1 <<- MR[MRw,1]
		MRn <<- toString(MRn1)

		if (MRn == nameC)
				{
				MR234<<- as.numeric( toString(MR[MRw,MillNum1]))
				
				NewListMRR <- c(NewListMRR,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
				}

		MRw <- MRw + 1 
		
	}
}

#######################################################################
## Create commodity value list before any separation 
## Commodity values
#######################################################################

FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- ncol (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value
MRw <<- 1  ## start at row 1
MRWMax <- MRl + 1

NewListCV <- c()    ## Makes new empty cvalue list


for (nameC in ListCNames )
{
MRw <<- 1  ## start at row 1

while (MRw < MRWMax )
	{
	
	MRn1 <<- MR[1,MRw]
	MRn <<- toString(MRn1)
	
	if (MRn == nameC)
			{
			MR234<<- as.numeric( toString(MR[2,MRw]))
			
			NewListCV <- c(NewListCV ,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
			}


	MRw <- MRw + 1 
	
	}
}

## Create number of commodity notice 
NoteCount <<- paste(CountCN," Commodities Detected",sep="")
lbl_data_frame_name <- glabel("", container = input5 )
lbl_data_frame_name <- glabel(NoteCount, container = input5 )

## Creates radio button choice - choice is based on number of commodities 
## Next step is to let the commodity names to be changed in this, 
if (CountCN == 6)
{
## Radio buttons for mill type options - based on 4 count

lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","2 - Product Flotation","3 - Product Flotation","Customize Mill Options", "None"  ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)

}
if (CountCN == 5)
{
## Radio buttons for mill type options - based on 4 count
lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","2 - Product Flotation","3 - Product Flotation","Customize Mill Options", "None"  ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)

}

if (CountCN == 4)
{
## Radio buttons for mill type options - based on 4 count
lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","2 - Product Flotation","3 - Product Flotation","3-Product Flotation (Omit lowest value commodity)","Customize Mill Options", "None"  ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)
}

if (CountCN == 3)
{
## Radio buttons for mill type options - based on 4 count
lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","2 - Product Flotation","3 - Product Flotation","Customize Mill Options", "None"   ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)
}

if (CountCN == 2)
{
## Radio buttons for mill type options - based on 4 count
lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","2 - Product Flotation","Customize Mill Options" , "None"  ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)

}

if (CountCN == 1)
{
## Radio buttons for mill type options - based on 4 count
lbl_data_frame_name <- glabel("Reccomended Mill Options:", container = input5 )
MillChoice00 <<- gradio(c("1 - Product Flotation","Customize Mill Options" , "None"  ), checked = TRUE, horizontal = FALSE, use.table=FALSE, handler = NULL, action = NULL, container = input5)

}

## End mill type selection 

#######################################################################
## Submit Mine and Mill Type selections  
#######################################################################

KOu1 <<- 0
KOu2 <<- 0
KCu1 <<- 0
KCu2 <<- 0
Name1 <<- "NA"
														   ### creates continue 4 button - sets process for next choices (environmental choice)
	obj <- gbutton(text   = "Continue", container=input5, 
	handler = function(h,...)
	{
	MillChoice1 <<- svalue(MillChoice00)
	MillChoice 	<<- MillChoice1
	#MineTypes001 <<- svalue(MT)
	
	if (MillChoice == "Customize Mill Options")
		{
	CF1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CustomTab.r", sep="")  
	source(CF1)
		}
	
#######################################################################
## Days of operation selection
#######################################################################	
																	   ### creates days of operation choice (350- unrestricted, 260- restricted) - days
	lbl_data_frame_name <- glabel("Days of Operation/yr",container = input66)
	lbl_data_frame_name <- glabel("Full Time (350), Restricted Time (260)",container = input66 )
	DO <<- c("350", "260")
	days <<- gradio(DO , container=input66)

#######################################################################
## Sets PVD to 0 , for start
#######################################################################

PVD2 <<- 0
PVD3 <<- 0 

#######################################################################
## Environemnt choices based on mine type -  Tailings Pond, Dam and Liners
#######################################################################

                                                                ### if open  pit, block caving, or room and pillar-  it gives the choice of tailings pond, dam, and liner
	lbl_data_frame_name <- glabel( "Select Waste Management Choices ", container = input62)
	EnvC <<- c("Tailings Pond and Dam", "Liner")
	EnvType<<- gcheckboxgroup(EnvC, checked = FALSE, horizontal = FALSE, use.table=FALSE,
	handler = NULL, action = NULL, container = input62)

	
																	    ### creates continue 4 button - to submit the environment choice 
	obj <- gbutton(text   = "Continue", container=Box0, 
	handler = function(h,...)
	{
	ECh <<- svalue(EnvType)

#######################################################################
## Registering/ using the envrionement choices 
#######################################################################
																	    ###  creates TPD variable - 1 if yes to tailings pond or 0 if not  
                                                                                                          ###  creates Liner variable - 1 if yes to liner or 0 if not  
TPD <<- 1
Liner <<- 1
if (is.na(ECh[1]) == "TRUE") { TPD <<- 0}
if (is.na(ECh[2]) == "TRUE") { Liner <<- 0}
if (is.na(ECh[1]) == "TRUE") { Liner <<- 0}


#######################################################################
## Marshall Swift Composite CE 1989-2008 avg in 2008$
MSC <<- 1.26                                                                                              ### MSC cost is set to 1.26 default 


#######################################################################
##Investment Rate of Return (Default)
IRR <<- 0.15                                                                                              ### MSC cost is set to 1.26 default 

#######################################################################
## Cost inflation factor  - Captial cost and operating cost                                               ### sets inflation factors to a default of 1
CCIF <<- 1.00
OCIF <<- 1.00

#######################################################################
## Creates calculation and submission dialog 
#######################################################################

	EnvT <<- svalue(EnvType)                                                                            ### saves the environment choices -  EnvT
	dpy <<- as.double(svalue(days))                                                                     ### saves the days of operation choice -  dpy

#######################################################################
## Creates finish process/ download buttons 
#######################################################################
																	    ### creates BoxS1 frame
BoxConfirm <- gframe("Confirm Data",horizontal= FALSE, container=BoxS)
																          ### Creates BoxS1A - will include download paramters and submit
                                                                                                          ### creates BoxS1B  -- will include download stats 
BoxS1CC <- gframe("Changes to Defaults",horizontal= FALSE, container=BoxS)

BoxS1A <- gframe("Run Steps",horizontal= FALSE, container=BoxS)

BoxS1B <- gframe("Download Stats",horizontal= FALSE, container=BoxS)

BoxS1D <- gframe("Download Plots",horizontal= FALSE, container=BoxS)                                      ### creates BoxS1D -- download plots 

BoxS1C <- gframe("Finish Process",horizontal= FALSE, container=BoxS)

CMRR1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/mrrchange.r", sep="")  

obj <- gbutton(                                                                                           ### creates change defualt MSC button 
	text   = "Confirm and check data",
      container=BoxConfirm,
      handler = function(h,...)
	{
ROut1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CVMR.r", sep="") 
source (ROut1)
	})

obj <- gbutton(                                                                                           ### creates change defualt MSC button 
	text   = "Metallurgical Recovery Rate",
      container= BoxS1CC,
      handler = function(h,...)
	{
	source(CMRR1)
	})


obj <- gbutton(                                                                                           ### creates change defualt MSC button 
	text   = "Marshall Swift Cost (1.26)",
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
	MSC <<- as.double(svalue(ObjMSC))
	}
	)
	}
	)

obj <- gbutton(                                                                                           ### creates change defualt MSC button 
	text   = "Investment Rate of Return (0.15)",
      container= BoxS1CC ,
      handler = function(h,...)
	{
	input5cc <- gwindow("",horizontal= FALSE)
	ObjIRR <<- gedit("0.15",width = 13,container = input5cc )
	obj <- gbutton(
	text   = "Confirm IRR Change",
      container= input5cc ,
      handler = function(h,...)
	{	
	IRR <<- as.double(svalue(ObjIRR))
	}
	)
	}
	)
obj <- gbutton(                                                                                           ### creates change defualt inflation factors button
	text   = "Operating Cost Inflation Factor(1)",
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
	OCIF <<- as.double(svalue(ObjOCIF))
	}
	)
	}
	)
obj <- gbutton(
	text   = "Capital Cost Inflation Factor(1)",
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
	CCIF <<- as.double(svalue(ObjCCIF))
	}
	)
	}
	)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	




































obj <- gbutton(
	text   = "Run RAEF Process",
      container= BoxS1B,
   handler = function(h,...)
	{

svalue(sb) <- "RAEF Process Started"
timenow <<- Sys.time()
newstatus <<- paste("Started Process at: ",timenow,sep="")
lbl_data_frame_name <- glabel(newstatus,container = BoxS1B  )

	
#############################################Step 00 Set Parameters

	date1 <<- Sys.Date()                                                                                ### calculates current date and time to add to the parameters file 
	date2 <<- format(date1,"%a %b %d %Y")
	time1 <<- Sys.time()
	time2 <<- format(time1, "%X ")
	
	##add econ file siumlation file input addres

	ECh <<- svalue(EnvType)                                                                               
	LCN1 <<- length (ListCNames)
	
MCho1 <<- "No set custom mill option for commodity #1"
MCho2 <<- "No set custom mill option for commodity #2"
MCho3 <<- "No set custom mill option for commodity #3"
MCho4 <<- "No set custom mill option for commodity #4"
MCho5 <<- "No set custom mill option for commodity #5"
MCho6 <<- "No set custom mill option for commodity #6"

if (MillChoice == "Customize Mill Options")
	{
	if (!is.na(MillCList[1]))
		{
		MCho1 <<- svalue(MillCList[1])
		}

	if (!is.na(MillCList[2]))
		{
		MCho2 <<- svalue(MillCList[2])
		}

	if (!is.na(MillCList[3]))
		{
		MCho3 <<- svalue(MillCList[3])
		}

	if (!is.na(MillCList[4]))
		{
		MCho4 <<- svalue(MillCList[4])
		}

	if (!is.na(MillCList[5]))
		{
		MCho5 <<- svalue(MillCList[5])
		}

	if (!is.na(MillCList[6]))
		{
		MCho6 <<- svalue(MillCList[6])
		}
	}

udtest <<- 1
if (MillChoice == "Customize Mill Options")
	{
	for (hh in MillCList)
		{
		zz <<- svalue(hh)
		if (zz == "User Define") 
			{ 
			udtest <<- 2
			}
		}
	}

if (udtest < 2)
{
KC1 <- 0
KC2 <- 0
KC3 <- 0
KO1 <- 0
KO2 <- 0
KO3 <- 0
UDName1 <- "NONE"
}

	if (is.na(KC1)){ KC1 <- "None"}
	if (is.na(KC2)){ KC2 <- "None"}
	if (is.na(KO1)){ KO1 <- "None"}
	if (is.na(KO2)){ KO2 <- "None"}
	if (is.na(UDName1 )){ UDName1 <- "None"}	


	KC1 <<- svalue(KC1)
	KC2 <<- svalue(KC2)
	KO1 <<- svalue(KO1)
	KO2 <<- svalue(KO2)

	RS1 <<- rbind (date2,time2, SimFile, WD, TN1, NumCat, Min1, Max1, Per1, Min2, Max2, Per2, Min3, Max3, Per3, Min4, Max4, Per4, DTy, minetypes, MillChoice[1],MillChoice[2], dpy, ECh[1],ECh[2], MSC,IRR, CCIF, OCIF, TA1, UDName1 ,KC1,KC2,KO1, KO2,MCho1,MCho2,MCho3,MCho4,MCho5,MCho6)
	rownames(RS1) <- c("Date", "Time", "Econ Filter File", "Working Directory", "Run Name", "Number of Depth Intervals", "Min1", "Max1", "Per1", "Min2", "Max2", "Per2", "Min3", "Max3", "Per3", "Min4", "Max4", "Per4","Deposit Type", "Mine Method","Mill Type 1 ", "Mill Type 2 ","Days of Operation", "Environment Choice 1 ","Liner?", "MSC", "Investment Rate of Return","Cap Cost Inflation Factor", "Operating Cost Inflation Factor", "Area","User Define Mill Name (if applicable)", "User Define: Mill Capital Cost Constant", "User Define: Mill Capital Cost Power log", "User Define: Mill Operating Cost Constant", "User Define: Mill Operating Cost Power log","Custom_Mill_Option1","Custom_Mill_Option2","Custom_Mill_Option3", "Custom_Mill_Option4","Custom_Mill_Option5","Custom_Mill_Option6" )
	filename <<- paste("EF_01_Parameters_",TN1,".csv", sep ="")		
	write.csv(RS1, file = filename , row.names=TRUE)
USL <<- paste(InputFolder1,"/AuxFiles/RScripts","/uselist1.r", sep="") 
	source(USL)


#############################################Step 01 Download Parameters
dat1000 <<- read.csv(filename , header = TRUE)	
filename <- paste("EF_01_Parameters_",TN1,".csv", sep ="")	
D2 <<- as.matrix(dat1000)
D1 <<- as.matrix(FullTable)
colnames(D1) <- c("A","B")
colnames(D2) <- c("A","B")
FullTab2 <- rbind(D2,D1)
write.csv(FullTab2, file = filename , row.names=TRUE)

svalue(sb) <- "Parameters file completed"


    #### Internal Files                                                                                                      ### Rcode file names
R0001 <<- paste(InputFolder1,"/AuxFiles/RScripts","/agg1.r", sep="")  
R0002 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CStatsR.r", sep="")  
R0003a <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1a.r", sep="")  
R0003b <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1b.r", sep="")  
R0003c <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1c.r", sep="")  
R0003d <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1d.r", sep="")  
R0003e <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1e.r", sep="") 
R0003f <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1f.r", sep="") 
R0004 <<- paste(InputFolder1,"/AuxFiles/RScripts","/D10R.r", sep="")  
R0005 <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes2int.r", sep="")  
R0005b <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes3int.r", sep="")  
R0005c <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes4int.r", sep="")  
R0005d <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes1int.r", sep="")  
R0006a <<- paste(InputFolder1,"/AuxFiles/RScripts","/dcat1a.r", sep="")  
R0006 <<- paste(InputFolder1,"/AuxFiles/RScripts","/dcat1.r", sep="")  
BE01 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CalcBE.r", sep="")  
BE02 <<- paste(InputFolder1,"/AuxFiles/RScripts","/PlotOV103018.r", sep="")  
BE03 <<- paste(InputFolder1,"/AuxFiles/RScripts","/PlotCUEQ.r", sep="")  
Redo <<- paste(InputFolder1,"/AuxFiles/RScripts","/file2_82917.r", sep="")  
dfile <<- paste(InputFolder1,"/AuxFiles/RScripts","/dfiles.r", sep="")  

























########################################## Step 02 Submit
##Reads the SimEF file
	listP <<- ""
	dat1 <<- read.csv(SimFile , header = TRUE)
	NumLines <<- nrow(dat1)
	NumCols <<- ncol(dat1)
	ColNames1 <<- colnames(dat1)
	listGrades1 <<-""

##################################################
## List of all Grades
#################################################

	listGradesI <<- grep("_pct",ColNames1 )                                                                 ### records the column names of the SimFile that reads "_pct" , grade names in a list - listGradesI
	GradeNum <<- length(listGradesI)												  ### records the number of grades in the list-  GradeNum
	ListGradeNames<<- c()                                                                                   ### creates Grade names list - ListGradeNames 
	for (xx in listGradesI)                                                                                 ### for each grade in the list, add the name to the grade name list - ListGradeNames 
		{
		ListGradeNames<<- c(ListGradeNames,ColNames1[xx])
		}
	x <<- 1


NumGrades0 <<-length(ListGradeNames)												   ### number of grades 
MineNum001 <<- 1 

DepthM <<- 0	
KoE <<- 0

#####################################
## Printing headings before analysis 
####################################
																		   ### creating name list of contained resources for heading 
cList00 <<-c()
for( gi in ListGradeNames)
	{
	h00 <-paste("Contained_",gi,sep="")                                                                      ### creates contained resources name 
	h200 <- sub("_pct", 'Tons', h00)
	cList00 <- c(cList00 , h200)                                                                             ### creates contained resources name list-  cList00
	}

## creating name list of recovered for heading 

rList0 <<-c()                                                                                                  ### creating name list of recovered resources for heading 
for( gir in ListGradeNames)
	{
	r <<-paste("Recovered_",gir,sep="")                                                                      ### creates recovered resources name 
	r2 <- sub("_pct", 'Tons', r)
	rList0 <<- c(rList0 , r2)                                                                                ### creates recovered resources name list-  rList0
	}

																		   ### creating names for OreV
G1 <<- 1
OVPECList2 <<- c()
for (gh in ListGradeNames)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	OVPECList2 <<- c(OVPECList2,zG)                                                                          ### create ore value per commodity list 
	G1 <<- G1 + 1
	}


if (MineNum001 == 1)
{

																		   ### creates a heading list based on the number of grades and mine types- if statements 

if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],"OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1], rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD" , "PVD_Max","NPV_Area", "BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],OVPECList2[6],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5], ListGradeNames[6],  cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}

}

if (MineNum001 == 2)
{



if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1], "OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1],  rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] ,"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3],  cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max", "NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],  rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5], OVPECList2[6],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],ListGradeNames[6],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}

}

OutF1 <<- paste("EF_02_Output_",TN1,".csv", sep = "")	
write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)                                               ### creates output file for run

#######################################################################
## Reads each of the lines in the SimEF file- line by line 
#######################################################################
x <<- 0
for (xx1 in 1:NumLines )
	{
	x <<- x + 1
	NumDep <<- dat1[x,3]
	
#######################################################################
## Checks to see if the record has 0 deposits ,if so sets variables to 0 
#######################################################################

	if (NumDep == 0) 
		{
		SimIndex <<- dat1[x,2]
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- ""
		listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, NA1)
		write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)
		}

#######################################################################
## Checks to see if Num of deposits > 0
#######################################################################

	if (NumDep > 0) 
		{
		
#######################################################################
## Saves the key info from the SimEF file 
#######################################################################

		SimIndex <<- dat1[x,2]
	
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- "FALSE"

#######################################################################
## If zero num deposits-  program says skip 
#######################################################################
           
	Ton <<- dat1[x,5]

#######################################################################
## Grades 
#######################################################################

	GradeNumM2 <<- GradeNum + 1
	y <<- 1
	z2 <- 6
	
	y <- 1
	for ( yi in ListGradeNames)
		{
																		      ### assigns the grade values to the grade names
 		assign(ListGradeNames[y], dat1[x,z2] )
		y<<- (y +1)
		z2 <<- z2+1
		}

#######################################################################
## Short Tons and Life Calculations
#######################################################################

## ShortTons
	ShortTons <<- (Ton/0.907185)

## Life 	
	Life <<- 0.2 * (ShortTons)^0.25
	#MineMethod <<- MineTypes001

#######################################################################
## Random number calc for depth
#######################################################################

## 1 Select a category using the probabiltiy

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

## 2 find random number based on the category

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
	
	if (DTy == "Flat-bedded/stratiform")
	{
	if (Depth >= 61)
		{
		MineMethod <<- "Room-and-Pillar"
		}
	if (Depth < 61)
		{
		MineMethod <<- "Open Pit"
		}
	}

if (DTy == "Ore body massive / disseminated")
	{
	if (Depth >= 61)
		{
		MineMethod <<- "Block Caving"
		}
	if (Depth < 61)
		{
		MineMethod <<- "Open Pit"
		}
	}

if (DTy == "Vein deposit / steep")
	{
	MineMethod <<- "Vertical Crater Retreat"
	}

	

#MineMethod <<- MineTypes001[1]

#######################################################################
## Calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
## Calculations based on each mine method 
#######################################################################
SR <<- "NA"
                                                                                              ### if mine method 1 is open pit
if (MineMethod == "Open Pit")
{
DF <<- .05
RF <<- .90
MOTRF <<-  ((1 + DF) * RF )
#DepthM <<- (0.5987 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth,  half sphere model
DepthM <<- (0.3772 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth,  half sphere model
SR <<- ((2.225 * 4.1 * (DepthM^3 / ShortTons ) - 1))
if (dpy == 350) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/70}
if (dpy == 260) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/52}

                                                                                             ### based on the open pit mine capacity, the operating costs changes 
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


		DepthM <<- ( 0.3772 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth, - cylinder model
	
		T <- (ShortTons * RF * (1+ DF))
		if (dpy == 350) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/52}

		KcA <<- 64800 * Cm^0.759
		KcB <<- 371 * Cm + 180 * 3 * DepthM * Cm^.404    ## UG deph captial cost
		Kc <<- KcB + KcA
		KoA <<- ((2343/Cm) + 0.44 *  (3* DepthM/Cm) + 0.00163 * 3* DepthM)  ## UG depth operating costs
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
		if (dpy == 350) { Cm <<-(((0.05 + 1) * (MOTRF * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<-(((0.05 + 1) * (MOTRF * ShortTons))^0.75)/52}
		#DCalc001 <<- (0.114*((ShortTons)^(1/3))+(1.0936*Depth))
		DCalc001 <<- (0.0243*((ShortTons)^(1/3))+(1.0936*Depth))
		if(DCalc001  < 6) { SDepth <<- 6 }
		if(DCalc001 >=6) {SDepth <<-DCalc001}
		KcA <<- 97600 * Cm^0.644   ## UG Room and Pillar capital cost
		KcB <<- 371 * Cm + 180 * 3 * SDepth * Cm^.404    ## Underground mine depth capital cost
		Kc <<- KcB + KcA ## Room Pillar capital cost
		KoA <<- 35.5 * Cm^(-0.171)  ## RP OC ($/st)
		KoB <<- ((2343/Cm)+0.44*3*SDepth/Cm+0.00163*3*SDepth) ## UG Depth OC($/st)
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
		if (dpy == 350) { Cm <<-(((0.1 + 1) * (MOTRF * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<-(((0.1 + 1) * (MOTRF * ShortTons))^0.75)/52}


		DepthM <<- 0.6853 * ShortTons^(1/3) + 1.0936 * Depth 
		
		KcA <<- 45200 * Cm^0.747
		KcB <<- 371 * Cm + 180 * 3 * DepthM* Cm^.404    ## UG deph captial cost
		Kc <<- KcB + KcA
		KoB <<- 51.0 * Cm^(-0.206)
		KoA <<- ((2343/Cm) + 0.44 * 3 * DepthM/Cm + 0.00163 * 3 * DepthM)  ## UG depth operating costs
		Ko <<- KoA + KoB
		MOCpy  <<- (Cm * Ko * dpy) 
		
		}

#######################################################################
## Records grades 
#######################################################################

GradeData <<- dat1
unn <<- 6
for (uuu in ListGradeNames) 
{
assign(uuu, GradeData[x,unn], env = .GlobalEnv)
unn <<- unn + 1
}

#######################################################################
## Calculates the value per each comoodity in Ore  
#######################################################################

G1 <<- 1
OVPECList <<- c()
for (gh in ListCNames)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	VPEC <<- ( 0.90715 * (svalue(CVList[G1])) * svalue(MRRList [G1]) * (svalue(ListGradeNames[G1]) / 100) )
	assign(zG,VPEC, env =.GlobalEnv)
	OVPECList <<- c(OVPECList,zG)
	G1 <<- G1 + 1
	}

if(NumGrades0 == 1)
	{
OVPEC1 <- svalue(OVPECList[1])
	}
if(NumGrades0 == 2)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
}

if(NumGrades0 == 3)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
	}

if(NumGrades0 == 4)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
	}

if(NumGrades0 == 5)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
	}

if(NumGrades0 == 6)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
OVPEC6 <- svalue(OVPECList[6])
	}

#######################################################################
## Configuring a test for commodities that are not none to be added to the list
#######################################################################

RecListWONone <<-c()
CountRecWON <<- 0

for (m8 in MRRList)
{
varm8 <<- svalue(m8)

if (varm8 >= 0)
{
RecListWONone <<- c(RecListWONone ,m8)
CountRecWON <<- CountRecWON + 1
}
}

OreVListWONone <<-c()
for (ovWN in OVPECList)
{
varm8 <<- svalue(ovWN)
if (varm8 >= 0)
{
OreVListWONone <<- c(OreVListWONone ,ovWN )
}
}

## Confirming save of values for print out 
if(CountRecWON == 1)
	{
OVPEC1b <- svalue(OreVListWONone[1])
	}

if(CountRecWON == 2)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])

if (OVPEC1b > OVPEC2b) 
{	
OH<<- OreVListWONone[1]
}

if (OVPEC2b > OVPEC1b) 
{	
OH<<- OreVListWONone[2]
}

if (OVPEC1b < OVPEC2b) 
{	
OL<<- OreVListWONone[1]
}

if (OVPEC2b < OVPEC1b) 
{	
OL<<- OreVListWONone[2]
}
}

if(CountRecWON == 3)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
OH<<- OreVListWONone[1]
}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
OH<<- OreVListWONone[2]
}}
if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
OH<<- OreVListWONone[3]
}}


if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
OL<<- OreVListWONone[1]
}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
OL<<- OreVListWONone[2]
}}
if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
OL<<- OreVListWONone[3]
}}

	}

if(CountRecWON == 4)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
OH<<- OreVListWONone[1]
}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
OH<<- OreVListWONone[2]
}}}
if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
OH<<- OreVListWONone[3]
}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
OH<<- OreVListWONone[4]
}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
OL<<- OreVListWONone[1]
}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
OL<<- OreVListWONone[2]
}}}
if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
OL<<- OreVListWONone[3]
}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
OL<<- OreVListWONone[4]
}}}

	}

if(CountRecWON == 5)
	{

OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])
OVPEC5b <- svalue(OreVListWONone[5])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
OH<<- OreVListWONone[1]
}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
OH<<- OreVListWONone[2]
}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
OH<<- OreVListWONone[3]
}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
OH<<- OreVListWONone[4]
}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
OH<<- OreVListWONone[5]
}}}}



if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
OL<<- OreVListWONone[1]
}}}}


if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
OL<<- OreVListWONone[2]
}}}}


if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
OL<<- OreVListWONone[3]
}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
OL<<- OreVListWONone[4]
}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
OL<<- OreVListWONone[5]
}}}}

	}

if(CountRecWON == 6)
	{

OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])
OVPEC5b <- svalue(OreVListWONone[5])
OVPEC6b <- svalue(OreVListWONone[6])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
if(OVPEC1b > OVPEC6b )
{
OH<<- OreVListWONone[1]
}}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
if(OVPEC2b > OVPEC6b )
{
OH<<- OreVListWONone[2]
}}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
if(OVPEC3b > OVPEC6b )
{
OH<<- OreVListWONone[3]
}}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
if(OVPEC4b > OVPEC6b )
{
OH<<- OreVListWONone[4]
}}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
if(OVPEC5b > OVPEC6b )
{
OH<<- OreVListWONone[5]
}}}}}

if (OVPEC6b > OVPEC1b) 
{	
if(OVPEC6b > OVPEC3b )
{
if(OVPEC6b > OVPEC2b )
{
if(OVPEC6b > OVPEC1b )
{
if(OVPEC6b > OVPEC5b )
{
OH<<- OreVListWONone[6]
}}}}}



if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
if(OVPEC1b < OVPEC6b )
{
OL<<- OreVListWONone[1]
}}}}}


if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
if(OVPEC2b < OVPEC6b )
{
OL<<- OreVListWONone[2]
}}}}}


if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
if(OVPEC3b < OVPEC6b )
{
OL<<- OreVListWONone[3]
}}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
if(OVPEC4b < OVPEC6b )
{
OL<<- OreVListWONone[4]
}}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5 < OVPEC4 )
{
if(OVPEC5b < OVPEC6b )
{
OL<<- OreVListWONone[5]
}}}}}

if (OVPEC6b < OVPEC1b) 
{	
if(OVPEC6b < OVPEC3b )
{
if(OVPEC6b < OVPEC2b )
{
if(OVPEC6b < OVPEC4b )
{
if(OVPEC6b < OVPEC5b )
{
OL<<- OreVListWONone[6]
}}}}}

	}

###########################################
## Value of Ore Calculation 
###########################################

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
a <<- MRRList [numL]
f <<- svalue(a)
b <<- CVList[numL] 
c0 <<- ListGradeNames[numL]

g <<- svalue(b)
d <<- svalue(c0)
e <<- (d /100) 
MATH1 <<-(f * g * e) 
assign(gg9, MATH1, env = .GlobalEnv)
numL <<- numL + 1
}


OreV <<- 0
OreV1  <<- 0
for (gg99 in OreGradeV) 
{
OreV1 <<- OreV1 + svalue(gg99)
}

OreV <<-  0.90715 * OreV1 
OldV <<- OreV 

if (MillChoice ==  "3-Product Flotation (Omit lowest value commodity)")
{
OreV <<- (OreV - svalue(OL))
}



if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- sub("OreV_","", OL)
}


if (MillChoice != "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- "NA"
}

#########################################
### Calcualtes Mill equations
########################################

## Capacity mill
if (dpy == 350) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 52)}

NS <<- 1

## Mill type equations 

if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
		{ 

		## equations for 3 product 
		KcM <<- 83600 * Cml^0.708
		KoM <<- 153 * Cml^(-0.344)
		}

if (MillChoice == "3 - Product Flotation") 
		{ 

		## equations for 3 product 
		KcM <<- 83600 * Cml^0.708
		KoM <<- 153 * Cml^(-0.344)
		}

if (MillChoice == "2 - Product Flotation") 
		{ 
		## equations for 2 product 
		KcM <<- 82500 * Cml^0.702
		KoM <<- 149 * Cml^(-0.356)	
		}

if (MillChoice == "1 - Product Flotation") 
		{ 
		## equations for 1 product 
		KcM <<- 92600 * Cml^0.667
		KoM <<- 121 * Cml^(-0.336)	
		}

if (MillChoice == "None") 
		{ 
		KcM <<- 0
		KoM <<- 0
		#MillNum <<- 13
		NS <<- 0
		}

if (MillChoice == "Customize Mill Options") 
	{
	## Set empty cost variables - so you can sum them , and if its not being used it iwll be summing a 0 value. 
	KoM1P <<- 0
	KoM2P <<- 0
	KoM3P <<- 0
	KoM4P <<- 0 
	KcM1P <<- 0
	KcM2P <<- 0
	KcM3P <<- 0 
	KcM4P <<- 0 
	KcMUDi <<- 0
	KoMUDi <<- 0
	KcMSX  <<- 0
	KoMSX  <<- 0
	KoMCD <<- 0
	KcMCD <<- 0
	KoMCIP <<- 0
	KcMCIP <<- 0
	KoMAHL <<- 0
	KcMAHL <<- 0
	KoMAFRL <<- 0
	KcMAFRL <<- 0

	hv1 <<- "A"
	hv2 <<- "A"
	hv3 <<- "A"
	hv4 <<- "A"
	hv5 <<- "A"
	hv6 <<- "A"

	hv1 <<- svalue(MillCList[1])
	hv2 <<- svalue(MillCList[2])
	hv3 <<- svalue(MillCList[3])
	hv4 <<- svalue(MillCList[4])
	hv5 <<- svalue(MillCList[5])
	hv6 <<- svalue(MillCList[6])

	if (is.na(hv2)== "TRUE")
		{
	hv2 <<- "A"
		}

	if (is.na(hv3)== "TRUE")
		{
	hv3 <<- "A"
		}

	if (is.na(hv4)== "TRUE")
		{
	hv4 <<- "A"
		}
	if (is.na(hv5)== "TRUE")
		{
	hv5 <<- "A"
		}
	if (is.na(hv6)== "TRUE")
		{
	hv6 <<- "A"
		}

	if ( hv1 == "3-Product" | hv2 == "3-Product" | hv3 == "3-Product"  | hv4 == "3-Product"  | hv5 == "3-Product" | hv6 == "3-Product"  )
		{
		KcM3P <<- 83600 * Cml^0.708
		KoM3P <<- 153 * Cml^(-0.344)
		}

	if ( hv1 == "2-Product" | hv2 == "2-Product" | hv3 == "2-Product"  | hv4 == "2-Product"  | hv5 == "2-Product" | hv6 == "2-Product"  )
		{
		KcM2P <<- 82500 * Cml^0.702
		KoM2P <<- 149 * Cml^(-0.356)
		}

	if ( hv1 == "1-Product" | hv2 == "1-Product" | hv3 == "1-Product"  | hv4 == "1-Product"   | hv5 == "1-Product"  | hv6 == "1-Product"  )
		{
		KcM1P <<- 92600 * Cml^0.667
		KoM1P <<- 121 * Cml^(-0.335)
		}

	if ( hv1 == "SX_EW" | hv2 == "SX_EW" | hv3 == "SX_EW"  | hv4 == "SX_EW"   | hv5 == "SX_EW"  | hv6 == "SX_EW"  )
		{
		KcMSX <<- 14600 * Cml^0.596
		KoMSX <<- 3 * Cml^(-0.145)
		}

	if ( hv1 == "CCD" | hv2 == "CCD" | hv3 == "CCD"  | hv4 == "CCD"   | hv5 == "CCD"  | hv6 == "CCD"  )
		{
		KcMCD <<- 414000 * Cml^0.584
		KoMCD <<- 128 * Cml^(-0.300)
		}

	if ( hv1 == "CIP" | hv2 == "CIP" | hv3 == "CIP"  | hv4 == "CIP"   | hv5 == "CIP"  | hv6 == "CIP"  )
		{
		KcMCIP <<- 372000 * Cml^0.540
		KoMCIP <<- 105 * Cml^(-0.303)
		}

	if ( hv1 == "Au Heap Leach" | hv2 == "Au Heap Leach" | hv3 == "Au Heap Leach"  | hv4 == "Au Heap Leach"   | hv5 == "Au Heap Leach"  | hv6 == "Au Heap Leach"  )
		{
		KcMAHL <<- 296500 * Cml^0.512
		KoMAHL <<- 31.5 * Cml^(-0.223)
		}

	if ( hv1 == "Au Float/Roast/Leach" | hv2 == "Au Float/Roast/Leach" | hv3 == "Au Float/Roast/Leach"  | hv4 == "Au Float/Roast/Leach"   | hv5 == "Au Float/Roast/Leach"  | hv6 == "Au Float/Roast/Leach"  )
		{
		KcMAFRL <<- 481000 * Cml^0.552
		KoMAFRL <<- 101 * Cml^(-0.246)
		}

	if ( (hv1 == "User Define") || (hv2 == "User Define") || (hv3 == "User Define")  || (hv4 == "User Define") || (hv5 == "User Define")|| (hv6 == "User Define")  )
		{
		KC1i <<- as.numeric(KC1)
		KC2i <<- as.numeric(KC2)
		KO1i <<- as.numeric(KO1)
		KO2i <<- as.numeric(KO2)
		KcMUDi <<- KC1i * Cml^KC2i 
		KoMUDi <<- KO1i * Cml^(KO2i)
		}

		### summing all the values 
		KoM <<- KoM1P + KoM2P + KoM3P + KoMUDi + KoMSX + KoMCD + KoMCIP + KoMAHL + KoMAFRL 
		KcM <<- KcM1P + KcM2P + KcM3P + KcMUDi + KcMSX + KcMCD + KcMCIP + KcMAHL + KcMAFRL 
	}

#######################################################################
## Calculating CuEQ%   
#######################################################################
if (!exists("CV_Cu"))
{
	FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
	MR22 <<- read.csv(FileinCV , header= FALSE) 
	countC <<- 1
	for (Z in MR22)
		{
		k <<- (MR22[1,countC])
		if(k == "Cu")
			{
			val1 <<- MR22[2,countC]
			g22 <<- (svalue(MR22[[2,1]]))
			gnew <<- as.numeric(levels(droplevels(g22)))
			c111 <<- gnew
			}
		countC <<- countC + 1
		}
}

if (exists("CV_Cu"))
{
c111 <<- svalue(CV_Cu)
}

c1010 <<- as.double(c111)


if (exists("MRR_Cu"))
{
c222 <<- svalue(MRR_Cu)
}


if (!exists("MRR_Cu"))
{

	c222 <<- 0.91
	MRR_Cu <<- c222
	
}
CuEQ <<- (100 * (1/0.90715)* OreV / ( c222 * c1010) )  

#######################################################################
## Mill operating costs per year
#######################################################################

MillOCpy <<- (Cml * KoM * dpy)

#######################################################################
## Calculation on the smelting cost 
#######################################################################

SmeltC <<- (NS *(0.26 * (2000 * ShortTons * (CuEQ/100) *  RF * MRR_Cu) / Life))

#######################################################################
## Total operating Costs Per Year
#######################################################################

TotalOCpy <<- (MSC * OCIF * (SmeltC + MOCpy + MillOCpy))

#######################################################################
## Calcualtes environment costs 
#######################################################################

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

#######################################################################
## Total Capital costs
#######################################################################

TKC <<- (( Kc + TPD*(TpKoE + DKoE) + (Liner * LKoE) + KcM) * MSC * CCIF) ## Total capital costs 
TKCpst <<- TKC/ ShortTons                                                                                                       #### Total capital costs per short ton

#######################################################################
## Value Prod $/a
#######################################################################

VP <<- ((OreV * Cml * dpy) - TotalOCpy)

#######################################################################
## Present Value
#######################################################################

pmt <<- VP  # payments - value prod
rate <<- IRR   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate
PV <<- P02 * pmt  # total present value

#######################################################################
## Present Value Deposit
#######################################################################

PVD <<- PV - TKC 

#######################################################################
#######################################################################
## Ends method 1 calcualtion  
#######################################################################
#######################################################################


#######################################################################
## Contained Grade Results 
#######################################################################

CList <<- c()
for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Contained_",u1,sep="")
d1 <- (Ton * (svalue(u)/100))
assign(z, d1, env = .GlobalEnv) 
CList <<- c(CList,z)
}

#######################################################################
## Find best method and record it as BestMethod -  if none- "None"
#######################################################################

#######################################################################
## IF MINE NUM=3 
#######################################################################

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

if (PVDa > PVDb)  { if (PVDa > PVDc)  {BestMMethod<<-  MineTypes001[1]}}
if (PVDb > PVDa)  { if (PVDb > PVDc) {BestMMethod<<-  MineTypes001[2]}}
if (PVDc > PVDa)  { if (PVDc > PVDb) {BestMMethod<<-  MineTypes001[3]}}
if (PVDa == 0) { if (PVDb == 0) { if (PVDc ==0) {BestMMethod<<- "None" } } }

#######################################################################
## PVD Max
#######################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes001[1])
{
PVDMax <<- PVD
}

if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes001[2])
		{
		PVDMax <<- PVD2
		}
	}

if(!is.na(BestMMethod))
	{
	 if (BestMMethod ==  MineTypes001[3]) 
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

} ## Ends if mine num 3

#######################################################################
## IF MINE NUM=2 
#######################################################################

if (MineNum001 == 2)
{
if (PVD < 0 ) {PVDa <<- 0}
if (PVD2 < 0 ) {PVDb <<- 0}

if (PVD > 0)   {PVDa <<- PVD}
if (PVD2 > 0 ) {PVDb <<- PVD2}

if (PVD == 0 ) {PVDa <<- 0}
if (PVD2 == 0 ) {PVDb <<- 0}

if (PVDa > PVDb)  {BestMMethod<<-  MineTypes001[1]}
if (PVDb > PVDa)  {BestMMethod<<-  MineTypes001[2]}
if (PVDa == 0) { if (PVDb == 0)  {BestMMethod<<- "None" } }

#######################################################################
### PVD Max
#######################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes001)
{
PVDMax <<- PVD
}

if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes001)
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

#######################################################################
## IF MINE NUM=1 
#######################################################################

if (MineNum001 == 1)
	{
	if (PVD < 0 ) {PVDa <<- 0}

	if (PVD > 0)   {PVDa <<- PVD}

	if (PVD == 0 ) {PVDa <<- 0}

	BestMMethod<<-  MineMethod

	if (PVDa == 0){BestMMethod<<- "None" } 

#######################################################################
## PVD Max
#######################################################################

	if (BestMMethod == "None")
		{
		PVDMax <<- 0
		}

	if (BestMMethod ==  MineMethod)
		{
		PVDMax <<- PVD
		}

	} ## ends if mine num 1

#######################################################################
## Recovered data
#######################################################################

if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- sub("OreV_","", OL)
YName <- paste(YName,"._pct",sep="")
}

CN <- 1

if (BestMMethod == "Open Pit")
	{
	RList00 <<- c()
	RF <<- .90
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		}  #ends if open pit recovered data
}

CN <- 1

if (BestMMethod == "Block Caving")
	{
	RList00 <<- c()
	RF <<- .95
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

CN <- 1

if (BestMMethod == "Room-and-Pillar")
	{
	RList00 <<- c()
	RF <<- .85
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data

}

CN <- 1

if (BestMMethod == "Vertical Crater Retreat")
	{
	RList00 <<- c()
	RF <<- .90
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

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
assign(z,svalue(u) , env = .GlobalEnv) 
GList <<- c(GList ,z)
}

#######################################################################
## Configuring a test for commodities that are not none to be added to the list
#######################################################################

RecListWONone <<-c()
CountRecWON <<- 0
for (m8 in MRRList)
{
varm8 <<- svalue(m8)
if (varm8 >= 0)
{
RecListWONone <<- c(RecListWONone ,m8)
CountRecWON <<- (CountRecWON + 1)

}
}

OreVListWONone <<-c()
for (ovWN in OVPECList)
{
varm8 <<- svalue(ovWN)

if (varm8 >= 0)
{
OreVListWONone <<- c(OreVListWONone ,ovWN )

}
}

## Confirming save of values for print out 
if(NumGrades0 == 1)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Con0001 <- svalue(CList[1])
Rec0001 <- svalue(RList00[1])
OVPEC1 <- svalue(OVPECList[1])
	}

if(NumGrades0 == 2)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])

Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])

Rec0001 <- svalue(RList00[1])
Rec0002 <- svalue(RList00[2])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
	}

if(CountRecWON == 2)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	if (OVPEC1b > OVPEC2b) 
		{	
		OH<<- OreVListWONone[1]
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		OH<<- OreVListWONone[2]
		}

	if (OVPEC1b < OVPEC2b) 
		{	
		OL<<- OreVListWONone[1]
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		OL<<- OreVListWONone[2]
		}

#1	
		if(OVPEC2b == 0)
			{
				OL<<- "NA"
			}		
		
#2	
		if(OVPEC1b == 0)
			{
				OL<<- "NA"
			}		
				

	}

if(NumGrades0 == 3)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])

Rec0001 <- svalue(RList00 [1])
Rec0002 <- svalue(RList00[2])
Rec0003 <- svalue(RList00[3])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
	}
	
if(CountRecWON == 3)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	
	if (OVPEC1b > OVPEC2b) 
		{	
		if(OVPEC1b > OVPEC3b )
			{
			OH<<- OreVListWONone[1]
			}
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		if(OVPEC2b > OVPEC3b )
			{
			OH<<- OreVListWONone[2]
			}
		}
	if (OVPEC3b > OVPEC1b) 
		{	
		if(OVPEC3b > OVPEC2b )
			{
			OH<<- OreVListWONone[3]
			}
		}

	if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b < OVPEC3b )
			{
			OL<<- OreVListWONone[1]
			}
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b < OVPEC3b )
			{
			OL<<- OreVListWONone[2]
			}
		}
	if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b < OVPEC2b )
			{
			OL<<- OreVListWONone[3]
			}
		}
		
		
		
		
			#####################################################################Start new edits

#1	
		if(OVPEC2b == 0)
			{
			if(OVPEC3b == 0 )
				{
				OL<<- "NA"
				}
			}
			
#2 			
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}

#3	
		if(OVPEC1b == 0)
			{
			if(OVPEC2b == 0 )
				{
				OL<<- "NA"
				}
			}
		
## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					OL<<- OreVListWONone[2]
				}
			}
		}

## 1 ,3 		
		if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					OL<<- OreVListWONone[3]
				}
			}
		}
		
## 2 ,1 		
		if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					OL<<- OreVListWONone[1]
				}
			}
		}
					
## 2 ,3 		
		if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					OL<<- OreVListWONone[3]
				}
			}
		}
			
## 3 ,1 		
		if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					OL<<- OreVListWONone[1]
				}
			}
		}

## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					OL<<- OreVListWONone[2]
				}
			}
		}		
				
		
		
		
	}

if(NumGrades0 == 4)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])


	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])




Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])



OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])


	}

if(CountRecWON == 4)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	
	if (OVPEC1b > OVPEC2b) 
		{	
		if(OVPEC1b > OVPEC3b )
			{
			if(OVPEC1b > OVPEC4b )
				{
				OH<<- OreVListWONone[1]
				}
			}
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		if(OVPEC2b > OVPEC3b )
			{
			if(OVPEC2b > OVPEC4b )
				{
				OH<<- OreVListWONone[2]
				}
			}
		}
	
	if (OVPEC3b > OVPEC1b) 
		{	
		if(OVPEC3b > OVPEC2b )
			{
			if(OVPEC3b > OVPEC4b )
				{
				OH<<- OreVListWONone[3]
				}
			}
		}

	if (OVPEC4b > OVPEC1b) 
		{	
		if(OVPEC4b > OVPEC3b )
			{
			if(OVPEC4b > OVPEC2b )
				{
				OH<<- OreVListWONone[4]
				}
			}
		}

	if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b < OVPEC3b )
			{
			if(OVPEC1b < OVPEC4b )
				{
				OL<<- OreVListWONone[1]
				}
			}
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b < OVPEC3b )
			{
			if(OVPEC2b < OVPEC4b )
				{
				OL<<- OreVListWONone[2]
				}
			}
		}
	
	if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b < OVPEC2b )
			{
			if(OVPEC3b < OVPEC4b )
				{
				OL<<- OreVListWONone[3]
				}
			}
		}

	if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b < OVPEC3b )
			{
			if(OVPEC4b < OVPEC2b )
				{
				OL<<- OreVListWONone[4]
				}
			}
		}
	
	#####################################################################Start new edits
		if (OVPEC4b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC2b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
		
		
		if (OVPEC4b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}

		
				
		if (OVPEC4b == 0) 
		{	
		if(OVPEC2b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
		
				
		if (OVPEC2b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
		
	
	
	
##1, 3
			if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
		
##1, 4
			if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC3b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}
			
##2, 1
			if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}
			
	
##2, 3
			if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
	
##2, 4
			if (OVPEC4b < OVPEC2b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}	
		
		
		
		
##3, 1
			if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}
	
	
## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC4b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
			
	
## 3 ,4 		
		if (OVPEC4b < OVPEC3b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}
				
	
## 4 ,1 		
		if (OVPEC1b < OVPEC4b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC2b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}

## 4 ,2 		
		if (OVPEC2b < OVPEC4b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
	

## 4 ,3 		
		if (OVPEC3b < OVPEC4b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
				
				

## 1 ,2 , 3		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}
	
	
## 1 ,2 , 4		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}	
			
## 1 ,3 , 2		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			
## 1 ,3 , 4		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}

			
## 1 ,4 , 2		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			
			
## 1 ,4 , 3		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}
			
			
## 2 ,1 , 3		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 2 ,1 , 4		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		
## 2 ,3 , 1		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 2 ,3 , 4		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 2 ,4 , 1		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

			
## 2 ,4 , 3		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 3 ,1 , 2		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		

## 3 ,1 , 4		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 3 ,2 , 1		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		
			
## 3 ,2 , 4		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 3 ,4 , 1		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 3 ,4 , 2		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		



## 4 ,1 , 2		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		

## 4 ,1 , 3		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 4 ,2 , 1		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 4 ,2 , 3		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		


## 4 ,3 , 1		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 4 ,3 , 2		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			


			
	##################################################################end new edits
	
	
	}
	
if(NumGrades0 == 5)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])
Grade0005 <-  svalue(ListGradeNames[5])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])
Con0005 <- svalue(CList[5])

Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])
Rec0005 <<- svalue(RList00[5])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
	}

if(CountRecWON == 5)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	OVPEC5b <- svalue(OreVListWONone[5])
	
	
if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
OH<<- OreVListWONone[1]
}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
OH<<- OreVListWONone[2]
}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
OH<<- OreVListWONone[3]
}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
OH<<- OreVListWONone[4]
}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
OH<<- OreVListWONone[5]
}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
OL<<- OreVListWONone[1]
}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
OL<<- OreVListWONone[2]
}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
OL<<- OreVListWONone[3]
}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
OL<<- OreVListWONone[4]
}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
OL<<- OreVListWONone[5]
}}}}
	
	#####################################################################Start new edits
#1	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}
		
	
#2	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC1b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}
	
#3	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC1b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	
	
#4	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC1b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	
	
#5	
	if (OVPEC1b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	

## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
	
	
	
## 1 ,3 		
		if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
	
## 1 ,4 		
		if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC2b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
## 1 ,5 		
		if (OVPEC5b < OVPEC1b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC2b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
## 2 ,1 		
		if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
## 2 ,3 		
		if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
	
## 2 ,4 		
		if (OVPEC4b < OVPEC2b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
	
## 2 ,5 		
		if (OVPEC5b < OVPEC2b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC3b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
	
## 3 ,1 		
		if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
## 3 ,4 		
		if (OVPEC4b < OVPEC3b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
## 3 ,5 		
		if (OVPEC5b < OVPEC3b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
				
## 4 ,1 		
		if (OVPEC1b < OVPEC4b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
				
## 4 ,2 		
		if (OVPEC2b < OVPEC4b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
		
				
## 4 ,3 		
		if (OVPEC3b < OVPEC4b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
				
## 4 ,5 		
		if (OVPEC5b < OVPEC4b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
				
## 5 ,1 		
		if (OVPEC1b < OVPEC5b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
			
## 5 ,2 		
		if (OVPEC2b < OVPEC5b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}					
				
## 5 ,3 		
		if (OVPEC3b < OVPEC5b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	

## 5 ,4 		
		if (OVPEC4b < OVPEC5b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	



## 1 ,2 , 3		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,2 , 4		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 1 ,2 , 5		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 1 ,3 , 2		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 1 ,3 , 5		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,4 , 5		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 2		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 3		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 4		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 3		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 4		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 5		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 2 ,3 , 1		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 2 ,3 , 4		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

			
			
			
			
## 2 ,4 , 3		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 3 ,1 , 2		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 3 ,1 , 4		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 3 ,1 , 5		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 1		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 4		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,4 , 1		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 3 ,4 , 5		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 1		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 2		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 5		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,3 , 2		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}



## 4 ,3 , 5		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 4 ,5 , 1		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 4 ,5 , 3		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 5 ,1 , 4		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 5 ,2 , 1		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 5 ,3 , 4		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 3		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}



#######################################

## 1 ,2 , 3	, 4	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 3	, 5	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 4	, 3	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,2 , 4	, 5	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 5	, 3	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,2 , 5	, 4	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 2	, 4	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 2	, 5	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4	, 2	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4	, 5	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 5	, 2	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 5	, 4	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2	, 3	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2	, 5	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3	, 2	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3	, 5	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 5	, 2	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 5	, 3	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 2	, 3	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 2	, 4	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 3	, 4	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 3	, 2	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 4	, 2	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 1 ,5 , 4	, 3	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}



## 2 ,1 , 3	, 4	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 3	, 5	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 4	, 3	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 4	, 5	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 2 ,1 , 5	, 3	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 5	, 4	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 2 ,3 , 1	, 4	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}



## 2 ,3 , 1	, 5	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 2 ,3 , 4	, 1	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}


## 2 ,3 , 4	, 5	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5	, 1	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5	, 4	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1	, 3	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1	, 5	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 2 ,4 , 3	, 1	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 3	, 5	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5	, 1	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5	, 3	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1	, 3	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1	, 4	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3	, 1	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3	, 4	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4	, 1	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4	, 3	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 2	, 4	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,1 , 2	, 5	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 4	, 2	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 4	, 5	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 3 ,1 , 5	, 2	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,1 , 5	, 4	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 1	, 4	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 3 ,2 , 1	, 5	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,2 , 4	, 1	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}



## 3 ,2 , 4	, 5	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5	, 1	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5	, 4	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 5	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,4 , 5	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 5	, 2	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 1	, 2	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 3 ,4 , 1	, 5	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 3 ,5 , 1	, 2	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 1	, 4	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2	, 4	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2	, 1	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4	, 1	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4	, 2	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 2	, 3	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 4 ,1 , 2	, 5	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3	, 2	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3	, 5	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 5	, 2	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}
			
## 4 ,1 , 5	, 3	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3	, 1	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3	, 5	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5	, 1	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5	, 3	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1	, 3	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1	, 5	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1	, 2	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1	, 5	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 4 ,3 , 2	, 1	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}


## 4 ,3 , 2	, 5	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 5	, 1	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}



## 4 ,3 , 5	, 2	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 4 ,5 , 1	, 2	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 1	, 3	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2	, 1	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2	, 3	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 3	, 1	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 3	, 2	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2	, 3	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2	, 4	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3	, 2	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3	, 4	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 4	, 2	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 4	, 3	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 1	, 3	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 1	, 4	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3	, 1	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3	, 4	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4	, 1	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4	, 3	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1	, 2	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1	, 4	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2	, 1	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2	, 4	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 4	, 1	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 4	, 2	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1	, 2	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1	, 3	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2	, 1	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2	, 3	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 5 ,4 , 3	, 1	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 3	, 2	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}



	
	
	
	}

if(NumGrades0 == 6)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])
Grade0005 <-  svalue(ListGradeNames[5])
Grade0006 <-  svalue(ListGradeNames[6])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])
Con0005 <- svalue(CList[5])
Con0006 <- svalue(CList[6])

Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])
Rec0005 <<- svalue(RList00[5])
Rec0006 <<- svalue(RList00[6])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
OVPEC6 <- svalue(OVPECList[6])
	}
	
if(CountRecWON == 6)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	OVPEC5b <- svalue(OreVListWONone[5])
	OVPEC6b <- svalue(OreVListWONone[6])
	
if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
if(OVPEC1b > OVPEC6b )
{
OH<<- OreVListWONone[1]
}}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
if(OVPEC2b > OVPEC6b )
{
OH<<- OreVListWONone[2]
}}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
if(OVPEC3b > OVPEC6b )
{
OH<<- OreVListWONone[3]
}}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
if(OVPEC4b > OVPEC6b )
{
OH<<- OreVListWONone[4]
}}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC4b )
{
if(OVPEC5b > OVPEC6b )
{
OH<<- OreVListWONone[5]
}}}}}

if (OVPEC6b > OVPEC1b) 
{	
if(OVPEC6b > OVPEC3b )
{
if(OVPEC6b > OVPEC2b )
{
if(OVPEC6b > OVPEC4b )
{
if(OVPEC6b > OVPEC5b )
{
OH<<- OreVListWONone[6]
}}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
if(OVPEC1b < OVPEC6b )
{
OL<<- OreVListWONone[1]
}}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
if(OVPEC2b < OVPEC6b )
{
OL<<- OreVListWONone[2]
}}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
if(OVPEC3b < OVPEC6b )
{
OL<<- OreVListWONone[3]
}}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
if(OVPEC4b < OVPEC6b )
{
OL<<- OreVListWONone[4]
}}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
if(OVPEC5b < OVPEC6b )
{
OL<<- OreVListWONone[5]
}}}}}

if (OVPEC6b < OVPEC1b) 
{	
if(OVPEC6b < OVPEC3b )
{
if(OVPEC6b < OVPEC2b )
{
if(OVPEC6b < OVPEC4b )
{
if(OVPEC6b < OVPEC5b )
{
OL<<- OreVListWONone[5]
}}}}}


#1
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
	
#2	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC1b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
	
#3	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC1b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
#4	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC1b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
#5	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC1b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}


	}

## Length of mine types choices

#######################################################################
## PVD_Max / Area
#######################################################################

NPV_Area <<- (PVDMax / TA1 )

#######################################################################
## ADDING FINAL RECORD
#######################################################################

	DCAT <<- SA

if (MineNum001 == 1)
	{

## Creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}
	
if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 , Con0001 ,Con0002 ,Con0003 , Rec0001 ,Rec0002 ,Rec0003)
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area, BestMMethod, Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5,OVPEC6, OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Grade0006,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 ,Con0006, Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}
	} #end if minenum ==1 

if (MineNum001 == 2)
	{

### creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax, NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003, Con0001 ,Con0002 ,Con0003, Rec0001 ,Rec0002 ,Rec0003)
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes001[2], dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OVPEC6 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005,Grade0006, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Con0006 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}

	} #end if minenum ==2

## Print/ save each line to the csv 
	
	write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)

	}  ## ends if statement if greater than 0
#x <<- (x + 1)

#BTime <<- Sys.time()
#OutF22 <<- paste("EF_09_TotalTime_",TN1,".txt", sep = "")
#TotalTime1 <<- BTime - ATime 
#DecTime <<- "Difference in Time"
#write(DecTime , file=OutF22, append=TRUE)
#write(TotalTime1 , file=OutF22, append=TRUE)

	}  ##ends while statement for each line 

svalue(sb) <- "RAEF Output file completed"












#############################################Step 03 Aggregate Deposits
source(R0001)
svalue(sb) <- "Aggregated deposits completed"

#############################################Step 04 Contained Stats
source(R0002) 

svalue(sb) <- "Contained stats completed"
#############################################Step 05 Depth Stats
 if (GradeNum == 4)
{source(R0003a)}
 if (GradeNum == 3)
{source(R0003b)}
 if (GradeNum == 2)
{source(R0003c)}
 if (GradeNum == 1)
{source(R0003d)}
 if (GradeNum == 5)
{source(R0003e)}
 if (GradeNum == 6)
{source(R0003f)}
svalue(sb) <- "Depth stats completed"


#############################################Step 06 10 Cat Depth Stats
source(R0004)
source(R0006a)
source(R0006) 
svalue(sb) <- "10 Cat Depth stats completed"
#############################################Step 07 Generate Table For Plots
source(BE01)
svalue(sb) <- "Table for plots generated"

#############################################Step 08 Ore Value / Metric Tons Plot
source(BE02)
#rapply((evaluate(file(BE02)))) 
svalue(sb) <- "Ore Value / Metric Tons plot completed"
#############################################Step 09 Cutoff Grade / Metric Tons Plot

source(BE03)
#rapply((evaluate(file(BE03)))) 
svalue(sb) <- "Cutoff grade/ Metric Tons plot completed"
#############################################Step 10 Finish Process		
file1a <<- paste(TN1,"_Depth10Agg5.csv",sep="")

 if (file.exists(file1a))
{
file.remove(file1a)
}

file2a <<- paste(TN1,"_DepthCat_Aggregated_Totals.csv",sep="")

 if (file.exists(file2a))
{
file.remove(file2a)
}

file3a <<- paste(TN1,"_DepthCat10_Agg_Totals8.csv",sep="")
 
if (file.exists(file3a))
{
file.remove(file3a)
}

file4a <<- paste(TN1,"_Depth10Agg6.csv",sep="")	
 
if (file.exists(file4a))
{
file.remove(file4a)
}	
	
file5a <<- paste(TN1,"_Depth10MMFF.csv",sep="")	
 
if (file.exists(file5a))
{
file.remove(file5a)
}
	
file66a <<- paste(TN1,"_NewBEOut10.csv",sep="")
if (file.exists(file66a))
{
file.remove(file66a)
}


file77a <<- paste(TN1,"_NewBEOut10WO0.csv",sep="")		
file88a <<- paste("EF_07_BreakEvenTable_",TN1,".csv",sep="")	
if (file.exists(file77a))
{
file.rename(file77a,file88a)
}
svalue(sb) <- "RAEF Run Compelted"

finishtime1 <<- Sys.time()
Finishtimeline <<- paste("The process completed at: ", finishtime1, sep="")
lbl_data_frame_name01 <- glabel(Finishtimeline,container = BoxS1B )
font(lbl_data_frame_name01) <- list(weight="bold")
})  ## Ends run raef proccess button


	} )## ends continue 4
	})
	} )## ends continue 3
	} )## ends continue 2
	} )## ends continue 1

#######################################################################
## Saves the amount of time program took
#######################################################################

#ITab <<- read.csv(OutF1)
# sink()
	}) ### end base






























################################################################################################################################################################################
##################################################################################################################################
################################################################################################################





















#######################################################################
#######################################################################
## Launch with PreSet Parameters (Batch Run) mode
#######################################################################
#######################################################################

obj <- gbutton(                                                                                         ### creates button for the launch RAEF pacakge 
	text   = "Launch with PreSet Parameters",
      container=baseW,
      handler = function(h,...)
	{
	PreSetFile <<- svalue(obj44)
	InputParTab <<- read.csv(file=PreSetFile, header=TRUE, sep=",")
	View(InputParTab)
	setwd(InputFolder1)

#######################################################################
## Set default values
#######################################################################

#######################################################################
## Frames and windows 
#######################################################################

win <- gwindow(width= 990)                                                                              ### opens main dialog for the RAEF GUI
imageL <<- paste(InputFolder1,"/AuxFiles/Images/bnrglobe3.gif",sep="")                                  ### USGS banner - adds to the dialog 
gimage(imageL , container = win)

## groups and frames inside the main dialog -to organize 
grp_name <- ggroup(horizontal= FALSE, container = win)
#grp2 <- ggroup(horizontal= FALSE,container = win)
#tmp <- gframe("Output Working Directory Input", container=grp_name)

#Box0 <- gframe("",horizontal= FALSE,container=grp_name)
BoxS <- gframe("",horizontal= FALSE,  container=grp_name)

lbl_data_frame_name <- glabel("STATUS:",container = grp_name  )

timenow <<- Sys.time()
newstatus <<- paste("Started Process at: ",timenow,sep="")
lbl_data_frame_name <- glabel(newstatus,container = grp_name  )


lbl_data_frame_name <- glabel("Batch process working..................",container = grp_name  )


#######################################################################
## Input files dialog code
#######################################################################

## Economic simulation input    
SimFile <<- as.character(InputParTab[3,3])                 ### browse for the Simulation ef file - SimFile 
wdir1 <<- as.character(InputParTab[4,3])
setwd(wdir1)                                                                                     
WD <<- getwd()                                                                                           ### changes the working directory -wdir1 and WD
cat (WD)

### Creates text box for user to enter run name - testname1 
testname1<<- as.character(InputParTab[5,3])                                   
																															
#######################################################################
## User input- Intervals dialog  --  after "continue 1 " button clicked 
#######################################################################
	
input5 <- gframe("",horizontal= FALSE, container=grp_name)                                              ### Creates new frame 	
TN1 <<- testname1                                                                                       ### Saves the test name -  TN1
OutF1 <<- paste("EF_02_Output_",TN1,".csv", sep = "")								        ### Creates file name for the output file -  EF_02_Output_"TN1".csv

#######################################################################
## Questions regarding deposit
#######################################################################
          
### Creates drop down list for the deposit types -   DTy
	DTy <<- as.character(InputParTab[19,3])

### Creates text box for the tract area - TA1
	TA1 <<-  as.character(InputParTab[30,3])
	TA1 <<- as.numeric(TA1)

#######################################################################
##  General depth input
#######################################################################

## Min interval
MinTot <<- 	as.character(InputParTab[7,3])						                          ### Creates text box to enter the mininum depth level - MinTot
MinTot <<- as.numeric(MinTot )

## Number of intervals- which will determine the number of interval inputs 
NumCat <<- as.character(InputParTab[6,3])                                                               ### Creates drop down list for the number of depth intervals (max 4) - NumCat
NumCat <<- as.numeric(NumCat )	
											                                      ### Saves deposit type result - DTy
int1 <<- strtoi(NumCat )                                                                                ### Saves number of intervals - int1
NumCat <<- strtoi(NumCat)
MinTot <<- strtoi(MinTot)                                                                               ### Saves overal depth information -  MinTot, MaxTot

#######################################################################
## Depth Interval input
#######################################################################
																	  ### Creates lists of the depth interval information  
MinList <<- c()
MaxList <<- c()
PVList  <<- c()
ObjAL <<- c()

Min1 <<- 0
Max1 <<- 0
Per1 <<- 0


Min2 <<- 0
Max2 <<- 0
Per2 <<- 0

Min3 <<- 0
Max3 <<- 0
Per3 <<- 0

Min4 <<- 0
Max4 <<- 0
Per4 <<- 0

																	  ### adds intervals based on the number of intervals entered - if statements 
																	  ### below is the interval input -  min, max, and fraction of the depth intervals using text boxes


if (int1 == 1)  
	{
	ObjMin1 <<- as.character(InputParTab[7,3])
	ObjMax1 <<- as.character(InputParTab[8,3])
	ObjPer1 <<- as.character(InputParTab[9,3])
	ObjMin1 <<- as.numeric(ObjMin1)
	ObjMax1 <<- as.numeric(ObjMax1)
	ObjPer1 <<- as.numeric(ObjPer1)
	Min1 <<- ObjMin1 
	Max1 <<- ObjMax1 
	Per1 <<- ObjPer1 
	MaxLine <<- c(ObjMax1)
	MaxMax <<- max(MaxLine)
	MaxTot <<- MaxMax 
	}

if (int1 == 2) 
	{
	ObjMin1 <<- as.character(InputParTab[7,3])
	ObjMax1 <<- as.character(InputParTab[8,3])
	ObjPer1 <<- as.character(InputParTab[9,3])	
	ObjMin2 <<- as.character(InputParTab[10,3])
	ObjMax2 <<- as.character(InputParTab[11,3])
	ObjPer2 <<- as.character(InputParTab[12,3])
	ObjMin1 <<- as.numeric(ObjMin1)
	ObjMax1 <<- as.numeric(ObjMax1)
	ObjPer1 <<- as.numeric(ObjPer1)
	ObjMin2 <<- as.numeric(ObjMin2)
	ObjMax2 <<- as.numeric(ObjMax2)
	ObjPer2 <<- as.numeric(ObjPer2)

	Min1 <<- ObjMin1 
	Max1 <<- ObjMax1 
	Per1 <<- ObjPer1 
	Min2 <<- ObjMin2 
	Max2 <<- ObjMax2 
	Per2 <<- ObjPer2 

	MaxLine <<- c(ObjMax1,ObjMax2)
	MaxMax <<- max(MaxLine)
	MaxTot <<- MaxMax 
	}

if (int1 == 3) 
	{
	ObjMin1 <<- as.character(InputParTab[7,3])
	ObjMax1 <<- as.character(InputParTab[8,3])
	ObjPer1 <<- as.character(InputParTab[9,3])
	
	ObjMin2 <<- as.character(InputParTab[10,3])
	ObjMax2 <<- as.character(InputParTab[11,3])
	ObjPer2 <<- as.character(InputParTab[12,3])

	ObjMin3 <<- as.character(InputParTab[13,3])
	ObjMax3 <<- as.character(InputParTab[14,3])
	ObjPer3 <<- as.character(InputParTab[15,3])

	ObjMin1 <<- as.numeric(ObjMin1)
	ObjMax1 <<- as.numeric(ObjMax1)
	ObjPer1 <<- as.numeric(ObjPer1)

	ObjMin2 <<- as.numeric(ObjMin2)
	ObjMax2 <<- as.numeric(ObjMax2)
	ObjPer2 <<- as.numeric(ObjPer2)

	ObjMin3 <<- as.numeric(ObjMin3)
	ObjMax3 <<- as.numeric(ObjMax3)
	ObjPer3 <<- as.numeric(ObjPer3)

	Min1 <<- ObjMin1 
	Max1 <<- ObjMax1 
	Per1 <<- ObjPer1 
	Min2 <<- ObjMin2 
	Max2 <<- ObjMax2 
	Per2 <<- ObjPer2 
	Min3 <<- ObjMin3 
	Max3 <<- ObjMax3 
	Per3 <<- ObjPer3 

	MaxLine <<- c(ObjMax1,ObjMax2,ObjMax3)
	MaxMax <<- max(MaxLine)
	MaxTot <<- MaxMax 
	}

if (int1 == 4) 
	{
	ObjMin1 <<- as.character(InputParTab[7,3])
	ObjMax1 <<- as.character(InputParTab[8,3])
	ObjPer1 <<- as.character(InputParTab[9,3])
	
	ObjMin2 <<- as.character(InputParTab[10,3])
	ObjMax2 <<- as.character(InputParTab[11,3])
	ObjPer2 <<- as.character(InputParTab[12,3])

	ObjMin3 <<- as.character(InputParTab[13,3])
	ObjMax3 <<- as.character(InputParTab[14,3])
	ObjPer3 <<- as.character(InputParTab[15,3])

	ObjMin4 <<- as.character(InputParTab[16,3])
	ObjMax4 <<- as.character(InputParTab[17,3])
	ObjPer4 <<- as.character(InputParTab[18,3])

	ObjMin1 <<- as.numeric(ObjMin1)
	ObjMax1 <<- as.numeric(ObjMax1)
	ObjPer1 <<- as.numeric(ObjPer1)

	ObjMin2 <<- as.numeric(ObjMin2)
	ObjMax2 <<- as.numeric(ObjMax2)
	ObjPer2 <<- as.numeric(ObjPer2)

	ObjMin3 <<- as.numeric(ObjMin3)
	ObjMax3 <<- as.numeric(ObjMax3)
	ObjPer3 <<- as.numeric(ObjPer3)

	ObjMin4 <<- as.numeric(ObjMin4)
	ObjMax4 <<- as.numeric(ObjMax4)
	ObjPer4 <<- as.numeric(ObjPer4)

	Min1 <<- ObjMin1 
	Max1 <<- ObjMax1 
	Per1 <<- ObjPer1 
	Min2 <<- ObjMin2 
	Max2 <<- ObjMax2 
	Per2 <<- ObjPer2 
	Min3 <<- ObjMin3 
	Max3 <<- ObjMax3 
	Per3 <<- ObjPer3 
	Min4 <<- ObjMin4 
	Max4 <<- ObjMax4 
	Per4 <<- ObjPer4

	MaxLine <<- c(ObjMax1,ObjMax2,ObjMax3,ObjMax4)
	MaxMax <<- max(MaxLine)
	MaxTot <<- MaxMax 
	}

#######################################################################
## Mine Type offering based on the deposit type
#######################################################################

MillNum1 <<- 11

#######################################################################
##  Mill Type selection  
#######################################################################

## Read Through grades in input data to make list of commodity names
## variable name SimFile is the econ filter input 
## ListCNames is the name of the list of all the commodities

dat1 <- read.csv(file=SimFile, header=TRUE, sep=",")
ColNames1 <<- colnames(dat1)
listGradesI <<- grep("_pct",ColNames1 )
ListCNames<<- c()
for (xx in listGradesI)
	{
	CName <<-  sub("._pct","",ColNames1[xx])
	ListCNames<<- c(ListCNames,CName )
	}
x <<- 1

## Calculate number of commodities 
CountCN <<- length(ListCNames)

#######################################################################
## Create MRR list for all commodities (before sepearaiton
#######################################################################

FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/MillR.csv", sep="")  
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- nrow (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value

MRWMax <- MRl + 1

NewListMRR <- c()

for (nameC in ListCNames )
{
	MRw <<- 2  ## start at row 2
	MRWMax <- MRl + 1

	while (MRw < MRWMax )
	{
		
		MRn1 <<- MR[MRw,1]
		MRn <<- toString(MRn1)
		
		if (MRn == nameC)
				{
				MR234<<- as.numeric( toString(MR[MRw,MillNum1]))
				
				NewListMRR <- c(NewListMRR,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
				}

		MRw <- MRw + 1 
		
	}
}

#######################################################################
## Create commodity value list before any separation 
#######################################################################

## Commodity values
FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- ncol (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value
MRw <<- 1  ## start at row 1
MRWMax <- MRl + 1

NewListCV <- c()    ## Makes new empty cvalue list

for (nameC in ListCNames )
{
MRw <<- 1  ## start at row 1

while (MRw < MRWMax )
	{
	
	MRn1 <<- MR[1,MRw]
	MRn <<- toString(MRn1)
	
	if (MRn == nameC)
			{
			MR234<<- as.numeric( toString(MR[2,MRw]))
			
			NewListCV <- c(NewListCV ,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
			}


	MRw <- MRw + 1 
	
	}
}

MillChoice00 <<-   as.character(InputParTab[21,3])

#######################################################################
## Submit Mine and Mill Type selections   
#######################################################################

KOu1 <<- 0
KOu2 <<- 0
KCu1 <<- 0
KCu2 <<- 0
Name1 <<- "NA"
			
MillChoice1 <<- MillChoice00
MillChoice 	<<- MillChoice1

	
	if (MillChoice == "Customize Mill Options")
		{
	CF1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CustomTabPF.r", sep="")  
	source(CF1)
		}
	
#######################################################################
## Days of operation selection
#######################################################################
																	   ### creates days of operation choice (350- unrestricted, 260- restricted) - days
days <<- as.character(InputParTab[23,3])
days <<- as.numeric(days)

#######################################################################
## Sets PVD to 0 , for start
#######################################################################

PVD2 <<- 0
PVD3 <<- 0 

#######################################################################
## Environemnt choices based on mine type -  Tailings Pond, Dam and Liners
#######################################################################

EnvType<<- as.character(InputParTab[24,3])

 	if ( DTy == "Vein deposit / steep")                                                                ### mine type selection if deposit type is Vein deposit/ steep-  cut and fill, sublevel, and vertical
		{
		minetypes <<- c("Mine Method: Vertical Crater Retreat")
		}

	if ( DTy == "Flat-bedded/stratiform")                                                              ### mine type selection if deposit type is flat bedded/straitiform-  open pit and room and pillar
		{	
		minetypes <<- c("Mine Method is based on depth to the top of the deposit, if depth >= 61m: Room and Pillar, if depth < 61m: Open Pit")
		}

	if ( DTy == "Ore body massive / disseminated")                                                     ### mine type selection if deposit type is ore body massive/disseminated-  open pit and block caving
		{
		minetypes <<-c("Mine Method is based on depth to the top of the deposit, if depth >= 61m: Block Caving, if depth < 61m: Open Pit")
		}
	

#######################################################################
## Registering/ using the envrionement choices 
#######################################################################
																	    ###  creates TPD variable - 1 if yes to tailings pond or 0 if not  
LinerQ <<- as.character(InputParTab[25,3])  
TPDQ <<-  as.character(InputParTab[24,3]) 
                                                                                                        ###  creates Liner variable - 1 if yes to liner or 0 if not  
TPD <<- 1
Liner <<- 1

if (!is.na(LinerQ))
	{
	if (LinerQ  == "") 
		{
		 Liner <<- 0
		}
	}
if (is.na(LinerQ))
	{
Liner <<- 0
	}

if (!is.na(TPDQ ))
	{
	if (TPDQ == "") 
		{
		 TPD <<- 0
		}
	}
if (is.na(TPDQ ))
	{
TPD <<- 0
	}

#######################################################################
## Marshall Swift Composite CE 1989-2008 avg in 2008$
#######################################################################

MSCa <<- as.character(InputParTab[26,3]) 
MSC <<- as.numeric(MSCa)               
                                                                              ### MSC cost is set to 1.26 default 

#######################################################################
## Investment Rate of Return
#######################################################################

IRRa <<- as.character(InputParTab[27,3]) 
IRR <<- as.numeric(IRRa)                                                                                           

#######################################################################
## Cost inflation factor  - Captial cost and operating cost
#######################################################################

CCIFa <<- as.character(InputParTab[28,3]) 
CCIF <<- as.numeric(CCIFa)  

OCIFa <<- as.character(InputParTab[29,3]) 
OCIF <<- as.numeric(OCIFa)  
                                          
#######################################################################
## Creates calculation and submission dialog 
#######################################################################

dpy <<- as.double(days)                                                                     ### saves the days of operation choice -  dpy

#######################################################################
## Creates finish frames 
#######################################################################

## Creates BoxS1 frame
BoxConfirm <- gframe("Confirm Data",horizontal= FALSE, container=BoxS)
																    ### Creates BoxS1A - will include download paramters and submit
BoxS1A <- gframe("Run Steps",horizontal= FALSE, container=BoxS)

BoxS1B <- gframe("Download Stats",horizontal= FALSE, container=BoxS)

BoxS1D <- gframe("Download Plots",horizontal= FALSE, container=BoxS)                                    ### creates BoxS1D -- download plots 

BoxS1C <- gframe("Finish Process",horizontal= FALSE, container=BoxS)

CMRR1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/mrrchange.r", sep="")  

#######################################################################
## Creates finish process/ download buttons 
#######################################################################

## Step 001 Confrim and check data
ROut1 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CVMRPF.r", sep="") 
source (ROut1)
	
## Step 002 Set parameters

	date1 <<- Sys.Date()                                                                               ### calculates current date and time to add to the parameters file 
	date2 <<- format(date1,"%a %b %d %Y")
	time1 <<- Sys.time()
	time2 <<- format(time1, "%X ")
	
## Add econ file siumlation file input addres

	ECh <<- EnvType                                                                               
	LCN1 <<- length (ListCNames)
	
MCho1 <<- as.character(InputParTab[36,3]) 
MCho2 <<- as.character(InputParTab[37,3]) 
MCho3 <<- as.character(InputParTab[38,3]) 
MCho4 <<- as.character(InputParTab[39,3]) 
MCho5 <<- as.character(InputParTab[40,3]) 
MCho6 <<- as.character(InputParTab[41,3]) 

UDName1 <- as.character(InputParTab[31,3]) 

KC1 <<-  as.character(InputParTab[32,3]) 
KC2 <<-  as.character(InputParTab[33,3]) 
KO1 <<-  as.character(InputParTab[34,3]) 
KO2 <<-  as.character(InputParTab[35,3]) 

	RS1 <<- rbind (date2,time2, SimFile, WD, TN1, NumCat, Min1, Max1, Per1, Min2, Max2, Per2, Min3, Max3, Per3, Min4, Max4, Per4, DTy,minetypes, MillChoice[1],MillChoice[2], dpy, ECh[1],ECh[2], MSC, IRR, CCIF, OCIF, TA1, UDName1 ,KC1,KC2,KO1, KO2,MCho1,MCho2,MCho3,MCho4,MCho5,MCho6)
	rownames(RS1) <- c("Date", "Time", "Econ Filter File", "Working Directory", "Run Name", "Number of Depth Intervals", "Min1", "Max1", "Per1", "Min2", "Max2", "Per2", "Min3", "Max3", "Per3", "Min4", "Max4", "Per4","Deposit Type", "Mine Method","Mill Type 1 ", "Mill Type 2 ","Days of Operation", "Environment Choice 1 ","Liner?", "MSC","Investment Rate of Return", "Cap Cost Inflation Factor", "Operating Cost Inflation Factor", "Area","User Define Mill Name (if applicable)", "User Define: Mill Capital Cost Constant", "User Define: Mill Capital Cost Power log", "User Define: Mill Operating Cost Constant", "User Define: Mill Operating Cost Power log","Custom_Mill_Option1","Custom_Mill_Option2","Custom_Mill_Option3", "Custom_Mill_Option4","Custom_Mill_Option5","Custom_Mill_Option6" )
	filename <<- paste("EF_01_Parameters_",TN1,".csv", sep ="")		
	write.csv(RS1, file = filename , row.names=TRUE)
	USL <<- paste(InputFolder1,"/AuxFiles/RScripts","/uselist1.r", sep="") 
	source(USL)

	
## Step 003 Download Parameters     

dat1000 <<- read.csv(filename , header = TRUE)	
filename <- paste("EF_01_Parameters_",TN1,".csv", sep ="")	
D2 <<- as.matrix(dat1000)
D1 <<- as.matrix(FullTable)
colnames(D1) <- c("A","B")
colnames(D2) <- c("A","B")
FullTab2 <- rbind(D2,D1)
write.csv(FullTab2, file = filename , row.names=TRUE)

#filename2 <- paste("EF_01B_CommodityInfo_",TN1,".csv", sep ="")	
#write.csv(FullTable, file = filename2 , row.names=TRUE)


### Rcode file names
R0001 <<- paste(InputFolder1,"/AuxFiles/RScripts","/agg1.r", sep="")  
R0002 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CStatsR.r", sep="")  
R0003a <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1aa.r", sep="")  
R0003b <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1b.r", sep="")  
R0003c <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1c.r", sep="")  
R0003d <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1d.r", sep="")  
R0003e <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1e.r", sep="") 
R0003f <<- paste(InputFolder1,"/AuxFiles/RScripts","/DS1f.r", sep="") 
R0004 <<- paste(InputFolder1,"/AuxFiles/RScripts","/D10R.r", sep="")  
R0005 <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes2int.r", sep="")  
R0005b <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes3int.r", sep="")  
R0005c <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes4int.r", sep="")  
R0005d <<- paste(InputFolder1,"/AuxFiles/RScripts","/DepthMineTypes1int.r", sep="")  
R0006a <<- paste(InputFolder1,"/AuxFiles/RScripts","/dcat1a.r", sep="")  
R0006 <<- paste(InputFolder1,"/AuxFiles/RScripts","/dcat1.r", sep="")  
BE01 <<- paste(InputFolder1,"/AuxFiles/RScripts","/CalcBE.r", sep="")  
BE02 <<- paste(InputFolder1,"/AuxFiles/RScripts","/PlotOV103018.r", sep="")  
BE03 <<- paste(InputFolder1,"/AuxFiles/RScripts","/PlotCUEQ.r", sep="")  
Redo <<- paste(InputFolder1,"/AuxFiles/RScripts","/file2_82917.r", sep="")  



lbl_data_frame_name <- glabel("Parameters file complete",container = grp_name  )

















## Step 004 Submit 


##Reads the SimEF file
	listP <<- ""
	dat1 <<- read.csv(SimFile , header = TRUE)
	NumLines <<- nrow(dat1)
	NumCols <<- ncol(dat1)
	ColNames1 <<- colnames(dat1)
	listGrades1 <<-""

#######################################################################
## List of all Grades
#######################################################################

	listGradesI <<- grep("_pct",ColNames1 )                                                                 ### records the column names of the SimFile that reads "_pct" , grade names in a list - listGradesI
	GradeNum <<- length(listGradesI)												  ### records the number of grades in the list-  GradeNum
	ListGradeNames<<- c()                                                                                   ### creates Grade names list - ListGradeNames 
	for (xx in listGradesI)                                                                                 ### for each grade in the list, add the name to the grade name list - ListGradeNames 
		{
		ListGradeNames<<- c(ListGradeNames,ColNames1[xx])
		}
	x <<- 1

NumGrades0 <<-length(ListGradeNames)

MineNum001 <<- 1

DepthM <<- 0	
KoE <<- 0

#######################################################################
## Printing headings before analysis 
#######################################################################
	

																		   ### creating name list of contained resources for heading 
cList00 <<-c()
for( gi in ListGradeNames)
	{
	h00 <-paste("Contained_",gi,sep="")                                                                      ### creates contained resources name 
	h200 <- sub("_pct", 'Tons', h00)
	cList00 <- c(cList00 , h200)                                                                             ### creates contained resources name list-  cList00
	}

## Creating name list of recovered for heading 

rList0 <<-c()                                                                                                  ### creating name list of recovered resources for heading 
for( gir in ListGradeNames)
	{
	r <<-paste("Recovered_",gir,sep="")                                                                      ### creates recovered resources name 
	r2 <- sub("_pct", 'Tons', r)
	rList0 <<- c(rList0 , r2)                                                                                ### creates recovered resources name list-  rList0
	}


																		   ### creating names for OreV
G1 <<- 1
OVPECList2 <<- c()
for (gh in ListGradeNames)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	OVPECList2 <<- c(OVPECList2,zG)                                                                          ### create ore value per commodity list 
	G1 <<- G1 + 1
	}


if (MineNum001 == 1)
{

																		   ### creates a heading list based on the number of grades and mine types- if statements 

if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],"OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1], rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , "OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD" , "PVD_Max","NPV_Area", "BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}


if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod","Dpy","Life", "DF", "RF", "Dcat", "Depth", "DepthM", "SR", "MC", "MKc", "MKo_t","TPa","TPc", "TPDl", "TPDc", "Liner?" , "TPLc", "MlT", "MlKc", "MlKo_t", "MlC", "MKo_y", "MlKo_y", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],OVPECList2[6],"OreV_Highest", "OreV_Lowest", "OreV_Tot", "CuEQ", "SmeltC", "TotKo_y", "TotK", "TotK_t", "VP_y", "PV", "PVD","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4], ListGradeNames[5], ListGradeNames[6],  cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}
}

if (MineNum001 == 2)
{

if(NumGrades0 == 1)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1], "OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], cList00[1],  rList0[1])
	}
	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2], "OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area", "BestMMethod",ListGradeNames[1], ListGradeNames[2], cList00[1], cList00[2], rList0[1], rList0[2])
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] ,"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3],  cList00[1], cList00[2], cList00[3],  rList0[1], rList0[2], rList0[3])
	}


if(NumGrades0 == 4)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max", "NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],   cList00[1], cList00[2], cList00[3], cList00[4], rList0[1], rList0[2], rList0[3], rList0[4])
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5],  rList0[1], rList0[2], rList0[3], rList0[4], rList0[5])
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind("SimIndex", "SimDepIndex", "NumDep", "MetricTons", "ShortTons", "Mmethod1","Mmethod2","Dpy","Life", "DF","DF2", "RF","RF2",  "Dcat", "Depth", "DepthM", "SR", "MC1", "MC2", "MKc1","MKc2", "MKo_t1","MKo_t2","TPa","TPc", "TPDl", "TPDc" ,"Liner?" , "TPLc", "MlT", "MlKc1", "MlKc2", "MlKo_t1", "MlKo_t2","MlC1", "MlC2", "MKo_y1","MKo_y2", "MlKo_y1","MlKo_y2", "MSC", "CCIF" , "OCIF", OVPECList2[1],  OVPECList2[2],  OVPECList2[3] , OVPECList2[4], OVPECList2[5], OVPECList2[6],"OreV_Highest", "OreV_Lowest","OreV_Tot", "CuEQ", "SmeltC", "SmeltC2","TotKo_y1","TotKo_y2",  "TotK", "TotK2", "TotK_t1","TotK_t2", "VP_y1",  "VP_y2","PV", "PV2","PVD","PVD2","PVD_Max","NPV_Area","BestMMethod", ListGradeNames[1], ListGradeNames[2], ListGradeNames[3], ListGradeNames[4],ListGradeNames[5],ListGradeNames[6],   cList00[1], cList00[2], cList00[3], cList00[4],cList00[5], cList00[6], rList0[1], rList0[2], rList0[3], rList0[4], rList0[5], rList0[6])
	}

}

OutF1 <<- paste("EF_02_Output_",TN1,".csv", sep = "")	
write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)                                               ### creates output file for run

#######################################################################
## Reads each of the lines in the SimEF file- line by line 
#######################################################################
x <<- 0
for (xx1 in 1:NumLines )
	{
	x <<- x + 1
	NumDep <<- dat1[x,3]
	
#######################################################################
## Checks to see if the record has 0 deposits ,if so sets variables to 0 
#######################################################################
	if (NumDep == 0) 
		{
		SimIndex <<- dat1[x,2]
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- ""
		listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, NA1)
		write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)
		}

#######################################################################
## Checks to see if Num of deposits > 0
#######################################################################

	if (NumDep > 0) 
		{
		
#######################################################################
## Saves the key info from the SimEF file 
#######################################################################

		SimIndex <<- dat1[x,2]
	
		SimDepIndex  <<- dat1[x,4]
		NA1 <<- "FALSE"

#######################################################################
## If zero num deposits-  program says skip 
#######################################################################
           
	Ton <<- dat1[x,5]

#######################################################################
## Grades 
#######################################################################

	GradeNumM2 <<- GradeNum + 1
	y <<- 1
	z2 <- 6
	
	y <- 1
	for ( yi in ListGradeNames)
		{														      ### assigns the grade values to the grade names
 		assign(ListGradeNames[y], dat1[x,z2] )
		y<<- (y +1)
		z2 <<- z2+1
		}

#######################################################################
## Short Tons and Life Calculations
#######################################################################

## ShortTons
	ShortTons <<- (Ton/0.907185)

## Life 	
	Life <<- 0.2 * (ShortTons)^0.25
	##MineMethod <<- MineTypes001

#######################################################################
## Random number calc for depth
#######################################################################

## 1 Select a category using the probabiltiy
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

## 2 find random number based on the category
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

#######################################################################
#######################################################################
## if statements for each mine method 
## it will create unique results/ variables for each selected mine method  -  to asllow for comparsion at end 
## if mine method 1 == true do first set    if is.na(minemethod[1] == "FALSE")
## if mine method 2 == true, do second set  if is.na(minemethod[2] == "FALSE")
## if mine method 3 == true, do third set   if is.na(minemethod[3] == "FALSE")
#######################################################################
#######################################################################

#######################################################################
## Mine Method 1
#######################################################################

##MineMethod <<- MineTypes001
	if (DTy == "Flat-bedded/stratiform")
	{
	if (Depth > 60)
		{
		MineMethod <<- "Room-and-Pillar"
		}
	if (Depth < 61)
		{
		MineMethod <<- "Open Pit"
		}
	}

if (DTy == "Ore body massive / disseminated")
	{
	if (Depth > 60)
		{
		MineMethod <<- "Block Caving"
		}
	if (Depth < 61)
		{
		MineMethod <<- "Open Pit"
		}
	}

if (DTy == "Vein deposit / steep")
	{
	MineMethod <<- "Vertical Crater Retreat"
	}
#######################################################################
## Calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
## Calculations based on each mine method 
#######################################################################

SR <<- "NA"
                                                                                              ### if mine method 1 is open pit
if (MineMethod == "Open Pit")
{
DF <<- .05
RF <<- .90
MOTRF <<-  ((1 + DF) * RF )
DepthM <<- (0.3772 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth,  half sphere model
SR <<- ((2.225 * 4.1 * (DepthM^3 / ShortTons ) - 1))
if (dpy == 350) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/70}
if (dpy == 260) { Cm <<- (((SR + 1) * (MOTRF * ShortTons))^0.75)/52}

                                                                                             ### based on the open pit mine capacity, the operating costs changes 
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

		DepthM <<- ( 0.3772 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth, - cylinder model
		T <- (ShortTons * RF * (1+ DF))
		if (dpy == 350) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<- (((0.15 + 1) * (0.95 * ShortTons))^0.75)/52}
		KcA <<- 64800 * Cm^0.759
		KcB <<- 371 * Cm + 180 * 3 * DepthM * Cm^.404    ## UG deph captial cost
		Kc <<- KcB + KcA
		KoA <<- ((2343/Cm) + 0.44 * (3 * DepthM/Cm) + 0.00163 * 3 * DepthM)  ## UG deptrh operating costs
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
		MOCpy <<- (Cm * Ko * dpy) ## mine operating costs per year
		}

	if (MineMethod == "Room-and-Pillar") 
		{ 
		DF <<- .05
		RF <<- .85
		MOTRF <<-  ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		if (dpy == 350) { Cm <<-(((0.05 + 1) * (MOTRF * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<-(((0.05 + 1) * (MOTRF * ShortTons))^0.75)/52}
		DCalc001 <<- (0.0243 *((ShortTons)^(1/3))+(1.0936*Depth))
		if(DCalc001  < 6) { SDepth <<- 6 }
		if(DCalc001 >=6) {SDepth <<-DCalc001}
		KcA <<- 97600 * Cm^0.644   ## UG Room and Pillar capital cost
		KcB <<- 371 * Cm  + 180 * 3 * SDepth * Cm^.404    ## Underground mine depth capital cost
		Kc <<- KcB + KcA ## Room Pillar capital cost
		KoA <<- 35.5 * Cm^(-0.171)  ## RP OC ($/st)
		KoB <<- ((2343/Cm)+0.44*3*SDepth/Cm+0.00163*3*SDepth) ## UG Depth OC($/st)
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
		MOCpy <<- (Cm * Ko * dpy) 
		DepthM <<- (0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel
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
		MOCpy <<- (Cm * Ko * dpy) 
		DepthM <<- (0.48 * (ShortTons^(1/3)) + 1.0936 * Depth)   ## in yards mine depth- from excel
		}

	if (MineMethod == "Vertical Crater Retreat") 
		{ 
		DF <<- .10
		RF <<- .90
		MOTRF <<- ((1 + DF) * RF )
		T <- (ShortTons * RF * (1+ DF))
		if (dpy == 350) { Cm <<-(((0.1 + 1) * (MOTRF * ShortTons))^0.75)/70}
		if (dpy == 260) { Cm <<-(((0.1 + 1) * (MOTRF * ShortTons))^0.75)/52}

		DepthM <<- 0.6853 * ShortTons^(1/3) + 1.0936 * Depth  
		KcA <<- 45200 * Cm^0.747
		KcB <<- 371 * Cm + 180 * 3 * DepthM* Cm^.404    ## UG deph captial cost
		Kc <<- KcB + KcA
		KoB <<- 51.0 * Cm^(-0.206)
		KoA <<- ((2343/Cm) + 0.44 * 3 * DepthM/Cm + 0.00163 * 3 * DepthM)  ## UG depth operating costs
		Ko <<- KoA + KoB
		MOCpy  <<- (Cm * Ko * dpy) 
		 
		}

#######################################################################
## Records grades 
#######################################################################

GradeData <<- dat1
unn <<- 6
for (uuu in ListGradeNames) 
{
assign(uuu, GradeData[x,unn], env = .GlobalEnv)
unn <<- unn + 1
}

#######################################################################
## ValuePerEachComoodity in Ore 
#######################################################################

G1 <<- 1
OVPECList <<- c()
for (gh in ListCNames)
	{
	zG<<- paste ("OreV","_",ListGradeNames[G1],sep="")
	zG <<- sub("._pct", '', zG)
	VPEC <<- ( 0.90715 * (svalue(CVList[G1])) * svalue(MRRList [G1]) * (svalue(ListGradeNames[G1]) / 100) )
	assign(zG,VPEC, env =.GlobalEnv)
	OVPECList <<- c(OVPECList,zG)
	G1 <<- G1 + 1
	}



## Confirming save of values for print out 
if(NumGrades0 == 1)
	{
OVPEC1 <- svalue(OVPECList[1])
	}

if(NumGrades0 == 2)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
}

if(NumGrades0 == 3)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
	}

if(NumGrades0 == 4)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
	}

if(NumGrades0 == 5)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
	}

if(NumGrades0 == 6)
	{
OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
OVPEC6 <- svalue(OVPECList[6])
	}
	
#######################################################################
## Configuring a test for commodities that are not none to be added to the list
#######################################################################

RecListWONone <<-c()
CountRecWON <<- 0
for (m8 in MRRList)
{
varm8 <<- svalue(m8)
if (varm8 >= 0)
{
RecListWONone <<- c(RecListWONone ,m8)
CountRecWON <<- CountRecWON + 1
}
}

OreVListWONone <<-c()
for (ovWN in OVPECList)
{
varm8 <<- svalue(ovWN)
if (varm8 >= 0)
{
OreVListWONone <<- c(OreVListWONone ,ovWN )
}
}

### confirming save of values for print out 
if(CountRecWON == 1)
	{
OVPEC1b <- svalue(OreVListWONone[1])
	}

if(CountRecWON == 2)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])

if (OVPEC1b > OVPEC2b) 
{	
OH<<- OreVListWONone[1]
}

if (OVPEC2b > OVPEC1b) 
{	
OH<<- OreVListWONone[2]
}

if (OVPEC1b < OVPEC2b) 
{	
OL<<- OreVListWONone[1]
}

if (OVPEC2b < OVPEC1b) 
{	
OL<<- OreVListWONone[2]
}

}

if(CountRecWON == 3)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
OH<<- OreVListWONone[1]
}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
OH<<- OreVListWONone[2]
}}
if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
OH<<- OreVListWONone[3]
}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
OL<<- OreVListWONone[1]
}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
OL<<- OreVListWONone[2]
}}
if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
OL<<- OreVListWONone[3]
}}
	}

if(CountRecWON == 4)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
OH<<- OreVListWONone[1]
}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
OH<<- OreVListWONone[2]
}}}
if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
OH<<- OreVListWONone[3]
}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
OH<<- OreVListWONone[4]
}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
OL<<- OreVListWONone[1]
}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
OL<<- OreVListWONone[2]
}}}
if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
OL<<- OreVListWONone[3]
}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
OL<<- OreVListWONone[4]
}}}
	}

if(CountRecWON == 5)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])
OVPEC5b <- svalue(OreVListWONone[5])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
OH<<- OreVListWONone[1]
}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
OH<<- OreVListWONone[2]
}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
OH<<- OreVListWONone[3]
}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
OH<<- OreVListWONone[4]
}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
OH<<- OreVListWONone[5]
}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
OL<<- OreVListWONone[1]
}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
OL<<- OreVListWONone[2]
}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
OL<<- OreVListWONone[3]
}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
OL<<- OreVListWONone[4]
}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
OL<<- OreVListWONone[5]
}}}}
	}

if(CountRecWON == 6)
	{
OVPEC1b <- svalue(OreVListWONone[1])
OVPEC2b <- svalue(OreVListWONone[2])
OVPEC3b <- svalue(OreVListWONone[3])
OVPEC4b <- svalue(OreVListWONone[4])
OVPEC5b <- svalue(OreVListWONone[5])
OVPEC6b <- svalue(OreVListWONone[6])

if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
if(OVPEC1b > OVPEC6b )
{
OH<<- OreVListWONone[1]
}}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
if(OVPEC2b > OVPEC6b )
{
OH<<- OreVListWONone[2]
}}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
if(OVPEC3b > OVPEC6b )
{
OH<<- OreVListWONone[3]
}}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
if(OVPEC4b > OVPEC6b )
{
OH<<- OreVListWONone[4]
}}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
if(OVPEC5b > OVPEC6b )
{
OH<<- OreVListWONone[5]
}}}}}

if (OVPEC6b > OVPEC1b) 
{	
if(OVPEC6b > OVPEC3b )
{
if(OVPEC6b > OVPEC2b )
{
if(OVPEC6b > OVPEC1b )
{
if(OVPEC6b > OVPEC5b )
{
OH<<- OreVListWONone[6]
}}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
if(OVPEC1b < OVPEC6b )
{
OL<<- OreVListWONone[1]
}}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
if(OVPEC2b < OVPEC6b )
{
OL<<- OreVListWONone[2]
}}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
if(OVPEC3b < OVPEC6b )
{
OL<<- OreVListWONone[3]
}}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
if(OVPEC4b < OVPEC6b )
{
OL<<- OreVListWONone[4]
}}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5 < OVPEC4 )
{
if(OVPEC5b < OVPEC6b )
{
OL<<- OreVListWONone[5]
}}}}}

if (OVPEC6b < OVPEC1b) 
{	
if(OVPEC6b < OVPEC3b )
{
if(OVPEC6b < OVPEC2b )
{
if(OVPEC6b < OVPEC4b )
{
if(OVPEC6b < OVPEC5b )
{
OL<<- OreVListWONone[6]
}}}}}
	}

#######################################################################
## Value of Ore Calculation 
#######################################################################

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
a <<- MRRList [numL]
f <<- svalue(a)
b <<- CVList[numL] 
c0 <<- ListGradeNames[numL]

g <<- svalue(b)
d <<- svalue(c0)
e <<- (d /100) 
MATH1 <<-(f * g * e) 
assign(gg9, MATH1, env = .GlobalEnv)
numL <<- numL + 1
}

OreV <<- 0
OreV1  <<- 0
for (gg99 in OreGradeV) 
{
OreV1 <<- OreV1 + svalue(gg99)
}

OreV <<-  0.90715 * OreV1 
OldV <<- OreV 

if (MillChoice ==  "3-Product Flotation (Omit lowest value commodity)")
{
OreV <<- (OreV - svalue(OL))
}

if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- sub("OreV_","", OL)
}

if (MillChoice != "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- "NA"
}

#######################################################################
## Calcualtes Mill equations
#######################################################################

## Capacity mill
if (dpy == 350) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml <<- (( MOTRF  * ShortTons)^ 0.75) / 52)}

NS <<- 1

## Mill type equations 

if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
		{ 
		## equations for 3 product 
		KcM <<- 83600 * Cml^0.708
		KoM <<- 153 * Cml^(-0.344)
		}

if (MillChoice == "3 - Product Flotation") 
		{ 
		## equations for 3 product 
		KcM <<- 83600 * Cml^0.708
		KoM <<- 153 * Cml^(-0.344)
		}

if (MillChoice == "2 - Product Flotation") 
		{ 
		## equations for 2 product 
		KcM <<- 82500 * Cml^0.702
		KoM <<- 149 * Cml^(-0.356)	
		}

if (MillChoice == "1 - Product Flotation") 
		{ 
		## equations for 1 product 
		KcM <<- 92600 * Cml^0.667
		KoM <<- 121 * Cml^(-0.336)	
		}

if (MillChoice == "None") 
		{ 
		KcM <<- 0
		KoM <<- 0
		NS <<- 0
		}

if (MillChoice == "Customize Mill Options") 
	{
	## set empty cost variables - so you can sum them , and if its not being used it iwll be summing a 0 value. 
	KoM1P <<- 0
	KoM2P <<- 0
	KoM3P <<- 0
	KoM4P <<- 0 
	KcM1P <<- 0
	KcM2P <<- 0
	KcM3P <<- 0 
	KcM4P <<- 0 
	KcMUDi <<- 0
	KoMUDi <<- 0
	KcMSX  <<- 0
	KoMSX  <<- 0
	KoMCD <<- 0
	KcMCD <<- 0
	KoMCIP <<- 0
	KcMCIP <<- 0
	KoMAHL <<- 0
	KcMAHL <<- 0
	KoMAFRL <<- 0
	KcMAFRL <<- 0

	hv1 <<- as.character(InputParTab[36,3])
	hv2 <<- as.character(InputParTab[37,3])
	hv3 <<- as.character(InputParTab[38,3])
	hv4 <<- as.character(InputParTab[39,3])
	hv5 <<- as.character(InputParTab[40,3])
	hv6 <<- as.character(InputParTab[41,3])

	if ( hv1 == "3-Product" | hv2 == "3-Product" | hv3 == "3-Product"  | hv4 == "3-Product"  | hv5 == "3-Product" | hv6 == "3-Product"  )
		{
		KcM3P <<- 83600 * Cml^0.708
		KoM3P <<- 153 * Cml^(-0.344)
		}

	if ( hv1 == "2-Product" | hv2 == "2-Product" | hv3 == "2-Product"  | hv4 == "2-Product"  | hv5 == "2-Product" | hv6 == "2-Product"  )
		{
		KcM2P <<- 82500 * Cml^0.702
		KoM2P <<- 149 * Cml^(-0.356)
		}

	if ( hv1 == "1-Product" | hv2 == "1-Product" | hv3 == "1-Product"  | hv4 == "1-Product"   | hv5 == "1-Product"  | hv6 == "1-Product"  )
		{
		KcM1P <<- 92600 * Cml^0.667
		KoM1P <<- 121 * Cml^(-0.335)
		}

	if ( hv1 == "SX_EW" | hv2 == "SX_EW" | hv3 == "SX_EW"  | hv4 == "SX_EW"   | hv5 == "SX_EW"  | hv6 == "SX_EW"  )
		{
		KcMSX <<- 14600 * Cml^0.596
		KoMSX <<- 3 * Cml^(-0.145)
		}

	if ( hv1 == "CCD" | hv2 == "CCD" | hv3 == "CCD"  | hv4 == "CCD"   | hv5 == "CCD"  | hv6 == "CCD"  )
		{
		KcMCD <<- 414000 * Cml^0.584
		KoMCD <<- 128 * Cml^(-0.300)
		}

	if ( hv1 == "CIP" | hv2 == "CIP" | hv3 == "CIP"  | hv4 == "CIP"   | hv5 == "CIP"  | hv6 == "CIP"  )
		{
		KcMCIP <<- 372000 * Cml^0.540
		KoMCIP <<- 105 * Cml^(-0.303)
		}

	if ( hv1 == "Au Heap Leach" | hv2 == "Au Heap Leach" | hv3 == "Au Heap Leach"  | hv4 == "Au Heap Leach"   | hv5 == "Au Heap Leach"  | hv6 == "Au Heap Leach"  )
		{
		KcMAHL <<- 296500 * Cml^0.512
		KoMAHL <<- 31.5 * Cml^(-0.223)
		}

	if ( hv1 == "Au Float/Roast/Leach" | hv2 == "Au Float/Roast/Leach" | hv3 == "Au Float/Roast/Leach"  | hv4 == "Au Float/Roast/Leach"   | hv5 == "Au Float/Roast/Leach"  | hv6 == "Au Float/Roast/Leach"  )
		{
		KcMAFRL <<- 481000 * Cml^0.552
		KoMAFRL <<- 101 * Cml^(-0.246)
		}

	if ( (hv1 == "User Define") || (hv2 == "User Define") || (hv3 == "User Define")  || (hv4 == "User Define") || (hv5 == "User Define")|| (hv6 == "User Define")  )
		{
		KC1 <<- as.character(InputParTab[32,3])
		KC1i <<- as.numeric(KC1)
		KC2<<- as.character(InputParTab[33,3])
		KC2i <<- as.numeric(KC2)
		KO1<<- as.character(InputParTab[34,3])
		KO1i <<- as.numeric(KO1)
		KO2<<- as.character(InputParTab[35,3])
		KO2i <<- as.numeric(KO2)
		KcMUDi <<- KC1i * Cml^KC2i 
		KoMUDi <<- KO1i * Cml^(KO2i)
		}

## summing all the values 
		KoM <<- KoM1P + KoM2P + KoM3P + KoMUDi + KoMSX + KoMCD + KoMCIP + KoMAHL + KoMAFRL 
		KcM <<- KcM1P + KcM2P + KcM3P + KcMUDi + KcMSX + KcMCD + KcMCIP + KcMAHL + KcMAFRL 
	}

#######################################################################
## Calculating CuEQ%   
#######################################################################
if (!exists("CV_Cu"))
{
	FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
	MR22 <<- read.csv(FileinCV , header= FALSE) 
	countC <<- 1
	for (Z in MR22)
		{
		k <<- (MR22[1,countC])
		if(k == "Cu")
			{
			val1 <<- MR22[2,countC]
			g22 <<- (svalue(MR22[[2,1]]))
			gnew <<- as.numeric(levels(droplevels(g22)))
			c111 <<- gnew
			}
		countC <<- countC + 1
		}
}

if (exists("CV_Cu"))
{
c111 <<- svalue(CV_Cu)
}

c1010 <<- as.double(c111)

if (exists("MRR_Cu"))
{
c222 <<- svalue(MRR_Cu)
}

if (!exists("MRR_Cu"))
	{
	c222 <<- 0.91
	MRR_Cu <<- c222
	}
CuEQ <<- (100 * (1/0.90715)* OreV / ( c222 * c1010) )  

#######################################################################
## Mill operating costs per year
#######################################################################

MillOCpy <<- (Cml * KoM * dpy)

#######################################################################
## Calculation on the smelting cost 
#######################################################################

SmeltC <<- (NS *(0.26 * (2000 * ShortTons * (CuEQ/100) *  RF * MRR_Cu) / Life))

#######################################################################
## Total operating Costs Per Year
#######################################################################

TotalOCpy <<- (MSC * OCIF * (SmeltC + MOCpy + MillOCpy))

#######################################################################
## Calcualtes environment costs 
#######################################################################

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
	
#######################################################################
## Total capital costs
#######################################################################

TKC <<- (( Kc + TPD*(TpKoE + DKoE) + (Liner * LKoE) + KcM) * MSC * CCIF) ## Total capital costs 
TKCpst <<- TKC/ ShortTons                                                                                                       #### Total capital costs per short ton

#######################################################################
## Value Prod $/a
#######################################################################

VP <<- ((OreV * Cml * dpy) - TotalOCpy)

#######################################################################
## Present Value
#######################################################################

pmt <<- VP  # payments - value prod
rate <<- IRR   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate
PV <<- P02 * pmt  # total present value

#######################################################################
## Present Value Deposit
#######################################################################

PVD <<- PV - TKC 

#######################################################################
#######################################################################
### Ends method 1 calcualtion  
#######################################################################
#######################################################################

#######################################################################
## Mine Method 2 calcualtion  
#######################################################################
nonworking <<- "TRUE"
if (nonworking == "FALSE")
	{
	MineMethod2 <<- MineTypes002

#######################################################################
## Calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
## Calculations based on each mine method 
#######################################################################

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

#######################################################################
## Calcualtes Mill equations 
#######################################################################

## Capacity mill
if (dpy == 350) { (Cml2 <<- (( MOTRF2  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml2 <<- (( MOTRF2  * ShortTons)^ 0.75) / 52)}
NS <<- 1

## Mill type equations 
if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
		{ 
		KcM2 <<- 83600 * Cml2^0.708
		KoM2 <<- 153 * Cml2^(-0.344)
		}

if (MillChoice == "3 - Product Flotation") 
		{ 
## equations for 3 product 
		KcM2 <<- 83600 * Cml2^0.708
		KoM2 <<- 153 * Cml2^(-0.344)
		}


if (MillChoice == "2 - Product Flotation") 
		{ 
## equations for 2 product 
		KcM2 <<- 82500 * Cml2^0.702
		KoM2 <<- 149 * Cml2^(-0.356)	
		}

if (MillChoice == "1 - Product Flotation") 
		{ 
## equations for 1 product 
		KcM2 <<- 92600 * Cml2^0.667
		KoM2 <<- 121 * Cml2^(-0.336)	
		}

	if (MillChoice == "None") 
		{ 
		KcM2 <<- 0
		KoM2 <<- 0
		NS <<- 0
		}	

if (MillChoice == "Customize Mill Options") 
	{

## set empty cost variables - so you can sum them , and if its not being used it iwll be summing a 0 value. 
	KoM1P <<- 0
	KoM2P <<- 0
	KoM3P <<- 0
	KoM4P <<- 0 
	KcM1P <<- 0
	KcM2P <<- 0
	KcM3P <<- 0 
	KcM4P <<- 0 
	KcMUDi <<- 0
	KoMUDi <<- 0
	KcMSX  <<- 0
	KoMSX  <<- 0
	KoMCD <<- 0
	KcMCD <<- 0
	KoMCIP <<- 0
	KcMCIP <<- 0
	KoMAHL <<- 0
	KcMAHL <<- 0
	KoMAFRL <<- 0
	KcMAFRL <<- 0

	hv1 <<- as.character(InputParTab[36,3])
	hv2 <<- as.character(InputParTab[37,3])
	hv3 <<- as.character(InputParTab[38,3])
	hv4 <<- as.character(InputParTab[39,3])
	hv5 <<- as.character(InputParTab[40,3])
	hv6 <<- as.character(InputParTab[41,3])

	if ( hv1 == "3-Product" | hv2 == "3-Product" | hv3 == "3-Product"  | hv4 == "3-Product"  | hv5 == "3-Product" | hv6 == "3-Product"  )
		{
		KcM3P <<- 83600 * Cml2^0.708
		KoM3P <<- 153 * Cml2^(-0.344)
		}

	if ( hv1 == "2-Product" | hv2 == "2-Product" | hv3 == "2-Product"  | hv4 == "2-Product"  | hv5 == "2-Product" | hv6 == "2-Product"  )
		{
		KcM2P <<- 82500 * Cml2^0.702
		KoM2P <<- 149 * Cml2^(-0.356)
		}

	if ( hv1 == "1-Product" | hv2 == "1-Product" | hv3 == "1-Product"  | hv4 == "1-Product"   | hv5 == "1-Product"  | hv6 == "1-Product"  )
		{
		KcM1P <<- 92600 * Cml2^0.667
		KoM1P <<- 121 * Cml2^(-0.335)
		}

	if ( hv1 == "SX_EW" | hv2 == "SX_EW" | hv3 == "SX_EW"  | hv4 == "SX_EW"   | hv5 == "SX_EW"  | hv6 == "SX_EW"  )
		{
		KcMSX <<- 14600 * Cml2^0.596
		KoMSX <<- 3 * Cml2^(-0.145)
		}

	if ( hv1 == "CCD" | hv2 == "CCD" | hv3 == "CCD"  | hv4 == "CCD"   | hv5 == "CCD"  | hv6 == "CCD"  )
		{
		KcMCD <<- 414000 * Cml2^0.584
		KoMCD <<- 128 * Cml2^(-0.300)
		}

	if ( hv1 == "CIP" | hv2 == "CIP" | hv3 == "CIP"  | hv4 == "CIP"   | hv5 == "CIP"  | hv6 == "CIP"  )
		{
		KcMCIP <<- 372000 * Cml2^0.540
		KoMCIP <<- 105 * Cml2^(-0.303)
		}

	if ( hv1 == "Au Heap Leach" | hv2 == "Au Heap Leach" | hv3 == "Au Heap Leach"  | hv4 == "Au Heap Leach"   | hv5 == "Au Heap Leach"  | hv6 == "Au Heap Leach"  )
		{
		KcMAHL <<- 296500 * Cml2^0.512
		KoMAHL <<- 31.5 * Cml2^(-0.223)
		}

	if ( hv1 == "Au Float/Roast/Leach" | hv2 == "Au Float/Roast/Leach" | hv3 == "Au Float/Roast/Leach"  | hv4 == "Au Float/Roast/Leach"   | hv5 == "Au Float/Roast/Leach"  | hv6 == "Au Float/Roast/Leach"  )
		{
		KcMAFRL <<- 481000 * Cml2^0.552
		KoMAFRL <<- 101 * Cml2^(-0.246)
		}

	if ( (hv1 == "User Define") || (hv2 == "User Define") || (hv3 == "User Define")  || (hv4 == "User Define") || (hv5 == "User Define")|| (hv6 == "User Define")  )
		{
		KC1 <<- as.character(InputParTab[32,3])
		KC1i <<- as.numeric(KC1)
		KC2<<- as.character(InputParTab[33,3])
		KC2i <<- as.numeric(KC2)
		KO1<<- as.character(InputParTab[34,3])
		KO1i <<- as.numeric(KO1)
		KO2<<- as.character(InputParTab[35,3])
		KO2i <<- as.numeric(KO2)
		KcMUDi <<- KC1i * Cml^KC2i 
		KoMUDi <<- KO1i * Cml^(KO2i)
		}

## Summing all the values 
		KoM2 <<- KoM1P + KoM2P + KoM3P + KoMUDi + KoMSX + KoMCD + KoMCIP + KoMAHL + KoMAFRL 
		KcM2 <<- KcM1P + KcM2P + KcM3P + KcMUDi + KcMSX + KcMCD + KcMCIP + KcMAHL + KcMAFRL 
	}

#######################################################################
## mill operating costs per year
#######################################################################

MillOCpy2 <<- (Cml2 * KoM2 * dpy)

#######################################################################
## Calculation on the smelting cost 
#######################################################################

SmeltC2 <<- (NS*(0.26 * (2000 * ShortTons * (CuEQ/100) *  RF2 * MRR_Cu ) / Life))

#######################################################################
## Total operating Costs Per Year   Mine Method 2
#######################################################################

TotalOCpy2 <<- (MSC * OCIF * (SmeltC2 + MOCpy2 + MillOCpy2))

#######################################################################
## Calcualates environment costs 
#######################################################################

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

#######################################################################
## Total Capital costs   Mine Method 2
#######################################################################

TKC2 <<- (( Kc2 + TPD*(TpKoE2 + DKoE2) + (Liner * LKoE2) + KcM2) * MSC * CCIF) ## Total capital costs 
TKCpst2 <<- TKC2/ ShortTons #### Total capital costs per short ton

#######################################################################
## Value Prod $/a
#######################################################################

VP2 <<- ((OreV * Cml2 * dpy) - TotalOCpy2)

#######################################################################
## Present Value  Mine Method 2
#######################################################################

pmt <<- VP2  # payments - value prod
rate <<- IRR   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P02 <<-  P01/rate   ## P01/rate
PV2 <<- P02 * pmt  # total present value

#######################################################################
## Present Value Deposit  Mine Method 2
#######################################################################

PVD2 <<- PV2 - TKC2 
	} 

#######################################################################
#######################################################################
## Ends the Mine Method 2 calculation 
#######################################################################
#######################################################################

#######################################################################
## Mine Method 3 calcualtion  
#######################################################################
nonworking <<- "TRUE"
if (nonworking == "FALSE")
	{
	MineMethod3 <<- MineTypes001[3]

#######################################################################
## Calculate the DilutionFactors, Recovery Factor, Mine Ore Tonnage Recovery Factor, Capitol costs, and operating costs 
## Calculations based on each mine method 
#######################################################################

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

#######################################################################
## Calcualates Mill equations 
#######################################################################

## Capacity mill
if (dpy == 350) { (Cml3 <<- (( MOTRF3  * ShortTons)^ 0.75) / 70)}
if (dpy == 260) { (Cml3 <<- (( MOTRF3  * ShortTons)^ 0.75) / 52)}

## Mill type equations 
	MillNum3<<- 1   ## base number for mill number temproarily  

	if (MillChoice == "Autoclave CIL-EW") 
		{ 
		KcM3 <<- 96500 * Cml3^0.770
		KoM3 <<- 78.1  * Cml3^(-0.196)
		MillNum3 <<- 2
		}	

	if (MillChoice == "CIL-EW") 
		{ 
		KcM3 <<- 50000 * Cml3^0.745
		KoM3 <<- 84.2  * Cml3^(-0.281)
		}	

	if (MillChoice == "CIP-EW") 
		{ 
		KcM3 <<- 372000 * Cml3^0.540
		KoM3 <<- 105 * Cml3^(-0.281)
		}	

	if (MillChoice == "CCD-MC") 
		{ 
		KcM3 <<- 414000 * Cml3^0.584
		KoM3 <<- 128 * Cml3^(-0.300)
		MillNum3 <<- 2
		}	

	if (MillChoice == "Float-Roast-Leach") 
		{ 
		KcM3 <<- 481000 * Cml3^0.552
		KoM3 <<- 101 * Cml3^(-0.246)
		MillNum3 <<- 5
		}	

	if (MillChoice == "Flotation, 1 Product") 
		{ 
		KcM3 <<- 92600 * Cml3^0.667
		KoM3 <<- 121 * Cml3^(-0.336)
		MillNum3 <<- 8
		}
	
	if (MillChoice == "Flotation, 2 Product") 
		{ 
		KcM3 <<- 82500 * Cml3^0.702
		KoM3 <<- 149 * Cml3^(-0.356)
		MillNum3 <<- 9 
		}	

	if (MillChoice == "Flotation, 3 Product") 
		{ 
		KcM3 <<- 83600 * Cml3^0.708
		KoM3 <<- 153 * Cml3^(-0.344)
		MillNum3 <<- 10
		}	

	if (MillChoice == "Gravity") 
		{ 
		KcM3 <<- 135300 * Cml3^0.529
		KoM3 <<- 87.8 * Cml3^(-0.364)
		}	

	if (MillChoice == "Heap Leach") 
		{ 
		KcM3 <<- 296500 * Cml3^0.512
		KoM3 <<- 31.5 * Cml3^(-0.223)
		MillNum3 <<- 4
		}	

	if (MillChoice == "Solvent Extraction") 
		{ 
		KcM3 <<- 14600 * Cml3^0.596
		KoM3 <<- 3.0 * Cml3^(-0.145)
		}	
	if (MillChoice == "None") 
		{ 
		KcM3 <<- 0
		KoM3 <<- 0
		MillNum3 <<- 13
		}	

if (MillChoice == "User Define") 
		{ 
		KcM3 <<- as.numeric(KCu1) * Cml ^as.numeric(KCu2)
		KoM3 <<- as.numeric(KOu1) * Cml ^as.numeric(KOu2)
		MillNum3 <<- 13
		NS <<- 1
		}	

#######################################################################
## Mill operating costs per year
#######################################################################

MillOCpy3 <<- (Cml3 * KoM3 * dpy)

#######################################################################
## Calculation on the smelting cost 
#######################################################################

SmeltC3 <<- (0.26 * (2000 * ShortTons * (CuEQ/100) *  RF3 * MRR_Cu ) / Life)

#######################################################################
## Total operating Costs Per Year   Mine Method 3
#######################################################################

TotalOCpy3 <<- (MSC * OCIF * (SmeltC3 + MOCpy3 + MillOCpy3))

#######################################################################
## Calcualates environment costs 
#######################################################################

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
	
#######################################################################
## Total Capital costs   Mine Method 3
#######################################################################

TKC3 <<- (( Kc3 + TPD*(TpKoE3 + DKoE3) + (Liner * LKoE3) + KcM3) * MSC * CCIF) ## Total capital costs 
TKCpst3 <<- TKC3/ ShortTons #### Total capital costs per short ton

#######################################################################
## Value Prod $/a
#######################################################################

VP3 <<- ((OreV * Cml3 * dpy) - TotalOCpy3)

#######################################################################
## Present Value  Mine Method 3 -- Production
#######################################################################

pmt <<- VP3  # payments - value prod
rate <<- IRR   # using .15 rate 
rate1 <<- 1 + rate  # 1 + rate
nper <<- Life   # number of periods-  life 
P01 <<-  (1-(1/(rate1)^nper))  ## =(1-(1/(rate1)^nper))
P03 <<-  P01/rate   ## P01/rate
PV3 <<- P03 * pmt  # total present value

#######################################################################
## Present Value Deposit  Mine Method 3
#######################################################################

PVD3 <<- PV3 - TKC3
}  ## ends the Mine Method 3 calculation 

#######################################################################
## Contained Grade Results 
#######################################################################

CList <<- c()

for (u in ListGradeNames) 
{
u1 <- sub("_pct", 'Tons', u)
z<<- paste ("Contained_",u1,sep="")
d1 <- (Ton * (svalue(u)/100))
assign(z, d1, env = .GlobalEnv) 
CList <<- c(CList,z)
}

#######################################################################
## Find best method and record it as BestMethod -  if none- "None"
#######################################################################

#######################################################################
## IF MINE NUM=3 
#######################################################################

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

if (PVDa > PVDb)  { if (PVDa > PVDc)  {BestMMethod<<-  MineTypes001[1]}}
if (PVDb > PVDa)  { if (PVDb > PVDc) {BestMMethod<<-  MineTypes001[2]}}
if (PVDc > PVDa)  { if (PVDc > PVDb) {BestMMethod<<-  MineTypes001[3]}}
if (PVDa == 0) { if (PVDb == 0) { if (PVDc ==0) {BestMMethod<<- "None" } } }

#######################################################################
## PVD Max
#######################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes001[1])
{
PVDMax <<- PVD
}

if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes001[2])
		{
		PVDMax <<- PVD2
		}
	}

if(!is.na(BestMMethod))
	{
	 if (BestMMethod ==  MineTypes001[3]) 
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


#######################################################################
## IF MINE NUM=2 
#######################################################################

if (MineNum001 == 2)
{
if (PVD < 0 ) {PVDa <<- 0}
if (PVD2 < 0 ) {PVDb <<- 0}

if (PVD > 0)   {PVDa <<- PVD}
if (PVD2 > 0 ) {PVDb <<- PVD2}

if (PVD == 0 ) {PVDa <<- 0}
if (PVD2 == 0 ) {PVDb <<- 0}

if (PVDa > PVDb)  {BestMMethod<<-  MineTypes001}
if (PVDb > PVDa)  {BestMMethod<<-  MineTypes002}
if (PVDa == 0) { if (PVDb == 0)  {BestMMethod<<- "None" } }

#######################################################################
## PVD Max
#######################################################################

if (BestMMethod == "None")
{
PVDMax <<- 0
}

if (BestMMethod ==  MineTypes001)
{
PVDMax <<- PVD
}

if(!is.na(BestMMethod))
	{
	if (BestMMethod ==  MineTypes002)
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

#######################################################################
## IF MINE NUM=1 
#######################################################################

if (MineNum001 == 1)
	{
	if (PVD < 0 ) {PVDa <<- 0}
	if (PVD > 0)   {PVDa <<- PVD}
	if (PVD == 0 ) {PVDa <<- 0}

	BestMMethod<<-  MineMethod

	if (PVDa == 0){BestMMethod<<- "None" } 

#######################################################################
## PVD Max
#######################################################################

	if (BestMMethod == "None")
		{
		PVDMax <<- 0
		}

	if (BestMMethod ==  MineMethod)
		{
		PVDMax <<- PVD
		}
	} ## ends if mine num 1

#######################################################################
## Recovered data
#######################################################################

if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
{
YName <- sub("OreV_","", OL)
YName <- paste(YName,"._pct",sep="")
}

CN <- 1

if (BestMMethod == "Open Pit")
	{
	RList00 <<- c()
	RF <<- .90
	for (u in ListGradeNames) 
		{

		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}


		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

CN <- 1

if (BestMMethod == "Block Caving")
	{
	RList00 <<- c()
	RF <<- .95
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

CN <- 1

if (BestMMethod == "Room-and-Pillar")
	{
	RList00 <<- c()
	RF <<- .85
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}

		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

CN <- 1

if (BestMMethod == "Vertical Crater Retreat")
	{
	RList00 <<- c()
	RF <<- .90
	for (u in ListGradeNames) 
		{
		if (u == YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- 0
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}


		if (u != YName)
			{
			u1 <- sub("_pct", 'Tons', u)
			z0 <<- paste ("Recovered_",u1,sep="")
			Gradev <<- svalue(u)
			MRRa <<- MRRList [CN]  
			MRRv <<- svalue(MRRa)  ## Records MRR value for the current grade
			UUU <<- svalue(u)
			d299 <<- (RF * MRRv * UUU * (Ton/100) )
			assign(z0, d299, env = .GlobalEnv) 
			RList00 <<- c(RList00 ,z0) 
			CN =CN + 1
			}
		}  #ends if open pit recovered data
}

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
assign(z,svalue(u) , env = .GlobalEnv) 
GList <<- c(GList ,z)
}

## Confirming save of values for print out 


#######################################################################
## Configuring a test for commodities that are not none to be added to the list
#######################################################################

RecListWONone <<-c()
CountRecWON <<- 0

for (m8 in MRRList)
{
varm8 <<- svalue(m8)

if (varm8 >= 0)
{
RecListWONone <<- c(RecListWONone ,m8)
CountRecWON <<- CountRecWON + 1
}
}

OreVListWONone <<-c()

for (ovWN in OVPECList)
{
varm8 <<- svalue(ovWN)

if (varm8 >= 0)
{
OreVListWONone <<- c(OreVListWONone ,ovWN )
}
}

## Confirming save of values for print out 
if(NumGrades0 == 1)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Con0001 <- svalue(CList[1])
Rec0001 <- svalue(RList00[1])
OVPEC1 <- svalue(OVPECList[1])
	}

if(NumGrades0 == 2)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])

Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])

Rec0001 <- svalue(RList00[1])
Rec0002 <- svalue(RList00[2])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
	}

if(CountRecWON == 2)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	if (OVPEC1b > OVPEC2b) 
		{	
		OH<<- OreVListWONone[1]
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		OH<<- OreVListWONone[2]
		}

	if (OVPEC1b < OVPEC2b) 
		{	
		OL<<- OreVListWONone[1]
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		OL<<- OreVListWONone[2]
		}
		
		#1	
		if(OVPEC2b == 0)
			{
				OL<<- "NA"
			}		
		
#2	
		if(OVPEC1b == 0)
			{
				OL<<- "NA"
			}		
		
	}

if(NumGrades0 == 3)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])

Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])

Rec0001 <- svalue(RList00 [1])
Rec0002 <- svalue(RList00[2])
Rec0003 <- svalue(RList00[3])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
	}

if(CountRecWON == 3)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	
	if (OVPEC1b > OVPEC2b) 
		{	
		if(OVPEC1b > OVPEC3b )
			{
			OH<<- OreVListWONone[1]
			}
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		if(OVPEC2b > OVPEC3b )
			{
			OH<<- OreVListWONone[2]
			}
		}
	if (OVPEC3b > OVPEC1b) 
		{	
		if(OVPEC3b > OVPEC2b )
			{
			OH<<- OreVListWONone[3]
			}
		}


	if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b < OVPEC3b )
			{
			OL<<- OreVListWONone[1]
			}
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b < OVPEC3b )
			{
			OL<<- OreVListWONone[2]
			}
		}
	if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b < OVPEC2b )
			{
			OL<<- OreVListWONone[3]
			}
		}
		
		
		
			#####################################################################Start new edits

#1	
		if(OVPEC2b == 0)
			{
			if(OVPEC3b == 0 )
				{
				OL<<- "NA"
				}
			}
			
#2 			
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}

#3	
		if(OVPEC1b == 0)
			{
			if(OVPEC2b == 0 )
				{
				OL<<- "NA"
				}
			}
		
## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					OL<<- OreVListWONone[2]
				}
			}
		}

## 1 ,3 		
		if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					OL<<- OreVListWONone[3]
				}
			}
		}
		
## 2 ,1 		
		if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					OL<<- OreVListWONone[1]
				}
			}
		}
					
## 2 ,3 		
		if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					OL<<- OreVListWONone[3]
				}
			}
		}
			
## 3 ,1 		
		if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					OL<<- OreVListWONone[1]
				}
			}
		}

## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					OL<<- OreVListWONone[2]
				}
			}
		}		
	}

if(NumGrades0 == 4)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])

Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
	}
	
if(CountRecWON == 4)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	
	if (OVPEC1b > OVPEC2b) 
		{	
		if(OVPEC1b > OVPEC3b )
			{
			if(OVPEC1b > OVPEC4b )
				{
				OH<<- OreVListWONone[1]
				}
			}
		}

	if (OVPEC2b > OVPEC1b) 
		{	
		if(OVPEC2b > OVPEC3b )
			{
			if(OVPEC2b > OVPEC4b )
				{
				OH<<- OreVListWONone[2]
				}
			}
		}
	
	if (OVPEC3b > OVPEC1b) 
		{	
		if(OVPEC3b > OVPEC2b )
			{
			if(OVPEC3b > OVPEC4b )
				{
				OH<<- OreVListWONone[3]
				}
			}
		}

	if (OVPEC4b > OVPEC1b) 
		{	
		if(OVPEC4b > OVPEC3b )
			{
			if(OVPEC4b > OVPEC2b )
				{
				OH<<- OreVListWONone[4]
				}
			}
		}

	if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b < OVPEC3b )
			{
			if(OVPEC1b < OVPEC4b )
				{
				OL<<- OreVListWONone[1]
				}
			}
		}

	if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b < OVPEC3b )
			{
			if(OVPEC2b < OVPEC4b )
				{
				OL<<- OreVListWONone[2]
				}
			}
		}
	
	if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b < OVPEC2b )
			{
			if(OVPEC3b < OVPEC4b )
				{
				OL<<- OreVListWONone[3]
				}
			}
		}

	if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b < OVPEC3b )
			{
			if(OVPEC4b < OVPEC2b )
				{
				OL<<- OreVListWONone[4]
				}
			}
		}
		
		
		#####################################################################Start new edits
		if (OVPEC4b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC2b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
		
		
		if (OVPEC4b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}

		
				
		if (OVPEC4b == 0) 
		{	
		if(OVPEC2b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
		
				
		if (OVPEC2b == 0) 
		{	
		if(OVPEC3b == 0)
			{
			if(OVPEC1b == 0 )
				{
				OL<<- "NA"
				}
			}
		}
## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
		
	
	
	
##1, 3
			if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
		
##1, 4
			if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC3b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}
			
##2, 1
			if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}
			
	
##2, 3
			if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
	
##2, 4
			if (OVPEC4b < OVPEC2b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}	
		
		
		
		
##3, 1
			if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC4b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}
	
	
## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC4b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
			
	
## 3 ,4 		
		if (OVPEC4b < OVPEC3b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[4]
					}
				}
			}
		}
				
	
## 4 ,1 		
		if (OVPEC1b < OVPEC4b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC2b == 0 )
					{
					OL<<- OreVListWONone[1]
					}
				}
			}
		}

## 4 ,2 		
		if (OVPEC2b < OVPEC4b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[2]
					}
				}
			}
		}
	

## 4 ,3 		
		if (OVPEC3b < OVPEC4b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
					if(OVPEC1b == 0 )
					{
					OL<<- OreVListWONone[3]
					}
				}
			}
		}
				
				

## 1 ,2 , 3		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}
	
	
## 1 ,2 , 4		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}	
			
## 1 ,3 , 2		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			
## 1 ,3 , 4		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}

			
## 1 ,4 , 2		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			
			
## 1 ,4 , 3		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}
			
			
## 2 ,1 , 3		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 2 ,1 , 4		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		
## 2 ,3 , 1		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 2 ,3 , 4		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 2 ,4 , 1		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

			
## 2 ,4 , 3		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 3 ,1 , 2		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		

## 3 ,1 , 4		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 3 ,2 , 1		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		
			
## 3 ,2 , 4		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[4]
							}
						}
					}
				}
			}		

## 3 ,4 , 1		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 3 ,4 , 2		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		



## 4 ,1 , 2		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}		

## 4 ,1 , 3		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		

## 4 ,2 , 1		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 4 ,2 , 3		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[3]
							}
						}
					}
				}
			}		


## 4 ,3 , 1		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							OL<<- OreVListWONone[1]
							}
						}
					}
				}
			}		

## 4 ,3 , 2		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							OL<<- OreVListWONone[2]
							}
						}
					}
				}
			}
			


			
	##################################################################end new edits
	
		
	}

if(NumGrades0 == 5)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])
Grade0005 <-  svalue(ListGradeNames[5])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])
Con0005 <- svalue(CList[5])

Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])
Rec0005 <<- svalue(RList00[5])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
	}

if(CountRecWON == 5)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	OVPEC5b <- svalue(OreVListWONone[5])
	
if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
OH<<- OreVListWONone[1]
}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
OH<<- OreVListWONone[2]
}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
OH<<- OreVListWONone[3]
}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
OH<<- OreVListWONone[4]
}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC1b )
{
OH<<- OreVListWONone[5]
}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
OL<<- OreVListWONone[1]
}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
OL<<- OreVListWONone[2]
}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
OL<<- OreVListWONone[3]
}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
OL<<- OreVListWONone[4]
}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
OL<<- OreVListWONone[5]
}}}}


#####################################################################Start new edits
#1	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}
		
	
#2	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC1b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}
	
#3	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC1b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	
	
#4	
	if (OVPEC5b == 0) 
		{	
		if (OVPEC1b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	
	
#5	
	if (OVPEC1b == 0) 
		{	
		if (OVPEC4b == 0) 
			{	
			if(OVPEC3b == 0)
				{
				if(OVPEC2b == 0 )
					{
					OL<<- "NA"
					}
				}
			}
		}	
	

## 1 ,2 		
		if (OVPEC2b < OVPEC1b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
	
	
	
## 1 ,3 		
		if (OVPEC3b < OVPEC1b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
	
## 1 ,4 		
		if (OVPEC4b < OVPEC1b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC2b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
## 1 ,5 		
		if (OVPEC5b < OVPEC1b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC2b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
## 2 ,1 		
		if (OVPEC1b < OVPEC2b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
## 2 ,3 		
		if (OVPEC3b < OVPEC2b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
	
## 2 ,4 		
		if (OVPEC4b < OVPEC2b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
	
## 2 ,5 		
		if (OVPEC5b < OVPEC2b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC3b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
	
## 3 ,1 		
		if (OVPEC1b < OVPEC3b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
## 3 ,2 		
		if (OVPEC2b < OVPEC3b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
## 3 ,4 		
		if (OVPEC4b < OVPEC3b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	
	
## 3 ,5 		
		if (OVPEC5b < OVPEC3b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC4b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
				
## 4 ,1 		
		if (OVPEC1b < OVPEC4b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
				
## 4 ,2 		
		if (OVPEC2b < OVPEC4b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC3b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}	
	
		
				
## 4 ,3 		
		if (OVPEC3b < OVPEC4b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC5b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	
	
				
## 4 ,5 		
		if (OVPEC5b < OVPEC4b) 
		{	
		if(OVPEC5b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[5]
						}
					}
				}
			}
		}	
	
				
## 5 ,1 		
		if (OVPEC1b < OVPEC5b) 
		{	
		if(OVPEC1b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[1]
						}
					}
				}
			}
		}	
	
			
## 5 ,2 		
		if (OVPEC2b < OVPEC5b) 
		{	
		if(OVPEC2b > 0 )
			{
			if(OVPEC1b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[2]
						}
					}
				}
			}
		}					
				
## 5 ,3 		
		if (OVPEC3b < OVPEC5b) 
		{	
		if(OVPEC3b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC1b == 0 )
					{
					if(OVPEC4b == 0 )
						{
						OL<<- OreVListWONone[3]
						}
					}
				}
			}
		}	

## 5 ,4 		
		if (OVPEC4b < OVPEC5b) 
		{	
		if(OVPEC4b > 0 )
			{
			if(OVPEC2b == 0 )
				{
				if(OVPEC3b == 0 )
					{
					if(OVPEC1b == 0 )
						{
						OL<<- OreVListWONone[4]
						}
					}
				}
			}
		}	



## 1 ,2 , 3		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,2 , 4		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 1 ,2 , 5		
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 1 ,3 , 2		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 1 ,3 , 5		
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,4 , 5		
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 2		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 3		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 1 ,5 , 4		
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 3		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 4		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 2 ,1 , 5		
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 2 ,3 , 1		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 2 ,3 , 4		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5		
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

			
			
			
			
## 2 ,4 , 3		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5		
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4		
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 3 ,1 , 2		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 3 ,1 , 4		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 3 ,1 , 5		
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 1		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 4		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5		
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,4 , 1		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 3 ,4 , 5		
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 1		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4		
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 2		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 4 ,1 , 5		
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5		
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,3 , 2		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC5b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}



## 4 ,3 , 5		
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[5]
								}
							}
						}
					}
				}
			}


## 4 ,5 , 1		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 4 ,5 , 3		
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC5b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}


## 5 ,1 , 4		
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC1b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC2b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}


## 5 ,2 , 1		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4		
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC2b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b == 0 )
							{
							if(OVPEC4b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}


## 5 ,3 , 4		
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC3b > 0 )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[4]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC3b == 0 )
								{
								OL<<- OreVListWONone[1]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[2]
								}
							}
						}
					}
				}
			}

## 5 ,4 , 3		
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC4b > 0 )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b == 0 )
							{
							if(OVPEC1b == 0 )
								{
								OL<<- OreVListWONone[3]
								}
							}
						}
					}
				}
			}



#######################################

## 1 ,2 , 3	, 4	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 3	, 5	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 4	, 3	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,2 , 4	, 5	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 1 ,2 , 5	, 3	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,2 , 5	, 4	
		if (OVPEC1b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 2	, 4	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 2	, 5	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4	, 2	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 4	, 5	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 5	, 2	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,3 , 5	, 4	
		if (OVPEC1b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2	, 3	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 2	, 5	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3	, 2	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 3	, 5	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 5	, 2	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,4 , 5	, 3	
		if (OVPEC1b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 2	, 3	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 2	, 4	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 3	, 4	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 3	, 2	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 1 ,5 , 4	, 2	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 1 ,5 , 4	, 3	
		if (OVPEC1b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}



## 2 ,1 , 3	, 4	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 3	, 5	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 4	, 3	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 4	, 5	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 2 ,1 , 5	, 3	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,1 , 5	, 4	
		if (OVPEC2b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 2 ,3 , 1	, 4	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}



## 2 ,3 , 1	, 5	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 2 ,3 , 4	, 1	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}


## 2 ,3 , 4	, 5	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5	, 1	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,3 , 5	, 4	
		if (OVPEC2b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1	, 3	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 1	, 5	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 2 ,4 , 3	, 1	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 3	, 5	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5	, 1	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,4 , 5	, 3	
		if (OVPEC2b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1	, 3	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 1	, 4	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3	, 1	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 3	, 4	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4	, 1	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 2 ,5 , 4	, 3	
		if (OVPEC2b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 2	, 4	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,1 , 2	, 5	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 4	, 2	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 3 ,1 , 4	, 5	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 3 ,1 , 5	, 2	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,1 , 5	, 4	
		if (OVPEC3b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 1	, 4	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}


## 3 ,2 , 1	, 5	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,2 , 4	, 1	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}



## 3 ,2 , 4	, 5	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5	, 1	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,2 , 5	, 4	
		if (OVPEC3b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 2	, 5	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 3 ,4 , 5	, 1	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 5	, 2	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,4 , 1	, 2	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 3 ,4 , 1	, 5	
		if (OVPEC3b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}



## 3 ,5 , 1	, 2	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 1	, 4	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2	, 4	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 2	, 1	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4	, 1	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 3 ,5 , 4	, 2	
		if (OVPEC3b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 2	, 3	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 4 ,1 , 2	, 5	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3	, 2	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 3	, 5	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,1 , 5	, 2	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}
			
## 4 ,1 , 5	, 3	
		if (OVPEC4b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3	, 1	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 3	, 5	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5	, 1	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 5	, 3	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1	, 3	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,2 , 1	, 5	
		if (OVPEC4b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1	, 2	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 1	, 5	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}


## 4 ,3 , 2	, 1	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC5b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}


## 4 ,3 , 2	, 5	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC5b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC5b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[5]
									}
								}
							}
						}
					}
				}
			}

## 4 ,3 , 5	, 1	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}



## 4 ,3 , 5	, 2	
		if (OVPEC4b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC5b )
				{
				if(OVPEC5b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC5b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


## 4 ,5 , 1	, 2	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 1	, 3	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2	, 1	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 2	, 3	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 3	, 1	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 4 ,5 , 3	, 2	
		if (OVPEC4b > OVPEC5b) 
			{	
			if(OVPEC5b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC5b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2	, 3	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 2	, 4	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3	, 2	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 3	, 4	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 4	, 2	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,1 , 4	, 3	
		if (OVPEC5b > OVPEC1b) 
			{	
			if(OVPEC1b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC1b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 1	, 3	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 1	, 4	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3	, 1	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 3	, 4	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC4b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4	, 1	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,2 , 4	, 3	
		if (OVPEC5b > OVPEC2b) 
			{	
			if(OVPEC2b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC3b )
					{
					if(OVPEC2b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1	, 2	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 1	, 4	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2	, 1	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC4b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 2	, 4	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC4b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC4b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[4]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 4	, 1	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC1b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,3 , 4	, 2	
		if (OVPEC5b > OVPEC3b) 
			{	
			if(OVPEC3b > OVPEC4b )
				{
				if(OVPEC4b > OVPEC2b )
					{
					if(OVPEC3b > 0 )
						{
						if(OVPEC4b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1	, 2	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 1	, 3	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC1b )
				{
				if(OVPEC1b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC1b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2	, 1	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC3b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 2	, 3	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC2b )
				{
				if(OVPEC2b > OVPEC3b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC2b > 0 )
							{
							if(OVPEC3b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[3]
									}
								}
							}
						}
					}
				}
			}


## 5 ,4 , 3	, 1	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC1b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC1b > 0 )
								{
								if(OVPEC2b == 0 )
									{
									OL<<- OreVListWONone[1]
									}
								}
							}
						}
					}
				}
			}

## 5 ,4 , 3	, 2	
		if (OVPEC5b > OVPEC4b) 
			{	
			if(OVPEC4b > OVPEC3b )
				{
				if(OVPEC3b > OVPEC2b )
					{
					if(OVPEC4b > 0 )
						{
						if(OVPEC3b > 0 )
							{
							if(OVPEC2b > 0 )
								{
								if(OVPEC1b == 0 )
									{
									OL<<- OreVListWONone[2]
									}
								}
							}
						}
					}
				}
			}


	}

if(NumGrades0 == 6)
	{
Grade0001 <-  svalue(ListGradeNames[1])
Grade0002 <-  svalue(ListGradeNames[2])
Grade0003 <-  svalue(ListGradeNames[3])
Grade0004 <-  svalue(ListGradeNames[4])
Grade0005 <-  svalue(ListGradeNames[5])
Grade0006 <-  svalue(ListGradeNames[6])
	
Con0001 <- svalue(CList[1])
Con0002 <- svalue(CList[2])
Con0003 <- svalue(CList[3])
Con0004 <- svalue(CList[4])
Con0005 <- svalue(CList[5])
Con0006 <- svalue(CList[6])

Rec0001 <<- svalue(RList00[1])
Rec0002 <<- svalue(RList00[2])
Rec0003 <<- svalue(RList00[3])
Rec0004 <<- svalue(RList00[4])
Rec0005 <<- svalue(RList00[5])
Rec0006 <<- svalue(RList00[6])

OVPEC1 <- svalue(OVPECList[1])
OVPEC2 <- svalue(OVPECList[2])
OVPEC3 <- svalue(OVPECList[3])
OVPEC4 <- svalue(OVPECList[4])
OVPEC5 <- svalue(OVPECList[5])
OVPEC6 <- svalue(OVPECList[6])
	}
	
if(CountRecWON == 6)
	{
	OVPEC1b <- svalue(OreVListWONone[1])
	OVPEC2b <- svalue(OreVListWONone[2])
	OVPEC3b <- svalue(OreVListWONone[3])
	OVPEC4b <- svalue(OreVListWONone[4])
	OVPEC5b <- svalue(OreVListWONone[5])
	OVPEC6b <- svalue(OreVListWONone[6])
	
if (OVPEC1b > OVPEC2b) 
{	
if(OVPEC1b > OVPEC3b )
{
if(OVPEC1b > OVPEC4b )
{
if(OVPEC1b > OVPEC5b )
{
if(OVPEC1b > OVPEC6b )
{
OH<<- OreVListWONone[1]
}}}}}

if (OVPEC2b > OVPEC1b) 
{	
if(OVPEC2b > OVPEC3b )
{
if(OVPEC2b > OVPEC4b )
{
if(OVPEC2b > OVPEC5b )
{
if(OVPEC2b > OVPEC6b )
{
OH<<- OreVListWONone[2]
}}}}}

if (OVPEC3b > OVPEC1b) 
{	
if(OVPEC3b > OVPEC2b )
{
if(OVPEC3b > OVPEC4b )
{
if(OVPEC3b > OVPEC5b )
{
if(OVPEC3b > OVPEC6b )
{
OH<<- OreVListWONone[3]
}}}}}

if (OVPEC4b > OVPEC1b) 
{	
if(OVPEC4b > OVPEC3b )
{
if(OVPEC4b > OVPEC2b )
{
if(OVPEC4b > OVPEC5b )
{
if(OVPEC4b > OVPEC6b )
{
OH<<- OreVListWONone[4]
}}}}}

if (OVPEC5b > OVPEC1b) 
{	
if(OVPEC5b > OVPEC3b )
{
if(OVPEC5b > OVPEC2b )
{
if(OVPEC5b > OVPEC4b )
{
if(OVPEC5b > OVPEC6b )
{
OH<<- OreVListWONone[5]
}}}}}

if (OVPEC6b > OVPEC1b) 
{	
if(OVPEC6b > OVPEC3b )
{
if(OVPEC6b > OVPEC2b )
{
if(OVPEC6b > OVPEC4b )
{
if(OVPEC6b > OVPEC5b )
{
OH<<- OreVListWONone[6]
}}}}}

if (OVPEC1b < OVPEC2b) 
{	
if(OVPEC1b < OVPEC3b )
{
if(OVPEC1b < OVPEC4b )
{
if(OVPEC1b < OVPEC5b )
{
if(OVPEC1b < OVPEC6b )
{
OL<<- OreVListWONone[1]
}}}}}

if (OVPEC2b < OVPEC1b) 
{	
if(OVPEC2b < OVPEC3b )
{
if(OVPEC2b < OVPEC4b )
{
if(OVPEC2b < OVPEC5b )
{
if(OVPEC2b < OVPEC6b )
{
OL<<- OreVListWONone[2]
}}}}}

if (OVPEC3b < OVPEC1b) 
{	
if(OVPEC3b < OVPEC2b )
{
if(OVPEC3b < OVPEC4b )
{
if(OVPEC3b < OVPEC5b )
{
if(OVPEC3b < OVPEC6b )
{
OL<<- OreVListWONone[3]
}}}}}

if (OVPEC4b < OVPEC1b) 
{	
if(OVPEC4b < OVPEC3b )
{
if(OVPEC4b < OVPEC2b )
{
if(OVPEC4b < OVPEC5b )
{
if(OVPEC4b < OVPEC6b )
{
OL<<- OreVListWONone[4]
}}}}}

if (OVPEC5b < OVPEC1b) 
{	
if(OVPEC5b < OVPEC3b )
{
if(OVPEC5b < OVPEC2b )
{
if(OVPEC5b < OVPEC4b )
{
if(OVPEC5b < OVPEC6b )
{
OL<<- OreVListWONone[5]
}}}}}

if (OVPEC6b < OVPEC1b) 
{	
if(OVPEC6b < OVPEC3b )
{
if(OVPEC6b < OVPEC2b )
{
if(OVPEC6b < OVPEC4b )
{
if(OVPEC6b < OVPEC5b )
{
OL<<- OreVListWONone[5]
}}}}}



#1
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
	
#2	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC1b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
	
#3	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC1b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
#4	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC5b == 0) 
			{	
			if (OVPEC1b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
#5	
	if (OVPEC6b == 0) 
		{	
		if (OVPEC1b == 0) 
			{	
			if (OVPEC4b == 0) 
				{	
				if(OVPEC3b == 0)
					{
					if(OVPEC2b == 0 )
						{
						OL<<- "NA"
						}
					}
				}
			}
		}
	}

## Length of mine types choices

#######################################################################
## PVD_Max / Area
#######################################################################

NPV_Area <<- (PVDMax / TA1 )

#######################################################################
## ADDING FINAL RECORD
#######################################################################

	DCAT <<- SA

if (MineNum001 == 1)
	{
## Creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}
	
if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 , Con0001 ,Con0002 ,Con0003 , Rec0001 ,Rec0002 ,Rec0003)
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area, BestMMethod, Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineMethod,dpy,Life, DF, RF, DCAT, Depth, DepthM, SR, Cm, Kc, Ko,TpAtp, TpKoE, TpDl, DKoE, Liner, LKoE, MillChoice, KcM, KoM, Cml, MOCpy, MillOCpy, MSC, CCIF , OCIF,OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5,OVPEC6, OH, OL, OreV, CuEQ, SmeltC, TotalOCpy, TKC, TKCpst, VP, PV, PVD,PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Grade0005,Grade0006,Con0001 ,Con0002 ,Con0003 ,Con0004  ,Con0005 ,Con0006, Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}
	} ## End if minenum ==1 

if (MineNum001 == 2)
	{

## Creating output values tables row by row based on the number of grades
if(NumGrades0 == 1)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001, Con0001, Rec0001)
	}	

if(NumGrades0 == 2)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax, NPV_Area,BestMMethod,Grade0001 ,Grade0002, Con0001 ,Con0002, Rec0001 ,Rec0002)
	}
	
if(NumGrades0 == 3)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003, Con0001 ,Con0002 ,Con0003, Rec0001 ,Rec0002 ,Rec0003)
	}

if(NumGrades0 == 4)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004, Con0001 ,Con0002 ,Con0003 ,Con0004 , Rec0001 ,Rec0002 ,Rec0003,Rec0004)
	}

if(NumGrades0 == 5)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2, PVDMax,NPV_Area,BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005)
	}

if(NumGrades0 == 6)
	{
	listPrint <<- cbind(SimIndex, SimDepIndex, NumDep, Ton, ShortTons, MineTypes001[1], MineTypes002, dpy,Life, DF, DF2, RF, RF2, DCAT, Depth, DepthM, SR, Cm,Cm2, Kc, Kc2, Ko, Ko2, TpAtp, TpKoE, TpDl, DKoE,Liner, LKoE, MillChoice, KcM, KcM2, KoM, KoM2, Cml, Cml2, MOCpy, MOCpy2, MillOCpy, MillOCpy2, MSC, CCIF , OCIF, OVPEC1, OVPEC2 , OVPEC3 , OVPEC4 ,OVPEC5 ,OVPEC6 ,OH, OL,OreV, CuEQ, SmeltC, SmeltC2, TotalOCpy, TotalOCpy2, TKC, TKC2, TKCpst, TKCpst2, VP, VP2, PV, PV2, PVD, PVD2,PVDMax,NPV_Area, BestMMethod,Grade0001 ,Grade0002 ,Grade0003 ,Grade0004,Grade0005,Grade0006, Con0001 ,Con0002 ,Con0003 ,Con0004 ,Con0005 , Con0006 , Rec0001 ,Rec0002 ,Rec0003,Rec0004,Rec0005,Rec0006)
	}

	} ## End if minenum ==2

## Print/ save each line to the csv 
	
	write.table(listPrint, file=OutF1, sep=",", append=TRUE, col.names=FALSE)

	}  ## Ends if statement if greater than 0
#x <<- (x + 1)
#BTime <<- Sys.time()
#OutF22 <<- paste("EF_09_TotalTime_",TN1,".txt", sep = "")
#TotalTime1 <<- BTime - ATime 
#DecTime <<- "Difference in Time"
#write(DecTime , file=OutF22, append=TRUE)
#write(TotalTime1 , file=OutF22, append=TRUE)
	}  ##ends while statement for each line 

lbl_data_frame_name <- glabel("Output file complete",container = grp_name  )
## Step 005 Aggregate Deposits

	   source(R0001)
lbl_data_frame_name <- glabel("Aggregation of deposits complete",container = grp_name  )
	   
## Step 006 Contained Stats

	  source(R0002) 
	
lbl_data_frame_name <- glabel("Contained stats complete",container = grp_name  )	
## Step 007 Depth Stats

 if (GradeNum == 4)
{source(R0003a)}
 if (GradeNum == 3)
{source(R0003b)}
 if (GradeNum == 2)
{source(R0003c)}
 if (GradeNum == 1)
{source(R0003d)}
 if (GradeNum == 5)
{source(R0003e)}
 if (GradeNum == 6)
{source(R0003f)}
lbl_data_frame_name <- glabel("Depth Stats complete",container = grp_name  )

## Step 008 10 Cat - Depth Stats
source(R0004)
source(R0006a)
source(R0006)

lbl_data_frame_name <- glabel("10 Cat Depth stats complete",container = grp_name  )
## Step 009 Generate Table for Plots
source(BE01)

lbl_data_frame_name <- glabel("Generating table for plots complete",container = grp_name  )
## Step 010 Download Ore Value / Metric Tons Plot		
source(BE02)
lbl_data_frame_name <- glabel("Ore Value/Metric Tons Plot complete",container = grp_name  )
## Step 011 Download Cutoff Grade / Metric Tons Plot 	
source(BE03)
lbl_data_frame_name <- glabel("Cutoff Grade / Metric Tons plot complete",container = grp_name  )
## Step 012 Finish Process

file1a <<- paste(TN1,"_Depth10Agg5.csv",sep="")
 if (file.exists(file1a))
{
file.remove(file1a)
}

file2a <<- paste(TN1,"_DepthCat_Aggregated_Totals.csv",sep="")
 if (file.exists(file2a))
{
file.remove(file2a)
}

file3a <<- paste(TN1,"_DepthCat10_Agg_Totals8.csv",sep="")
 if (file.exists(file3a))
{
file.remove(file3a)
}

file4a <<- paste(TN1,"_Depth10Agg6.csv",sep="")	
 if (file.exists(file4a))
{
file.remove(file4a)
}	
	
file5a <<- paste(TN1,"_Depth10MMFF.csv",sep="")	
 if (file.exists(file5a))
{
file.remove(file5a)
}


file66a <<- paste(TN1,"_NewBEOut10.csv",sep="")
if (file.exists(file66a))
{
file.remove(file66a)
}


file77a <<- paste(TN1,"_NewBEOut10WO0.csv",sep="")		
file88a <<- paste("EF_07_BreakEvenTable_",TN1,".csv",sep="")	
if (file.exists(file77a))
{
file.rename(file77a,file88a)
}








lbl_data_frame_name <- glabel("RAEF Run Completed",container = grp_name  )
finishtime1 <<- Sys.time()
Finishtimeline <<- paste("The process completed at: ", finishtime1, sep="")
lbl_data_frame_name0 <- glabel(Finishtimeline,container = grp_name  )
font(lbl_data_frame_name0) <- list(weight="bold")
	



#######################################################################
## Ends the normal RAEF program
#######################################################################


	}) ## end base

#######################################################################
## Empircal model option
#######################################################################

obj <- gbutton(text   = "Run Empirical Mode", container=baseW, 
handler = function(h,...)
	{
	setwd(InputFolder1)
	EmpScript <<- paste(InputFolder1,"/AuxFiles/RScripts","/EmpScript102918.r", sep="") 
	source( EmpScript)
	})