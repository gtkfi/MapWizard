#' @title Plot the univariate, marginal pdfs and ccdfs for the
#' total ore and resource tonnages in
#' all undiscovered deposits within the permissive tract
#'
#' @description Plot the unvariate, marginal probability density
#' functions (pdfs) and complementary cumulative distribution functions
#' (ccdfs)
#' for the total ore and resource tonnages in all undiscovered
#' deposits within the permissive tract.
#'
#' @param object
#' An object of class "TotalTonnagePdf".
#'
#' @param adjust
#' Smoothing used to calculate the pdfs.
#'
#' @param isUsgsStyle
#' Make the plot format similar to the U.S. Geological Survey style
#'
#' @details
#' Argument adjust is scaling applied to the bandwidth of the kernel density
#' estimate, which is calculated with R function density. As adjust increases,
#' the pdf becomes smoother.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oSimulation <- Simulation(oPmf, oTonPdf, oGradePdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf, oGradePdf)
#' plot(oTotalTonPdf)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oSimulation <- Simulation(oPmf, oTonPdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf)
#' plot(oTotalTonPdf)
#'
#' @export
#'
plot.TotalTonnagePdf <- function(object, adjust = 2, isUsgsStyle = TRUE, labelSize=12) {

  if(isUsgsStyle) {
    xLabel <- "Total tonnage, in metric tons"
  } else {
    xLabel <- "Total tonnage (mt)"
  }

  nPdfs <- ncol( object$rs )
  nSamples <- nrow( object$rs )
  countZeros <- unname(colSums(object$rs == 0))

  # pdf

  rsTonnage1 <- object$rs
  rsTonnage1[rsTonnage1 == 0] <- NA
  rsLogTonnage <- log10(rsTonnage1)

  probZero <- countZeros[1] / nSamples

  theRange <- range(rsLogTonnage, na.rm = TRUE)
  margin <- 0.05 * diff(theRange)
  theRange[1] <- theRange[1] - margin
  theRange[2] <- theRange[2] + margin

  df <- data.frame()
  for( j in 1:nPdfs ) {

    tmp1 <- density( rsLogTonnage[, j],
                    from = theRange[1], to = theRange[2], na.rm = TRUE)

    tmp2 <- data.frame( Material = rep.int(colnames(rsTonnage1)[j], length(tmp1$y)),
                        Tonnage = 10^tmp1$x,
                        Density = tmp1$y * ( 1 - probZero ))
    df <- rbind(df, tmp2)
  }

  caption <- paste( "Prob of zero tonnage = ",
                     round(probZero, digits=3), sep="" )

  p <- ggplot2::ggplot(df) +
    ggplot2::geom_line(ggplot2::aes(x = Tonnage, y = Density, colour = Material)) +
    ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
    ggplot2::geom_text(ggplot2::aes(x, y, label = caption),
                       data = data.frame(x = min(df$Tonnage), y = 0),
                       hjust = 0, vjust = 1, size = 2.5)

  if(isUsgsStyle) {
    p <- p + ggplot2::theme_bw()+
      ggplot2::ggtitle("A.") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                        face = "italic"))
  } else {
    p <- p + ggplot2::ggtitle("(a)") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0))
  }

  # ccdf

  df2 <- data.frame()
  for( j in 1:nPdfs ) {

    x <- object$rs[, j]
    y <- 1.0 - ecdf(x)(x)

    areZero <- x == 0
    x <- x[!areZero]
    y <- y[!areZero]

    tmp <- data.frame( Material = rep.int(colnames(object$rs)[j], length(y)),
                      Tonnage = x,
                      Probability = y)
    df2 <- rbind(df2, tmp)
  }

  q <- ggplot2::ggplot(df2) +
    ggplot2::geom_hline(yintercept = 1-probZero, colour = "gray65") +
    ggplot2::geom_line(ggplot2::aes(x = Tonnage, y = Probability, colour = Material)) +
    ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
    ggplot2::scale_y_continuous(limits = c(0,1))

  if(isUsgsStyle) {
    q <- q + ggplot2::theme_bw()+
      ggplot2::ggtitle("B.") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                        face = "italic"))
  } else {
    q <- q + ggplot2::ggtitle("(b)") +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0))
  }

    p <- p + ggplot2::theme(axis.text = ggplot2::element_text(size = labelSize),
                            axis.title = ggplot2::element_text(size = labelSize))
	q <- q + ggplot2::theme(axis.text = ggplot2::element_text(size = labelSize),
	axis.title = ggplot2::element_text(size = labelSize))

  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
  plot(p, vp=grid::viewport(layout.pos.row=1, layout.pos.col=1))
  plot(q, vp=grid::viewport(layout.pos.row=1, layout.pos.col=2))

}

