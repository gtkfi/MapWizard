#' @title Generate random samples from the pdf that represents the tonnage
#'
#' @description Generate random samples from the probability density
#' function (pdf) that represents the tonnage.
#'
#' @param object
#' An object of class "TonnagePdf"
#'
#' @param nSamples
#' Integer specifying the number of random samples
#'
#' @param seed
#' Integer containing the seed.
#'
#' @param log_rs
#' Logical variable indicating whether the random sample are transformed
#' with the natural logarithm.
#'
#' @details
#' To generate random samples, the tonnages (from the model) are
#' transformed with the natural logarithm.
#' If the \code{pdfType} within \code{object} is \code{kde}, then
#' a kernel density estimate
#' of the log-transformed tonnages is used to
#' generate log-transformed random samples
#' (Hastie and others, 2009, p. 208-209;
#' Shalizi, 2016, p. 308-330).
#' In contrast, if the \code{pdfType} is \code{normal},
#' then a normal distribution is used to generate
#' log-transformed random samples.
#'
#' The log-transformed random samples are converted to random samples of
#' tonnage with exponentiation.
#'
#' @return Vector containing random samples from the pdf that represents the
#' tonnages for one undiscovered deposit in the permissive tract.
#'
#' @references
#' Hastie, Tevor, Tibshirani, Robert, and Friedman, Jerome, 2009,
#' The elements of statistical learning - Data mining, inference, and
#' prediction (2nd ed.): New York, Springer Science + Business Media, LLC, 745 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' @examples
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' rs <- getRandomSamples(oTonPdf, 2518)
#'
#' oTonPdf <- TonnagePdf(ExampleTm)
#' rs <- getRandomSamples(oTonPdf, 2518)
#'
#' @export
#'
getRandomSamples.TonnagePdf <- function(object, nSamples, seed = NULL,
                                         log_rs = FALSE, labelSize=12) {

  # The number of random samples that are generated is 2 * nSamples because,
  # if the random samples are truncated, then there will be enough remaining
  # so that nSamples random samples can be returned.

  N <- 2 * nSamples

  set.seed(seed)

  if(object$pdfType == "kde") {
    bw <- density(object$logTonnages)$bw

    indices <- sample( 1:length(object$logTonnages), N, replace=TRUE )

    # For each element of indices, a random sample could be drawn. However,
    # this results in very slow code. Instead, determine the unique indices
    # (uniqueIndices) and the number of occurrences for each unique index
    # (counts). Then for uniqueIndices[i], draw counts[i] random samples.
    tmp <- table(indices)
    uniqueIndices <- as.integer(names(tmp))
    counts <- as.vector(tmp, mode = "integer")

    rsLogTonnage <- NULL
    for(i in seq_along(uniqueIndices)) {
      index <- uniqueIndices[i]
      rs <- rnorm( counts[i], mean = object$logTonnages[index], sd = bw)
      rsLogTonnage <- c(rsLogTonnage, rs)
    }

    # Make the draws random
    rsLogTonnage <- rsLogTonnage[sample.int(N, size = N)]

  } else {
    rsLogTonnage <- rnorm(N, mean = mean(object$logTonnages),
                          sd = sd(object$logTonnages))
  }

  if(object$isTruncated == TRUE){
    theRange <- range(object$logTonnages)

    areWithinBnds <- theRange[1] <= rsLogTonnage & rsLogTonnage <= theRange[2]

    rsLogTonnage <- rsLogTonnage[areWithinBnds]
  }

  rsLogTonnage <- rsLogTonnage[1:nSamples]

  if(log_rs == FALSE) {
    return(exp(rsLogTonnage))
  } else {
    return(rsLogTonnage)
  }

}

