

nrowInput <<- nrow (InputParTab)
CVList<<- c()
MRRList<<- c()
for (rownum1 in 42:nrowInput) 
	{
	print (rownum1)
	rowvaluename <<- as.character(InputParTab[rownum1,2]) 
	print (rowvaluename)
	trueindex <<- grep("CV", rowvaluename, ignore.case = FALSE,  perl = FALSE, value = FALSE, fixed = FALSE, useBytes = FALSE)
	print (trueindex)
	trueindexMRR <<- grep("MRR", rowvaluename, ignore.case = FALSE,  perl = FALSE, value = FALSE, fixed = FALSE, useBytes = FALSE)
	
	
	if (length(trueindex) > 0)
		{
		CVList<<- c(CVList,rowvaluename)
		ValueNew <<- as.character(InputParTab[rownum1,3]) 	
		ValueNew <<- as.numeric(ValueNew)
		assign(rowvaluename, ValueNew , env = .GlobalEnv)
		}

		if (length(trueindexMRR) > 0)
		{
		MRRList<<- c(MRRList,rowvaluename)
		ValueNew <<- as.character(InputParTab[rownum1,3]) 	
		ValueNew <<- as.numeric(ValueNew)
		assign(rowvaluename, ValueNew , env = .GlobalEnv)
		}
	}

#gmessage("All data has been checked and confirmed", title="message",icon =  "info") 
