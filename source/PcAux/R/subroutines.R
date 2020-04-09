### Title:        PcAux Subroutines
### Author:       Kyle M. Lang & Stephen Chesnut
### Contributors: Byungkwan Jung, Pavel Panko
### Created:      2015-JUL-27
### Modified:     2020-APR-09

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


checkInputs <- function() {
    ## Get access to objects defined in createPcAux():
    env    <- parent.frame()
    ## Index this function's parent:
    ## (2 = prepData, 1 = createPcAux, 0 = miWithPcAux)
    if(is.null(env$pcAuxData)) parent <- 2
    else                       parent <- sum(sapply(env$pcAuxData$call, is.null))
    
    if(env$verbose > 0) cat("\nChecking inputs' validity...\n")

    if(parent == 2) {
        ## Make sure the data object is a data.frame:
        if(!is.data.frame(env$rawData))
            if(is.matrix(env$rawData)) env$rawData <- as.data.frame(env$rawData)
            else                       errFun("badDataType")
        
        ## Check the existance of all designated variables:
        varNames <- with(env, c(idVars, nomVars, ordVars, groupVars, dropVars))
        check    <- !varNames %in% colnames(env$rawData)
        if(any(check))
            errFun("missingVars", varNames = varNames, check = check)
        
        ## Check for a non-empty intersection between 'dropVars' and the other
        ## arguments:
        varNames <- with(env, c(idVars, nomVars, ordVars, groupVars))
        check    <- varNames %in% env$dropVars
        if(any(check))
            errFun("dropVarOverlap", varNames = varNames, check = check)

        ## Check for a non-empty intersection between 'idVars' and the other
        ## arguments:
        varNames <- with(env, c(nomVars, ordVars, groupVars, dropVars))
        check    <- varNames %in% env$idVars
        if(any(check))
            errFun("idOverlap",
                   varNames      = varNames,
                   check         = check,
                   creatingPcAux = TRUE)
    }
    
    if(parent == 1) {
        ## Check the polynomial specification:
        if(env$maxPolyPow < 1)      errFun("smallPower")
        else if(env$maxPolyPow > 4) errFun("largePower")
        
        ## Check for non-zero linear component counts:
        if(env$nComps[1] == 0) errFun("noLinPcAux", creatingPcAux = TRUE)
        
        ## Check for disagreement between nComps and usePoly/useInteract:
        checkVal <-
            env$interactType == 0 & env$maxPolyPow == 1 & env$nComps[2] > 0
        if(checkVal) errFun("nonLinOptionClash", nNonLinear = env$nComps[2])

        ## Check for disagreement between nComps and usePoly/useInteract:
        checkVal <- env$interactType == 1 & env$nComps[2] > 0
        if(checkVal) {
            env$nComps[2] <- 0
            warnFun("nonLinPcAuxClash")
        }
    }
    
    if(parent == 0) {
        ## Check the existance of all designated variables:
        varNames <-
            with(env$pcAuxData, c(idVars, nomVars, ordVars, dropVars[ , 1]))
        
        varNames <- setdiff(varNames, "NONE_DEFINED")
        check    <- !varNames %in% colnames(env$rawData)
        if(any(check))
            errFun("missingVars", varNames = varNames, check = check)
        
        ## Check for a non-empty intersection between newly specified 'dropVars'
        ## and the other newly specified arguments:
        varNames <- with(env, c(idVars, nomVars, ordVars))
        check    <- varNames %in% env$dropVars
        if(length(check) > 0 && any(check))
            errFun("dropVarOverlap", varNames = varNames, check = check)
        
        ## Check for a non-empty intersection between 'idVars' and the other
        ## arguments:
        varNames <- with(env$pcAuxData, c(nomVars, ordVars, dropVars))
        check    <- varNames %in% env$pcAuxData$idVars
        if(any(check))
            errFun("idOverlap",
                   varNames      = varNames,
                   check         = check,
                   creatingPcAux = FALSE)
    }
    
    check <- env$verbose %in% c(0, 1, 2)
    if(!check) errFun("badVerb")
    
    if(env$verbose > 0) cat("Complete.\n")
}# END checkInputs()



