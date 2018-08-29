\name{getLoggedEvents}
\alias{getLoggedEvents}
\title{
  Extract logged imputation events from a PcAuxData object.
}
\description{
  This is function is used to retrieve logged events from the
  PcAuxData object produced by mice during the initial imputation
  within the \code{createPcAux} function.
}
\usage{
getLoggedEvents(pcAuxData)
}
\arguments{
  \item{pcAuxData}{
    A fitted object of class \code{PcAuxData} produced as output of the
    \code{miWithPcAux} function.
  }
}
\value{
  A data.frame object produced by mice containing events logged during
  the imputation. The format of these data sets is defined by the
  \code{loggedEvents} value in \code{pcAuxData}. See
  \code{\link{createPcAux}} 
  for more information.
}
\author{
  Pavel Panko 
}
\seealso{
  \code{\link{miWithPcAux}}, \code{\link{createPcAux}}
}
\examples{
## Load the data:
data(iris2)

## Prepare the data:
cleanData <- prepData(rawData   = iris2,
                      nomVars   = "Species",
                      ordVars   = "Petal.Width",
                      idVars    = "ID",
                      dropVars  = "Junk",
                      groupVars = "Species")

## Create principal component auxiliary variables:
pcAuxOut <- createPcAux(pcAuxData    = cleanData,
                        nComps       = c(3, 2),
                        interactType = 2)

## Retrieve logged events 
loggedEventsFrame <- getLoggedEvents(pcAuxData = pcAuxOut)
}