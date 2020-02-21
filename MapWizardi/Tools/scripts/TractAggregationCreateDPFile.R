# Modified Tract Aggregation R-script for MapWizard software.
# Modified by Sakari Hautala
# Original script:
	#################################################################
	##### Title:   AssessmentTractAggregationGUI (ATA GUI): A Graphical User Interface for the Tract AggEx.fn Aggregation Script 
	##### Author:  Jason Shapiro
	##### Date:    07/17/2018
	#################################################################

	#################################################################
	#############To run, click Edit, Run All in the R Console 
	#################################################################


	#################################################################
	###### Reference
	#################################################################
	#Schuenemeyer, J.H., Zientek, M.L, and Box, S.E., 2011, Aggregation of estimated numbers of undiscovered deposits�an R-script with an example from the Chu Sarysu Basin, Kazakhtan: U.S. Geological Survey Scientific Investigations Report 2010�5090�B, 13 p., accessed April 30, 2018, at http://pubs.usgs.gov/sir/2010/5090/b/ .
#####################################################################

#################################################################
##Uploads required R packages 
#################################################################
#library(MapMark4)
#install.packages('gWidgets')
library(gWidgets)
#install.packages('gWidgetstcltk')
library(gWidgetstcltk)
#install.packages("dplyr")
library(dplyr)

############################################################################
##  Reads Aggregation function r script from Schuenemeyer,Zintek, and Box
############################################################################

AggtEx.fn<-function(Exfn,UsrC,nt=2000){			#can be easily called without any buttons or modifications. Writes under RID: Run ID, setting can be rerouted from button to somewhere else
# Aggregation of user specified discrete distributions
# Exfn is user data (ID, n and Prob)
# UsrC is user specified correlation matrix
# nt is number of trials for simulation run
  
  uv<-unique(Exfn[,1])
  nau<-length(uv)
  ri<-matrix(0,nt,nau)
  squ<-matrix(0,3,10)
# generate distributions
  for (i in 1:nau){
# print(i)
  urn<-runif(nt)
  rv<-Exfn[Exfn[,1]==uv[i],]
  # cumulative distribution
  cus<-cumsum(rv[,3])
  lc<-length(cus)
    for (j in 1:nt){
     urn1<-urn[j]
     for (k in 1:lc){ 
       if(urn1 < cus[k]) {
        ri[j,i]<-rv[k,2]
        break}
    }  
   }
  }
  
# independence
    t2<-rowSums(ri[,1:nau]) 
    t1<-Sum.fn(t2)





    squ[1,]<-c(nau,"Independent",t1)
    ########################### Added ########################
squ1<-matrix(0,1,10)
squ1[1,]<-c(nau,"Independent",t1)
squ1<-as.data.frame(squ1)
names(squ1)<-c("Tracts","Assoc","P90", "P50", "P10", "P05", "P01", "Mean", "Std_Dev", "CV")
filenameA<<- paste(RID,"AggEstIndependent.csv",sep="")
  write.csv(squ1,file=filenameA,row.names=FALSE)
########################### Added ########################

    
#sort distributions 
for (i in 1:nau){
   ri[,i]<-sort(ri[,i])
  }

or<-length(UsrC[,1])
orw<-length(UsrC[1,])
if(orw>or)  UsrC<-UsrC[,2:orw]
if(or != nau){ 
   print(c("num tracts",nau," not equal order corr matrix",or))
   stop}
for (i in 1:(or-1)){
  for (j in (i+1):or) {
  UsrC[i,j]<-UsrC[j,i]
}}

# uniform numbers for correlation
   rv<-runif(nau*nt,-1,1)
   U<-matrix(rv,nt,nau)
   or<-length(UsrC[,1])
   for (i in 1:(or-1)){
    for (j in (i+1):or) {
     UsrC[i,j]<-UsrC[j,i]
   }}  

  #print(UsrC)
  t2<-as.matrix(UsrC)
  eig<-eigen(t2)
  eval<-eig$values
  #print(eval[nau])
 # is matrix a correlation matrix
  if(eval[nau] <= 0){
 # adjust matrix to be correlation
    bias<-abs(eval[nau])+0.001
    eval<-eval+bias
    evec<-eig$vectors
    t2<-evec%*%diag(eval)%*%t(evec)
    tri<-t2[1,1]
    t2<-t2/tri
     for(k in 2:nau){
       for(k1 in 1:(k-1)){
        t2[k,k1]<-t2[k1,k]
     }
     }
   #print(t2)
    write.csv(t2,file="BiasCorr.csv",row.names=FALSE)
    }

  Ch<-chol(t2)
  V<-U%*%Ch
  Ags<-0
   for (j in 1:nau){
   t3<-rank(V[,j])
   t4<-ri[,j]
   t5<-t4[t3]
   Ags<-Ags+t5
   }
  t1<-Sum.fn(Ags)


  squ[2,]<-c(nau,"Correlation",t1)
###################################################
squ2<-matrix(0,1,10)
squ2[1,]<-c(nau,"Correlation",t1)
squ2<-as.data.frame(squ2)
names(squ2)<-c("Tracts","Assoc","P90", "P50", "P10", "P05", "P01", "Mean", "Std_Dev", "CV")
filenameA<<- paste(RID,"AggEstCorrelation.csv",sep="")
  write.csv(squ2,file=filenameA,row.names=FALSE)
###################################################


#totally dependent
  Ags<-rowSums(ri[,1:nau])
   t1<-Sum.fn(Ags)

   squ[3,]<-c(nau,"Dependent",t1)
#output
  squ<-as.data.frame(squ)
  names(squ)<-c("Tracts","Assoc","P90", "P50", "P10", "P05", "P01", "Mean", "Std_Dev", "CV")
 
##################################################
squ3<-matrix(0,1,10)
squ3[1,]<-c(nau,"Dependent",t1)
squ3<-as.data.frame(squ3)
names(squ3)<-c("Tracts","Assoc","P90", "P50", "P10", "P05", "P01", "Mean", "Std_Dev", "CV")
filenameA<<- paste(RID,"AggEstDependent.csv",sep="")
  write.csv(squ3,file=filenameA,row.names=FALSE)
###################################################

	filenameA<<- paste(RID,"AggEstSummary.csv",sep="")
  write.csv(squ,file=filenameA,row.names=FALSE)
	Out1 <<- paste("Output is in",filenameA)
  print(Out1 )
  }