## Check input formatting and cast variables to declared types:
castData <- function(map) {
    if(map$verbose > 0) cat("\nChecking data and information provided...\n")
    
    creatingPcAux <- length(map$time$create) > 0 && length(map$time$mi) == 0 # Are we in createPcAux()?
    nVars         <- ncol(map$data)             # How many variables?
    
    if(map$verbose > 0) cat("--Examining data...")
    ## Count variable levels:
    map$countVarLevels()

    ## Store the initial percent missing:
    map$countResponses(initialPm = TRUE)
    if(map$verbose > 0) cat("done.\n")

    ## Flag variable types:
    if(map$verbose > 0) cat("--Typing data...")
    map$typeData()

    ## If any ID variables are factors, cast them as character objects:
    if(creatingPcAux) map$idToCharacter()
    if(map$verbose > 0) cat("done.\n")

    ## Cast all variables to the appropriate measurement level:
    if(map$verbose > 0) cat("--Casting data...")
    map$castData()

    ## Dummy code nominal variables if in creatPcAux():
    check <- creatingPcAux & length(map$nomVars) > 0
    if(check) map$codeNomVars()
    
    if(map$verbose > 0) cat("done.\n")

    ## Center continuous variables:
    if(creatingPcAux) {
        if(map$verbose > 0) cat("--Centering continuous data...")
        map$centerData()
        if(map$verbose > 0) cat("done.\n")
    }
    
    confirmTypes <- !map$simMode
    if(confirmTypes) {
        map$checkTypes()

        if(length(map$probNoms) > 0) {# Any suspicious nominal variables?
            warnFun("badNoms", map)
            
            map$setTime("usrNomsStr")
            
            userAnswer <-
                readline("Do you want to continue the analysis? (y/N) ")
            ansCheck <- grep("y|yes", userAnswer, ignore.case = TRUE)

            if(length(ansCheck) == 0) {
                errFun("userKill")
            } else {
                cat("\nAs you wish.\n")
            }

            map$setTime("usrNomsEnd")
            
        }

        if(length(map$probOrds) > 0) {# Any suspicious ordinal variables?
            warnFun("badOrds", map)

            map$setTime("usrOrdsStr")
            
            userAnswer <-
                readline("Do you want to continue the analysis? (y/N) ")
            ansCheck <- grep("y|yes", userAnswer, ignore.case = TRUE)

            if(length(ansCheck) == 0) {
                errFun("userKill")
            } else {
                cat("\nAs you wish.\n")
            }

            map$setTime("usrOrdsEnd")
            
        }

        if(length(map$probCons) > 0) {# Any suspicious continuous variables?
            warnFun("badCons", map)

            map$setTime("usrConsStr")
            
            userAnswer <-
                readline("Do you want to continue the analysis? (y/N) ")
            ansCheck <- grep("y|yes", userAnswer, ignore.case = TRUE)

            if(length(ansCheck) == 0) {
                errFun("userKill")
            } else {
                cat("\nAs you wish.\n")
            }

            map$setTime("usrConsEnd")
            
        }
        
    }# CLOSE if(confirmTypes)

    if(map$verbose > 0) cat("Complete.\n")
}# END castData()



