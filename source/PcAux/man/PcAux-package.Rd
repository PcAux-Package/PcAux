\name{PcAux-package}
\alias{PcAux-package}
\docType{package}
\title{
\packageTitle{PcAux}
}
\description{
\packageDescription{PcAux}
}
\details{
\packageIndices{PcAux}
}
\author{
\packageAuthor{PcAux}

Maintainer: \packageMaintainer{PcAux}
}
\references{
  Howard, W. H., Rhemtulla, M., & Little, T. D. (2015). Using principal
  components as auxiliary variables in missing data estimation.
  Multivariate Behavioral Research. 50(3). 285-299.
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
pcAuxOut <- createPcAux(pcAuxData = cleanData,
                        nComps    = c(3, 0)
                        )

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)

### OR get the constituent parts ###

## Merge the PC auxiliaries with the original data:
outData <- mergePcAux(pcAuxData = pcAuxOut, rawData = iris2)

### outData can be analyzed via FIML, with the
### pcAux scores used as auxiliary variables.

## Create a predictor matrix:
predMat <- makePredMatrix(mergedData = outData)

### You can run mice() manually by supplying
### predMat to the predictorMatrix argument.
}
\keyword{ package }
