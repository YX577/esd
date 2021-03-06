% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write2ncdf.R
\name{write2ncdf4.dsensemble}
\alias{write2ncdf4.dsensemble}
\title{Saves climate data as netCDF.}
\usage{
\method{write2ncdf4}{dsensemble}(x, ..., file = "esd.dsensemble.nc",
  prec = "short", offset = 0, scale = 0.1, torg = "1970-01-01",
  missval = -99, verbose = TRUE)
}
\arguments{
\item{x}{data object}

\item{\dots}{additional arguments}

\item{file}{filename}

\item{prec}{Precision: see \code{\link[ncdf4]{ncvar_def}}}

\item{offset}{Sets the attribute 'add_offset' which is added to the values
stored (to save space may be represented as 'short').}

\item{scale}{Sets the atttribute 'scale_factor' which is used to scale
(multiply) the values stored (to save space may be represented as 'short').}

\item{torg}{Time origin}

\item{missval}{Missing value: see \code{\link[ncdf4]{ncvar_def}}}

\item{verbose}{If TRUE print progress}
}
\value{
None
}
\description{
Method to save 'dsensemble' data as netCDF, making sure to include the data
structure and meta-data (attributes). The code tries to follow the netCDf
'CF' convention. The method is built on the \code{ncdf4} package.
}
\details{
To save space, the values are saved as short (16-bit signed integer that
can hold values between -32768 and 32767).
(see NC_SHORT in \url{https://www.unidata.ucar.edu/software/netcdf/docs/data_type.html}).
}
\seealso{
write2ncdf4
}
\keyword{ncdf4}
\keyword{netcdf}
\keyword{save}