## Find and (possibly) remove problematic data columns (i.e., variables with few
## or no observations and constants):
cleanData <- function(map) {
    if(map$verbose > 0)
        cat("\nFinding and addressing problematic data columns...\n")
    
    creatingPcAux <- length(map$pcAux$lin) == 0 # Are we in createPcAux()?
    
    if(creatingPcAux) {
        ## Check for factor id columns
        checkFactors <- sapply(map$idCols, is.factor)
        if(any(checkFactors))
            map$idCols[checkFactors] <- lapply(map$idCols[checkFactors], as.character)
        if(length(map$idVars) > 1) {
            ## Check for missing data on ID variables:
            missIdCounts <- switch(as.character(length(map$idVars)),
                                   "1" = sum(is.na(map$idCols)),
                                   colSums(is.na(map$idCols))
                                   )
            missIds <- map$idVars[missIdCounts > 0]
                    
            ## If there are any missing IDs, fill them with dummy values:
            if(length(missIds) > 1) {# More than 1 incomplete ID
                map$idFills <-
                    lapply(map$idCols, FUN = createDummyIdValues)
                
                ## Fill missing IDs with their dummy values
                for(i in missIds)
                    map$idCols[ , i][is.na(map$idCols[ , i])] <- map$idFills[[i]]
                
            } else if(length(missIds) == 1) {# Only 1 incomplete ID
                map$idFills <- createDummyIdValues(map$idCols[ , missIds])
                map$idCols[ , missIds][is.na(map$idCols[ , missIds])] <-
                    map$idFills
            }
            rm(missIdCounts)
        }# CLOSE if(length(map$idVars) > 1)
    }# CLOSE if(creatingPcAux)
    
    ## Find each variable's number of observations:
    map$countResponses()

    ## Flag empty variables:
    if(map$verbose > 0) cat("--Checking for empty columns...")
    haveEmptyVars <- map$findEmptyVars(remove = creatingPcAux)
    if(map$verbose > 0) cat("done.\n")

    ## Flag constant columns:
    if(map$verbose > 0) cat("--Checking for constant columns...")
    haveConstCols <- map$findConstCols()
    if(map$verbose > 0) cat("done.\n")

    ## Flag variables with few responses:
    if(map$verbose > 0) cat("--Checking for high PM...")
    haveHighPmVars <- map$findHighPmVars()
    if(map$verbose > 0) cat("done.\n")

    if(haveHighPmVars) {# Any low-response variables?
        warnFun("highPm", map)

        map$setTime("usrHighPmStr")
        
        userAnswer <-
            readline("Would you like to remove them from the analysis? (Y/n) ")
        ansCheck <- grep("n|no", userAnswer, ignore.case = TRUE)

        if(length(ansCheck) == 0) {# Remove the low-response variables
            map$removeVars(x = map$highPmVars, reason = "low_resp_rate")
        }

        map$setTime("usrHighPmEnd")
        
        rm(userAnswer)
        rm(ansCheck)
    }

    if(haveEmptyVars) warnFun("emptyVars", map)
    
    if(haveConstCols)
        warnFun(ifelse(creatingPcAux, "pcAuxConstCols", "romConstCols"), map)
    
    if(map$verbose > 0) cat("Complete.\n")
}# END cleanData()



## Flag variables with perfect bivariate correlations (within some epsilon):
findCollin <- function(map) {
    if(map$verbose > 0) cat("\nExamining data for collinear relationships...\n")
    
    ## Get all unique variable pairings:
    varPairs <- NULL
    varPairs <- data.frame(t(utils::combn(colnames(map$data), 2)),
                           stringsAsFactors = FALSE)
    ##If not using any parallel process
    if(map$nProcess == 1)
        linAssocFrame <- data.frame(varPairs,
                                    unlist(
                                        apply(varPairs, 1,
                                              FUN = flexLinearAssoc,
                                              map = map)),
                                    stringsAsFactors = FALSE
                                    )
    else {
        myCluster <- makeCluster(map$nProcess)
        clusterEvalQ(myCluster, library(mice))
        linAssocFrame <- data.frame(varPairs,
                                    unlist(parApply(myCluster, varPairs, 1,
                                                    FUN = flexLinearAssoc,
                                                    map = map)),
                                    stringsAsFactors = FALSE
                                    )
        stopCluster(myCluster)
    }
    colnames(linAssocFrame) <- c("var1", "var2", "coef")
    
    collinFlag <- !is.na(linAssocFrame$coef) &
        abs(linAssocFrame$coef) > map$collinThresh
    
    if(any(collinFlag)) {
        ## Update the data object by removing the collinear variables:
        map$cleanCollinVars(linAssocFrame[collinFlag, ])
        warnFun("collin", map)
    }
    map$corPairs <- linAssocFrame
    if(map$verbose > 0) cat("Complete.\n")
}# END findCollin()



