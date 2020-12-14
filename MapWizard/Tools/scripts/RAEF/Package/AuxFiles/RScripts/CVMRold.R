##########################################################
### Create commodity use list                   ##########
##########################################################

dat1 <<- read.csv(SimFile , header = TRUE)	
ColNames1 <<- colnames(dat1)
listGradesI <<- grep("_pct",ColNames1 )
ListCNames<<- c()
for (xx in listGradesI)
	{
	CName <<-  sub("._pct","",ColNames1[xx])
	ListCNames<<- c(ListCNames,CName )
	}
x <<- 1


##########################################################
### Create CV variables /list                   ##########
##########################################################

CVList <<- c()
for (cc in ListCNames)
{
CVa <<- paste("CV_",cc,sep="")
assign(CVa , -999, env = .GlobalEnv)  
CVList <<- c(CVList, CVa)
}
CVListNum <<- length (CVList)

##########################################################
### Read CV Values                              ##########
##########################################################

FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/CValues.csv", sep="")  
CVS <<- read.csv(FileinCV , header= FALSE)   ## input table with commodity values
CVl <<- length (CVS)
CVl <<- as.numeric(CVl)
CVw <<- 1
while (CVw < (CVl + 1))
{
	print (CVw)
	CVn1 <<- CVS[1,CVw]
	CVn <<- toString(CVn1)
	print (CVn)
	cg <<- 1
	while ( cg < (CVListNum + 1))
		{
		if (CVn == ListCNames[cg])
			{
			CV234<<- as.numeric( toString(CVS[2,cg]))
			assign(CVList[cg],CV234)
			}
		cg <<- cg + 1
		}	
	CVw <<-( CVw +1 )
}


##########################################################
### Flag missing CV Values                      ##########
##########################################################
for (CVObj in CVList)
{
	print (CVObj)
	print (svalue(CVObj))
	sw <<- 1
	if (svalue(CVObj) == -999)

		{
		# gmessage("There are missing commodity values, please correct them before continuing, by filling out the next dialogs", title="message",icon =  "error") 
		sw <<- 2
		print ( "TRUE")
		CVinput <- gwindow("",horizontal= FALSE)
		CVobj00  <<-  sub("CV_","",CVObj )
		CVLabel0 <<- paste("The commodity", CVobj00  ,"is missing a value", sep=" ") 
		CVLabel1 <<- paste("please input an updated value", sep=" ") 
		CVLabel2 <<- paste("or click ignore the commodity", sep=" ") 
		CVlabel <<-  glabel(CVLabel0 , container = CVinput )
		CVlabel <<-  glabel(CVLabel1 , container = CVinput )
		CVlabel <<-  glabel(CVLabel2 , container = CVinput )
		CVe <<- gedit("Enter missing value ($/metric ton)",width = 30,container = CVinput )
		obj <- gbutton(
		text   = "Update value",
		container= CVinput ,
		handler = function(h,...)
			{
			assign(CVObj, as.double(svalue(CVe)), env = .GlobalEnv)
			sw <<- 1
			dispose(CVinput)
			}
		)
		
		obj <- gbutton(text   = "Ignore missing value",container= CVinput ,handler = function(h,...)
			{	
			assign(CVObj,0, env = .GlobalEnv)
			sw <<- 1
			dispose(CVinput)
			}
		)
		

while (sw ==2){ print ("waiting for user input")}


		}	
}


for (CVObj in CVList)
{
	print (CVObj)
	print (svalue(CVObj))
}


	
##########################################################
### Create MRR variables /list                  ##########
##########################################################

MRRList <<- c()
for (cc in ListCNames)
{
MRRa <<- paste("MRR_",cc,sep="")
assign(MRRa , -999, env = .GlobalEnv)  
MRRList <<- c(MRRList, MRRa )
}



##########################################################
### Set Mill numbers                             ##########
##########################################################
	MillNum<<- 13   ## base number for mill number temproarily 

	if (MillT == "Autoclave CIL-EW") 
		{ 
		MillNum <<- 2
		}	

	if (MillT == "CCD-MC") 
		{ 
		MillNum <<- 2
		}	

	if (MillT == "Float-Roast-Leach") 
		{ 
		MillNum <<- 5
		}	

	if (MillT == "Flotation, 1 Product") 
		{ 
		MillNum <<- 8
		} 
	
	if (MillT == "Flotation, 2 Product") 
		{ 
		MillNum <<- 9 
		}	

	if (MillT == "Flotation, 3 Product") 
		{ 

		MillNum <<- 11
		}	

	if (MillT == "Heap Leach") 
		{ 
		MillNum <<- 4
		}	


	if (MillT == "None") 
		{ 
		MillNum <<- 13
		}	


if (MillT == "User Define") 
		{ 
		MillNum3 <<- 13
		}	

##########################################################
### Read MRR Values                             ##########
##########################################################

FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/MillR.csv", sep="")  
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with commodity values
MRl <<- nrow (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value
MRw <<- 2  ## start at row 2
while (MRw < (MRl + 1))
{
	print (MRw)
	MRn1 <<- MR[MRw,1]
	MRn <<- toString(MRn1)
	print (MRn)
	cg <<- 1
	while ( cg < (CVListNum + 1))
		{
		if (MRn == ListCNames[cg])
			{
			MR234<<- as.numeric( toString(MR[MRw,MillNum]))
			assign(MRRList[cg],MR234)
			}
		cg <<- cg + 1
		}	
	MRw <<-( MRw +1 )
}


##########################################################
### Flag missing MRR Values                      ##########
##########################################################
for (MRObj in MRRList)
{
	print (MRObj)
	print (svalue(MRObj))
	sw <<- 1
	if (svalue(MRObj) == -999)
		{
		sw <<- 2
		print ( "TRUE")
		MRinput <- gwindow("",horizontal= FALSE)
		MRobj00  <<-  sub("MRR_","",MRObj )
		MRLabel0 <<- paste("The commodity", MRobj00  ,"is missing a Metalogical Recovery Rate", sep=" ") 
		MRLabel1 <<- paste("please input an updated value", sep=" ") 
		MRLabel2 <<- paste("or click ignore the commodity", sep=" ") 
		MRlabel <<-  glabel(MRLabel0 , container = MRinput )
		MRlabel <<-  glabel(MRLabel1 , container = MRinput )
		MRlabel <<-  glabel(MRLabel2 , container = MRinput )
		MRe <<- gedit("Enter missing value (decimal fraction)",width = 30,container = MRinput )
		obj <- gbutton(
		text   = "Update value",
		container= MRinput ,
		handler = function(h,...)
			{
			assign(MRObj, as.double(svalue(MRe)), env = .GlobalEnv)
			sw <<- 1
			dispose(MRinput)
			}
		)
		
		obj <- gbutton(text   = "Ignore missing value",container= MRinput ,handler = function(h,...)
			{	
			assign(MRObj,0, env = .GlobalEnv)
			sw <<- 1
			dispose(MRinput)
			}
		)
		

while (sw ==2){ print ("waiting for user input")}


		}	
}

for (MRObj in MRRList)
{
	print (MRObj)
	print (svalue(MRObj))
}

# gmessage("All data has been checked and confirmed", title="message",icon =  "info") 
