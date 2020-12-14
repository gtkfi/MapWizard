#' @title Print the simulated undiscovered deposits in a file
#'
#' @description Print the simulated undiscovered deposits in a file for which
#' the format is the comma separated value.
#'
#' @param object
#' An object of class "Simulation"
#'
#' @param filename
#' Name of the file
#'
#' @details
#' If the simulated deposits include grades, then they are reported in percent.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oDeposits <- Simulation(oPmf, oTonPdf, oGradePdf)
#' filename <- paste(getTractId(oMeta), "_Simulation.csv", sep = "")
#' print(oDeposits, filename)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oGradePdf <- GradePdf(ExampleTm)
#' oDeposits <- Simulation(oPmf, oTonPdf)
#' filename <- paste(getTractId(oMeta), "_Simulation.csv", sep = "")
#' print(oDeposits, filename)
#'
#' @export
#'
print.Simulation <- function(object, filename) {

  # Modify the column name for the tonnage
  colnames(object$deposits)[4] <-
    paste(colnames(object$deposits)[4], "tonnage", sep = " ")


  nCols <- ncol(object$deposits)

  if(nCols > 4){
    # convert grades to percent
    object$deposits[, 5:nCols] <- object$deposits[, 5:nCols] * 100
    # modify the column names
    colnames(object$deposits)[5:nCols] <-
      paste(colnames(object$deposits)[5:nCols], rep.int("grade", nCols - 4), sep = " ")

  }


  write.csv(object$deposits, file = filename, row.names = FALSE)
}


#' @title Simulate undiscovered deposits in the permissive tract
#'
#' @description Simulate undiscovered deposits in the permissive tract
#'
#' @param oPmf
#' An object of class "NDepositsPmf"
#'
#' @param oTonPdf
#' An object of class "TonnagePdf"
#'
#' @param oGradePdf
#' An object of class "GradePdf"
#'
#' @param nSimulations
#' Number of simulations
#'
#' @details
#' The random samples are computed using the algorithm described in
#' Ellefsen (2017).
#'
#' @return A list with the following components is returned.
#' @return \item{deposits}{Matrix comprising the simulated undiscovered
#' deposits. The first column contains the simulation index. (The last index
#' may not equal argument \code{nSimulations}, but it should be very close.)
#' The second column contains the number of deposits for the current simulation
#' index. The third column contains the deposit number (which is called the
#' "sim deposit index") for the
#' current number of deposits. The fourth column contains the tonnage for
#' the current deposit. If the argument oGradePdf is included in the function
#' call, then the fifth and subsequent columns contain the resource and gangue
#' grades for the current deposit.}
#' @return \item{call}{Function call}
#'
#' @references
#' Ellefsen, K.J.,
#' 2017, Probability calculations for three-part mineral resource assessments,
#' U.S. Geological Survey Report Techniques and Methods XXXX, XX p.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst1))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oDeposits <- Simulation(oPmf, oTonPdf, oGradePdf)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst1))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oDeposits <- Simulation(oPmf, oTonPdf)
#'
#' @export
#'
Simulation <- function(oPmf, oTonPdf, oGradePdf, oTonGradePdf,
#                       nSimulations = 20000) {
                        nSimulations = 10000) {
    
  if(nSimulations < 2500) {
    warning( sprintf( "Function Simulation\n" ),
          sprintf( "The number of simulations should be\n" ),
          sprintf( "greater than 2500.\n" ),
          sprintf( "But the specified number is %d\n", nSimulations ),
          call. = FALSE )
  }

  # Number of deposits per set, which is defined as
  # a non-zero probability in the pmf
  nDepPerSet <- round( oPmf$probs * nSimulations ) * oPmf$nDeposits

  # Number of deposits needed for all sets plus 50% extra
  nTotalDep <- round(1.5 *  sum(nDepPerSet))

  # Get all of the random samples simultaneously.
  # It is done this way because repeated calls to getRandomSamples can
  # require a lot of time.
  
  if (!missing(oTonGradePdf)) {
    rsTonGradePdf<-getRandomSamples(oTonGradePdf, nTotalDep,seed=oTonGradePdf$seed)
    rsTonPdf<-rsTonGradePdf[,1]
    rsGradePdf<-rsTonGradePdf[,-1]
  } else {
    rsTonPdf <- getRandomSamples(oTonPdf, nTotalDep, seed = oTonPdf$seed)
    if(!missing(oGradePdf)){
      rsGradePdf <- getRandomSamples(oGradePdf, nTotalDep, seed = oGradePdf$seed)
    }
  }

  # Construct the container for the deposit simulations
  if(oPmf$nDeposits[1] == 0) {
    nRows <- round(oPmf$probs[1] * nSimulations) + nTotalDep
  } else {
    nRows <- nTotalDep
  }

  if(!missing(oTonGradePdf)) {
    colNames <- c("Simulation Index",
                  "Number of Deposits",
                  "Sim Deposit Index",
                  colnames(rsTonGradePdf))
  } else {
    if(!missing(oGradePdf)) {
      colNames <- c("Simulation Index",
                  "Number of Deposits",
                  "Sim Deposit Index",
                  oTonPdf$matName,
                  colnames(rsGradePdf))
  } else {
    colNames <- c("Simulation Index",
                  "Number of Deposits",
                  "Sim Deposit Index",
                  oTonPdf$matName)
    }
  }


  ds <- matrix(NA_real_, nrow = nRows, ncol = length(colNames),
               dimnames = list(NULL, colNames))

  rsIndex <- 1
  rowIndex <- 1
  resample <- function(x, ...) x[sample.int(length(x), ...)]
  for(simIndex in 1:nSimulations){

    nDeposits <- resample(oPmf$nDeposits, size = 1, prob = oPmf$probs)

    if(nDeposits == 0){
      ds[rowIndex, 1:2] <- c(simIndex, nDeposits)
      rowIndex <- rowIndex + 1
    } else {
      for(i3 in 1:nDeposits){
        if(!missing(oGradePdf)|!missing(oTonGradePdf)){
          ds[rowIndex, ] <- c(simIndex, nDeposits, i3,
                              rsTonPdf[rsIndex], rsGradePdf[rsIndex, ])
        } else {
          ds[rowIndex, ] <- c(simIndex, nDeposits, i3,
                              rsTonPdf[rsIndex])
        }

        rsIndex <- rsIndex + 1
        rowIndex <- rowIndex + 1
      }

    }
  }

  ds <- ds[1:(rowIndex-1), ]


  rval <- list( deposits = ds,
                call=sys.call() )

  class(rval) <- "Simulation"
  return(rval)
}