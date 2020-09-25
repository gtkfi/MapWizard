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

CountCVS <- 1
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
			CV234<<- as.numeric( toString(CVS[2,CountCVS]))
			assign(CVList[cg],CV234)
			}
		cg <<- cg + 1
		}	
	CVw <<-( CVw +1 )
	CountCVS <- CountCVS + 1
}


##########################################################
### Flag missing CV Values                      ##########
##########################################################
for (CVObj in CVList)
{
	print (CVObj)
	print (get(CVObj))
	sw <<- 1
	if (get(CVObj) == -999)

		{
		#gmessage("There are missing commodity values, please correct them before continuing, by filling out the next dialogs", title="message",icon =  "error") 
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
			assign(CVObj, as.double(get(CVe)), env = .GlobalEnv)
			sw <<- 1
			dispose(CVinput)
			})
		
		obj <- gbutton(text   = "Ignore missing value",container= CVinput ,handler = function(h,...)
			{	
			assign(CVObj,0, env = .GlobalEnv)
			sw <<- 1
			dispose(CVinput)
			})
while (sw ==2){ print ("waiting for user input")}


		}	
}


for (CVObj in CVList)
{
	print (CVObj)
	print (get(CVObj))
}


	




############################################################################################################################editted 1/17/18  to add if statements about mill custom or regualrt,  if mill cvustom - try to set specific mrr commidity values 


if (MillChoice != "Customize Mill Options")
{



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

	if (MillChoice == "3-Product Flotation (Omit lowest value commodity)") 
		{ 
		MillNum <<- 11
		}	

	if (MillChoice == "3 - Product Flotation") 
		{ 
		MillNum <<- 11
		}	

	if (MillChoice == "2 - Product Flotation") 
		{ 
		MillNum <<- 9
		}	
	if (MillChoice == "1 - Product Flotation") 
		{ 
		MillNum <<- 8
		}	

	if (MillChoice == "None") 
		{ 
		MillNum <<- 13
		}	


	if (MillChoice == "User Define") 
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
	}  ##Ends if mil choice is not custom 



################################################################start if mill choice is custom

