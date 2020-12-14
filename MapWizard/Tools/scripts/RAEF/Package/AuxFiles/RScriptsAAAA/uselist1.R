UseList00 <<- c()
	
for ( b in ListCNames) 
		{
		h <<- paste("CV_",b,sep="")
		i <<- paste ("MRR_",b,sep="")
		UseList00 <<- c(UseList00,h,i)
		}

	UseList2 <<- c()
	for ( b in UseList00)
		 {
		hhh <<- svalue(b)
		UseList2 <<- c(UseList2,hhh)
		}

	FullTable<<- cbind(UseList00, UseList2)
