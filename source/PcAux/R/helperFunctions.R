### Title:    PcAux Helper Functions
### Author:   Kyle M. Lang
### Created:  2015-AUG-03
### Modified: 2017-MAR-27

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


## Print startup message:
.onAttach <- function(libname, pkgname) {
    version <- read.dcf(file = system.file("DESCRIPTION", package = pkgname),
                        fields = "Version")
    packageStartupMessage(
        "Loading: ", paste(pkgname, version), ", Copyright (C) 2017 Kyle M. Lang."
    )
    packageStartupMessage(
        pkgname, " comes with ABSOLUTELY NO WARRANTY; execute 'pcAuxW()' for details."
    )
    packageStartupMessage(
        pkgname, " is beta software. Please report any bugs. Thank You."
    )
}



## Count levels of variables:
countLevels <- function(x) length(unique(na.omit(x)))



### Create a set of dummy ID values ensured to be disjoint from the observed IDs
### to use as temporary fill-ins for missing IDs:
createDummyIdValues <- function(x) {
    varType <- class(x)
    if(varType == "numeric" | varType == "integer")
        idFills <- 2 * max(x, na.rm = TRUE) + c(0 : (sum(is.na(x)) - 1))
    else if(varType == "character")
        idFills <- paste0("dummyID", c(1 : sum(is.na(x))))
    idFills
}# END createDummyIdValues()



### Calculate various kinds of 'correlation' coefficient:
flexLinearAssoc <- function(varNames, map, checkMat = FALSE, autoType = FALSE)
{
    options(warn = -1)# Suppress warnings
    
    ## Find the class of the target variables:
    if(autoType) {# HACK: Find a better way to do this.
        varType <- rep("continuous", 2)
        tmp     <- map$data[ , varNames]
        
        check <- unlist(lapply(tmp, is.factor))
        if(any(check)) varType[check] <- "nominal"
        
        check <- unlist(lapply(tmp, is.ordered))
        if(any(check)) varType[check] <- "ordinal"
    } else {
        varType <- map$typeVec[varNames]
    }
    
    if(.Platform$OS.type == "unix") nullFile <- "/dev/null"
    else                            nullFile <- "nul"

    sink(nullFile)# Suppress output

    ## Check for pairwise available obvservations
    pairwiseCheck <- mean(
        apply(!is.na(map$data[ , varNames]), 1, all)
    )

    if(pairwiseCheck != 0) {
        ## Compute an appropriate measure of linear association:
        if( all(varType == "continuous") ) {
            ## Pearson's R for two continuous
            corVal <- cor(map$data[ , varNames[1] ],
                          map$data[ , varNames[2] ],
                          method = "pearson",
                          use = "pairwise")
            corType <- "pearson"
        }
        else if( all(varType == "ordinal") ) {
            ## Spearman's Rho for two ordinal
            corVal <- cor(as.numeric(map$data[ , varNames[1] ]),
                          as.numeric(map$data[ , varNames[2] ]),
                          method = "spearman",
                          use = "pairwise")
            corType <- "spearman"
        }
        else if( all(varType == "nominal" | varType == "binary") ) {
            ## Cramer's V for two nominal
            corVal <- vcd::assocstats( table(map$data[ , varNames]) )$cramer
            corType <- "cramer"
        }
        else if(all(varType == "ordinal" |
                        varType == "nominal" |
                            varType == "binary") ) {
            ## Cramer's V for nominal and ordinal
            corVal <- vcd::assocstats( table(map$data[ , varNames]) )$cramer
            corType <- "cramer"
        }
        else if( all(varType == "continuous" | varType == "ordinal") ) {
            ## Spearman's Rho for continuous and ordinal
            corVal <- cor(as.numeric(map$data[ , varNames[1] ]),
                          as.numeric(map$data[ , varNames[2] ]),
                          method = "spearman",
                          use = "pairwise")
            corType <- "spearman"
        }
        else if(all(varType == "continuous" |
                        varType == "nominal" |
                            varType == "binary") ) {
            ## Itra-class correlation for continuous and nominal
            nomVar  <- varNames[varType == "nominal" | varType == "binary"]
            contVar <- varNames[varType == "continuous"]
            corVal  <- ICC::ICCbare(x = nomVar, y = contVar, data = map$data)
            corType <- "icc"
        }
        else {
            ## NA for unrecognized class pairs
            corVal <- NA
        }
    }
    else {
        ## NA with no pairwise available data
        corVal <- NA
    }

    sink()# Stop suppressing output
    options(warn = 0)# Back to defaults

    outList <- list(value = corVal)
    if(checkMat) {
        outList$corType  <- corType
        outList$varTypes <- varType
    }
    outList
}# END flexLinearAssoc()



