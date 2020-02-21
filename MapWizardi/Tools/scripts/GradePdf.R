#' @title Generate random samples from the pdf that represents the
#' grades
#'
#' @description Generate random samples from the probability density function
#' (pdf) that represents the grades
#'
#' @param object
#' An object of class "GradePdf"
#'
#' @param nSamples
#' Integer specifying the number of random samples
#'
#' @param seed
#' Integer containing the seed.
#'
#' @details
#' To generate random samples, the grades (from the grade and tonnage
#' model) are
#' transformed with the isometric log-ratio transform (Pawlowsky-Glahn, and
#' others, 2015, p. 37).
#' If the item \code{pdfType} within \code{object} is \code{kde}, then
#' a kernel density estimate
#' of the ilr-transformed grades is used to
#' generate ilr-transformed random samples
#' (Duong, 2007; Hastie and others, 2009, p. 208-209;
#' Shalizi, 2016, p. 308-330).
#' In contrast, if the itme \code{pdfType} is \code{normal},
#' then a normal distribution is used to generate
#' ilr-transformed random samples.
#'
#' The ilr-transformed random samples are converted to random samples of
#' grade with the inverse ilr-transform.
#'
#' @return Matrix containing random samples from the pdf that represents
#' the grades for one undiscovered deposit in the permissive
#' tract.
#'
#' @references
#' Duong, Tarn, 2007, ks - Kernel density estimation and kernel discriminant
#' analysis for multivariate data in R: Journal of Statistical Software,
#' v. 21, issue 7, \url{http://www.jstatsoft.org/}
#'
#' Hastie, Tevor, Tibshirani, Robert, and Friedman, Jerome, 2009,
#' The elements of statistical learning - Data mining, inference, and
#' prediction (2nd ed.): New York, Springer Science + Business Media, LLC, 745 p.
#'
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' @examples
#' gradePdf1 <- GradePdf1(ExampleGatm)
#' rs <- getRandomSamples(gradePdf1, 2518)
#'
#' @export
#'
getRandomSamples.GradePdf <- function(object, nSamples, seed = NULL) {

  # The number of random samples that are generated is 3 * nSamples because,
  # if the random samples are truncated, then there will be enough remaining
  # so that nSamples random samples can be returned.

  N <- 3 * nSamples

  set.seed(seed)

  ilrBase <- compositions::ilrBase(D = ncol(object$grades))
  tGrades <- compositions::ilr(object$grades, V = ilrBase)

  if(object$pdfType == "kde") {
    indices <- sample( 1:nrow(tGrades), N, replace=TRUE )

    # For each element of indices, a random sample could be drawn. However,
    # this results in very slow code. Instead, determine the unique indices
    # (uniqueIndices) and the number of occurrences for each unique index
    # (counts). Then for uniqueIndices[i], draw counts[i] random samples.
    tmp <- table(indices)
    uniqueIndices <- as.integer(names(tmp))
    counts <- as.vector(tmp, mode = "integer")

    if(ncol(tGrades) > 1){
      theCov <- as.matrix(ks::Hpi(x = tGrades))
    } else {
      theCov <- as.matrix(ks::hpi(x = as.vector(tGrades)))
    }

    rsTGrades <- NULL
    for(i in seq_along(uniqueIndices)) {
      index <- uniqueIndices[i]
      rs <- mvtnorm::rmvnorm( counts[i],
                              mean = tGrades[index, , drop = FALSE],
                              sigma = theCov)
      rsTGrades <- rbind(rsTGrades, rs)
    }

    # Make the draws random
    rsTGrades <- rsTGrades[sample.int(N, size = N), , drop = FALSE]

  } else {
    rsTGrades <- mvtnorm::rmvnorm(N, mean = colMeans(tGrades),
                                  sigma = cov(tGrades))
  }

  rs <- unclass(compositions::ilrInv(rsTGrades, V = ilrBase))
  colnames(rs) <- colnames(object$grades)

  if(object$isTruncated == TRUE){
    areWithinBnds <- rep.int(TRUE, N)
    for(j in 1:ncol(object$grades)) {
      theRange <- range(object$grades[, j])
      areWithinBnds <- areWithinBnds &
        theRange[1] <= rs[, j] & rs[, j] <= theRange[2]
    }
    rs <- rs[areWithinBnds, , drop = FALSE]
  }

  rs <- rs[1:nSamples, , drop = FALSE]


  return(rs)

}

