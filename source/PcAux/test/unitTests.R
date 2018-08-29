### Title:    Unit Tests for PcAux
### Author:   Kyle M. Lang, Pavel Panko
### Created:  2015-NOV-01
### Modified: 2018-MAY-25

##--------------------- COPYRIGHT & LICENSING INFORMATION --------------------##
##  Copyright (C) 2018 Kyle M. Lang <k.m.lang@uvt.nl>                         ##
##                                                                            ##
##  This file is part of PcAux.                                               ##
##                                                                            ##
##  This program is free software: you can redistribute it and/or modify it   ##
##  under the terms of the GNU General Public License as published by the     ##
##  Free Software Foundation, either version 3 of the License, or (at you     ##
##  option) any later version.                                                ##
##                                                                            ##
##  This program is distributed in the hope that it will be useful, but       ##
##  WITHOUT ANY WARRANTY; without even the implied warranty of                ##
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General  ##
##  Public License for more details.                                          ##
##                                                                            ##
##  You should have received a copy of the GNU General Public License along   ##
##  with this program. If not, see <http://www.gnu.org/licenses/>.            ##
##----------------------------------------------------------------------------##


rm(list = ls(all = TRUE))

library(PcAux)
library(mvtnorm)
source("makeTestData.R")

##### DOCUMENTATION EXAMPLES ######

### prepData():

## Load data:
data(iris2)

## Prepare the data:
newData <- prepData(rawData   = iris2,
                    nomVars   = "Species",
                    ordVars   = "Petal.Width",
                    idVars    = "ID",
                    dropVars  = "Junk",
                    groupVars = "Species")

### createPcAux():

## Load data:
data(iris2)

## Prepare the data:
cleanData <- prepData(rawData   = iris2,
                      nomVars   = "Species",
                      ordVars   = "Petal.Width",
                      idVars    = "ID",
                      dropVars  = "Junk",
                      groupVars = "Species")

## Create the principal component auxiliaries:
pcAuxOut <- createPcAux(pcAuxData = cleanData, nComps = c(3, 0))


## miWithPcAux():

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

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData = iris2, pcAuxData = pcAuxOut, nImps = 5)

### mergePcAux():

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
                        interactType = 3)

## Merge the PC auxiliaries with the original data:
outData <- mergePcAux(pcAuxData = pcAuxOut, rawData = iris2)

### makePredMatrix():

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
pcAuxOut <- createPcAux(pcAuxData = cleanData, nComps = c(3, 0))

## Merge the PC auxiliaries with the original data:
outData <- mergePcAux(pcAuxData = pcAuxOut, rawData = iris2)

## Create a predictor matrix:
predMat <- makePredMatrix(mergedData = outData)

### getImpData():

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

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)

## Extract a list of imputed data sets:
impList <- getImpData(pcAuxData = miOut)

### inspect():

## Load data:
data(iris2)

## Prepare the data:
newData <- prepData(rawData   = iris2,
                    nomVars   = "Species",
                    ordVars   = "Petal.Width",
                    idVars    = "ID",
                    dropVars  = "Junk",
                    groupVars = "Species")

## Pull the 'data' field from 'newData':
inspect(object = newData, what = "data")

### pcAuxW():

## Check PcAux's warranty:
pcAuxW()

### pcAuxL():

## Check PcAux's license:
pcAuxL()


### iris2:
data(iris2)

### calcTime():

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

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)

## Extract timing infromation:
timeInfo <- calcTime(pcAuxData = miOut, what = "mi")

### writeStatus():

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

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)

## Extract timing infromation:
writeStatus(pcAuxData = miOut,
            outName   = "miOutStatus.txt",
            what      = "mi")

### getLoggedEvents():

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

## Extract mice logged events
pcLoggedEvents <- getLoggedEvents(pcAuxOut)

## Conduct MI with the pcAux:
miOut <- miWithPcAux(rawData   = iris2,
                     pcAuxData = pcAuxOut,
                     nImps     = 5)