### Compute several measures of central tendency:
flexCenTen <- function(x) {
    varType <- class(x)[1]
    if(varType == "numeric" | varType == "integer") {
        ## Mean for continuous variables
        cenVal <- mean(x, na.rm = TRUE)
    }
    else if(varType == "factor" |
            varType == "ordered" |
            varType == "character") {
        ## Mode for nominal and ordinal variables
        tmpTab <- table(x)
        cenVal <- names(tmpTab)[tmpTab == max(tmpTab)]
        if(length(cenVal) > 1) cenVal <- sample(cenVal, 1)
    }
    else {
        cenVal <- NA
    }
    cenVal
}# END flexCenTen()



missCheck <- function(x) {
    if(missing(x)) return(TRUE)
    if(!is.object(x)) {
        if(length(x) == 0) return(TRUE)
        if(length(x) == 1 & is.null(x) || is.na(x) || x == "") return(TRUE)
    }
    FALSE
}



### Do a simple PCA while trying to minimize memory usage:
simplePca <- function(map, lv, parse, scale = TRUE)
{
    ## Scale the raw data:
    if(scale) {
        for(i in 1 : ncol(map$data)) {
            map$data[ , i] <-
                (map$data[ , i] - mean(map$data[ , i])) / sd(map$data[ , i])
        }
    }

    ## Get the eigen decomposition
    eigenOut <- eigen(cov(map$data), symmetric = TRUE)

    ## Due to numerical instability, some eigenvalues stray below zero.
    ## Replace such values with zero:
    eigenOut$values[eigenOut$values < 0.0] <- 0.0

    ## Compute the proportions of variance explained:
    map$rSquared[[lv]] <- eigenOut$values
    map$calcRSquared()

    ## Set component counts when some are defined by variance explained:
    if(parse) map$setNComp(type = lv)
    
    nc <- map$nComps[lv]
    
    ## Compute and save the PcAux scores:
    if(is.null(map$idCols))
        map$pcAux[[lv]] <- data.frame(
            as.matrix(map$data) %*% eigenOut$vectors[ , 1 : nc]
        )
    else
        map$pcAux[[lv]] <- data.frame(
            map$idCols,
            as.matrix(map$data) %*% eigenOut$vectors[ , 1 : nc]
        )
}# END simplePca()



