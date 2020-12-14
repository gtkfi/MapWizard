
args = commandArgs(trailingOnly = TRUE)

inputFile=args[1]
CVpath=args[2]
MRRpath=args[3]
# Mitä pitää luoda: 
#       ListCNames (inputFIlestä)
dat1 <- read.csv(file=inputFile, header=TRUE, sep=",")
ColNames1 <<- colnames(dat1)
listGradesI <<- grep("_pct",ColNames1 )
ListCNames<<- c()
for (xx in listGradesI)
	{
	CName <<-  sub("._pct","",ColNames1[xx])
	ListCNames<<- c(ListCNames,CName )
	}
CountCN <<- length(ListCNames)    
MillNum1=11		#Should this be dynamic?
#######################################################################
## Create MRR list for all commodities (before sepearaiton
#######################################################################

FileinCV <<- MRRpath 
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- nrow (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value

MRWMax <- MRl + 1


NewListMRR <- c()
MRRnames<-c()
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
				MRRnames<-append(MRRnames,paste("MRR_",nameC),after=length(MRRnames))
				NewListMRR <- c(NewListMRR,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
				}

		MRw <- MRw + 1 
		
	}
}

#######################################################################
## Create commodity value list before any separation 
## Commodity values
#######################################################################

FileinCV <<- CVpath
MR <<- read.csv(FileinCV , header= FALSE)   ## input table with MRR values
MRl <<- ncol (MR )  ## number of rows in table
MRl <<- as.numeric(MRl ) ## convert the number to a numeric value
MRw <<- 1  ## start at row 1
MRWMax <- MRl + 1

NewListCV <- c()    ## Makes new empty cvalue list
CVnames<-c()
for (nameC in ListCNames )
{
MRw <<- 1  ## start at row 1

while (MRw < MRWMax )
	{
	
	MRn1 <<- MR[1,MRw]
	MRn <<- toString(MRn1)
	
	if (MRn == nameC)
			{
				CVnames<-append(CVnames,paste("CV_",nameC),after=length(CVnames))
			MR234<<- as.numeric( toString(MR[2,MRw]))
			
			NewListCV <- c(NewListCV ,MR234)  ## creates new table of MRR Values (using the mine method 1 set)
			}


	MRw <- MRw + 1 
	
	}
}

#NewListCV
#NewListCV
#^sit näistä ylläolevista 1 listahässäkkä, ja returnaa/printtaa se, ja voila.
#listat staggeroituna yhteen.
CombinedList<<- c()
CombinedString<<-""
for(i in 1:CountCN){
#CombinedList<-append(CombinedList,NewListCV[i],after=length(CombinedList))
#CombinedList<-append(CombinedList,NewListMRR[i],after =length(CombinedList))
#paste(..., sep = " ", collapse = NULL)
CombinedList<-append(CombinedList,CVnames[i],after=length(CombinedList))
CombinedList<-append(CombinedList,MRRnames[i],after =length(CombinedList))
CombinedList<-append(CombinedList,NewListCV[i],after=length(CombinedList))
CombinedList<-append(CombinedList,NewListMRR[i],after =length(CombinedList))
}

print(cat(paste(shQuote(CombinedList, type="cmd"), collapse=", ")))
