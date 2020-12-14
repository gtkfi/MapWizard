filename <<- paste(TN1,"_Depth10MMFF.csv",sep="")
readfile <<- read.csv(filename)
Data0 <<- cbind(Out1[3], Out1[4]) 