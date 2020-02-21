
#### UPDATE May 21st, 2019 #######
# Added to NdepositsPmf() writing the number of deposits and the corresponding probabilities to a csv format text file.
# Accordingly, added parameters TrID (tract identification ID) and outProbFile (output file name) to the NdepositsPmf() function.
##################################


#################################################################
## Author:  Johanna Torppa (Based on existing MapMark codes by Karl Ellefsen and Jason Shapiro)
## Date:    December 12, 2018
#################################################################
## Usage: call NDepositsPmf( type, pmf.args, description="" )
#################################################################
## References:
## Ellefsen, K.J., 2017b, User's guide for MapMark4. An R package for the probability calculations
#  in three-part mineral resource assessments: Techniques and Methods.
## Singer, D., and Menzie, W.D., 2010, Quantitative Mineral Resource Assessments: An Integrated Approach:
#  Oxford University Press.

# This function is a combination of Mark3 and Mark4 NDepositsPmf functions to include
# all the three approaches for defining the probability distribution for the number
# of deposits:
# 1. Fit input 90-50-10 percentiles to the negative binomial function
# 2. Normalize and plot given probability-number pairs
# 3. Use the approach by by Singer, D., and Menzie, W.D., 2010,
#    Quantitative Mineral Resource Assessments: An Integrated Approach: Oxford University Press.



# The function arguments are defined in the documentation for
# function NDepositsPmf.

CalcNegBinomialPmf <- function( nDepEst,
                                nGridPoints = 40,
                                power = 1.0,
                                isOptimized = TRUE,
                                probRightTail = 0.001 ){

  CheckInput <- function(df){

    colNames <- c("Name", "Weight", "N90", "N50", "N10")
    if(any(colnames(df) != colNames)){
      stop( sprintf( "Dataframe with the number of deposit estimates has\n"),
            sprintf( "one or more incorrect column names.\n"),
            sprintf( "The column names must be \"Name Weight N90 N50 N10\".\n"),
            call. = FALSE )
    }

    if(any(is.na(df))){
      stop( sprintf( "Dataframe with the number of deposit estimates has\n"),
            sprintf( "one or more missing entries.\n"),
            call. = FALSE )
    }
    if(any(df[, -1] < 0)){
      stop( sprintf( "Dataframe with the number of deposit estimates has\n"),
            sprintf( "one or more negative values.\n"),
            call. = FALSE )
    }
    for(i in 1:nrow(df)){
      if(!(df[i, "N90"] <= df[i, "N50"] && df[i, "N50"] <= df[i, "N10"])){
        stop( sprintf( "Row %4d of dataframe with the number of deposit\n", i),
              sprintf( "estimates is mis-ordered.\n"),
              call. = FALSE )
      }
    }

  } # End function CheckInput

  CalcParms <- function(nDepEst, nGridPoints, power, isOptimized){

# The input params have to be defined in function input as is below,
# for the function to work properly in optim() function.
    fn <- function(params, nDepEst, power){

      prevOp <- options(warn = -1)

      theProb <- params[1]
      theSize <- params[2]
# The qnbinom function gives the the number of successfull trials (here the number of deposits)
# for given quantiles.
      nDeposits <- qnbinom(c(0.90, 0.50, 0.10), size = theSize,
                           prob = theProb, lower.tail = FALSE)
      cost <- 0.0
      for(k in 1:nrow(nDepEst)){
        absDiff <- abs(nDeposits - nDepEst[k, c("N90", "N50", "N10")])
        currentCosts <- nDepEst[k, "Weight"] * (absDiff)^power
        cost <- cost + sum(currentCosts)
      }

      options(prevOp)

      return(cost)
    }

# Minimum and maximum mean of the neg bin func for cost f sampling
    lowBnd <- sum(nDepEst$N90 * nDepEst$Weight) / sum(nDepEst$Weight) 
    upBnd <- sum(nDepEst$N10 * nDepEst$Weight) / sum(nDepEst$Weight)

    mean_seq <- seq(from = lowBnd + 0.01, to = upBnd, length.out = nGridPoints)

# Maximum stdev. Minimum stdev=sqrt(mean).
    sdMax <- upBnd - lowBnd
    varMax <- sdMax^2

    cost <- matrix(0, nrow = nGridPoints, ncol = nGridPoints)
    theProb <- matrix(NA_real_, nrow = nGridPoints, ncol = nGridPoints)
    theSize <- matrix(NA_real_, nrow = nGridPoints, ncol = nGridPoints)

    for(i in 1:nGridPoints){ # mean loop

      var_seq <- seq(from = mean_seq[i] + 0.01,
                     to = varMax,
                     length.out = nGridPoints)

      for(j in 1:nGridPoints){ # Variance loop

        theProb[i,j] = mean_seq[i] / var_seq[j]
        theSize[i,j] <- mean_seq[i] * theProb[i,j] / (1 - theProb[i,j])

        cost[i,j] <- fn(c(theProb[i,j], theSize[i,j]), nDepEst, power)
      }
    }

    index <- which.min(cost)
    j <- index %/% nGridPoints + 1
    i <- index - (j-1) * nGridPoints

    if(isOptimized){
# The Nelder-Mead optimization algorithm is used
      tmp <- optim(c(theProb[i,j], theSize[i,j]), fn, NULL, nDepEst, power)
      if(tmp$convergence > 0){
        stop( sprintf( "Optimization failed\n"),
              call. = FALSE )
      } else{
        result <- list(theProb = tmp$par[1], theSize = tmp$par[2])
      }
    } else {
      result <- list(theProb = theProb[i,j], theSize = theSize[i,j])
    }

    return(result)
  } # End of function CalcParams() 

  CheckInput(nDepEst)

  nDepEst$Name <- NULL

  # Remove the estimates with zero weight
  nDepEst <- nDepEst[nDepEst$Weight > 0, ]

  params <- CalcParms(nDepEst, nGridPoints, power, isOptimized)

  # x is the upper trunation point. The upper truncation point is the
  # quantile above which the sum of the probabilities is less than (or equal to)
  # probRightTail.
# the size parameter need not be an integer, but the output is always an integer from 
# the qnbinom() function
  x <- qnbinom( 1-probRightTail, size = params$theSize, prob = params$theProb )
  
  # Now compute the lower truncation point, if any.
  # The lower truncation point is that quantile at which the probability is
  # less than (or equal to) the probability at the upper truncation point.
  nDeposits <- 0:x
# All the pmf values for nDeposits values
  pmf <- dnbinom( nDeposits, size = params$theSize, prob = params$theProb )
# Probability at the upper truncation point
  areTooSmall <- (pmf < pmf[length(pmf)])
  nDeposits <- nDeposits[!areTooSmall]
  pmf <- pmf[!areTooSmall]

  # Normalize the pmf so that it sums to 1.
  pmf <- pmf/sum(pmf)

  return( list( nDeposits = nDeposits, probs = pmf ) )
} # End function CalcNegBinomialPmf





