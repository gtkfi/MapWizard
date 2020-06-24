### R code from vignette source 'restrictedpartitionsgeneratingfunction.Rnw'

###################################################
### code chunk number 1: userestrictedpartsfunction
###################################################
library("partitions")


###################################################
### code chunk number 2: restrictedpartitionsgeneratingfunction.Rnw:78-80
###################################################
jj <- restrictedparts(7,3)
ncol(jj)


###################################################
### code chunk number 3: useRopenclose
###################################################
R(3,7,include.zero=TRUE)


###################################################
### code chunk number 4: define_Rgf_version1
###################################################
library("spray")
R_gf <- function(k,n){   # version 1
   x <- spray(cbind(1,0))
   y <- spray(cbind(0,1))
   P <- ooom(y,k)  # term x^0; number of zeros chosen
   for(i in seq_len(k)){  # starts at 1
     P <- P*ooom(x^i*y,n)
   }
   return(value(P[k,n]))
}


###################################################
### code chunk number 5: restrictedpartitionsgeneratingfunction.Rnw:169-170
###################################################
R_gf(7,3)


###################################################
### code chunk number 6: define_strip
###################################################
strip <- function(P,k,n){  # strips out powers higher than needed
  ind <- index(P)
  val <- value(P)
  wanted <- (ind[,1] <= k) & (ind[,2] <= n)
  spray(ind[wanted,],val[wanted])
}


###################################################
### code chunk number 7: define_Rgf_version2
###################################################
R_gf2 <- function(k,n,give_poly=FALSE){
   x <- spray(cbind(x=1,y=0))
   y <- spray(cbind(x=0,y=1))
   P <- ooom(y,k)  # term x^0
   for(i in seq_len(k)){  # starts at 1
     P <- strip(P*ooom(spray(cbind(i,0))*y, min(n,ceiling(k/i))),k,n)
   }
   if(give_poly){
     return(P)
   } else {
     return(value(P[k,n]))
   }
}


###################################################
### code chunk number 8: rgf2_use
###################################################
R_gf2(7,3)


###################################################
### code chunk number 9: test
###################################################
k <- 140
n <- 4


###################################################
### code chunk number 10: restrictedpartitionsgeneratingfunction.Rnw:217-220
###################################################
system.time(jj1 <- R(n,k,include.zero=TRUE))
system.time(jj2 <- R_gf2(k,n))
jj1==jj2


