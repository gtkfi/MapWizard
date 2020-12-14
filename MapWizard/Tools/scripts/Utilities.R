#' @export
getRandomSamples <- function(z, ...) UseMethod("getRandomSamples")

CheckModel <- function(model, minNDeposits){
  if(nrow(model) < as.double(minNDeposits)) {
  warning("The input grade-tonnage data file contains less than 20 deposits. This might reduce the representativeness of the generated pdfs.")
    #stop( sprintf( "The number of rows in the model must be.\n" ),
    #      sprintf( "greater than or equal to %d.\n", as.double(minNDeposits) ),
    #      sprintf( "But the actual number is %d.\n", nrow(model) ),
    #      call. = FALSE )
  }

  for(j in 3:ncol(model)){
    if(any(is.na(model[, j]))) {
      stop( sprintf( "Column %d of dataframe model has\n", j ),
            sprintf( "one or more missing values\n"),
            call. = FALSE )
    }
    if(any(model[, j] <= 0.0)) {
      stop( sprintf( "Column %d of dataframe model has\n", j ),
            sprintf( "one or more zero values\n"),
            call. = FALSE )
    }
  }
}