# The function arguments are defined in the documentation for
# function NDepositsPmf.
#
CalcCustomPmf <- function(type, nDeposits, relProbabilities ) {

  if( length( nDeposits ) != length( relProbabilities ) ) {
    stop( sprintf( "Function CalcCustomPmf\n" ),
          sprintf( "The length of nDeposits must equal the length of relProbabilities.\n" ),
          call. = FALSE )
  }

  if( any( nDeposits < 0 ) ) {
    stop( sprintf( "Function CalcCustomPmf\n" ),
          sprintf( "All elements of nDeposits must be >= 0.\n" ),
          call. = FALSE )
  }

# In the version NDepositsPmf2 of the GUI version (i.e., the Mark3 version), the following condition is not required to be fulfilled.
  if( type=="CustomMark4" & any( diff( nDeposits ) <= 0 ) ) {
    stop( sprintf( "Function CalcCustomPmf\n" ),
          sprintf( "All elements of nDeposits must be in strictly ascending order.\n" ),
          call. = FALSE )
  }

  if( any( relProbabilities < 0.0 ) ) {
    stop( sprintf( "Function CalcCustomPmf\n" ),
          sprintf( "All elements of relProbabilities must be >= 0.\n" ),
          call. = FALSE )
  }

  probs <- relProbabilities / sum( relProbabilities )

  return( list( nDeposits=nDeposits, probs=probs ) )

} # End CalcCustomPmf() function




