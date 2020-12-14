

################################
##uploads required R packages 
################################

library(gWidgets)
library(gWidgetstcltk)
library(dplyr)
library(reshape)
library(evaluate)


baseW0 <- gwindow("")  

lbl <- glabel("Select a commodity to change it's MRR.", container = baseW0)
lbl <- glabel("MRR is Metallurgical recovery rate", container = baseW0)

MRRSelect <- gdroplist((MRRList), container = baseW0 )
obj <- gbutton(text = "Continue", container=baseW0,
	handler = function(h,...)
	{
	MRRSelect <<- svalue(MRRSelect)
	MRRSValue <<- svalue(MRRSelect)
	label1 <<- paste ("Current value for ", MRRSelect, " is ", MRRSValue, sep="")
	lbl <- glabel(label1, container = baseW0)
	lbl <- glabel("", container = baseW0)
	lbl <- glabel("Enter a MRR number below [fraction]", container = baseW0)
	MRREnter1 <<- gedit(container = baseW0)
	
	obj <- gbutton(text = "Submit", container=baseW0,
	handler = function(h,...)
		{
		MRREnter1 <<- svalue(MRREnter1)
		MRREnter1 <<-as.double(MRREnter1)
		mrrcount <<- 1
		for (cc in MRRList)
			{
			print (MRRList)
			print (cc)
			print (mrrcount)
			print (MRRList[mrrcount])
			if (cc == MRRSelect)
				{
				print ("CC is true")
				print (MRRSelect)
				print (mrrcount)
				assign (MRRList[mrrcount], MRREnter1, env = .GlobalEnv)
				}
			mrrcount <<- mrrcount + 1
			}


		obj <- gbutton(text = "Exit", container=baseW0,
		handler = function(h,...)
			{
			 dispose( baseW0)
			})
		})
	})