#' @title Plot the pdf and cdf for the tonnage.
#'
#' @description Plot the probability density function (pdf) and the
#' cumulative distribution function (cdf) that represent the
#' tonnages. The pdf is represented by the histogram.
#' Beneath the pdf, plot the tonnages from the model.
#' On the cdf, plot the
#' empirical cumulative distribution function (ecdf)
#' for the tonnages from the model.
#'
#' @param object
#' An object of class "TonnagePdf".
#'
#' @param isUsgsStyle
#' Make the plot format similar to the U.S. Geological Survey style
#'
#' @details
#' In the cdf, the solid line represent the cdf, and the dots represent
#' the ecdf.
#'
#' Deviance measures the
#' misfit between the pdf and the tonnages from the model.
#' Smaller values of deviance indicate smaller misfit. The deviance
#' is printed near the bottom of the pdf.
#'
#' @examples
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' plot(oTonPdf)
#'
#' @export
#'
plot.TonnagePdf <- function(object, isUsgsStyle = TRUE) {

  # If there are too many random samples, subset them.
  n <- length(object$rs)
  if(n > 5000) {
    indices <- sample.int(n, size = 5000)
    df.rs <- data.frame(Tonnage = object$rs[indices])
  } else {
    df.rs <- data.frame(Tonnage = object$rs)
  }

  df.obs <- data.frame(Tonnage = object$model[, 3])

  if(isUsgsStyle) {
    xLabel <- paste(object$matName, " tonnage, in metric tons", sep = "")
  } else {
    xLabel <- paste(object$matName, " tonnage (mt)", sep = "")
  }

  caption <- paste("Deviance = ",
                   signif(object$deviance, digits = 3), sep = "")

  p1 <- ggplot2::ggplot() +
    ggplot2::geom_histogram(ggplot2::aes(x = Tonnage, y = ..density..),
                            data = df.rs, bins = 15,
                            color = "white", fill = "gray45") +
    ggplot2::geom_rug(ggplot2::aes(x = Tonnage), data = df.obs, colour = "red") +
    ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
    ggplot2::ylab("Density")

  p2 <- ggplot2::ggplot() +
    ggplot2::stat_ecdf(ggplot2::aes(x = Tonnage),
                       data = df.obs,
                       pad = FALSE,
                       geom = "point", colour = "red") +
    ggplot2::stat_ecdf(ggplot2::aes(x = Tonnage),
                       data = df.rs,
                       pad = FALSE, geom = "step") +
    ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
    ggplot2::ylab("Probability") +
    ggplot2::geom_text(ggplot2::aes(x, y, label = caption),
                       data = data.frame(x = exp(mean(log(df.obs$Tonnage))), y = 0),
                       vjust = "inward", nudge_y = 0.01)

  if(isUsgsStyle) {
    p1 <- p1 + ggplot2::theme_bw() +
      ggplot2::ggtitle("A.") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                        face = "italic"))

    p2 <- p2 + ggplot2::theme_bw() +
      ggplot2::ggtitle("B.") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                        face = "italic"))
  }


  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
  print(p1, vp=grid::viewport(layout.pos.row=1, layout.pos.col=1))
  print(p2, vp=grid::viewport(layout.pos.row=1, layout.pos.col=2))

}