CalcCustomMark3Pmf<-function(type,nDeposits) {
# MARK3 PMF Option Run
# Based off of Singer, D., and Menzie, W.D., 2010,
# Quantitative Mineral Resource Assessments: An Integrated Approach: Oxford University Press.
    N9 <<- nDeposits[1]
    N5 <<- nDeposits[2]
    N1 <<- nDeposits[3]
    N05 <<- nDeposits[4]
    N01 <<- nDeposits[5]
    
    max1 <<- max(nDeposits)
    nlist <<- c(0:max1)
    P = c(0)
##########################################
##S Calculation 
##########################################
    S1 <<- (1 + 2 * N9)
    if (N9 == N5) {
      S2 <<- 1 
    } else {
      S2 <<- 2 + 2 * (N5 - N9 - 1)
    }
    if (N5 == N1) {
      S3 <<- 1 
    } else {
      S3 <- ( 2 + 2 * (N1 - N5 - 1))
    }
    if (N1 == N05) {
      S4 <<- 1 
    } else {
      S4 <<- ( 2 + 2 * (N05 - N1 - 1))
    }
    if (N01 == N05) {
      S5 <<- 1 
    } else {
      S5 <<- ( 2 + 2 * (N01 - N05 - 1))
    }
    
#######################
##Setting Variables
######################
    sum <- 0.0
    expect <-0.0
    
###############################################
## For statements - general MapMark loop run
##################################################
    for(n in 1:(N01 + 1)) {
      if (n < (N9 + 1)) {
        P[n] <- 0.2/S1    ## first P, n = 1  [0.067]
      } else {
        if (n == N9 + 1) {
          P[n] = 0.1/S1 + 0.4/S2  #second P, n= 2 [0.233]
          if (N9 == N5) {
            P[n] = P[n] + 0.4/S3
            if (N5 == N1) {
              P[n] = P[n] + 0.05/S4
            }
            if (N5 == N05) {
              P[n] <- P[n] + 0.04/S5
            }
          }	
        } else {
          if (n < N5 + 1) {
            P[n] <- 0.8/S2  
            if (N9 == N5) {
              P[n] <- 0.8/S3
            }
          } else {
            if (n == N5 + 1) {
              P[n] = 0.4/S2 + 0.4/S3
              if (N5 == N1) {
                P[n] = P[n] + 0.05/S4
                if (N1 == N05) {
                  P[n] <- P[n] + 0.04/S5
                }
              }
            } else {
              if (n < N1 + 1) {
                P[n] = 0.8/S3
                if (N5 == N1) {
                  P[n] <- 0.0
                }
              } else {
                if (n == N1 + 1) {
                  P[n] = 0.4/S3 + 0.05/S4
                  if (N1 == N05) {
                    P[n] <- (P[n] + 0.04/S5 )    ## last P , n =5 [0.19]
                  }
                } else{
                  if (n < N05 + 1) {
                    P[n] <- 0.1/S4
                  } else{
                    if (n == N05 + 1) {
                      P[n] = 0.05/S4 + 0.04/S5
                    } else{
                      if (n < N01 + 1) {
                        P[n] <- 0.08/S5
                      } else {
                        if (n == N01 + 1) {
                          P[n] = 0.08/S5 + 0.01
                          if (N01 == N05) {
                            P[n] <- P[n] + 0.025
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    for(n in 1:(N01 + 1)) {
      sum <- sum + P[n]
    }
    
## changed the count to plus 1 to follow the others mabd added the last p , as the probability plus the rest of the sum
    P[N01 + 1] <- P[N01 + 1] + (1.0 - sum)
    
#######################
## Setting Expect Variable
#######################
    for(n in 1:(N01+1)) {
      expect = expect + P[n] * n
    }
    
    rel6 <<- P
############################################################
### Runs PMF from MapMark4 package using the MARK 3 Option
#############################################################
    pmf <<- CalcCustomPmf( type, nlist, rel6)
    return(pmf)
} # End function CalcCustomMark3Pmf()




#' @title Plot both the pmf and the elicitation percentiles for the number of
#' undiscovered deposits
#'
#' @description Plots both the probability mass function (pmf) and the
#' elicitation percentiles for the number of
#' undiscovered deposits in the permissive tract. However, if the pmf type
#' is CustomMark3 or CustomMark4, then there are no elicitation percentiles, and, hence,
#' they are not plotted.
#'
#' @param object
#' An object of class "NDepositsPmf"
#'
#' @param isMeanPlotted
#' Logical variable indicating whether the mean is plotted on the pmf.
#'
#' @param areLinesAdded
#' Logical variable indicating whether vertical lines are added to the pmf.
#' A vertical line is added for each number of an undiscovered deposit, making
#' it easier to perceive the associated probability mass.
#'
#' @param isUsgsStyle
#' Make the plot format similar to the U.S. Geological Survey style.
#'
#' @details
#' The elicitation percentiles are defined in the User's Guide.
#'
#' If the range for the horizontal axis is large (for example, 0 to 300) then
#' the plot of the pmf using bars may appear odd. In this case,
#' set argument pmfPlotSymbol to "point".
#'
#' In the plot of the elicitation percentiles, the count refers to the number
#' of assessment members who estimated the same number of undiscovered
#' deposits, for the specified percentile.
#'
#' @examples
#' pmf1 <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst1))
#' plot(pmf1)
#'
#' pmf2 <- NDepositsPmf("Custom", list(nDeposits = 1, relProbabilities = 1))
#' plot(pmf2)
#'
#' @export
#'
plot.NDepositsPmf <- function( object,
                               isMeanPlotted = FALSE,
                               areLinesAdded = TRUE,
                               isUsgsStyle = TRUE) {


  df <- data.frame(nDeposits = object$nDeposits,
                   probs = object$probs)

  p <- ggplot2::ggplot(df)

  if(isMeanPlotted == TRUE) {
    p <- p + ggplot2::geom_vline(xintercept = object$theMean, colour = "red")
  }

  if(areLinesAdded){
    for(i in 1:length(object$nDeposits)){
      df1 <- data.frame( x = rep.int(object$nDeposits[i], 2),
                        y = c(0, object$probs[i]))
      p <- p + ggplot2::geom_line(ggplot2::aes(x = x, y = y), data = df1)
    }
  }

  p <- p + ggplot2::geom_point(ggplot2::aes(x = nDeposits, y = probs)) +
    ggplot2::scale_x_continuous(name = "Number of undiscovered deposits",
                                limits = range(df$nDeposits) + c(-1,1)) +
    ggplot2::scale_y_continuous(name = "Probability",
                                limits = c(0, max(df$probs)))

  if(isUsgsStyle)
    p <- p + ggplot2::theme_bw()

  if(object$type == "CustomMark3" | object$type == "CustomMark4") {
    print(p)
  } else {

    df$accdf <- c(1, 1-cumsum(df$probs)[-length(df$probs)])

    a <- table(object$pmf.args$nDepEst$N90)
    b <- table(object$pmf.args$nDepEst$N50)
    c <- table(object$pmf.args$nDepEst$N10)

    df2 <- data.frame(nDeposits = c(as.integer(names(a)),
                                    as.integer(names(b)),
                                    as.integer(names(c))),
                      Percentiles = c(rep.int(90, length(a)),
                                      rep.int(50, length(b)),
                                      rep.int(10, length(c))),
                      Sizes = c(as.vector(a),
                                as.vector(b),
                                as.vector(c)))

    q <- ggplot2::ggplot() +
      ggplot2::geom_point(ggplot2::aes(x = nDeposits,
                                       y = Percentiles,
                                       size = Sizes),
                          data = df2, colour = "red", shape = 1, stroke = 1.1) +
      ggplot2::geom_point(ggplot2::aes(x = nDeposits,
                                       y = accdf * 100),
                          data = df) +
      ggplot2::scale_y_continuous(name = "Elicitation percentiles", limits = c(0,100),
                                  breaks = c(0, 10, 50, 90, 100)) +
      ggplot2::scale_x_continuous(name = "Number of undiscovered deposits") +
      ggplot2::scale_size(name = "Count", breaks = min(df2$Sizes):max(df2$Sizes))

    if(isUsgsStyle)
      q <- q + ggplot2::theme_bw()

    q <- q + ggplot2::theme(legend.position = c(1,1), legend.justification = c(1.1,1.1))

    if(isUsgsStyle) {
      p <- p + ggplot2::ggtitle("A.") +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                          face = "italic"))
      q <- q + ggplot2::ggtitle("B.") +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                          face = "italic"))
    } else {
      p <- p + ggplot2::ggtitle("(a)") +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0))
      q <- q + ggplot2::ggtitle("(b)") +
        ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0))
    }

    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
    plot(p, vp=grid::viewport(layout.pos.row=1, layout.pos.col=1))
    plot(q, vp=grid::viewport(layout.pos.row=1, layout.pos.col=2))

  }

}


#' @title Summarize the pmf for the number of undiscovered deposits
#'
#' @description Summarize the probability mass function (pmf) for
#' the number of undiscovered deposits in the permissive tract.
#'
#' @param object
#' An object of class "NDepositsPmf"
#'
#' @examples
#' pmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst1))
#' summary(pmf)
#'
#' @export
#'
summary.NDepositsPmf <- function( object) {

  cat(sprintf("Summary of the pmf for the number of undiscovered deposits\n"))
  cat(sprintf("within the permissive tract.\n"))
  cat(sprintf("------------------------------------------------------------\n"))
  cat( sprintf( "Type: %s\n", object$type ))
  cat( sprintf( "Description: %s\n", object$description ))
  cat( sprintf( "Mean: %g\n", object$theMean ))
  cat( sprintf( "Variance: %g\n", object$theVar ))
  cat( sprintf( "Standard deviation: %g\n", sqrt(object$theVar) ))
  cat( sprintf( "Mode: %d\n", object$nDeposits[which.max(object$probs)] ))
  cat( sprintf( "Smallest number of deposits in the pmf: %d\n",
                min(object$nDeposits) ))
  cat( sprintf( "Largest number of deposits in the pmf: %d\n",
                max(object$nDeposits) ))
  cat( sprintf( "Information entropy: %g\n",
                max(object$entropy) ))

  cat( sprintf( "\n###############################################################\n"))
  cat(sprintf("\n\n\n\n"))

}


#' @title Construct the pmf for the number of undiscovered deposits
#'
#' @description Construct the probability mass function (pmf) for the number of
#' undiscovered deposits within the permissive tract
#'
#' @param type
#' Character string with the type of pmf (See Details).
#'
#' @param pmf.args
#' List with the arguments for the specified type (See Details).
#'
#' @param description
#' Character string with a short description of the pmf.
#'
#' @details
#' The type must be either "NegBinomial", "CustomMark3" or "CustomMark4". Each type, as well as
#' it associated arguments, is described below.
#'
#' \emph{NegBinomial}
#'
#' List pmf.args has one required element and four optional arguments.
#' The required element \code{nDepEst} is a dataframe containing
#' the estimates of the numbers of undiscovered deposits by the members of the
#' assessment team. Each row of the dataframe has information for one member.
#' There are five columns in the dataframe.
#' Column 1 ("Name") lists the member identifiers.
#' Column 2 ("Weight") lists the weights that multiply the cost function.
#' Column 3 ("N90") lists the estimated number of the undiscovered deposits,
#' n90, for which P( N >= n90 ) = 0.9 where N is the random variable representing
#' the number of undiscovered deposits.
#' Likewise, column 4 ("N50") lists n50 for which P( N >= n50 ) = 0.5, and
#' column 5 ("N10") lists n10 for which P( N >= n10 ) = 0.1. Within each row
#' of the dataframe, n90, n50, and n10 must be in strickly ascending order. That
#' is, n90 <= n50 <= n10.
#'
#' There are four optional arguments that may be added to the list of parameters
#' for the pmf: \code{nGridPoints}, \code{power},
#' \code{isOptimized}, and \code{probRightTail}.
#' To understand the first three arguments,
#' it is necessary to understand how the two
#' parameters that are needed to characterize a negative binomial pmf are
#' estimated. The two parameters are specified on a two-dimensional grid, and
#' \code{nGridPoints} is the number of grid points in each dimension of the
#' grid. At
#' each grid point, a cost function is calculated, and a parameter in that
#' cost function is \code{power}.
#' If the value of argument \code{isOptimized} is FALSE, then
#' the two parameter values associated with the grid point with the lowest cost
#' are used as the parameters for negative binomial pmf. Otherwise, these two
#' parameter values are the starting point for an optimization that finds their
#' optimal values.
#'
#' To understand the fourth optional argument, it is necessary to understand
#' the negative binomial pmf itself. The random variable that represents the
#' number of undiscovered deposits extends from 0 to infinity. Of course,
#' the probability calculations cannot be performed for an infinite range.
#' At some point in the right tail, the probabilities are
#' so small that they have no practical effect on the probability calculations.
#' Thus, the pmf is truncated at an appropriate large value. This upper
#' truncation point is the quantile above which the sum of the probabilities
#' (from that quantile to infinity)
#' is less than (or equal to) \code{probRightTail}.
#' The lower truncation point is that quantile for which the probability is
#' less than or equal to that at the upper truncation point. After truncation,
#' the pmf is normalized so that the sum of its probabilities is 1.
#'
#' The default values for these four optional arguments are appropriate for
#' most assessments, so they should rarely be changed.
#'
#' The computation of the negative binomial pmf requires
#' a long time---but usually less than a minute.
#'
#' \emph{Custom}
#'
#' List pmf.args has two elements, which are named "nDeposits" and
#' "relProbabilities". nDeposits is an integer vector, and relProbabilities is
#' a real vector.
#'
#' Regarding vector nDeposits, all elements must be in strictly ascending order.
#' That is,
#' 0 <= nDeposits[1] < nDeposits[2] < nDeposits[3] and so on. Regarding
#' vector relProbabilities, the elements are postive,
#' real-valued numbers. The sum of the elements in relProbabilities is
#' not required to be 1. Vector nDeposits
#' and vector relProbabilites must have the same length.
#'
#' @return If the input arguments have an error, the R-value NULL is returned.
#' Otherwise, a list with the following components is returned.
#' @return \item{Type}{Input argument type}
#' @return \item{pmf.args}{Input argument pmf.args}
#' @return \item{description}{Input argument description}
#' @return \item{call}{Function call}
#' @return \item{probs}{Vector containing just the non-zero probabilities
#' in the pmf.}
#' @return \item{nDeposits}{Vector containing the number of undiscovered
#' deposits that are associated with the non-zero probabilities in the pmf.
#' The size of vector nDeposits is equal to the size of vector probs.}
#' @return \item{theMean}{The expected value (mean) of the number of
#' undiscovered deposits within the permissive tract.}
#' @return \item{theVar}{The variance of the number of undiscovered deposits
#' within the permissive tract.}
#' @return \item{entropy}{The information entropy, which is calculated with
#' the natural logarithm.}
#'
#' @references
#' Ellefsen, K.J., Phillips, J.D.,
#' 2017, Probability calculations for three-part mineral resource assessments,
#' U.S. Geological Survey Report Techniques and Methods XXXX, XX p.
#'
#' @examples
#' pmf1 <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst1))
#' plot(pmf1)
#'
#' pmf2 <- NDepositsPmf("NegBinomial",
#'          list(nDepEst = ExampleDepEst1, probRightTail = 0.0005,
#'          nGridPoints = 65, power = 1.0, isOptimized = FALSE))
#' plot(pmf2)
#'
#' pmf3 <- NDepositsPmf("Custom", list(nDeposits = 1, relProbabilities = 1))
#' plot(pmf3)
#'
#' pmf4 <- NDepositsPmf("Custom",
#'          list(nDeposits = c(2, 3), relProbabilities = c(0.3, 0.7)))
#' plot(pmf4)
#'
#' @export
#'
NDepositsPmf <- function( type, pmf.args, outProbFile, TrID, description="") {


  CalcSummaryStats <- function( probs, nDeposits, base=exp(1) )
  {

    theMean <- sum( probs * nDeposits )
    theVar <- sum( probs * nDeposits^2 ) - theMean^2
    theEntropy <- - sum( probs * log( probs, base=base ) )

    return( list( theMean=theMean, theVar=theVar, theEntropy=theEntropy ) )

  }

  if(!any(type == c("NegBinomial", "CustomMark4","CustomMark3"))) {
    stop( sprintf( "Function NDepositsPmf\n" ),
          sprintf( "Argument type must be either NegBinomial, CustomMark3 or CustomMark4.\n"),
          sprintf( "It is specified as %s\n", type),
          call. = FALSE )
  }

  pmf <- switch( type,
                 NegBinomial = do.call( CalcNegBinomialPmf, pmf.args ),
                 CustomMark4 = do.call( CalcCustomPmf, list(type,pmf.args[[1]],pmf.args[[2]]) ),
                 CustomMark3 = do.call(CalcCustomMark3Pmf,list(type,pmf.args[[1]])))

  # Obviously, it must be greater than 0. Greater than 5000 is preferable.
  nTotalDraws <- 20000

  stats <- CalcSummaryStats( pmf$probs, pmf$nDeposits )

  rval <- list( type = type,
                pmf.args = pmf.args,
                description = description,
                call = sys.call(),
                probs = pmf$probs,
                nDeposits = pmf$nDeposits,
                theMean = stats$theMean,
                theVar = stats$theVar,
                entropy = stats$theEntropy )
  outTable<-cbind(TrID,pmf$nDeposits,pmf$probs)
  names(outTable)<-c("TrID","nDep","Prob")
  write.table(outTable,outProbFile,sep=",",quote=F,row.names=F,col.names=c("TrID","nDep","Prob"))

  class(rval) <- "NDepositsPmf"
  return(rval)
}