##### DATA PREP TESTING #####


## Test:   Normal usage with one ID
## Result: Successful execution
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1"),
                      dropVars  = c("y1", "y2", "z2", "id2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Catch high percent missing
## Result: Warning with request for user input
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )
frozenPcAuxData1 <- pcAuxData$copy()

## Test:   Find bad nominals
## Result: Warning with request for user input
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2", "bigCat"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2", "z2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Find bad ordinals
## Result: Warning with request for user input
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2", "bigCat"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2", "z2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Find bad continuous
## Result: Warning with request for user input
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2", "z2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Replace IDs with fully observed versions to test 'simMode'
testData2 <- testData
testData2[ , c("id1", "id2")] <-
    matrix(seq(1 : (2 * nrow(testData2))), ncol = 2)

## Test:   Use simMode = TRUE
## Result: Successful execution
pcAuxData <- prepData(rawData   = testData2,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("x3", "z1", "z2", "y5"),
                      groupVars = c("nom1", "nom2", "ord1"),
                      simMode   = TRUE)
frozenPcAuxData2 <- pcAuxData$copy()

## Test:   Trip initial check for non-existant variables
## Result: Fatal Error
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2", "bob"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2", "suzy"),
                      dropVars  = c("y1", "y2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Trip initial check for non-distinct dropVars
## Result: Fatal Error
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2", "nom1"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Trip initial check for non-distinct idVars
## Result: Fatal Error
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2", "id2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2"),
                      groupVars = c("nom1", "nom2", "ord1")
                      )

## Test:   Use parallel processing to check for collinearity
## Result: Successful execution
pcAuxData <- prepData(rawData   = testData,
                      nomVars   = c("nom1", "nom2"),
                      ordVars   = c("ord1", "ord2"),
                      idVars    = c("id1", "id2"),
                      dropVars  = c("y1", "y2", "z2"),
                      groupVars = c("nom1", "nom2", "ord1"),
                      nProcess  = 4L)

## Test:   Specify key moderators variables
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("x1", "nom1", "ord1"),
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1", "id2"),
                      dropVars   = c("y1", "y2", "z2"),
                      groupVars  = c("nom1", "nom2", "ord1")
                      )
frozenPcAuxData3 <- pcAuxData$copy()

## Test:   Make sure collinear moderators are not dropped
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = "y4",
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1"),
                      dropVars   = c("y1", "y2", "z2", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1")
                      )

## Test:   Make sure moderators' collinear partner is dropped
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = "x2",
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1"),
                      dropVars   = c("y1", "y2", "z2", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1")
                      )

## Test:   Make sure both collinear moderators are retained
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("y4", "x2"),
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1"),
                      dropVars   = c("y1", "y2", "z2", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1")
                      )

## Test:   Don't specify any dropped variables
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("y4", "x2"),
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1")
                      )
frozenPcAuxData4 <- pcAuxData$copy()

## Test:   Suppress all printed output
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("y4", "x2"),
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1"),
                      verbose    = 0)

## Test:   Suppress all printed output 2
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("y4", "x2"),
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      idVars     = c("id1", "id2"),
                      groupVars  = c("nom1", "nom2", "ord1"),
                      verbose    = 1)


##### PCAUX CREATION TESTING #####


## Test:   Basic usage
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData = tmp,
                        nComps    = c(5, 3)
                        )
frozenPcAuxOut1 <- pcAuxOut$copy()

## Test:   Use low memory pca
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData = tmp,
                        nComps    = c(5, 3),
                        control   = list(pcaMemLev = 1L)
                        )

## Test:   Use simMode = TRUE
## Result: Successful execution
tmp      <- frozenPcAuxData2$copy()
pcAuxOut <- createPcAux(pcAuxData = tmp,
                        nComps    = c(5, 0),
                        simMode   = TRUE)
frozenPcAuxOut2 <- pcAuxOut$copy()