#' @title Plot the marginal distributions for the
#' total ore and resource tonnages in all undiscovered deposits
#' within the permissive tract
#'
#' @description Plot the univariate and bivariate marginal distributions,
#' for the total ore and resource tonnages
#' in all undiscovered deposit within the permssive tract.
#'
#' @param object
#' An object of class "TotalTonnagePdf".
#'
#' @param nPlotSamples
#' Number of samples that represent the pdf in the plots.
#'
#' @param isUsgsStyle
#' Make the plot format similar to the U.S. Geological Survey style
#'
#' @details
#' The plot is a matrix with three parts: the plots in the upper triangle,
#' the plots along the diagonal, and the plots in the lower triangle. In the
#' upper triangle are crossplots of the ore and resource tonnages, showing the
#' bivariate marginal distributions. Along the diagonal are histograms,
#' showing the univariate marginal distributions.
#' In the lower triangle are contour plots, showing the bivariate marginal
#' distributions. The plots in the lower triangle have corresponding plots
#' in the upper triangle.
#'
#' Above the matrix of plots is text specifying the probability that
#' the tonnages are zero.
#'
#' Recall that the pdf is implicitly specified by random samples. Consequently,
#' the plots are generated from \code{nPlotSamples} random
#' samples. A suitable value for parameter \code{nPlotSamples} is
#' approximately 1000.
#'
#' If a tonnage model is used for the assessment, then there is only one
#' tonnage, which is contained metal tonnage. In this case, there
#' is only one plot in the matrix, which is the histogram for the
#' contained metal tonnage.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oSimulation <- Simulation(oPmf, oTonPdf, oGradePdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf, oGradePdf)
#' plotMarginals(oTotalTonPdf)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oSimulation <- Simulation(oPmf, oTonPdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf)
#' plotMarginals(oTotalTonPdf)
#'
#' @export
#'
plotMarginals <- function(object, nPlotSamples = 1000,
                                    isUsgsStyle = TRUE, labelSize=12) {

  areZero <- object$rs[, 1] == 0
  probZero <- sum(areZero) / nrow(object$rs)

  tmp <- object$rs[!areZero, , drop = FALSE]
  d <- as.data.frame(tmp[1:nPlotSamples, , drop = FALSE])
  N <- ncol(d)

  if(isUsgsStyle) {
    tLabel <- "tonnage, in metric tons"
  } else {
    tLabel <- "tonnage (mt)"
  }

  caption <- paste( "Probability of zero tonnage = ",
                    round(probZero, digits=3), sep="" )

  grid::grid.newpage()
  grid::pushViewport(
    grid::viewport(
      layout =
        grid::grid.layout(N+1, N,
                          heights =
                            grid::unit(rep.int(1,N+1),
                                       c("lines", rep.int("null",N))))))

  grid::grid.text(caption, gp = grid::gpar(fontsize = 10),
                  vp = grid::viewport(layout.pos.row = 1,
                                      layout.pos.col = NULL))

  for (i in 1:N) {
    for(j in 1:N) {
      if(i == j) {
        # diagonal
        matName <- colnames(d)[i]
        p <- ggplot2::ggplot() +
          ggplot2::geom_histogram(ggplot2::aes_string(x = matName, y = "..density.."),
                                  data = d, bins = 15, colour = "white",
                                  fill = "gray45") +
          ggplot2::scale_x_continuous(name = paste( "Total", matName, tLabel, sep = " "),
                                      trans = "log10") +
          ggplot2::scale_y_continuous(name = "Density")
      } else if (j < i) {
        # lower triangle
        xMatName <- colnames(d)[j]
        yMatName <- colnames(d)[i]
        p <- ggplot2::ggplot() +
          ggplot2::geom_density_2d(
            ggplot2::aes_string(x = xMatName, y = yMatName), data = d,
            colour = "black") +
          ggplot2::scale_x_continuous(
            name = paste("Total", xMatName, tLabel, sep = " "), trans = "log10") +
          ggplot2::scale_y_continuous(
            name = paste("Total", yMatName, tLabel, sep = " "), trans = "log10")

      } else {
        # upper triangle
        xMatName <- colnames(d)[j]
        yMatName <- colnames(d)[i]
        p <- ggplot2::ggplot() +
          ggplot2::geom_point(ggplot2::aes_string(x = xMatName, y = yMatName),
                              data = d, colour = "black", shape = ".") +
          ggplot2::scale_x_continuous(
            name = paste("Total", xMatName, tLabel, sep = " "), trans = "log10") +
          ggplot2::scale_y_continuous(
            name = paste("Total", yMatName, tLabel, sep = " "), trans = "log10")

      }

      if(isUsgsStyle) {
        p <- p + ggplot2::theme_bw()
      }

      p <- p + ggplot2::theme(axis.title = ggplot2::element_text(size = labelSize),
                              axis.text = ggplot2::element_text(size = labelSize))

      if(N > 1){
        index <- (i - 1) * N + j

        if(isUsgsStyle) {
          figLabel <- paste(LETTERS[index], ".", sep = "" )
          p <- p + ggplot2::ggtitle(figLabel) +
            ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                              face = "italic",
                                                              size = labelSize))
        } else {
          figLabel <- paste( "(", letters[index], ")", sep = "")
          p <- p + ggplot2::ggtitle(figLabel) +
            ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                              size = labelSize))
        }
      }

      print(p, vp=grid::viewport(layout.pos.row=i+1, layout.pos.col=j))
    }
  }
}


