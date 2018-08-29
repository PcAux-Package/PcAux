### Title:        Exported PcAux Helper Functions
### Author:       Kyle M. Lang
### Contributors: Pavel Panko, Vibhuti Gupta
### Created:      2015-OCT-29
### Modified:     2018-AUG-17

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


## Print the (lack of) warranty information:
pcAuxW <- function() {
    lic <- readLines(system.file("LICENSE", package = "PcAux"))
    
    start <- grep("15. Disclaimer of Warranty", lic)
    end   <- grep("END OF TERMS AND CONDITIONS", lic) - 1
    
    writeLines(lic[start : end])
}


## Print license:
pcAuxL <- function()
    writeLines(readLines(system.file("LICENSE", package = "PcAux")))


### Merge the Principal Component Auxiliaries with the raw data from which they
### were created:
mergePcAux <- function(pcAuxData, rawData, nComps = NULL, verbose = TRUE, ...)
{
    args   <- list(...)
    idVars <- pcAuxData$idVars
    varExp <- c(NA, NA)
    
    if(missCheck(nComps)) {
        ## If no explicit number of components is defined, use all available:
        nComps <- pcAuxData$nComps
    } else {
        ## Ascertain the number of components to use:
        for(i in c(1, 2)) {
            r2 <- pcAuxData$rSquared[[i]]
            nc <- nComps[i]
            if(is.infinite(nc)) {
                tmp       <-  which(r2[-length(r2)] == r2[-1])
                nComps[i] <- ifelse(length(tmp) == 0, length(r2), tmp[1])
            } else if(nc < 1 & nc > 0) {
                varExp[i] <- nComps[i]
                nComps[i] <- sum(r2 < nc) + 1
            } else if(nc < 0) {
                nComps[i] <- length(r2)
            }
        }

        ## Must use at least 1 linear PcAux
        check <- nComps[1] == 0
        if(check) errFun("noLinPcAux", creatingPcAux = FALSE)
        
        ## Make sure non-linear PcAux are available, if requested
        check <- pcAuxData$nComps[2] == 0 & nComps[2] > 0
        if(check) errFun("missingNonLinPcAux")
        
        ## Requesting a legal number of linear components?
        check <- nComps[1] <= pcAuxData$nComps[1]
        if(check) {
            if(verbose) {# How much variance is explained?
                print(
                    paste0("NOTE: ",
                           nComps[1],
                           " component ",
                           ifelse(nComps[1] > 1,
                                  "scores explain ",
                                  "score explains "),
                           round(100 * pcAuxData$rSquared$lin[nComps[1]]),
                           "% of the variance in 'rawData.'")
                )
            }
        } else {
            if(is.na(varExp[1])) # Argument -> Component counts
                errFun("fewLinPcAux", pcAuxData = pcAuxData, nComps = nComps)
            else                 # Argument -> Variance explained
                errFun("linVarExp", pcAuxData = pcAuxData, varExp = varExp)    
        }
        
        ## Requesting a legal number of non-linear components?
        check <- nComps[2] <= pcAuxData$nComps[2]
        if(check) {
            if(verbose & nComps[2] != 0) {# How much variance is explained?
                print(
                    paste0("NOTE: ",
                           nComps[2],
                           " component ",
                           ifelse(nComps[2] > 1,
                                  "scores explain ",
                                  "score explains "),
                           round(100 * pcAuxData$rSquared$nonLin[nComps[2]]),
                           "% of the variance in the nonlinear ",
                           "expansion of 'rawData.'")
                )
            }
        } else {
            if(is.na(varExp[2])) # Argument -> Component counts
                errFun("fewNonLinPcAux", pcAuxData = pcAuxData, nComps = nComps)
            else                 # Argument -> Variance explained
                errFun("nonLinVarExp", pcAuxData = pcAuxData, varExp = varExp)    
        }
    }# CLOSE if(missCheck(nComps))
    
    badId <- FALSE
    
    ## Check for shared ID variables:
    check <- idVars %in% colnames(rawData) &
        idVars %in% colnames(pcAuxData$pcAux$lin)
    
    if(nComps[2] > 0)
        check <- check & idVars %in% colnames(pcAuxData$pcAux$nonLin)
    
    if(!any(check)) {
        warnFun("mergeNoID")
        badId <- TRUE
    } else {
        idVars <- idVars[check]
        
        ## Check that ID variables are unique row-identifiers:
        check <-
            unlist(
                lapply(as.data.frame(pcAuxData$pcAux$lin[ , idVars]),
                       function(x) length(unique(x)) == length(x)
                       )
            )
        if(any(check)) {# At least one viable ID variable
            
            ## Arbitrarily select an acceptable ID variable to use for matching:
            useId    <- idVars[check][1]
            dataId   <- rawData[ , useId]
            extraIds <- setdiff(idVars, useId)
            
            ## Temporarily cast factor-valued raw data IDs as character:
            check <- class(dataId) == "factor" | class(dataId) == "ordered"
            if(check) dataId <- as.character(dataId)
            
            idMissPat <- is.na(dataId)
            
            ## Fill missing ID values with dummy levels from the PcAux object:
            if(any(idMissPat))
                ## KML 2016-JUL-31: Check class of 'idFills' to avoid crashes
                ## with one incomplete ID
                if(is.list(pcAuxData$idFills))
                    dataId[idMissPat] <- pcAuxData$idFills[[useId]]
                else
                    dataId[idMissPat] <- pcAuxData$idFills
        } else {# No viable ID variables
            warnFun("mergeBadID", pcAuxData)
            badId <- TRUE
        }
    }

    ## Are we using any non-linear PcAux?
    useNonLin <- pcAuxData$intMeth != 1 & nComps[2] > 0
        
    ## Merge the PcAux scores onto the raw data:
    linPcNames    <- paste0("linPC",    c(1 : nComps[1]))
    if(useNonLin) nonLinPcNames <- paste0("nonLinPC", c(1 : nComps[2]))
    
    if(badId) {
        if(useNonLin)
            outData <-
                data.frame(rawData,
                           pcAuxData$pcAux$lin[ , linPcNames],
                           pcAuxData$pcAux$nonLin[ , nonLinPcNames]
                           )
        else
            outData <- data.frame(rawData, pcAuxData$pcAux$lin[ , linPcNames])
    } else {
        linPcNames    <- c(useId, linPcNames)
        if(useNonLin) nonLinPcNames <- c(useId, nonLinPcNames)
        
        if(useNonLin)
            tmp <- merge(pcAuxData$pcAux$lin[ , linPcNames],
                         pcAuxData$pcAux$nonLin[ , nonLinPcNames]
                         )
        else
            tmp <- pcAuxData$pcAux$lin[ , linPcNames]
        outData <- merge(rawData, tmp, by = useId)
    }
    if(!is.null(args$intern) && args$intern) pcAuxData$data <- outData
    else                                     outData
}# END mergePcAux()


