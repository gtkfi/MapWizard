#' @title Generate random samples from the a joint pdf that represents the
#' total tonnage and grades
#'
#' @description Generate random samples from the joint probability density function
#' (pdf) that represents the total tonnage and grades, when there is correlation between
#' total tonnage and grade of each resource.
#'
#' @param object
#' An object of class "TonGradePdf"
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
#' others, 2015, p. 37). Tonnages are log10 transformed.
#' Smoothing kernel for the multivariate joint distribution of the ilr
#' transformed grades and log10 tonnages is computed using the multivariate
#' generalization of the univariate plug-in selector of Wand and Jones (1994)
#' The ilr and log10 transformed random samples are converted to random
#' samples of tonnage and grade for the returned object rval.
#'
#' @return Matrix containing random samples from the pdf that represents
#' the total tonnage grades for one undiscovered deposit in the permissive
#' tract.
#'
#' @references
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' Wand M. and Jones M., 1994, Multivariate plugin bandwidth selection,
#' Computational Statistics, 9, 97 p.
#' 
#' @examples
#' TGpdf <- TonGradePdf(ExampleGatm)
#' rs <- getRandomSamples(TGpdf, 2518)
#'
#' @export
#'
getRandomSamples.TonGradePdf <- function(object, nSamples, seed = NULL) {

  # The number of random samples that are generated is 3 * nSamples because,
  # if the random samples are truncated, then there will be enough remaining
  # so that nSamples random samples can be returned.

  N <- 3 * nSamples

  set.seed(seed)
  
  ##
  ## create the grade and tonnage model in the transformed domain
  ##
  ilrBase <- compositions::ilrBase(D = ncol(object$grades))
  tGrades <- compositions::ilr(object$grades, V = ilrBase)
  gatm_trans <- data.frame(log_tonnages = log10(object$gatm[,3]),ilr_grades = tGrades)
##
## construct the multivariate pdf that represents both the transformed grades and the
## transformed tonnages. The pdf is a kernel density estimate with optional truncation.
##
  if(object$pdfType=="kde")  {
    indices <- sample( 1:nrow(tGrades), N, replace=TRUE )
    tmp <- table(indices)
    uniqueIndices <- as.integer(names(tmp))
    counts <- as.vector(tmp, mode = "integer")
  
    theCov <- as.matrix(ks::Hpi(x = gatm_trans)) # plug-in bandwith for the multivariate distribution

    rs_t <- matrix(NA_real_, nrow = N, ncol = ncol(gatm_trans),
                   dimnames = list(NULL, colnames(gatm_trans)))
    current_index <- 1L
    for(i in seq_along(uniqueIndices)) {
      index <- uniqueIndices[i]
      rs_t[current_index:(current_index + counts[i] - 1), ] <- 
        mvtnorm::rmvnorm(counts[i],
                         mean = as.matrix(gatm_trans[index, ]),
                         sigma = theCov)
      current_index <- current_index + counts[i]
    }
    
  } else {
    rs_t <- mvtnorm::rmvnorm(N, mean = colMeans(gatm_trans),
                                  sigma = cov(gatm_trans))
  }
  
  # Make the draws random
  rs_t <- rs_t[sample.int(N, size = N), ]
  
  # truncate using the convex hull
  if (object$isTruncated==TRUE) {
    indicator <- geometry::inhulln(geometry::convhulln(gatm_trans),rs_t)
    rs_t <- rs_t[indicator == TRUE, ]
  }
  
  # convert back to grades and tonnages
  rs <- cbind(10^rs_t[,1],unclass(compositions::ilrInv(as.matrix(rs_t[,-1]), V = ilrBase)))

  colnames(rs) <- c(colnames(object$gatm)[3],colnames(object$grades))
  
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
#' An object of class "TonGradePdf".
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
#' TongradePdf <- TonGradePdf(ExampleGatm)
#' plot(TongradePdf)
#'
#' @export
#'
plot.TonGradePdf <- function(object, tg, isUsgsStyle = TRUE, labelSize=12) {

  # If there are too many random samples, subset them.
  if(nrow(object$rs) > 10000) {
    df.rs <- as.data.frame(object$rs[1:10000,])
  } else {
    df.rs <- as.data.frame(object$rs)
  }

  df.obs <- as.data.frame(cbind(object$gatm[,3],object$grades))
  colnames(df.obs)[1]<-colnames(object$gatm)[3]

  tongradeNames <- c(names(object$gatm)[3],colnames(object$grades))
  N_all <- length(tongradeNames)

  
  # Plot logratios of each grade as in GradePdf
  gen_xLabel <- function(material1, material2, isUsgsStyle) {
    tmp <- paste("Log ratio of ", material1, " and ", material2, sep = "")
    if(isUsgsStyle) {
      xLabel <- paste(tmp, ", no units",  sep = "")
    } else {
      xLabel <- paste(tmp, " (no units)",  sep = "")
    }
    return(xLabel)
  }
  if (tg=="grade") {
    N<-N_all
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
          xLabel <- gen_xLabel(tongradeNames[j], tongradeNames[i], isUsgsStyle)

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

          xLabel <- gen_xLabel(tongradeNames[i], tongradeNames[j], isUsgsStyle)

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
    
  } else if (tg=="tonnage") {
    
    # Plot tonnage
    if(isUsgsStyle) {
      xLabel <- paste(object$matName, " tonnage, in metric tons", sep = "")
    } else {
      xLabel <- paste(object$matName, " tonnage (mt)", sep = "")
    }
  
    caption <- paste("Tonnage deviance = ",
                     signif(object$devianceTon, digits = 3), sep = "")
  
    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
    p1 <- ggplot2::ggplot() +
          ggplot2::geom_histogram(ggplot2::aes_string(x = tongradeNames[1], y = "..density.."),
                                  data = df.rs, bins = 15,
                                  color = "white", fill = "gray45") +
          ggplot2::geom_rug(ggplot2::aes_string(x = tongradeNames[1]), data = df.obs, colour = "red") +
          ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
          ggplot2::ylab("Density")
  
    p2 <- ggplot2::ggplot() +
          ggplot2::stat_ecdf(ggplot2::aes_string(x =  tongradeNames[1]),
                             data = df.obs,
                             pad = FALSE,
                             geom = "point", colour = "red") +
          ggplot2::stat_ecdf(ggplot2::aes_string(x = tongradeNames[1]),
                             data = df.rs,
                             pad = FALSE, geom = "step") +
          ggplot2::scale_x_continuous(name = xLabel, trans = "log10") +
          ggplot2::ylab("Probability") +
          ggplot2::geom_text(ggplot2::aes(x, y, label = caption),
                             data = data.frame(x = exp(mean(log(df.obs[,1]))), y = 0),
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
    
    print(p1, vp=grid::viewport(layout.pos.row=1, layout.pos.col=1))
    print(p2, vp=grid::viewport(layout.pos.row=1, layout.pos.col=2))
    
  } else if (tg=="tongrade") {
    
  # Plot scatterplots pairwise for tonnage and all the grades
    count_upper <- 1
    count_lower <- N_all * (N_all - 1) / 2 + 1
  
    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout=grid::grid.layout(N_all,N_all)))
  
    for (i in 1:(N_all-1)) {
      for(j in (i+1):N_all) {
# Now only upper triangle filled
        # Uncomment the following rows if gangue is not to be logged. If the variation is very small
        # This is not relevant.
        df.rs.lg<-log(df.rs)
#        meanrs<-colMeans(df.rs)
#        print(meanrs)
#        df.rs.lg[,meanrs>0.85&meanrs<=1]<-df.rs[,meanrs>0.85&meanrs<=1]
        df.obs.lg<-log(df.obs)
#        df.obs.lg[,meanrs>0.85&meanrs<=1]<-df.obs[,meanrs>0.85&meanrs<=1]
        
        xLabel <- tongradeNames[i]
        yLabel <- tongradeNames[j]
        
        p3 <- ggplot2::ggplot() +
              ggplot2::geom_point(aes_string(x = tongradeNames[i], y = tongradeNames[j]),data = df.rs.lg, colour = "red") +
              ggplot2::geom_point(aes_string(x = tongradeNames[i], y = tongradeNames[j]),data = df.obs.lg, colour = "black") +
              ggplot2::scale_x_continuous(name = paste("Log(",xLabel,")")) +
              ggplot2::ylab(paste("Log(",yLabel,")"))
          
        figLabel_index <- count_lower
        count_lower <- count_lower + 1
        
        if(isUsgsStyle) {
          p3 <- p3 + ggplot2::theme_bw()
        }
        
        p3 <- p3 + ggplot2::theme(axis.text = ggplot2::element_text(size = labelSize),
                              axis.title = ggplot2::element_text(size = labelSize))
      
        if(isUsgsStyle) {
          figLabel <- paste(LETTERS[figLabel_index], ".", sep = "" )
          p3 <- p3 + ggplot2::ggtitle(figLabel) +
                ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                                  face = "italic",
                                                                  size = labelSize))
        } else {
          figLabel <- paste( "(", letters[figLabel_index], ")", sep = "")
          p3 <- p3 + ggplot2::ggtitle(figLabel) +
                ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0,
                                                                  size = labelSize))
        }
        print(p3, vp=grid::viewport(layout.pos.row=i, layout.pos.col=j))
      }
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
#' An object of class "TonGradePdf"
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
#' tongradePdf <- TonGradePdf(ExampleGatm)
#' summary(tongradePdf)
#'
#' @export
#'
summary.TonGradePdf <- function(object, tg, nDigits = 3) {
  if (tg=="grade") {
      
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
      if (df[5,1]>99.89) { # Print six decimals in case three sign digits produces value of 100 (usually gangue)
        print(round(df, 6))
      } else {
        print(signif(df, digits = nDigits))
      }
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
    cat(sprintf( "Column Gatm refers to the actual grades from the grade and tonnage\n"))
    cat(sprintf( "model; column Pdf refers to the pdf representing the grades.\n"))

    N <- ncol(object$grade)
    for(i in 1:N) {
      cat( sprintf( "Component: %s\n", colnames(object$grade)[i] ))
      PrintStats(object$grade[, i], object$rs[, (i+1)], nDigits, convertToPercent = TRUE)
      cat(sprintf("\n"))
    }

    cat(sprintf("------------------------------------------------------------\n"))

    cat(sprintf( "Compositional mean (reported in percent)\n"))
    cat(sprintf( "Column Gatm refers to the actual grades from the grade and tonnage\n"))
    cat(sprintf( "model; column Pdf refers to the pdf representing the grades.\n"))
    df <- data.frame(Gatm = unclass(object$theGatmMeanG),
                     Pdf = unclass(object$theMeanG))
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
    
    } else if (tg=="tonnage") {
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
                  nrow(object$gatm) ))
    cat( sprintf( "\n" ))

    cat(sprintf("Deviance = %g\n", object$devianceTon))

    cat(sprintf("------------------------------------------------------------\n"))
    cat( sprintf( "This table pertains to the log-transformed tonnages.\n"))
    cat( sprintf( "Column Gatm refers to the actual tonnages in the\n"))
    cat( sprintf( "grade and tonnage model; column Pdf refers to the\n"))
    cat( sprintf( "pdf representing the tonnages.\n"))

    PrintStats(log(object$gatm[,3]), log(object$rs[,1]), nDigits)

    cat(sprintf("------------------------------------------------------------\n"))
    cat( sprintf( "This table pertains to the (untransformed) tonnages.\n"))
    cat( sprintf( "Column Gatm refers to the tonnages in the grade and\n"))
    cat( sprintf( "tonnage model; column Pdf refers to the pdf\n"))
    cat( sprintf( "representing the tonnages.\n"))

    PrintStats(object$gatm[, 3], object$rs[,1], nDigits)

    cat( sprintf( "\n###############################################################\n"))
    cat(sprintf("\n\n\n\n"))

  }
}