#' @title Plot the histogram and the cdf for each log-ratio of grades
#'
#' @description Plot the histogram and the
#' cumulative distribution function (cdf) for each log-ratio of the grades.
#' The grades are derived from the joint pdf that represents them.
#' Beneath each histogram are the log-ratios calculated from the grade and
#' tonnage model. Included with each cdf is the
#' empirical cumulative distribution function (ecdf)
#' for the log-ratios calculated from the grade and tonnage model.
#'
#' @param object
#' An object of class "GradePdf".
#'
#' @param isUsgsStyle
#' Make the plot format similar to the U.S. Geological Survey style
#'
#' @details
#' In the cdf, the solid black line represent the cdf, and the red dots
#' represent the ecdf.
#'
#' @references
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' @examples
#' gradePdf <- GradePdf(ExampleGatm)
#' plot(gradePdf)
#'
#' @export
#'
plot.GradePdf <- function(object, isUsgsStyle = TRUE, labelSize=12) {

  # If there are too many random samples, subset them.
  if(nrow(object$rs) > 10000) {
    df.rs <- as.data.frame(object$rs[1:10000, ])
  } else {
    df.rs <- as.data.frame(object$rs)
  }

  df.obs <- as.data.frame(object$grades)

  gradeNames <- colnames(object$grades)
  N <- length(gradeNames)

  gen_xLabel <- function(material1, material2, isUsgsStyle){
    tmp <- paste("Log ratio of ", material1, " and ", material2, sep = "")
    if(isUsgsStyle){
      xLabel <- paste(tmp, ", no units",  sep = "")
    } else {
      xLabel <- paste(tmp, " (no units)",  sep = "")
    }
    return(xLabel)
  }

  count_upper <- 1
  count_lower <- N * (N - 1) / 2 + 1

  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout=grid::grid.layout(N,N)))

  for (i in 1:N) {
    for(j in 1:N) {

      if(i == j) next

      if (i > j) {
        # lower triangle

        df.rs.lr <- data.frame(lr = log(df.rs[, j] / df.rs[, i]))
        df.obs.lr <- data.frame(lr = log(df.obs[, j] / df.obs[, i]))

        xLabel <- gen_xLabel(gradeNames[j], gradeNames[i], isUsgsStyle)

        p <- ggplot2::ggplot() +
          ggplot2::stat_ecdf(ggplot2::aes(x = lr),
                             data = df.obs.lr,
                             pad = FALSE,
                             geom = "point", colour = "red") +
          ggplot2::stat_ecdf(ggplot2::aes(x = lr),
                             data = df.rs.lr,
                             pad = FALSE, geom = "step") +
          ggplot2::scale_x_continuous(name = xLabel) +
          ggplot2::ylab("Probability")

        figLabel_index <- count_lower
        count_lower <- count_lower + 1

      } else {
        # upper triangle

        df.rs.lr <- data.frame(lr = log(df.rs[, i] / df.rs[, j]))
        df.obs.lr <- data.frame(lr = log(df.obs[, i] / df.obs[, j]))

        xLabel <- gen_xLabel(gradeNames[i], gradeNames[j], isUsgsStyle)

        p <- ggplot2::ggplot() +
          ggplot2::geom_histogram(ggplot2::aes(x = lr, y = ..density..),
                                data = df.rs.lr) +
          ggplot2::geom_rug(ggplot2::aes(x = lr),
                            data = df.obs.lr, colour = "red") +
          ggplot2::scale_x_continuous(name = xLabel) +
          ggplot2::ylab("Density")

        figLabel_index <- count_upper
        count_upper <- count_upper + 1

      }

      if(isUsgsStyle) {
        p <- p + ggplot2::theme_bw()
      }

      p <- p + ggplot2::theme(axis.text = ggplot2::element_text(size = labelSize),
                              axis.title = ggplot2::element_text(size = labelSize))

        if(isUsgsStyle) {
          figLabel <- paste(LETTERS[figLabel_index], ".", sep = "" )
          p <- p + ggplot2::ggtitle(figLabel) +
            ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                              face = "italic",
                                                              size = labelSize))
        } else {
          figLabel <- paste( "(", letters[figLabel_index], ")", sep = "")
          p <- p + ggplot2::ggtitle(figLabel) +
            ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                              size = labelSize))
        }

      print(p, vp=grid::viewport(layout.pos.row=i, layout.pos.col=j))
    }
  }
}