############################################################################
##  Reads sum function r script from Schuenemeyer,Zintek, and Box:
############################################################################
Sum.fn<-function(da){
 mri<-mean(da)
 sdri<-sd(da)
 cvri<-sdri/mri
 va<-c(as.integer(quantile(da,c(0.10,0.50,0.90,0.95,0.99))),mri,sdri,cvri)

 return(va)
}




		
        createCorrFile<-function(dirCp){            
            setwd(dirCp) #user specified directory containing input files.: comes from function params Must contain ListFiles.csv -file to be proper.
            WD <<- getwd()
            cat (WD)
            wdir1<-dirCp
            RID<-""
            ProbFileList <- read.csv(file="ListFiles.csv", header=FALSE, sep=",")
            TID <<- ProbFileList [1]
            nfiles <- nrow(ProbFileList)

			filename <<- ProbFileList[1,2]
			filename <<- as.character(filename)
			print (filename)	
			fileN0 <- read.csv(file= filename , header=TRUE, sep=",")
			nrowsfile1 <<- nrow(fileN0)
			TractID0 <<- TID[1,1]
			TractID1 <<- data.frame(matrix(TractID0 , nrow = nrowsfile1, ncol = 1))
			fileN0[1] <- TractID1 
			colnames(fileN0)<- c("TractID","NDeposits","RelProbs")
			fileadd <<- paste(wdir1,"/",RID,"NewAggCProbsFile.csv",sep="")
			write.csv(fileN0, file = fileadd, row.names=FALSE)
			g <- 2
			while (g <= nfiles)
				{
				print (g)
				filename <<- ProbFileList[g,2]
				filename <<- as.character(filename)
				print (filename)	
				fileN <- read.csv(file= filename , header=TRUE, sep=",")
				nrowsfile1 <<- nrow(fileN)
				TractID0 <<- TID[g,1]
				TractID1 <<- data.frame(matrix(TractID0 , nrow = nrowsfile1, ncol = 1))
				fileN[1] <- TractID1 
				
				
				write.table(fileN, file = fileadd, sep=",", col.names=FALSE,  row.names=FALSE, append=TRUE)
				#fileN0 <<- rbind(fileN0,fileN)
				g <- g + 1
				}
			CP1file <<-  fileadd 
			newCS2 <<- read.csv(CP1file)
			CPFile00 <<- CP1file 
			}

	





args = commandArgs(trailingOnly = TRUE)



createCorrFile(args[1]) 