warnFun <- function(type, map) {
    ## Select an appropriate warning message:
    warnMessage <-
        switch(type,
               badNoms =
                   paste0("The following variables have ",
                          "been declared as nominal: ",
                          toString(map$probNoms),
                          ", but they take: ",
                          toString(map$levelVec[colnames(map$data) %in%
                                                map$probNoms]),
                          " levels, respectively.\n"),
               badOrds =
                   paste0("The following variables have ",
                          "been declared as ordinal: ",
                          toString(map$probOrds),
                          ", but they take: ",
                          toString(map$levelVec[colnames(map$data) %in%
                                                map$probOrds]),
                          " levels, respectively.\n"),
               badCons =
                   paste0("The following variables have ",
                          "been declared as continuous: ",
                          toString(map$probCons),
                          ", but they only take: ",
                          toString(map$levelVec[colnames(map$data) %in%
                                                map$probCons]),
                          " levels, respectively.\n"),
               highPm =
                   paste0("The following variables have fewer than ",
                          map$minRespCount,
                          " observed responses: ",
                          toString(map$highPmVars),
                          ".\n"),
               emptyVars =
                   paste0("The following variables have ",
                          "no observed responses ",
                          "and have been excluded from ",
                          "the data analysis: ",
                          toString(map$emptyVars),
                          ".\n"),
               pcAuxConstCols =
                   paste0("The following data columns ",
                          "are constants ",
                          "and have been excluded from ",
                          "the data analysis: ",
                          toString(map$constants),
                          ".\n"),
               romConstCols =
                   paste0("The following data columns ",
                          "are constants: ",
                          toString(map$constants),
                          ".\n Their missing data have been ",
                          "replaced with the appropriate ",
                          "constant value.\n"),
               collin = {
                   tmpDropNames <-
                       map$dropVars[map$dropVars[ , 2] == "collinear", 1]
                   prettyPairs <- toString(
                       apply(map$collinVars, 1,
                             FUN = function(x) {
                                 paste0("{", x[1], ", ", x[2], "}")
                             }
                             )
                   )
                   paste0("The following variable pairs ",
                          "are bivariate collinear: ",
                          prettyPairs,
                          ", so ",
                          toString(tmpDropNames),
                          " will be excluded from ",
                          "further analysis.\n")
               },
               firstImpFail =
                   paste0("First-pass imputation has failed ",
                          "for the following variables: ",
                          toString(map$impFails$firstPass),
                          ".\nI will now attempt to fill their missing ",
                          "data by using predictive mean matching (PMM).\n"),
               pmmFail =
                   paste0("Predictive mean matching has failed ",
                          "for the following variables: ",
                          toString(map$impFails$pmm),
                          ".\nI will now attempt to fill their missing ",
                          "data by using group-mean substitution.\n"),
               groupMeanFail =
                   paste0("Group-mean substitution has failed ",
                          "for the following variables: ",
                          toString(map$impFails$groupMean),
                          ".\nI will now fill their missing ",
                          "data by using grand-mean substitution.\n"),
               noGroupVars =
                   paste0("No grouping variables were specified, ",
                          "so I will employ grand-mean substitution ",
                          "to treat the following variables: ",
                          toString(map$impFails$pmm),
                          ".\n"),
               dropGroupVars =
                   paste0("All grouping variables have been dropped, ",
                          "so I will employ grand-mean substitution ",
                          "to treat the following variables: ",
                          toString(map$impFails$pmm),
                          ".\n"),
               grandMeanFail =
                   paste0("Grand-mean substitution has failed ",
                          "for the following variables: ",
                          toString(map$impFails$grandMean),
                          ".\nThese variables will be exluded from ",
                          "subsequent analyses.\n"),
               linPcNum = {
                   datCols <- ncol(map$data)
                   nComps <- map$nComps[1]
                   paste0("The number of linear principal component ",
                          "scores that you requested (i.e., ",
                          nComps,
                          ") is greater than the number of remaining ",
                          "columns in your data object (i.e., ",
                          datCols,
                          "). So, nComps[1] will be set to: ",
                          datCols,
                          ".\n")
               },
               nonLinPcNum = {
                   datCols <- ncol(map$data)
                   nComps <- map$nComps[2]
                   paste0("The number of nonlinear principal component ",
                          "scores that you requested (i.e., ",
                          nComps,
                          ") is greater than the number of remaining ",
                          "columns in your data object (i.e., ",
                          datCols,
                          "). So, nComps[2] will be set to: ",
                          datCols,
                          ".\n")
               },
               mergeNoID =
                   "No ID variables are shared by the PcAuxData object and the raw data, so the merging was accomplished via naive column-binding.\nPlease confirm the output object's row alignment.\n",
               mergeBadID =
                   paste0("None of the potential ID variables (i.e., ",
                          toString(map$idVars),
                          ") are unique row-identifiers, so the ",
                          "merging was accomplished via naive column-binding.\n",
                          "Please confirm the output object's row alignment.\n"),
               miceCrash =
                   paste0("The mice() algorithm has crashed while creating ",
                          "imputation number ",
                          map$impNum,
                          "and returned the following error message:\n",
                          map$miceObj,
                          "\n"),
               noMods =
                   "You have specified 'interactType = 1' without specifying any moderators, so I will incorporate all pairwise interactions among the observed variables into the initial imputation model.\n",
               collinMods = {
                   val <- map[ , 3]
                   paste0("Two of your moderator variables (i.e., ",
                          toString(map[ , 1 : 2]),
                          ") are ",
                          ifelse(val < 1, "approximately", "exactly"),
                          " collinear. Their strength of linear association is ",
                          round(val, 3),
                          ". This collinearity may lead to numerical problems ",
                          "when estimating the initial imputation model.\n")
               },
               nonLinPcAuxClash =
                   "You have requested a non-trivial number of non-linear PcAux scores while specifying interactType == 1.\nNonlinearities will be directly incorporated into the linear PcAux scores, and no distinct non-linear PcAux scores will be extracted.\n"
               )

    ## Print the warning message
    options(warn = 1) # Print warnings immediately
    warning(warnMessage, call. = FALSE)
    options(warn = 0) # Back to normal
}# END warnFun()



