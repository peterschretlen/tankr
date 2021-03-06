% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/tankr.R
\name{rank_diff_pair}
\alias{rank_diff_pair}
\title{Compare rankings between two measurements in long (plot-friendly) form}
\usage{
rank_diff_pair(m1, m2)
}
\arguments{
\item{m1}{data frame with first measurement}

\item{m2}{data frame with second measurement}
}
\value{
A dataframe with the changes in ranking between the two measurements.
}
\description{
Each measurement is a dataframe with these columns:
\itemize{
\item rank: numeric value of ranking
\item measurement_id: an identifier for the measurement. This can by a character string or number
\item id: an identifier for the item holding the ranking
\item measure: a description of the measurement, e.g. "non-fiction bestsellers"
}
}
\examples{
todo
}