### Make a predictor matrix suitable for use by mice() that designated subset of
### the principle component auxiliaries produced by pcAux() as the imputation
### model predictors:
makePredMatrix <- function(mergedData,
                           nLinear      = NULL,
                           nNonLinear   = NULL,
                           useQuickPred = FALSE,
                           minCor       = NULL)
{    
    if(missCheck(nLinear))
        nLinear <- length(grep("linPC", colnames(mergedData)))
    
    if(missCheck(nNonLinear))
        nNonLinear <- length(grep("nonLinPC", colnames(mergedData)))
    
    if(nNonLinear > 0)
        predVars    <- c(paste0("linPC", c(1 : nLinear)),
                         paste0("nonLinPC", c(1 : nNonLinear))
                         )
    else 
        predVars    <- paste0("linPC", c(1 : nLinear))
    
    if(useQuickPred) {
        nonPredVars <- setdiff(colnames(mergedData), predVars)
        
        predMat <-
            quickpred(mergedData, mincor  = minCor, exclude = nonPredVars)
    } else {
        predMat              <- matrix(0, ncol(mergedData), ncol(mergedData))
        colnames(predMat)    <- rownames(predMat) <- colnames(mergedData)
        predMat[ , predVars] <- 1
        
        compFlag            <- colSums(is.na(mergedData)) == 0
        predMat[compFlag, ] <- 0
    }
    
    predMat
}# END makePredMatrix()


## Wrapper function to give S3/S4-like access to fields:
inspect <- function(object, what) object$field(what)


## Wrapper function to return the imputed data sets:
getImpData <- function(pcAuxData) pcAuxData$miDatasets


##Compute elapsed time at each interval: 
calcTime <- function(pcAuxData, what) {
    time     <- pcAuxData$time[[what]]  
    eachStep <- diff(time)
    
    nPoints                      <- length(eachStep)
    eachStep[nPoints + 1]        <- as.vector(time[length(time)] - time["start"])
    names(eachStep)[nPoints + 1] <- "overall"
    
    usrVars <- lapply(c("End", "usr"), function(x) grep(x, names(eachStep)))
    
    if(length(unlist(usrVars)) > 1) {
        eachStep["overall"] <- eachStep["overall"] - eachStep[usrVars[[1]]]
        timeSteps           <- eachStep[-usrVars[[2]]]
        timeSteps["usr"]    <- eachStep[usrVars[[1]]]
    }
    else timeSteps <- eachStep
    
    timeSteps
}


## Write machine status to a text files 
writeStatus <- function(pcAuxData, outName, what) {
    capture.output(pcAuxData$status[[what]], file = outName)
    paste("Wrote status to", outName)
}


getLoggedEvents <- function(pcAuxData) {
    if(!nrow(pcAuxData$loggedEvents))
        return("No logged events")
    else
        return(pcAuxData$loggedEvents)
}
