\name{getMiceMethods}
\alias{getMiceMethods}
\title{
  Extract imputation methods used by mice from a PcAuxData object.
}
\description{
  This is a simple wrapper function that extracts the specified mice
  imputation methods from PcAuxData object.
}
\usage{
getMiceMethods(pcAuxData)
}
\arguments{
  \item{pcAuxData}{
    A fitted object of class \code{PcAuxData} produced as output of the
    \code{prepData}, \code{createPcAux}, or \code{miWithPcAux} function.
  }
}
\value{
  A named list of methods for each of the four variable types:
  "continuous", "ordinal", "nominal", and "binary". 
}
\author{
  Pavel Panko
}
\seealso{
    \code{\link{getMethVec}}, \code{\link{prepData}}, \code{\link{createPcAux}}, \code{\link{miWithPcAux}}
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

## Retrieve mice methods
getMiceMethods(pcAuxOut)
}
