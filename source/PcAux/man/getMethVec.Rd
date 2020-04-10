\name{getMethVec}
\alias{getMethVec}
\title{
  Extract imputation method vector used by mice from a PcAuxData object.
}
\description{
  This is a simple wrapper function that extracts the method vector for
  creating mice imputations from PcAuxData object.
}
\usage{
getMethVec(pcAuxData)
}
\arguments{
  \item{pcAuxData}{
    A fitted object of class \code{PcAuxData} produced as output of the
    \code{prepData}, \code{createPcAux}, or \code{miWithPcAux} function.
  }
}
\value{
  A list of method names utilized for imputation by mice. 
}
\author{
  Pavel Panko
}
\seealso{
    \code{\link{getMiceMethods}}, \code{\link{prepData}}, \code{\link{createPcAux}}, \code{\link{miWithPcAux}}
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
                        interactType = 2,
                        control = list(
                            miceMethods = list(
                                continuous = "pmm",
                                ordinal    = "polr",
                                nominal    = "polyreg",
                                binary     = "logreg"
                            )
                        )
                        )

## Retrieve method vector
getMethVec(pcAuxOut)
}
