\name{writeStatus}
\alias{writeStatus}
\title{
  Records system and OS infromation into a text file.
}
\description{
 Provide a text file featuring system and OS information for
 documentation purposes. 
}
\usage{
writeStatus(pcAuxData, outName, what)
}
\arguments{
  \item{pcAuxData}{
    A fitted object of class \code{PcAuxData} produced as output of
    \code{prepData}, \code{createPcAux}, or \code{miWithPcAux} functions.
  }
  \item{outName}{
    A character vector indicating the name of the file to write the
    information to, such as a .txt file. 
  }
  \item{what}{
    A character vector indicating the name of a function for which to
    extract status information. abbreviates the functions
    \code{prepData}, \code{createPcAux}, and \code{miWithPcAux} as
    "prep", "create", and "mi", respectively. 
  }
}
\details{
  This function can be used to write the tertiary information about the
  status of a PcAux function run to disk. The information consists of the
  operating system, session information and the system RAM/CPU hardware
  and usage during a PcAux run. This functionality works in tandem with
  the control list parameter \code{checkStatus}, which has options
  "all", "start", and "none", which is the default option. Selecting
  "start" will record the initial session/OS information and the usage
  during the beginning of the function. On the other hand, "all", will
  record the initial session/OS information and will also record usage
  at each interval within the given PcAux function. After the desired
  infromation has been recorded within the PcAux object through the use
  of \code{checkStatus}, \code{writeStatus} can be used to extract it
  into a text file.
}
\value{
  A string object containing the compiled system and OS information. 
}
\author{
  Pavel Panko
}
\seealso{
  \code{\link{calcTime}}
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
                      groupVars = "Species",
                      control   = list(checkStatus = "all")
                      )

## Create principal component auxiliary variables:
pcAuxOut <- createPcAux(pcAuxData    = cleanData,
                        nComps       = c(3, 2),
                        interactType = 2)

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)

## Extract timing infromation:
writeStatus(pcAuxData = miOut, outName = "miOutStatus.txt", what = "mi")
}