## Do the initial single imputation:
doSingleImputation <- function(map) {
    if(map$verbose > 0) cat("\nDoing initial, single imputation...\n")
    
    ## Construct a design matrix of predictors:
    if(map$verbose > 0) cat("--Constructing predictor matrix...")
    predMat <- makePredMat(map = map)
    if(map$verbose > 0) cat("done.\n")
    
    passCount <- ifelse(map$forcePmm, 1, 0)
    while(passCount < 2) {
        passCount <- passCount + 1
        
        ## Specify a vector of elementary imputation methods:
        if(map$verbose > 0) cat("--Creating method vector...")
        map$createMethVec(initialImp = TRUE)
        if(map$verbose > 0) cat("done.\n")
        
        ## Initially fill-in the data with a single imputation:
        if(map$verbose > 0) cat("--Filling missing values...")
        map$data <- try(
            mice(data            = map$data,
                 maxit           = map$miceIters,
                 m               = 1L,
                 predictorMatrix = predMat,
                 method          = map$methVec,
                 printFlag       = map$verbose > 1,
                 seed            = map$seed,
                 nnet.MaxNWts    = map$maxNetWts,
                 ridge           = map$miceRidge),
            silent = TRUE)
        if(map$verbose > 0) cat("done.\n")
        
        if(class(map$data) != "try-error") { # mice() didn't crash
            ## Record any logged events 
            map$loggedEvents <- as.data.frame(map$data$loggedEvents)
            ## Fill missing values with the imputations
            map$data         <- complete(map$data)
        } else {
            errFun("miceCrash", map = map)
        }
        
        ## Check for any remaining missing data:
        ## NOTE: map$respCounts now contains counts of missing data
        map$countResponses(countMissing = TRUE)
        
        if(all(map$respCounts == 0)) {# All is well :)
            passCount <- 2
            if(map$verbose > 0)
                cat("All variable successfully imputed in first pass.\n")
            return(0)
        } else {
            ## Store names of un-imputed variables:
            map$updateImpFails(x    = colnames(map$data)[map$respCounts > 0],
                               type = switch(passCount, "firstPass", "pmm")
                               )
            warnFun(switch(passCount, "firstImpFail", "pmmFail"), map)
        }
    }# CLOSE while(passCount < 2)
    
    rm(predMat)
    
    ## If there are any more missing data, fill them through mean substitution:
    meanSubstitute(map)

    ## Do a final check for remaining missing values:
    map$countResponses(countMissing = TRUE)
    
    if(any(map$respCounts > 0)) {
        ## If any missingness remains exclude the incomplete columns:
        map$updateImpFails(
                colnames(map$data)[map$respCounts > 0], type = "grandMean"
            )
        warnFun("grandMeanFail", map)
        
        map$removeVars(x      = colnames(map$data)[map$respCounts > 0],
                       reason = "imp_fail")
    }# CLOSE if( any(map$respCounts > 0) )
    
    if(map$verbose > 0) cat("Complete.\n")
}# END doSingleImputation()

     
  
## Implement group-mean substitution:
doGroupMeanSub <- function(map) {
    ## Construct the grouping patterns:
    map$createPatterns()

    for(j in 1 : 2) {
        if(j == 2) {
            ## If the initial group-mean substition isn't fully successful,
            ## reverse the order of the grouping variables and recreate the
            ## patterns
            map$groupVars <- rev(map$groupVars)
            map$createPatterns()
        }

        for(i in 1 : length(map$patterns)) {
            ## Find the unique grouping patterns
            patLevels <- unique(map$patterns[[i]])

            ## Fill the missing data with approprite group means:
            if(sum(map$respCounts > 0) > 1) 
                map$data[ , map$respCounts > 0] <-
                    data.frame(
                        lapply(map$data[ , map$respCounts > 0],
                               FUN     = fillWithGroupMean,
                               pat     = map$patterns[[i]],
                               patLevs = patLevels)
                    )
            else 
                map$data[ , map$respCounts > 0] <-
                    fillWithGroupMean(map$data[ , map$respCounts > 0],
                                      pat     = map$patterns[[i]],
                                      patLevs = patLevels)
            
            map$countResponses(countMissing = TRUE)
            if(all(map$respCounts == 0)) return(0)

            ## Re-create the patterns to incorporate the grouping variables
            ## imputed values
            map$createPatterns()
        }
    }
}# END doGroupMeanSub()
    


