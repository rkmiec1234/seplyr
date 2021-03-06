% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/group_by_se.R
\name{group_by_se}
\alias{group_by_se}
\title{group_by standard interface.}
\usage{
group_by_se(.data, groupingVars, add = FALSE)
}
\arguments{
\item{.data}{data.frame}

\item{groupingVars}{character vector of column names to group by.}

\item{add}{logical, passed to group_by}
}
\value{
.data grouped by columns named in groupingVars
}
\description{
Group a data frame by the groupingVars.
}
\examples{

datasets::mtcars \%>\%
  group_by_se(c("cyl", "gear")) \%>\%
  head()
# essentially group_by_at()

}
\seealso{
\code{\link[dplyr]{group_by}}, \code{\link[dplyr]{group_by_at}}
}