#' @title Summarize the total ore and resource
#' tonnages in all undiscovered deposits within the permissive tract
#'
#' @description The summary has two parts. The first part comprises point
#' statistics for the univariate, marginal probability density
#' functions (pdfs) for the
#' total ore and resource tonnages in all undiscovered deposits within the
#' permissive
#' tract. The second part is a comparison between sets of statistics. One
#' set is calculated from
#' the multivariate pdf that represents the ore and resourc tonnages. The
#' other set is calculated with analytic formulas.
#'
#' @param object
#' An object of class "TotalTonnagePdf"
#'
#' @param nDigits
#' Number of signficant digits.
#'
#' @details
#' The point statistics are the
#' 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, and 0.95 quantiles,
#' the arithmetic mean, the probability of zero tonnage,
#' and the probability of exceeding the arithmetic mean.
#'
#' The statistics used for the comparison are the mean vector, the
#' standard deviation vector, and the correlation coefficients.
#' Differences between
#' corresponding statistics are common but should be small.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oSimulation <- Simulation(oPmf, oTonPdf, oGradePdf)
#' oTotalTonPdf <- TonnagePtPdf(oSimulation, oPmf, oTonPdf, oGradePdf)
#' summary(oTotalTonPdf)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oSimulation <- Simulation(oPmf, oTonPdf)
#' oTotalTonPdf <- TonnagePtPdf(oSimulation, oPmf, oTonPdf)
#' summary(oTotalTonPdf)
#'
#' @export
#'
summary.TotalTonnagePdf <- function(object, nDigits = 3) {

  CalcTonnageStats <- function( rs )
  {
    probs <- c(0.05,0.10,0.25,0.50,0.75,0.90,0.95)
    labels <- c( paste( "Q_", probs, sep = ""), "Mean", "P(0)", "P(>Mean)" )

    if ( missing( rs ) )
      return( labels )

    quantiles <- quantile( rs, probs, na.rm = TRUE, names = FALSE )
    theMean <- mean( rs )
    p0 <- sum( rs == 0 ) / length( rs )
    p.exceed.mean <- sum( rs > theMean ) / length( rs )

    statistics <- c( quantiles, theMean, p0, p.exceed.mean )
    names( statistics ) <- labels
	options(width=1000)
    return( statistics )

  }

  cat(sprintf("Summary of the pdf for the total ore and resource tonnages in\n"))
  cat(sprintf("all undiscovered deposits within the permissive tract.\n"))
  cat(sprintf("------------------------------------------------------------\n"))

  theNames <- colnames(object$rs)
  nRowsInTable <- length(theNames)

  statTable <- matrix( NA, nrow = nRowsInTable,
                       ncol = length( CalcTonnageStats() ) )

  dimnames(statTable) <- list( theNames, CalcTonnageStats() )

  for ( name in theNames )
    statTable[name,] <- signif( CalcTonnageStats( object$rs[ ,name] ),
                                digits = nDigits )
  cat(sprintf("\n\n"))
  print(statTable)

  cat(sprintf("\n\n"))
  cat(sprintf("Explanation\n"))
  cat(sprintf("\"Q_0.05\" is the 0.05 quantile, \"Q_0.1\" is the 0.1 quantile, and so on.\n"))
  cat(sprintf("\"Mean\" is the arithmetic mean. \"P(0)\" is probability of zero tonnage.\n"))
  cat(sprintf("\"P(>Mean)\" is probability that the tonnage exceeds the arithmetic mean.\n"))
  cat(sprintf("\n"))

  cat(sprintf("------------------------------------------------------------\n"))
  cat(sprintf("Comparison between statistics estimated from the multivariate\n"))
  cat(sprintf("pdf and statistics from analytic formulas.\n\n"))

  cat(sprintf("Mean vectors\n"))
  df <- data.frame(Pdf = object$theMean, Formula = object$thePredMean)
  print(signif(df, digits = nDigits))
  cat(sprintf("\n"))

  cat(sprintf("Standard deviation vectors\n"))
  df <- data.frame(Pdf = object$theSd, Formula = object$thePredSd)
  print(signif(df, digits = nDigits))
  cat(sprintf("\n"))

  if(ncol(object$theCorr) > 1){
    cat(sprintf("Composite correlation matrix\n" ))
    tmp <- object$theCorr
    tmp[lower.tri(tmp)] <- object$thePredCorr[lower.tri(object$thePredCorr)]
    diag(tmp) <- NA
    print(signif(tmp, digits = nDigits))

    cat(sprintf("\nExplanation\n" ))
    cat(sprintf("1. The upper triangle of the composite correlation matrix\n"))
    cat(sprintf("is the upper triangle of the correlation matrix that is\n" ))
    cat(sprintf("estimated from the pdf.\n" ))
    cat(sprintf("2. The lower triangle of the composite correlation matrix\n" ))
    cat(sprintf("is the lower triangle of the correlation matrix that is\n"))
    cat(sprintf("calculated with analytic formulas.\n"))

  } else {
    cat(sprintf("There is only one material, presumably because a\n"))
    cat(sprintf("tonnage model is used for the assessment. Consequently,\n"))
    cat(sprintf("the correlation matrix is irrelevant. So, the composite\n"))
    cat(sprintf("correlation matrix is not printed.\n"))
  }

  cat( sprintf( "\n###############################################################\n"))
  cat(sprintf("\n\n\n\n"))

}