## Fill a variable's missing values with appropriate group-means:
fillWithGroupMean <- function(v, pat, patLevs) {
    for(k in 1 : length(patLevs)) {
        subData <- subset(v, pat == patLevs[k])
        
        if(all(is.na(subData))) tmp <- NA
        else                    tmp <- flexCenTen(subData)
        
        ## With multiple modes, break ties randomly:
        groupMean <- ifelse(length(tmp) > 1, sample(tmp, size = 1), tmp)
        
        ## Make sure the group mean is non-missing and finite:
        badMean <- is.na(groupMean) | is.nan(groupMean) |
            is.infinite(groupMean) | is.null(groupMean)
        
        if(!badMean) v[pat == patLevs[k] & is.na(v)] <- groupMean
    }
    v
}# END fillWithGroupMean()



doGrandMeanSub <- function(map) {
    missCols <- map$respCounts > 0

    if(sum(missCols) == 1) 
        map$data[ , missCols][is.na(map$data[ , missCols])] <-
            flexCenTen(map$data[ , missCols])
    else 
        map$data[ , missCols] <-
            do.call(data.frame,
                    lapply(map$data[ , missCols],
                           FUN = function(x) {
                               x[is.na(x)] <- flexCenTen(x)
                               x
                           })
                    )
}# END doGrandMeanSub()
    


## Do the various flavors of mean substitution:
meanSubstitute <- function(map) {
    if(missCheck(map$groupVars)) {# No grouping variables
        warnFun("noGroupVars", map)
        
        if(map$verbose > 0) cat("--Filling missing values...")
        doGrandMeanSub(map)
        if(map$verbose > 0) cat("done.\n")
        
        return(1)
    }  
    
    ## Make sure we don't try to use dropped grouping variables:
    map$groupVars <- setdiff(map$groupVars, map$dropVars[ , 1])
    
    if(missCheck(map$groupVars)) {# All groupVars have been dropped
        warnFun("dropGroupVars", map)
        
        if(map$verbose > 0) cat("--Filling missing values...")
        doGrandMeanSub(map)
        if(map$verbose > 0) cat("done.\n")

        return(2)
    }
    
    ## Try group-mean substitution:
    if(map$verbose > 0) cat("--Filling missing values...")
    doGroupMeanSub(map)
    if(map$verbose > 0) cat("done.\n")
    
    if(any(map$respCounts > 0)) {# Still have missing?
        ## If all else fails, do global-mean substitution
        map$updateImpFails(
                colnames(map$data)[map$respCounts > 0], "groupMean"
            )
        warnFun("groupMeanFail", map)
        
        if(map$verbose > 0) cat("--Filling missing values...")
        doGrandMeanSub(map)
        if(map$verbose > 0) cat("done.\n")
    }
}# END meanSubstitute()



