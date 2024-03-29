% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_digits.R
\name{format_percent}
\alias{format_percent}
\title{Format number to percent}
\usage{
format_percent(x, digits = 1, ...)
}
\arguments{
\item{x}{Number to format percentage.}

\item{digits}{the desired number of digits after the decimal
    point (\code{format = "f"}) or \emph{significant} digits
    (\code{format = "g"}, \code{= "e"} or \code{= "fg"}).

    Default: 2 for integer, 4 for real numbers.  If less than 0,
    the C default of 6 digits is used.  If specified as more than 50, 50
    will be used with a warning unless \code{format = "f"} where it is
    limited to typically 324. (Not more than 15--21 digits need be
    accurate, depending on the OS and compiler used.  This limit is
    just a precaution against segfaults in the underlying C runtime.)
  }

\item{...}{arguments passed to \code{format}.}
}
\value{
A formatted percent character.
}
\description{
Format values to percentage format. Multiply 100 and add \% symbol.
}