errFun <- function(type, ...) {
    x <- list(...) # Unpack extra arguments

    ## Select the appropriate error message:
    errMessage <-
        switch(type,
               noData =
                   "Please provide a data object for the rawData argument.\n",
               badDataType =
                   "Please provide a data frame or matrix for the rawData argument.\n",
               noPcAuxData =
                   "Please provide an instantiated PcAuxData object for the pcAuxData argument.\n",
               noNComps =
                   "Please provide a two-element numeric vector for the 'nComps' argument.\n",
               smallPower =
                   "maxPolyPow must be a positive integer.\n",
               largePower =
                   "Polynomial powers greater than 4 are not supported.\n",
               noLinPcAux =
                   paste0("You must ",
                          ifelse(x$creatingPcAux, "extract", "use"),
                          " at least 1 linear auxiliary principal component ",
                          "score. You have requested 0.\n"),
               nonLinOptionClash =
                   paste0("You have requested a non-trivial number of ",
                          "non-linear principal component scores (i.e., ",
                          x$nNonLinear,
                          "), but you have also told me not to compute any ",
                          "interactions or polynomial terms.\nI am confused.\n",
                          "Could you please adjust the values supplied to the ",
                          "'nComps', 'interactType', and 'maxPolyPow' ",
                          "arguments so that they are consistent?\n"),
               badVerb =
                   "The value supplied for the 'verbose' argument must be an integer in {0, 1, 2}.\n",
               missingVars =
                   paste0("Some of the arguments you've supplied correspond ",
                          "to variables that do not exist in the data object.\n",
                          "The problematic variables are: ",
                          toString(x$varNames[x$check]),
                          ".\n"),
               dropVarOverlap =
                   paste0("The set of variable names supplied for the ",
                          "'dropVars' argument overlaps with the variable ",
                          "names supplied for other arguments.\nThe ",
                          "problematic variables are: ",
                          toString(unique(x$varNames[x$check])),
                          ".\nPlease ensure that 'dropVars' and ",
                          "c('idVars', 'nomVars', 'ordVars', 'groupVars') ",
                          "are disjoint sets.\n"),
               idOverlap = {
                   tmpVec <-
                       ifelse(
                           x$creatingPcAux,
                           "c('nomVars', 'ordVars', 'groupVars', 'dropVars') ",
                           "c('nomVars', 'ordVars', 'dropVars') "
                       )
                   paste0("The set of variable names supplied ",
                          "for the 'idVars' argument overlaps ",
                          "with the variable names supplied for other ",
                          "arguments.\nThe problematic variables are: ",
                          toString(unique(x$varNames[x$check])),
                          ".\nPlease ensure that 'idVars' and ",
                          tmpVec,
                          "are disjoint sets.\n")
               },
               userKill =
                   "Execution stopped by user.\n",
               miceCrash =
                   paste0("The mice() algorithm has crashed ",
                          "and returned the following error message:\n",
                          x$map$data,
                          "\n"),
               badPcaMemLev =
                   paste0("An unrecognized value has been specified ",
                          "for the 'pcaMemLevel' argument (i.e., ",
                          x$map$pcaMemLev,
                          ").\nPlease provide a value of '0' ",
                          "or '1' for this argument.\n"),
               missingNonLinPcAux =
                   "You have requested the use of non-linear principal component scores, but 'pcAuxData' does not contain any non-linear principal component scores.\n Please adjust your analysis accordingly.\n",
               linVarExp =
                   paste0("The number of available linear ",
                          "component scores (i.e., ",
                          x$pcAuxData$nComps[1],
                          ") cannot explain the requested ",
                          "proportion of variance (i.e., ",
                          x$varExp[1],
                          ").\nPlease consult the output of: ",
                          "'inspect(pcAuxData, what = \"rSquared\")' ",
                          "for more details.\n"),
               fewLinPcAux =
                   paste0("The number of linear component scores you ",
                          "requested (i.e., ",
                          x$nComps[1],
                          ") is greated than the number of linear component ",
                          "scores available in 'pcAuxData' (i.e., ",
                          x$pcAuxData$nComps[1],
                          ").\nPlease adjust your analysis accordingly.\n"),
               nonLinVarExp =
                   paste0("The number of available non-linear ",
                          "component scores (i.e., ",
                          x$pcAuxData$nComps[2],
                          ") cannot explain the requested ",
                          "proportion of variance (i.e., ",
                          x$varExp[2],
                          ").\nPlease consult the output of: ",
                          "'inspect(pcAuxData, what = \"rSquared\")' ",
                          "for more details.\n"),
               fewNonLinPcAux =
                   paste0("The number of non-linear component scores you ",
                          "requested (i.e., ",
                          x$nComps[2],
                          ") is greated than the number of non-linear component ",
                          "scores available in 'pcAuxData' (i.e., ",
                          x$pcAuxData$nComps[2],
                          ").\nPlease adjust your analysis accordingly.\n")
               )# CLOSE switch()

    stop(errMessage, call. = FALSE)
}# END errFun()