doPCA <- function(map) {
    ## Are we extracting linear or nonlinear PC scores?
    if(length(map$pcAux$lin) == 0) {linVal <- "lin";    pcType <- 1}
    else                           {linVal <- "nonLin"; pcType <- 2}
    
    ## Do we need to parse the nComps argument?
    parseCheck <- is.infinite(map$nComps[pcType]) |
        (map$nComps[pcType] < 1 & map$nComps[pcType] != 0)
    
    if(linVal == "lin") {
        if(map$verbose > 0)
            cat("\nCalculating linear principal component scores...\n")

        if(map$intMeth != 1 & map$maxPower > 1) {
            ## Replace the raw polinomial values with the imputed versions from
            ## the data:
            map$poly <- map$data[ , colnames(map$poly)]
            ## Remove polynomial terms from the data before extracting linear
            ## PcAux:
            map$data <- with(map,
                             data[ , setdiff(colnames(data), colnames(poly))]
                             )
        }
        
        ## Cast ordinal factors to numeric formats:
        if(!missCheck(map$ordVars)) map$castOrdVars() 
        ## Dummy code nominal variables:
        if(!missCheck(map$nomVars)) map$castNomVars() 

        ## Cast any remaining factors to numeric formats:
        check <- sapply(map$data, is.factor)
        if(sum(check) > 1)
            map$data[ , check] <- data.frame(lapply(map$data[ , check], f2n))
        if(sum(check) == 1)
            map$data[ , check] <- f2n(map$data[ , check])
        
        if(!map$simMode & !parseCheck) {
            ## Make sure the number of PC scores we want is less than the number
            ## of columns in our data object:
            if(map$nComps[1] > ncol(map$data)) {
                warnFun("linPcNum", map)
                map$nComps[1] <- ncol(map$data)
            }
        }
    } else {# We already have linear component scores
        if(map$verbose > 0)
            cat("\nCalculating nonlinear principal component scores...\n")

        ## Redefine the data object:
        if(map$intMeth > 1) map$data <- map$interact
        
        if(map$maxPower > 1) {
            ## Orthogonalize the polynomial terms w.r.t. the linear PcAux:
            map$poly <- data.frame(
                lapply(map$poly,
                       function(y, pc)
                           .lm.fit(y = y, x = as.matrix(pc))$residuals,
                       pc = with(map,
                                 pcAux$lin[ , setdiff(colnames(pcAux$lin),
                                                      idVars)]
                                 )
                       )
            )
            if(map$intMeth > 1) map$data <- data.frame(map$data, map$poly)
            else                map$data <- map$poly
        }
        colnames(map$data) <- c(colnames(map$interact), colnames(map$poly))
        
        ## Remove the contents of the 'interact' and 'poly' fields when they are
        ## no longer necessary:
        map$interact <- "Removed to save resources"
        map$poly     <- "Removed to save resources"
        
        if(!map$simMode & !parseCheck) {
            ## Make sure the number of PC scores we want is less than
            ## the number of columns in our data object:
            if(map$nComps[2] > ncol(map$data)) {
                warnFun("nonLinPcNum", map)
                map$nComps[2] <- ncol(map$data)
            }
        }
    }# CLOSE if(length(map$pcAux$lin) == 0)

    ## Execute the principal component analysis:
    if(map$pcaMemLev == 0) {
        ## Higher numerical accuracy, but more memory usage
        pcaOut <- prcomp(map$data, scale = TRUE, retx  = TRUE)
        
        ## Compute and store the cumulative proportion of variance explained by
        ## the component scores:
        map$rSquared[[linVal]] <- cumsum(pcaOut$sdev^2) / sum(pcaOut$sdev^2)
        
        ## Set component counts when some are defined in terms of variance
        ## explained:
        if(parseCheck) map$setNComps(type = pcType)
                
        ## Extract the principal component scores:
        if(length(map$idCols) == 0)
            map$pcAux[[linVal]] <- pcaOut$x[ , 1 : map$nComps[pcType]]
        else
            map$pcAux[[linVal]] <-
                data.frame(map$idCols, pcaOut$x[ , 1 : map$nComps[pcType]])
    } else if(map$pcaMemLev == 1) {
        ## Save memory at the expense of numerical accuracy
        pcaOut <-
            simplePca(map = map, lv = pcType, parse = parseCheck, scale = TRUE)
    } else {
        errFun("badPcaMemLev", map = map)
    }
        
    ## Remove the contents of the 'data' field when they're no longer needed:
    if(linVal == "nonLin") map$data <- "Removed to save resources"
    
    ## Give some informative column names:
    colnames(map$pcAux[[linVal]]) <-
        c(map$idVars,
          paste0(ifelse(linVal == "lin", "linPC", "nonLinPC"),
                 c(1 : map$nComps[ifelse(linVal == "lin", 1, 2)])
                 )
          )    
    if(map$verbose > 0) cat("Complete.\n")
}# END doPCA()



## Construct one imputed data set with mice for use in parallel processing
parallelMice <- function(imp, predMat, map) {
    ## Setup the PRNG:
    tmpSeed <- ifelse(is.na(map$seed), round(runif(1, 1, 1e6)), map$seed)
    .lec.SetPackageSeed(rep(tmpSeed, 6))
    if(!imp %in% .lec.GetStreams()) .lec.CreateStream(c(1 : map$nImps))
    .lec.CurrentStream(imp)
    
    ## Create a single imputation:
    miceOut <- try(
        mice(data            = map$data,
             m               = 1L,
             maxit           = 1L,
             predictorMatrix = predMat,
             method          = map$methVec,
             printFlag       = map$verbose > 1,
             ridge           = map$miceRidge,
             nnet.MaxNWts    = map$maxNetWts),
        silent = FALSE)
    
    if(class(miceOut) != "try-error") {
        impData <- complete(miceOut, 1)
    } else {
        impData <- NULL
        warnFun("miceCrash",
                map = list(impNum = imp, miceObj = miceOut)
                )
    }
    impData
}