## Test:   Specify interactions among key moderators and raw data
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 1)

## Test:   Specify interactions among key moderators and PcAux
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 2)
frozenPcAuxOut3 <- pcAuxOut$copy()

## Test:   Specify interactions among all observed variables and PcAux
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 3)

## Test:   Specify moderators but don't use them
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 3)

## Test:   Extract 0 non-linear components
## Result: Successful exectution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(10, 0),
                        interactType = 3)
frozenPcAuxOut4 <- pcAuxOut$copy()

## Test:   Try extracting 0 linear components
## Result: Fatal Error
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData = tmp,
                        nComps    = c(0, 3)
                        )

## Test:   Don't use interactions
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 0)

## Test:   Don't use polynomials
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData  = tmp,
                        nComps     = c(5, 3),
                        maxPolyPow = 1)

## Test:   Only use squares
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData  = tmp,
                        nComps     = c(5, 3),
                        maxPolyPow = 2L)

## Test:   Use polynomials up to 4th power
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData  = tmp,
                        nComps     = c(5, 3),
                        maxPolyPow = 4L)

## Test:   Try to request polynomial power greater than 4
## Result: Fatal Error
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData  = tmp,
                        nComps     = c(5, 3),
                        maxPolyPow = 5L)

## Test:   Try to request nComps[2] > 0 while asking for no nonlinearities
## Result: Fatal Error
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        nComps       = c(5, 3),
                        interactType = 0,
                        maxPolyPow   = 1)

## Test:   Don't specify any ID variables
## Result: Successful Execution
pcAuxData <- prepData(rawData    = testData,
                      moderators = c("x1", "nom1", "ord1"), 
                      nomVars    = c("nom1", "nom2"),
                      ordVars    = c("ord1", "ord2"),
                      dropVars   = c("y1", "y2", "z2", "id1", "id2")
                      )
pcAuxOut <- createPcAux(pcAuxData = pcAuxData,
                        nComps = c(5, 3)
                        )

## Test:   Don't specify any dropped variables
## Result: Successful execution
pcAuxData <- prepData(rawData = testData,
                      nComps  = c(5, 3),
                      nomVars = c("nom1", "nom2"),
                      ordVars = c("ord1", "ord2"),
                      idVars  = c("id1", "id2")
                      )
pcAuxOut <- createPcAux(pcAuxData = pcAuxData,
                        nComps    = c(5, 3)
                        )
frozenPcAuxOut5 <- pcAuxOut$copy()

## Simulate some clean data:
sigma       <- matrix(0.3, 50, 50)
diag(sigma) <- 1.0

testData3           <- rmvnorm(500, rep(0, 50), sigma)
colnames(testData3) <- paste0("x", c(1 : 50))

testData3[as.logical(rbinom(prod(dim(testData3)), 1, 0.2))] <- NA

## Test:   Run PcAux on clean, normally distributed data
## Result: Successful execution
pcAuxData <- prepData(rawData    = testData3,
                      moderators = c("x1", "x2", "x3")
                      )
pcAuxOut  <- createPcAux(pcAuxData    = pcAuxData,
                         nComps       = c(5, 3),
                         interactType = 2)
frozenPcAuxOut6 <- pcAuxOut$copy()

## Test:   Run PcAux on clean, normally distributed data using simMode = TRUE
## Result: Successful execution
pcAuxData <- prepData(rawData = as.data.frame(testData3),
                      simMode = TRUE)
pcAuxOut <- createPcAux(pcAuxData    = pcAuxData,
                        nComps       = c(5, 3),
                        interactType = 2,
                        simMode      = TRUE)
frozenPcAuxOut7 <- pcAuxOut$copy()

## Simulate some P > N data:
sigma       <- matrix(0.3, 100, 100)
diag(sigma) <- 1.0

testData4           <- rmvnorm(75, rep(0, 100), sigma)
colnames(testData4) <- paste0("x", c(1 : 100))