#' @title Construct the joint pdf that represents the total tonnage and resource grades
#'
#' @description Construct the joint probability density function (pdf) that
#' represents the total tonnage and resource grades.
#' The pdf is not explicitly specified; instead it is implicitly
#' specified with the random samples that are generated from it.
#'
#' @param gatm
#' Dataframe containing the grade and tonnage model (gatm). (See details.)
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
#' Smoothing kernel for the multivariate joint distribution of the ilr
#' transformed grades and log10 tonnages is computed using the multivariate
#' generalization of the univariate plug-in selector of Wand and Jones (1994)
#' (ilr refers to isometric log-ratio
#' transformation (Pawlowsky-Glahn and others, 2015, p. 37).)
#' The ilr and log10 transformed random samples are converted to random
#' samples of tonnage and grade for the returned object rval.
#'
#' @return A list with the following components is returned.
#' @return \item{gatm}{Input argument gatm.}
#' @return \item{seed}{Input argument seed.}
#' @return \item{isTruncated}{Input argument isTruncated.}
#' @return \item{tongrades}{Total tonnage and grades from the gatm that have been scaled to be
#' between 0 and 1. The grade of the gangue has been appended.}
#' @return \item{resourceNames}{Names of the resources.}
#' @return \item{theGatmMean}{Compositional mean for the total tonnage and grades.}
#' @return \item{theGatmVar}{Variation matrix for the total tonnage and grades.}
#' @return \item{rs}{Random samples of the pdf.}
#' @return \item{theMean}{Compositional mean for the pdf.}
#' @return \item{theVar}{Variation matrix for the pdf.}
#' @return \item{call}{Function call.}
#'
#' @references
#' Pawlowsky-Glahn, V., Egozcue, J.J., and Tolosana-Delgado, R., 2015, Modeling
#' and analysis of compostional data: Chichester, United Kindom, John Wiley &
#' Sons, Ltd., 247 p.
#'
#' Shalizi, C.R., 2016, Advanced data analysis from an elementary point of
#' view: Draft book manuscript publicly available at
#' \url{http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/}
#'
#' Wand M. and Jones M., 1994, Multivariate plugin bandwidth selection,
#' Computational Statistics, 9, 97 p.
#' 
#' @examples
#' TGpdf <- TonGradePdf(ExampleGatm)
#'
#' @export
#'
TonGradePdf <- function(gatm,
                     seed = NULL,
                     isTruncated = FALSE,
                     pdfType="kde",
                     minNDeposits = 20,
                     nRandomSamples = 1000000) {
  
  CheckModel(gatm, minNDeposits)

  
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
  
# Let the number of grades be D-1. Including the gangue, the dimension of
# the simplex is D. After the ilr transformation, the number of ilr
# coordinates is D-1.
# Because the kernel density estimate function , kde, has a maximum of 6 dimensions,
# the maximum number of ilr coordinates is 6. Thus the maximum number of
# grades is 6.
# The first three columns of the grade and tonnage model (which is stored
# in containter gatm) are not grades; the subsequent columns the grades. Thus,
# the maximum number of columns is 9.
  if(ncol(gatm) > 9) {
    stop( sprintf( "Function TonGradePdf\n" ),
          sprintf( "The maximum number of grades\n"),
          sprintf( "is 6. There are %3d in the grade and tonnage model.\n",
                   ncol(gatm) - 3),
          call. = FALSE )
  }
  # Grades on the scale from 0 to 1, gangue column added
  tmp <- gatm[, -(1:3), drop = FALSE] / 100  # convert from percentages
  grades <- cbind(tmp, 1 - rowSums(tmp))
  resourceNames = colnames(gatm[, -(1:3), drop = FALSE])
  colnames(grades) <- c(resourceNames, "gangue")
  rval <- list( gatm = gatm,
                isTruncated = isTruncated,
                pdfType=pdfType,
                seed=seed,
                grades = grades,
                resourceNames = resourceNames,
                theGatmMeanG = mean(compositions::acomp(grades), robust = FALSE),
                theGatmVarG = compositions::variation(compositions::acomp(grades),
                                                     robust = FALSE),
                theGatmMeanT = mean(gatm[, 3]),
                theGatmSdT = sd(gatm[, 3]))


  class(rval) <- "TonGradePdf"
  
  rval$rs <- getRandomSamples(rval, nRandomSamples,seed = seed)
  rval$theMeanG <- mean(compositions::acomp(rval$rs[,-1]), robust = FALSE)
  rval$theVarG <- compositions::variation(compositions::acomp(rval$rs[,-1]),
                                         robust = FALSE)
  rval$theMeanT <- mean(rval$rs[,1])
  
  rval$theSdT <- sd(rval$rs[,1])
  rval$devianceTon <- CalcDeviance(rval$rs[,1], rval$gatm[,3])
  rval$call <- sys.call()
  return(rval)
}