#' @title Construct the pdf for the total ore and resource tonnages in
#' all undiscovered deposits within the permissive tract
#'
#' @description Construct the probability density function (pdf) for the
#' total ore and resource tonnages in all undiscovered deposits within
#' the permissive
#' tract. The pdf is not explicitly specified; instead it is implicitly
#' specified with the random samples.
#'
#' @param oSimulation
#' An object of class "Simulation"
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
#' @details
#' The pdf is constructed from the simulated deposits that are stored in
#' oSimulation.
#'
#' In addition to constructing the pdf, its mean vector, its standard
#' deviation vector, and its correlation correlation matrix are calculated.
#' To check the pdf, a predicted mean vector, a predicted standard devation
#' vector, and a predicted correlation matrix are calculated with
#' analytic formulas.
#'
#' @return A list with the following components is returned.
#' @return \item{rs}{Matrix comprising the random samples of
#' the total ore and resource tonnages in all undiscovered deposits
#' in the permissive tract.}
#' @return \item{theMean}{Mean vector of the total tonnages.}
#' @return \item{theSd}{Standard deviation vector of the total tonnages.}
#' @return \item{theCorr}{Correlation matrix of the total tonnages.}
#' @return \item{thePredMean}{Predicted mean vector of the total tonnages.}
#' @return \item{thePredSd}{Predicted standard deviation vector of the
#' total tonnages.}
#' @return \item{thePredCorre}{Predicted correlation matrix of the total
#' tonnages.}
#' @return \item{call}{Function call}
#'
#' @references
#' Ellefsen, K.J., Phillips, J.D.,
#' 2017, Probability calculations for three-part mineral resource assessments,
#' U.S. Geological Survey Report Techniques and Methods XXXX, XX p.
#'
#' @examples
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleGatm)
#' oGradePdf <- GradePdf(ExampleGatm)
#' oSimulation <- Simulation(oPmf, oTonPdf, oGradePdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf, oGradePdf)
#'
#' oPmf <- NDepositsPmf("NegBinomial", list(nDepEst = ExampleDepEst4))
#' oTonPdf <- TonnagePdf(ExampleTm)
#' oSimulation <- Simulation(oPmf, oTonPdf)
#' oTotalTonPdf <- TotalTonnagePdf(oSimulation, oPmf, oTonPdf)
#'
#' @export
#'
TotalTonnagePdf <- function(oSimulation, oPmf, oTonPdf, oGradePdf,oTonGradePdf) {

  nCols <- ncol(oSimulation$deposits)
  if(nCols > 4) {
    # column 4 is the ore tonnage; columns > 4 are resource tonnages including
    # the gangue. The gangue is omitted.
    tonnages <- cbind(oSimulation$deposits[, 4, drop = FALSE],
                         oSimulation$deposits[, 4] *
                        oSimulation$deposits[, 5:(nCols-1), drop = FALSE])
  } else {
    # column 4 is the contained metal tonnage
    tonnages <- oSimulation$deposits[, 4, drop = FALSE]
  }

# The last simulation index in oSimulation is the number of simulations
  nSimulations <- tail(oSimulation$deposits[, "Simulation Index"], n = 1)

  totalTonnages <- matrix(0, nrow = nSimulations, ncol = ncol(tonnages))
  colnames(totalTonnages) <- colnames(tonnages)

  rowIndex <- 1
  simIndex <- 1
# Compute total tonnages for each simulation
  while(simIndex <= nSimulations){
    N <- oSimulation$deposits[rowIndex, "Number of Deposits"]
    if(N == 0){
      totalTonnages[simIndex, ] <- 0
      rowIndex <- rowIndex + 1
    } else if(N == 1){
      totalTonnages[simIndex, ] <- tonnages[rowIndex, ]
      rowIndex <- rowIndex + 1
    } else{
      rowIndices <- rowIndex:(rowIndex + N - 1)
      totalTonnages[simIndex, ] <- colSums(tonnages[rowIndices, , drop = FALSE])
      rowIndex <- rowIndex + N
    }
    simIndex <- simIndex + 1
  }

  # Generate random samples of the total ore and resource tonnages
  if(!missing(oTonGradePdf)){
    # omit the gangue
    rs <- cbind(oTonGradePdf$rs[,1], oTonGradePdf$rs[,1] * oTonGradePdf$rs[,c(-1,-ncol(oTonGradePdf$rs)), drop = FALSE])
  } else {
    if(!missing(oGradePdf)){
      # omit the gangue
      rs <- cbind(oTonPdf$rs, oTonPdf$rs * oGradePdf$rs[, -ncol(oGradePdf$rs), drop = FALSE])
    } else {
      rs <- as.matrix(oTonPdf$rs, ncol = 1)
    }
    colnames(rs)[1] <- oTonPdf$matName
  }
  

  # mean ore and resource tonnage
  mu <- colMeans(rs)

  thePredVar <- oPmf$theMean * cov(rs) + oPmf$theVar * (mu %o% mu)

  rval <- list( rs = totalTonnages,
                theMean = colMeans(totalTonnages),
                theSd = apply(totalTonnages, 2, sd),
                theCorr = cor(totalTonnages),
                thePredMean = oPmf$theMean * mu,
                thePredSd = sqrt(diag(thePredVar)),
                thePredCorr = cov2cor(thePredVar),
                call=sys.call() )

  class(rval) <- "TotalTonnagePdf"
  return(rval)
}