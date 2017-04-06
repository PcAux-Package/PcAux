### Title:        Conduct Multiple Imputation with PC Auxiliaries
### Author:       Kyle M. Lang
### Contributors: Steven Chesnut
### Created:      2015-SEP-17
### Modified:     2017-MAR-27
### Purpose:      Use the principal component auxiliaries produced by
###               createPcAux() to conduct MI.

### Copyright (C) 2017 Kyle M. Lang
###
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program.  If not, see <http://www.gnu.org/licenses/>.


miWithPcAux <- function(rawData,
                        pcAuxData,
                        nImps      = 100L,
                        nomVars    = NULL,
                        ordVars    = NULL,
                        idVars     = NULL,
                        dropVars   = "useExtant",
                        nComps     = NULL,
                        compFormat = "list",
                        seed       = NULL,
                        simMode    = FALSE,
                        forcePmm   = FALSE,
                        nProcess   = 1L,
                        verbose    = 2L,
                        control)
{
    pcAuxData$setCall(match.call(), parent = "miWithPcAux")

    if(missing(rawData))   errFun("noData")
    if(missing(pcAuxData)) errFun("noPcAuxData")
    
    ## Get variable types:
    if(!missCheck(nomVars)) {
        pcAuxData$nomVars        <- nomVars
        pcAuxData$dropVars[ , 1] <- setdiff(pcAuxData$dropVars[ , 1], nomVars)
    }
    if(!missCheck(ordVars)) {
        pcAuxData$ordVars        <- ordVars
        pcAuxData$dropVars[ , 1] <- setdiff(pcAuxData$dropVars[ , 1], ordVars)
    }
    if(!missCheck(idVars)) {
        pcAuxData$idVars         <- idVars
        pcAuxData$dropVars[ , 1] <- setdiff(pcAuxData$dropVars[ , 1], idVars)
    }
    if(length(dropVars) == 1 && dropVars == "useExtant") {
        tmp <- pcAuxData$dropVars[pcAuxData$dropVars[ , 2] == "user_defined", ]
        if(class(tmp) != "matrix") tmp <- matrix(tmp, 1, 2)
        pcAuxData$dropVars <- tmp
    } else if(!missCheck(dropVars)) {
        pcAuxData$dropVars <- cbind(dropVars, "user_defined")
        pcAuxData$nomVars  <- setdiff(pcAuxData$nomVars, dropVars)
        pcAuxData$ordVars  <- setdiff(pcAuxData$ordVars, dropVars)
        pcAuxData$idVars   <- setdiff(pcAuxData$idVars, dropVars)
    } else {
        pcAuxData$dropVars <- cbind("NONE_DEFINED", "user_defined")
    }

    ## Check inputs' validity:
    if(!simMode) checkInputs(parent = "miWithPcAux")
    
    ## Combine the principal component auxiliaries with the raw data:
    mergePcAux(pcAuxData = pcAuxData,
               rawData   = rawData,
               nComps    = nComps,
               intern    = TRUE)
    
    ## Populate new fields in the extant PcAuxData object:
    pcAuxData$nImps      <- as.integer(nImps)
    pcAuxData$simMode    <- simMode
    pcAuxData$compFormat <- compFormat
    pcAuxData$forcePmm   <- forcePmm
    pcAuxData$verbose    <- as.integer(verbose)
    
    if(!missCheck(seed)) pcAuxData$seed <- as.integer(seed)
    
    ## Make sure the control list is fully populated:
    if(!missCheck(control)) pcAuxData$setControl(x = control)
    
    ## Cast the variables to their appropriate types:
    castData(map = pcAuxData)
    
    ## Check and clean the data:
    if(!simMode) cleanData(map = pcAuxData)
    
    ## Check for and treat any single nominal variables that are missing
    ## only one datum
    singleMissNom <- with(pcAuxData, (nrow(data) - respCounts == 1) &
                                     (typeVec == "binary" | typeVec == "nominal")
                          )
    if(any(singleMissNom))
        pcAuxData$fillNomCell(colnames(pcAuxData$data[singleMissNom]))
    
    if(verbose > 1) cat("\nMultiply imputing missing data...\n")
    
    ## Construct a predictor matrix for mice():
    if(verbose > 1) cat("--Constructing predictor matrix...")
    nLin    <- length(grep("^linPC\\d", colnames(pcAuxData$data)))
    nNonLin <- ifelse(nComps[2] == 0,
                      0,
                      length(grep("^nonLinPC\\d", colnames(pcAuxData$data)))
                      )
    predMat <- makePredMatrix(mergedData = pcAuxData$data,
                              nLinear    = nLin,
                              nNonLinear = nNonLin)
    if(verbose > 1) cat("done.\n")
    
    ## Specify a vector of elementary imputation methods:
    if(verbose > 1) cat("--Creating method vector...")
    pcAuxData$createMethVec()
    if(verbose > 1) cat("done.\n")
    
    if(forcePmm & verbose > 1) cat("PMM forced by user.\n")
    
    ## Multiply impute the missing data in 'mergedData':
    if(verbose > 1) cat("--Imputing missing values...\n")
    
    if(nProcess == 1) {# Impute in serial
        pcAuxData$miceObject <- try(
            mice(pcAuxData$data,
                 m               = nImps,
                 maxit           = 1L,
                 predictorMatrix = predMat,
                 method          = pcAuxData$methVec,
                 printFlag       = verbose == 2,
                 ridge           = pcAuxData$miceRidge,
                 seed            = pcAuxData$seed,
                 nnet.MaxNWts    = pcAuxData$maxNetWts),
            silent = TRUE)
        
        if(class(pcAuxData$miceObject) != "try-error") {
            pcAuxData$data <- "Removed to save resources."
            
            ## Complete the incomplete data sets:
            pcAuxData$completeMiData()
        } else {
            errFun("miceCrash", map = pcAuxData)
        }
        
    } else {# Impute in parallel
        myCluster <- makeCluster(nProcess)
        clusterEvalQ(myCluster, library(mice))
        
        pcAuxData$miDatasets <- parLapply(myCluster,
                                          X       = c(1 : nImps),
                                          fun     = parallelMice,
                                          predMat = predMat,
                                          map     = pcAuxData)
        
        stopCluster(myCluster)
        
        pcAuxData$transformMiData()
    }
    
    if(verbose > 1) cat("\n--done.\n")
    if(verbose > 1) cat("Complete.\n")
    
    pcAuxData
}# END miWithPcAux()
    