testData4[as.logical(rbinom(prod(dim(testData4)), 1, 0.2))] <- NA

pcAuxData <- prepData(rawData = as.data.frame(testData4))
pcAuxOut  <- createPcAux(pcAuxData    = pcAuxData,
                         nComps       = c(5, 3),
                         interactType = 3)
frozenPcAuxOut8 <- pcAuxOut$copy()

## Test:   Specify number of PcAux in terms of variance explained
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(0.5, 0.5)
                        )

## Test:   Specify number of PcAux in terms of variance explained and include
##         interactions between PcAux and key moderators
## Result: Successful execution
tmp      <- frozenPcAuxData3$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 2,
                        nComps       = c(0.5, 0.5)
                        )

## Test:   Specify number of PcAux in mixed terms
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(5, 0.5)
                        )

## Test:   Specify number of PcAux in mixed terms 2
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(0.5, 5)
                        )

## Test:   Specify number of PcAux with special keyword
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(Inf, Inf)
                        )
frozenPcAuxOut9 <- pcAuxOut$copy()

## Test:   Specify number of PcAux in mixed terms 3
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(Inf, 5)
                        )

## Test:   Specify number of PcAux in mixed terms 4
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(0.75, Inf)
                        )

## Test:   Get all possible PcAux
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(-100, -100)
                        )
frozenPcAuxOut10 <- pcAuxOut$copy()

## Test:   Specify number of PcAux in mixed terms 5
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(Inf, -1)
                        )

## Test:   Specify number of PcAux in mixed terms 6
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(4, -11)
                        )

## Test:   Run without user-defined dropVars
## Result: Successful execution
tmp      <- frozenPcAuxData4$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(5, 5)
                        )
frozenPcAuxOut11 <- pcAuxOut$copy()

## Test:   Suppress all printed output
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(5, 5),
                        verbose      = 0)

## Test:   Suppress printed output from mice()
## Result: Successful execution
tmp      <- frozenPcAuxData1$copy()
pcAuxOut <- createPcAux(pcAuxData    = tmp,
                        interactType = 3,
                        nComps       = c(5, 5),
                        verbose      = 1)


##### MI TESTING #####


## Test:   Ordinary usage
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     nImps     = 5L)

## Test:   Use forcePmm = TRUE
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     forcePmm  = TRUE)

## Test:   Use simMode = TRUE
## Result: Successful execution
tmp   <- frozenPcAuxOut2$copy()
miOut <- miWithPcAux(rawData   = testData2,
                     pcAuxData = tmp,
                     dropVars  = c("z2", "z1", "y5"),
                     nImps     = 5L,
                     simMode   = TRUE)

## Test:   Use simMode = TRUE and forcePmm = TRUE
## Result: Successful execution
tmp   <- frozenPcAuxOut2$copy()
miOut <- miWithPcAux(rawData   = testData2,
                     pcAuxData = tmp,
                     dropVars  = c("z2", "z1", "y5"),
                     nImps     = 5L,
                     simMode   = TRUE,
                     forcePmm  = TRUE)

## Test:   Defining nComps in terms of variance explained
## Result: Successful execution
tmp   <- frozenPcAuxOut3$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(0.3, 0.05)
                     )

## Test:   Defining nComps in terms of 'Inf' keyword
## Result: Successful execution
tmp   <- frozenPcAuxOut9$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = c("z2", "ord2"),
                     nImps     = 2L,
                     nComps    = c(Inf, Inf)
                     )

## Test:   Using all possible PcAux:
## Result: Successful execution
tmp   <- frozenPcAuxOut10$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = c("z2", "ord2"),
                     nImps     = 2L,
                     nComps    = c(-1, -1)
                     )

## Test:   Asking for too much linear variance explained
## Result: Fatal Error
tmp   <- frozenPcAuxOut3$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  ="z2",
                     nImps     = 5L,
                     nComps    = c(0.9, 0.05)
                     )