makePredMat <- function(map) {
    options(warn = -1)
    ## Construct a predictor matrix for mice():
    predMat <- quickpred(map$data, mincor = map$minPredCor, exclude = map$idVars)
    
    ## Make sure we have fewer predictors than rows:
    badPredFlag <- rowSums(predMat) > (nrow(map$data) - 1)
    
    if(any(badPredFlag)) {# Some models have P > (N - 1)
        badVars <- colnames(map$data)[badPredFlag]
        for(v in badVars) {
            ## Get names of potential predictors:
            candidates <- setdiff(colnames(map$data), c(map$dropVars[ , 1], v))
            
            ## Find the bivariate linear associations with the target:
            tmp <- unlist(
                lapply(candidates,
                       FUN = function(x, y, map)
                           flexLinearAssoc(varNames = c(x, y),
                                           map      = map,
                                           autoType = TRUE)$value,
                       y   = v,
                       map = map)
            )
            ## Select the strongest N - 1 candidates to use as predictors:
            predNames <- candidates[order(abs(tmp))][1 : (nrow(map$data) - 1)]
            ## Modify the predictor matrix accordingly:
            predMat[v, ] <- 0
            predMat[v, colnames(predMat) %in% predNames] <- 1
        }
    }
    options(warn = 0)
    predMat
}# END makePredMat()
