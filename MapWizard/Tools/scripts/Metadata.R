#' @title Get the tract identifier
#'
#' @description Get the tract identifier, which is a unique character string
#' specifying the permissive tract.
#'
#' @param object
#' An object of class "Metadata"
#'
#' @return
#' A character string containing the tract identifier.
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#' getTractId(oMeta)
#'
#' @export
#'
getTractId <- function(object) {
  return(object$tractId)
}

#' @title Get the filename for either the grade and tonnage model or
#' the tonnage model
#'
#' @description Get the filename for either the grade and tonnage model
#' or the tonnage model.
#'
#' @param object
#' An object of class "Metadata"
#'
#' @return
#' A character string containing the filename.
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#' getModelFilename(oMeta)
#'
#' @export
#'
getModelFilename <- function(object) {
  return(object$modelFilename)
}

#' @title Get the filename containing the estimated numbers of undiscovered
#' deposits
#'
#' @description Get the filename containing the estimated numbers of
#' undiscovered deposits.
#'
#' @param object
#' An object of class "Metadata"
#'
#' @return
#' A character string containing the filename.
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#' getDepEstFilename(oMeta)
#'
#' @export
#'
getDepEstFilename <- function(object) {
  return(object$depEstFilename)
}

#' @title Get the seed
#'
#' @description Get the seed for the probability calculations.
#'
#' @param object
#' An object of class "Metadata"
#'
#' @return
#' A positive integer with the seed.
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#' getSeed(oMeta)
#'
#' @export
#'
getSeed <- function(object) {
  return(object$seed)
}

#' @title Summarize the metadata for the probability calculations
#'
#' @description Summarize the metadata for the probability calculations for
#' the permissive tract.
#'
#' @param object
#' An object of class "Metadata"
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#' summary(oMeta)
#'
#' @export
#'
summary.Metadata <- function(object) {

  cat(sprintf("Meta data for the permissive tract\n"))
  cat(sprintf("------------------------------------------------------------\n"))
  cat(sprintf("Tract identifier: %s\n", object$tractId))
  cat(sprintf("Name of file containing the model: %s\n", object$modelFilename))
  cat(sprintf("Name of file containing the estimates of the number of deposits: %s\n",
              object$depEstFilename))
  cat(sprintf("Seed: %d\n", object$seed))
  cat(sprintf("Tract name: %s\n", object$tractName))
  cat(sprintf("Deposit model: %s\n", object$depositModel))
  cat(sprintf("Calculation date: %s\n", object$calcDate))
  cat(sprintf("Name of person performing the calculations: %s\n", object$personName))
  cat(sprintf("Other information: %s\n", object$otherInfo))

  cat( sprintf( "\n###############################################################\n"))
  cat(sprintf("\n\n\n\n"))

}

#' @title Construct the metadata for the probability calculations
#'
#' @description Construct the metadata for the probability calculations
#' for one permissive tract.
#'
#' @param tractId
#' Character string containing the tract identifier, which is a unique
#' identifier for the permissive tract. (See Details).
#'
#' @param modelFilename
#' Name of the file containing either the grade and tonnage model or
#' the tonnage model.
#'
#' @param depEstFilename
#' Name of the file containing the esimated numbers of undiscovered deposits.
#'
#' @param seed
#' Seed for the probability calculations
#'
#' @param tractName
#' Character string containing the name of the permissive tract.
#'
#' @param depositModel
#' Character string containing the name of the deposit model.
#'
#' @param calcDate
#' Character string containing the date and time of the probability
#' calculations.
#'
#' @param personName
#' Character string containing the name of the person performing the
#' probability calculations.
#'
#' @param otherInfo
#' Character string containing addtional information about the
#' permissive tract or the assessment.
#'
#' @details
#' Parameter \code{tractId}, which is a character string, is used to
#' generate file
#' names associated with the probability calculations. Consequently,
#' \code{tractId} must be suitable for a file name. That is,
#' \code{tractId} should contain neither spaces nor non-standard characters
#' such as !, $, and &.
#'
#' @return A list with the following components is returned.
#' @return \item{tractId}{Input argument tractId}
#' @return \item{modelFilename}{Input argument modelFilename}
#' @return \item{depEstFilename}{Input argument depEstFilename}
#' @return \item{seed}{Input argument seed}
#' @return \item{tractName}{Input argument tractName}
#' @return \item{depositModel}{Input argument depositModel}
#' @return \item{calcDate}{Input argument calcDate}
#' @return \item{personName}{Input argument personName}
#' @return \item{otherInfo}{Input argument otherInfo}
#' @return \item{call}{Function call}
#'
#' @examples
#' oMeta <- Metadata("PT001", "myGatm.csv", "myDepEst.csv",
#'                   seed = 7, tractName = "Lucky Strike",
#'                   depositModel = "Copper-gold subtype of porphyry copper",
#'                   personName = "Mary Doe",
#'                   otherInfo = "Example assessment")
#'
#' @export
#'
Metadata <- function(tractId,
                     modelFilename,
                     depEstFilename,
                     seed = NULL,
                     tractName = "(not specified)",
                     depositModel = "(not specified)",
                     calcDate = date(),
                     personName = "(not specified)",
                     otherInfo = "(not specified)") {

  rval <- list( tractId = tractId,
                modelFilename = modelFilename,
                depEstFilename = depEstFilename,
                seed = seed,
                tractName = tractName,
                depositModel = depositModel,
                calcDate = calcDate,
                personName = personName,
                otherInfo = otherInfo,
                call=sys.call() )

  class(rval) <- "Metadata"
  return(rval)
}