## Test:   Asking for too much non-linear variance explained
## Result: Fatal Error
tmp   <- frozenPcAuxOut3$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(0.5, 0.5)
                     )

## Test:   Asking for too many linear components
## Result: Fatal Error
tmp   <- frozenPcAuxOut3$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(42, 3)
                     )

## Test:   Asking for too many non-linear components
## Result: Fatal Error
tmp   <- frozenPcAuxOut3$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(10, 42)
                     )

## Test:   Use defaults with no non-linear pcAux:
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     nImps     = 5L)

## Test:   Request no non-linear components
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(5, 0)
                     )

## Test:   Try requesting no linear components
## Result: Fatal Error denoting the requirement for nLinear >= 1
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nComps    = c(0, 5)
                     )

## Test:   Specify nomVars different from pcAuxObj$nomVars
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     nomVars   = "nom1",
                     dropVars  = c("z2", "nom2"),
                     nImps     = 5L)

## Test:   Specify ordVars different from pcAuxObj$ordVars
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     ordVars   = "ord1",
                     dropVars  = c("z2", "ord2"),
                     nImps     = 5L)

## Test:   Specify idVars different from pcAuxObj$idVars
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     nomVars   = "nom2",
                     idVars    = c("id1", "id2", "nom1"),
                     dropVars  = "z2",
                     nImps     = 5L)

## Test:   Trip initial check for distinct idVars
## Result: Fatal Error
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     idVars    = c("id1", "id2", "nom1"),
                     dropVars  = "z2",
                     nImps     = 5L)

## Test:   Trip initial check for distinct dropVars
## Result: Fatal Error
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     idVars    = c("id1", "id2"),
                     dropVars  = c("id2", "z2")
                     )

## Test:   Trip initial check for non-existant variables
## Result: Fatal Error
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     idVars    = c("id1", "id2", "suzy"),
                     dropVars  = c("z2", "z1", "y5")
                     )

## Test:   Request 'long' format for imputed data sets
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     compFormat = "long")

## Test:   Request 'broad' format for imputed data sets
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     compFormat = "broad")

## Test:   Request 'repeated' format for imputed data sets
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     compFormat = "repeated")

## Test:   Call miWithPcAux() with no user-defined dropVars in prepData():
## Result: Successful execution
tmp   <- frozenPcAuxOut11$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     nImps     = 5L)

## Test:   Use miWithPcAux() with clean, normally distributed data:
## Result: Successful execution
tmp   <- frozenPcAuxOut6$copy()
miOut <- miWithPcAux(rawData   = testData3,
                     pcAuxData = tmp,
                     nImps     = 5L)

## Test:   Use miWithPcAux() with clean, normally distributed data with
##         simMode = TRUE
## Result: Successful execution
tmp   <- frozenPcAuxOut7$copy()
miOut <- miWithPcAux(rawData   = testData3,
                     pcAuxData = tmp,
                     nImps     = 5L,
                     simMode   = TRUE)

## Test:   Use parallel processing to generate the multiple imputations
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData   = testData,
                     pcAuxData = tmp,
                     dropVars  = "z2",
                     nImps     = 5L,
                     nProcess  = 4)

## Test:   Use parallel processing with "long" output
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     nProcess   = 4,
                     compFormat = "long")

## Test:   Use parallel processing with "broad" output
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     nProcess   = 4,
                     compFormat = "broad")

## Test:   Use parallel processing with "repeated" output
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     nProcess   = 4,
                     compFormat = "repeated")

## Test:   Suppress all printed output
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     verbose    = 0)

## Test:   Suppress printed output from mice()
## Result: Successful execution
tmp   <- frozenPcAuxOut1$copy()
miOut <- miWithPcAux(rawData    = testData,
                     pcAuxData  = tmp,
                     dropVars   = "z2",
                     nImps      = 5L,
                     verbose    = 1)