#' @title Summary comparison of the pdf that represents the grades
#' and the grades from the grade and tonnage model
#'
#' @description Using summary statistics, this function compares
#' the probability density function (pdf) that represents the grades
#' to the grades from the grade and tonnage model.
#' The summary statistics are various quantiles,
#' the compositional mean and the variation matrix.
#'
#' @param object
#' An object of class "GradePdf"
#'
#' @param nDigits
#' Number of signficant digits.
#'
#' @details
#' Corresponding minimum and maximum statistics might differ a lot,
#' if the pdf is not truncated (see function GradePdf1).
#'
#' @references
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' @examples
#' gradePdf <- GradePdf(ExampleGatm)
#' summary(gradePdf)
#'
#' @export
#'
summary.GradePdf <- function(object, nDigits = 3) {

  PrintStats <- function(gatm, pdf, nDigits, convertToPercent = TRUE){

    df <- data.frame(Gatm = quantile(gatm, probs = c(0, 0.25, 0.50, 0.75, 1),
                                       names = FALSE),
                     Pdf = quantile(pdf, probs = c(0, 0.25, 0.50, 0.75, 1),
                                      names = FALSE))
    row.names(df) <- c("Minimum", "0.25 quantile", "Median",
                       "0.75 quantile", "Maximum")
    if(convertToPercent == TRUE){
      df <- df * 100
    }
    print(signif(df, digits = nDigits))
  }

  cat(sprintf("Summary comparison of the pdf representing the grades\n"))
  cat(sprintf("and the actual grades in the grade and tonnage model.\n"))
  cat(sprintf("------------------------------------------------------------\n"))
  cat( sprintf( "Pdf type: %s\n", object$pdfType ))
  if(object$isTruncated) {
    cat( sprintf("Pdf is truncated at the lowest and the highest values\n"))
    cat( sprintf("of the grades in the grade and tonnage model.\n"))
  } else {
    cat( sprintf("Pdf is not truncated.\n"))
  }
  cat( sprintf( "Number of discovered deposits in the grade and tonnage model: %d\n",
                nrow(object$gatm) ))
  cat( sprintf( "Number of resources: %d\n", length(object$resourceNames) ))

  cat(sprintf("------------------------------------------------------------\n"))
  cat(sprintf( "Quantiles (reported in percent)\n"))
  cat(sprintf( "Column Gatm refers to the actual grades from the grade and\n"))
  cat(sprintf( "model; column Pdf refers to the pdf representing the grades.\n"))

  N <- ncol(object$grade)
  for(i in 1:N) {
    cat( sprintf( "Component: %s\n", colnames(object$grade)[i] ))
    PrintStats(object$grade[, i], object$rs[, i], nDigits, convertToPercent = TRUE)
    cat(sprintf("\n"))
  }

  cat(sprintf("------------------------------------------------------------\n"))

  cat(sprintf( "Compositional mean (reported in percent)\n"))
  cat(sprintf( "Column Gatm refers to the actual grades from the grade and\n"))
  cat(sprintf( "model; column Pdf refers to the pdf representing the grades.\n"))
  df <- data.frame(Gatm = unclass(object$theGatmMean),
                   Pdf = unclass(object$theMean))
  df <- df * 100
  print(signif(df, digits = nDigits))

  cat(sprintf("------------------------------------------------------------\n"))

  cat( sprintf( "Composite variation matrix\n"))
  tmp <- object$theGatmVar
  tmp[lower.tri(tmp)] <- object$theVar[lower.tri(object$theVar)]

  print(signif(tmp, digits = nDigits))

  cat(sprintf("\n\n"))
  cat(sprintf("Explanation\n"))
  cat(sprintf("The composite variation matrix has two parts: its upper\n"))
  cat(sprintf("triangle and its lower triangle. The upper triangle is\n"))
  cat(sprintf("the upper triangle of the variation matrix for the actual\n"))
  cat(sprintf("grades in the grade and tonnage model. The lower triangle\n" ))
  cat(sprintf("is the lower triangle of the variation matrix for the\n"))
  cat(sprintf("pdf that the represents the grades. Thus, corresponding \n"))
  cat(sprintf("elements in the upper and lower triangles should be\n"))
  cat(sprintf("compared to one another.\n"))

  cat( sprintf( "\n###############################################################\n"))
  cat(sprintf("\n\n\n\n"))
}