#' @title Summary comparison of the pdf that represents
#' the tonnages and the actual tonnages in the model.
#'
#' @description Using summary statistics, this function compares
#' the probability density function (pdf) that represents
#' the tonnages to the actual tonnages in the model.
#' The summary statistics are various quantiles, mean, and standard deviation.
#' The comparison is involves both the log-transformed tonnages
#' and the untransformed tonnages.
#'
#' @param object
#' An object of class "TonnagePdf"
#'
#' @param nDigits
#' Number of signficant digits.
#'
#' @details
#' The statistics calculated with log-transformed tonnages are particularly
#' important because they indicate the fit of the pdf to the tonnages
#' from either the grade and tonnage model or the tonnage model.
#' Differences between corresponding statistics usually differ slightly.
#' However, if the pdf is not
#' truncated (see function TonnagePdf), then the corresponding
#' minimum and the maximum statistics might differ a lot.
#'
#' For the untransformed tonnages, the
#' differences between corresponding statistics may be relatively large.
#' The reason is
#' that the pdf is fit to the log-transformed tonnages, not the
#' untransformed tonnages.
#'
#' @examples
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' summary(oTonPdf)
#'
#' oTonPdf <- TonnagePdf(ExampleTm)
#' summary(oTonPdf)
#'
#' @export
#'
summary.TonnagePdf <- function(object, nDigits = 3) {

  PrintStats <- function(model, pdf, nDigits){

    df <- data.frame(Gatm = c(quantile(model, probs = c(0, 0.25, 0.50, 0.75, 1),
                                     names = FALSE), mean(model), sd(model)),
                     Pdf = c(quantile(pdf, probs = c(0, 0.25, 0.50, 0.75, 1),
                                    names = FALSE), mean(pdf), sd(pdf)))
    row.names(df) <- c("Minimum", "0.25 quantile", "Median",
                       "0.75 quantile", "Maximum", "Mean", "Standard deviation")
    print(signif(df, digits = nDigits))
  }

  cat(sprintf("Summary comparison of the pdf representing the tonnage\n"))
  cat(sprintf("and the actual tonnages in the model.\n"))
  cat(sprintf("------------------------------------------------------------\n"))
  cat( sprintf( "Pdf type: %s\n", object$pdfType ))
  if(object$isTruncated) {
    cat( sprintf("Pdf is truncated at the lowest and the highest values\n"))
    cat( sprintf("of the tonnages in the model.\n"))
  } else {
    cat( sprintf("Pdf is not truncated.\n"))
  }
  cat( sprintf( "Number of discovered deposits in the model: %d\n",
                nrow(object$model) ))
  cat( sprintf( "\n" ))

  cat(sprintf("Deviance = %g\n", object$deviance))

  cat(sprintf("------------------------------------------------------------\n"))
  cat( sprintf( "This table pertains to the log-transformed tonnages.\n"))
  cat( sprintf( "Column Gatm refers to the actual tonnages in the\n"))
  cat( sprintf( "grade and tonnage model; column Pdf refers to the\n"))
  cat( sprintf( "pdf representing the tonnages.\n"))

  PrintStats(object$logTonnages, log(object$rs), nDigits)

  cat(sprintf("------------------------------------------------------------\n"))
  cat( sprintf( "This table pertains to the (untransformed) tonnages.\n"))
  cat( sprintf( "Column Gatm refers to the tonnages in the grade and\n"))
  cat( sprintf( "tonnage model; column Pdf refers to the pdf\n"))
  cat( sprintf( "representing the tonnages.\n"))

  PrintStats(object$model[, 3], object$rs, nDigits)

  cat( sprintf( "\n###############################################################\n"))
  cat(sprintf("\n\n\n\n"))

}


