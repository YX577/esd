% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map.dsensemble.R
\name{expandpca}
\alias{expandpca}
\title{Expand PCA to obtain station data}
\usage{
expandpca(x, it = NULL, FUN = NULL, FUNX = "mean", verbose = FALSE,
  anomaly = FALSE, test = FALSE)
}
\arguments{
\item{x}{an object of type 'pca'}

\item{it}{time index (see \code{\link{subset}})}

\item{FUN}{function applied to aggregate in time}

\item{FUNX}{function applied aggregate ensemble members}

\item{verbose}{if TRUE print progress}

\item{anomaly}{if FALSE add the mean value stored as attribute in x}

\item{test}{if TRUE perform test on one GCM simulation}
}
\description{
Expand PCA to obtain station data
}