if (MillChoice == "Customize Mill Options")
	{



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
### Set Mill MRR                                ##########
##########################################################
	MillNum<<- 13   ## base number for mill number temproarily 
	for (hh in MillCList)
		{
		zz <<- get(hh)
		print (zz)
		cn0 <<- sub("Mill", '', hh)
		print (cn0)
		print (hh)
	
		FileinCV <<- paste(InputFolder1,"/AuxFiles/ValueTabs","/MillR.csv", sep="")  
		MR <<- read.csv(FileinCV , header= FALSE)   ## input table with commodity values
		MRl <<- nrow (MR )  ## number of rows in table
		MRl <<- as.numeric(MRl ) ## convert the number to a numeric value
		MRw <<- 2  ## start at row 2


		if (zz == "3-Product")
			{
			print ("3 product true")
			MillNum <<- 11
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))   ###  loop each row starting at 2
				{
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if (MRn == cn0)
					{
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print ("3 product MRR set")
					}
				MRw <<-( MRw +1 )
				cg <<- cg + 1
				}

			}

		
	

		
		if (zz == "2-Product")
			{
			print ("2 product true")
			MillNum <<- 9
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 9
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print ("2 product MRR set")
					}	
				MRw <<-( MRw +1 )
				cg <<- cg + 1
				}
			


			}



		if (zz == "1-Product")
			{
			print ("1 product true")
			MillNum <<- 8
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 8
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 8
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("1 product MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}

			}



		if (zz == "SX_EW")
			{
			print ("SX_EW true")
			MillNum <<- 7
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 7
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 7
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("SX_EW MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}


			}

		if (zz == "CCD")
			{
			print ("CCD true")
			MillNum <<- 2
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 2
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 2
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("CCD MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}


			}

		if (zz == "CIP")
			{
			print ("CIP true")
			MillNum <<- 3
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 3
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 3
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("CIP MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}

			}

	
		if (zz == "Au Heap Leach")
			{
			print ("Au Heap Leach true")
			MillNum <<- 4
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 4
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 4
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("Au Heap Leach MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}


			}


	
		if (zz == "Au Float/Roast/Leach")
			{
			print ("Au Float/Roast/Leach true")
			MillNum <<- 5
			print (MillNum)
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MillNum <<- 5
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					MillNum <<- 5
					MR234<<- as.numeric( toString(MR[MRw,MillNum]))
					assign(MRRList[cg],MR234)
					print (MRRList[cg])
					print (MR234) 
					print ("Au Float/Roast/Leach MRR set")
					}
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}


			}




		if (zz == "None")
			{
			print ("None is True")
			dp11 <<- sub("Mill", "", hh)
			YName <<- dp11 
			cg <<- 1
			while (MRw < (MRl + 1))
				{
				MRn1 <<- MR[MRw,1]
				MRn <<- toString(MRn1)
				if  (MRn == cn0)
					{
					assign(MRRList[cg],0)
					}
					
				MRw <<-( MRw +1 )	
				cg <<- cg + 1		
				}


			}






		if (zz == "User Define") 
			{ 
			print ("User Define TRUE")
			sw <<- 2
			MRinput <- gwindow("",horizontal= FALSE)
			MRLabel0 <<- paste("Enter user define mill parameters for: ", cn0 ,sep=" ") 
			MRLabel1 <<- paste("Enter metallurgical recovery rate (decimal fraction)", sep=" ") 
			MRlabel <<-  glabel(MRLabel0 , container = MRinput )
			MRlabel <<-  glabel(MRLabel1 , container = MRinput )
			MRe <<- gedit("",width = 30,container = MRinput )
			UDLabel1 <<-  glabel("Enter the capital cost equation parameters:  Constant and the Power log.  Example Flotation 3 equation is: 83600 * Cml^0.708 ", container = MRinput )
			UDName1 <<- gedit("Name of user defined mill? ",width = 30,container = MRinput )
			KC1 <<- gedit("$ constant for capital Cost",width = 30,container = MRinput )
			KC2 <<- gedit("Power log for capital cost",width = 30,container = MRinput )
			UDLabel1 <<-  glabel("Enter the operating cost equation parameters:  Constant and the Power log.  Example Flotation 3 equation is: 153 * Cml^(-0.344)", container = MRinput )
			KO1 <<- gedit("$ constant for operating Cost",width = 30,container = MRinput )
			KO2 <<- gedit("Power log for operating cost",width = 30,container = MRinput )
			obj <- gbutton(text   = "Submit User Define Mill",container= MRinput ,handler = function(h,...)
					{
					#assign(MRObj, as.double(get(MRe)), env = .GlobalEnv)
					sw <<- 1
					UDName1 <<- get(UDName1)	
					MRe <<- get (MRe)
					MRei <<- as.numeric(MRe)
				
					numset <- 1
					for (ml99 in MRRList)
						{
						name112 <<- sub("MRR_", "", ml99)
						print (name112)
						if (name112 == cn0) 
							{
							assign(MRRList[numset],MRei, env = .GlobalEnv)
							}
						numset <- (numset + 1)
						}	
					KC1 <<- get(KC1)
					KC2 <<- get(KC2)
					KO1 <<- get(KO1)
					KO2 <<- get(KO2)
					dispose(MRinput)
					})
			while (sw ==2)
				{
				print ("waiting for user input")
				}
			} ## for is user define 

		}## ends each hh in millclist 
	} ## ends if customize mill option


################################ Code to test if missing MRR - have user enter an MRR.  
for (MRObj in MRRList)
	{
	name112 <<- sub("MRR_", "", MRObj)
	print (name112)
	sw <<- 1
	svMR <<- get(MRObj)
	if (svMR  == -999)
		{
		sw <<- 2
		print ( "TRUE")
		MRinput <- gwindow("",horizontal= FALSE)
		MRobj00  <<-  sub("MRR_","",MRObj )
		MRLabel0 <<- paste("The commodity", MRobj00  ,"is missing a Metallurgical Recovery Rate", sep=" ") 
		MRLabel1 <<- paste("Please input an updated value", sep=" ") 
		MRLabel2 <<- paste("or click ignore the commodity", sep=" ") 
		MRlabel <<-  glabel(MRLabel0 , container = MRinput )
		MRlabel <<-  glabel(MRLabel1 , container = MRinput )
		MRlabel <<-  glabel(MRLabel2 , container = MRinput )
		MRe0 <<- gedit("Enter missing value (decimal fraction)",width = 30,container = MRinput )
		obj <- gbutton(
		text   = "Update value",
		container= MRinput ,
		handler = function(h,...)
			{
			assign(MRObj, as.double(get(MRe0)), env = .GlobalEnv)
			sw <<- 1
			dispose(MRinput)
			})
		
		obj <- gbutton(text   = "Ignore missing value",container= MRinput ,handler = function(h,...)
			{	
			assign(MRObj,0, env = .GlobalEnv)
			sw <<- 1
			dispose(MRinput)
			})
		

		while (sw ==2){ print ("waiting for user input")}

		}
	}


# gmessage("All data has been checked and confirmed", title="message",icon =  "info") 