#' @title Construct the pdf that represents the tonnages
#'
#' @description Construct the probability density function (pdf)
#' that represents the tonnages, which are either ore tonnages in a
#' grade and tonnage model or contained metal tonnages in a tonnage model.
#' The pdf is not explicitly specified; instead it is implicitly
#' specified with the random samples that are generated from it.
#'
#' @param model
#' Dataframe containing either the grade and tonnage model or the tonnage
#' model. (See details.)
#'
#' @param seed
#' Seed for the random number generator.
#'
#' @param pdfType
#' Character string containing the type of pdf for
#' the log-transformed material tonnages. The choices are either
#' "kde" or "normal".
#'
#' @param isTruncated
#' Logical variable indicating whether the pdf is
#' truncated at the lowest and highest values of the actual tonnages in the
#' model.
#'
#' @param minNDeposits
#' Minimum number of deposits in the grade and tonnage model.
#'
#' @param nRandomSamples
#' Number of random samples used to compute summary statistics.
#' It should be a large value
#' to ensure that the summary statistics are precise.
#'
#' @details
#' If argument model is a grade and tonnage model, then argument model
#' comprises the ore tonnages and the grades for its deposits.
#' Each row comprises the data for one deposit.
#' The first column lists a unique identifier for each deposit.
#' The second column lists the names of the deposits.
#' The third column lists the ore tonnage.
#' The fourth and subsequent columns, if any, list
#' the grades for the resources.
#' Ore tonnages must not be missing and must be greater than zero.
#' The minimum number of
#' deposits (that is, rows in the data frame) should be greater than or
#' equal to 20.
#'
#' The columns of the data frame must have headings.
#' The heading for the first column is "ID".
#' The heading for the
#' second column is "Name" or "Deposit name".
#' The heading for the third column is Ore.
#' The headings for the fourth and subsequent columns, if any, are the
#' names of the resources. For example, they might be "Au" and "Cu".
#'
#' If argument model is a tonnage model, then argument model comprises just the
#' contained metal tonnages
#' for its deposits. The structure of the tonnage model is identical to that
#' of a grade and tonnage model, with two exceptions. First, the column heading
#' for the tonnage is appropriate for the model. For example, the heading
#' could be \"Uranium\". Second, tonnage model lacks columns with grades.
#'
#' If the \code{pdfType} is \code{kde}, then
#' a univariate kernel density estimate
#' of the log-transformed, tonnages is used to
#' generate log-transformed random samples of tonnage
#' (Hastie and others, 2009, p. 208-209;
#' Shalizi, 2016, p. 308-330).
#' In contrast, if the \code{pdfType} is \code{normal},
#' then a normal distribution is used to generate
#' log-transformed random samples of tonnage. For both cases,
#' the log-transformed random samples are converted to random samples of
#' tonnage with exponentiation.
#'
#' The misfit between the actual tonnages in the model and
#' the pdf that represents those tonnages is quantified with the
#' deviance (McElreath, 2016, p. 177-182).
#'
#' @return A list with the following components is returned.
#' @return \item{model}{Input argument model.}
#' @return \item{seed}{Input argument seed.}
#' @return \item{pdfType}{Input argument pdfType.}
#' @return \item{isTruncated}{Input argument isTruncated.}
#' @return \item{logTonnages}{Vector with the natural logarithm
#' of the tonnages in the model.}
#' @return \item{theModelMean}{Mean of the tonnages in the model.}
#' @return \item{theModelSd}{Standard deviation of the tonnages in the
#' model.}
#' @return \item{rs}{Random samples of the pdf.}
#' @return \item{theMean}{Mean for the pdf.}
#' @return \item{theSd}{Standard deviation for the pdf.}
#' @return \item{deviance}{Deviance measuring the relative fit of
#' the pdf.}
#' @return \item{call}{Function call.}
#'
#' @references
#' Hastie, Tevor, Tibshirani, Robert, and Friedman, Jerome, 2009,
#' The elements of statistical learning - Data mining, inference, and
#' prediction (2nd ed.): New York, Springer Science + Business Media, LLC, 745 p.
#'
#' McElreath, Richard, 2016, Statistical rethinking - A Bayesian course
#' with examples in R and Stan: New York, CRC Press, 469 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' @examples
#' tonPdf <- TonnagePdf(ExampleGatm)
#'
#' @export
#'
TonnagePdf <- function(model,
                       seed = NULL,
                       pdfType = "normal",
                       isTruncated = FALSE,
                       minNDeposits = 20,
                       nRandomSamples = 1000000) {

  CalcDeviance <- function(rsPdf, rsData, nBins = 30) {

    logRsPdf <- log(rsPdf)
    logRsData <- log(rsData)

    theBreaks <- seq(from = min(logRsData, logRsPdf),
                     to = max(logRsData, logRsPdf),
                     length.out = nBins)

    tmpPdf <- hist(logRsPdf, breaks = theBreaks, plot = FALSE)

    tmpData <- hist(logRsData, breaks = theBreaks, plot = FALSE)

    deviance <- (- 2) * sum(tmpPdf$density * tmpData$counts)

    return(deviance)
  }

  CheckModel(model, minNDeposits)

  if(!any(pdfType == c("kde", "normal"))) {
    stop( sprintf( "Function TonnagePdf\n" ),
          sprintf( "Argument type must be either kde or normal.\n"),
          sprintf( "It is specified as %s\n", pdfType),
          call. = FALSE )
  }

  rval <- list( model = model,
                seed = seed,
                pdfType = pdfType,
                isTruncated = isTruncated,
                matName = colnames(model)[3],
                logTonnages = log(model[, 3]),
                theModelMean = mean(model[, 3]),
                theModelSd = sd(model[, 3]))

  class(rval) <- "TonnagePdf"

  rval$rs <- getRandomSamples(rval, nRandomSamples, seed = seed)
  rval$theMean <- mean(rval$rs)
  rval$theSd <- sd(rval$rs)
  rval$deviance <- CalcDeviance(rval$rs, rval$model[, 3])
  rval$call <- sys.call()

  return(rval)
}