#' @title Construct the pdf that represents the resource grades
#'
#' @description Construct the probability density function (pdf) that
#' represents the resource grades.
#' The pdf is not explicitly specified; instead it is implicitly
#' specified with the random samples that are generated from it.
#'
#' @param gatm
#' Dataframe containing the grade and tonnage model (gatm). (See details.)
#'
#' @param pdfType
#' Character string containing the type of pdf for the grades.
#' The choices are either "kde" or "normal".
#'
#' @param isTruncated
#' Logical variable indicating whether the pdf is
#' truncated at the lowest and highest values of the grades in the grade
#' and tonnage model.
#'
#' @param minNDeposits
#' Minimum number of deposits in the grade and tonnage model.
#'
#' @param nRandomSamples
#' Number of random samples used to compute summary statistics.
#' It should be a large value
#' to ensure that the summary statistics are precise.
#'
#' @param seed
#' Seed for the random number generator.
#'
#' @details
#' Data frame gatm comprises the ore tonnages and the grades for the
#' deposits listed in the grade and tonnage model.
#' Each row comprises the data for one deposit.
#' The first column lists a unique identifier for each deposit.
#' The second column lists the names of the deposits.
#' The third column lists the ore tonnage.
#' The fourth and subsequent columns, if any, list
#' the grades for the resources. The grades are specified in percent.
#' Grades must not be missing, must be greater than zero, and less than 100.
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
#' If the \code{pdfType} is \code{kde}, then
#' a multivariate kernel density estimate
#' of the ilr-transformed grades is used to
#' generate ilr-transformed random samples
#' (Duong, 2007; Hastie and others, 2009, p. 208-209;
#' Shalizi, 2016, p. 308-330). (ilr refers to isometric log-ratio
#' transformation (Pawlowsky-Glahn and others, 2015, p. 37).)
#' In contrast, if the \code{pdfType} is \code{normal},
#' then a multivariate normal distribution is used to generate
#' ilr-transformed random samples. For both cases,
#' the ilr-transformed random samples are converted to random samples of
#' grade with the inverse ilr transformation.
#'
#' @return A list with the following components is returned.
#' @return \item{gatm}{Input argument gatm.}
#' @return \item{seed}{Input argument seed.}
#' @return \item{pdfType}{Input argument pdfType.}
#' @return \item{isTruncated}{Input argument isTruncated.}
#' @return \item{grades}{Grades from the gatm that have been scaled to be
#' between 0 and 1. The grade of the gangue has been appended.}
#' @return \item{resourceNames}{Names of the resources.}
#' @return \item{theGatmMean}{Compositional mean for the grades.}
#' @return \item{theGatmVar}{Variation matrix for the grades.}
#' @return \item{rs}{Random samples of the pdf.}
#' @return \item{theMean}{Compositional mean for the pdf.}
#' @return \item{theVar}{Variation matrix for the pdf.}
#' @return \item{call}{Function call.}
#'
#' @references
#' Duong, Tarn, 2007, ks - Kernel density estimation and kernel discriminant
#' analysis for multivariate data in R: Journal of Statistical Software,
#' v. 21, issue 7, \url{http://www.jstatsoft.org/}
#'
#' Hastie, Tevor, Tibshirani, Robert, and Friedman, Jerome, 2009,
#' The elements of statistical learning - Data mining, inference, and
#' prediction (2nd ed.): New York, Springer Science + Business Media, LLC, 745 p.
#'
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' @examples
#' gradePdf1 <- GradePdf1(ExampleGatm)
#'
#' @export
#'
GradePdf <- function(gatm,
                     seed = NULL,
                     pdfType = "normal",
                     isTruncated = FALSE,
                     minNDeposits = 20,
                     nRandomSamples = 1000000) {

  CheckModel(gatm, minNDeposits)

  if(!any(pdfType == c("kde", "normal"))) {
    stop( sprintf( "Function GradePdf\n" ),
          sprintf( "Argument type must be either kde or normal.\n"),
          sprintf( "It is specified as %s\n", pdfType),
          call. = FALSE )
  }

  # Let the number of grades be D-1. Including the gangue, the dimension of
  # the simplex is D. After the ilr transformation, the number of ilr
  # coordinates is D-1.
  #
  # Because the kernel density estimate, kde, has a maximum of 6 dimensions,
  # the maximum number of ilr coordinates is 6. Thus the maximum number of
  # grades is 6.
  #
  # The first three columns of the grade and tonnage model (which is stored
  # in containter gatm) are not grades; the subsequent columns the grades. Thus,
  # the maximum number of columns is 9.
  if(pdfType == "kde" && ncol(gatm) > 9) {
    stop( sprintf( "Function GradePdf\n" ),
          sprintf( "When the pdf type is kde, the maximum number of grades\n"),
          sprintf( "is 6. There are %3d in the grade and tonnage model.\n",
                   ncol(gatm) - 3),
          call. = FALSE )
  }

  resourceNames = colnames(gatm[, -(1:3), drop = FALSE])

  # Grades on the scale from 0 to 1
  tmp <- gatm[, -(1:3), drop = FALSE] / 100  # convert from percentages
  grades <- cbind(tmp, 1 - rowSums(tmp))
  colnames(grades) <- c(resourceNames, "gangue")

  rval <- list( gatm = gatm,
                pdfType = pdfType,
                isTruncated = isTruncated,
                grades = grades,
                resourceNames = resourceNames,
                theGatmMean = mean(compositions::acomp(grades), robust = FALSE),
                theGatmVar = compositions::variation(compositions::acomp(grades),
                                                     robust = FALSE))

  class(rval) <- "GradePdf"

  rval$rs <- getRandomSamples(rval, nRandomSamples, seed = seed)
  rval$theMean <- mean(compositions::acomp(rval$rs), robust = FALSE)
  rval$theVar <- compositions::variation(compositions::acomp(rval$rs),
                                         robust = FALSE)
  rval$call <- sys.call()

  return(rval)
}