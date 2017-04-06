### Title:        PcAuxData Reference Class Definition
### Author:       Kyle M. Lang
### Contributors: Byung Jung, Vibhuti Gupta
### Created:      2015-OCT-30
### Modified:     2017-MAR-27
### Note:         PcAuxData is the metadata class for the PcAux package.

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


#################################################################################
#####----------------------- DEFINE CLASS & FIELDS -------------------------#####
#################################################################################

PcAuxData <- setRefClass("PcAuxData",

                         fields = list(
                             call         = "list",
                             data         = "ANY",
                             seed         = "integer",
                             miceIters    = "integer",
                             miceRidge    = "numeric",
                             maxNetWts    = "integer",
                             forcePmm     = "logical",
                             typeVec      = "vector",
                             methVec      = "vector",
                             nComps       = "vector",
                             respCounts   = "vector",
                             initialPm    = "vector",
                             nomVars      = "vector",
                             ordVars      = "vector",
                             idVars       = "vector",
                             dropVars     = "matrix",
                             nomMaxLev    = "integer",
                             ordMaxLev    = "integer",
                             conMinLev    = "integer",
                             probNoms     = "vector",
                             probOrds     = "vector",
                             probCons     = "vector",
                             levelVec     = "vector",
                             simMode      = "logical",
                             highPmVars   = "vector",
                             emptyVars    = "vector",
                             constants    = "vector",
                             minRespCount = "integer",
                             verbose      = "integer",
                             groupVars    = "vector",
                             intVars      = "vector",
                             pcAux        = "list",
                             rSquared     = "list",
                             pcaMemLev    = "integer",
                             maxPower     = "integer",
                             interact     = "ANY",
                             poly         = "ANY",
                             collinThresh = "numeric",
                             minPredCor   = "numeric",
                             nGVarCats    = "integer",
                             collinVars   = "data.frame",
                             impFails     = "list",
                             patterns     = "list",
                             frozenGVars  = "ANY",
                             idFills      = "ANY",
                             nImps        = "integer",
                             compFormat   = "character",
                             miDatasets   = "ANY",
                             miceObject   = "ANY",
                             nProcess     = "integer",
                             moderators   = "character",
                             intMeth      = "integer",
                             idCols       = "ANY",
                             dumNoms      = "ANY",
                             facNoms      = "ANY"
                         )# END fields
                         )# END PcAuxData


#################################################################################
#####---------------------------- DEFINE METHODS ---------------------------#####
#################################################################################

PcAuxData$methods(

    ##------------------------------ Constructor ------------------------------##

    initialize     = function(
        call         = list(
            prepData    = NULL,
            createPcAux = NULL,
            miWithPcAux = NULL
        ),
        data         = data.frame(NULL),
        seed         = as.integer(NA),
        miceIters    = 10L,
        miceRidge    = 1.0e-5,
        maxNetWts    = 10000L,
        forcePmm     = FALSE,
        typeVec      = vector("character"),
        methVec      = vector("character"),
        nComps       = vector("integer"),
        respCounts   = vector("numeric"),
        initialPm    = vector("numeric"),
        nomVars      = vector("character"),
        ordVars      = vector("character"),
        idVars       = vector("character"),
        dropVars     = matrix(NA, 1, 2),
        nomMaxLev    = 10L,
        ordMaxLev    = 10L,
        conMinLev    = 10L,
        probNoms     = vector("character"),
        probOrds     = vector("character"),
        probCons     = vector("character"),
        levelVec     = vector("integer"),
        simMode      = FALSE,
        highPmVars   = vector("character"),
        emptyVars    = vector("character"),
        constants    = vector("character"),
        minRespCount = as.integer(floor(0.05 * nrow(data))),
        verbose      = 0L,
        groupVars    = vector("character"),
        intVars      = vector("character"),
        pcaMemLev    = 0L,
        maxPower     = 3L,
        interact     = NULL,
        poly         = NULL,
        collinThresh = 0.95,
        minPredCor   = 0.1,
        nGVarCats    = 3L,
        collinVars   = data.frame(NULL),
        patterns     = list(),
        frozenGVars  = NULL,
        idFills      = list(),
        pcAux        = list(
            lin    = data.frame(NULL),
            nonLin = data.frame(NULL)
        ),
        rSquared     = list(
            lin    = vector("numeric"),
            nonLin = vector("numeric")
        ),
        impFails     = list(
            firstPass = vector("character"),
            pmm       = vector("character"),
            groupMean = vector("character"),
            grandMean = vector("character")
        ),
        nImps        =  0L,
        compFormat   = "",
        miDatasets   = NULL,
        miceObject   = NULL,
        nProcess     = 1L,
        moderators   = vector("character"),
        intMeth      = 0L,
        idCols       = NULL,
        dumNoms      = data.frame(NULL),
        facNoms      = data.frame(NULL)
    )                                                                           {
        "Initialize an object of class PcAuxData"
        call         <<- call
        data         <<- data[ , setdiff(colnames(data), dropVars)]
        dropVars     <<- cbind(dropVars, "user_defined")
        seed         <<- seed
        miceIters    <<- miceIters
        miceRidge    <<- miceRidge
        maxNetWts    <<- maxNetWts
        forcePmm     <<- forcePmm
        typeVec      <<- typeVec
        methVec      <<- methVec
        nComps       <<- nComps
        respCounts   <<- respCounts
        initialPm    <<- initialPm
        nomVars      <<- nomVars
        ordVars      <<- ordVars
        idVars       <<- idVars
        nomMaxLev    <<- nomMaxLev
        ordMaxLev    <<- ordMaxLev
        conMinLev    <<- conMinLev
        probNoms     <<- probNoms
        probOrds     <<- probOrds
        probCons     <<- probCons
        levelVec     <<- levelVec
        simMode      <<- simMode
        highPmVars   <<- highPmVars
        emptyVars    <<- emptyVars
        constants    <<- constants
        minRespCount <<- minRespCount
        verbose      <<- verbose
        groupVars    <<- groupVars
        pcaMemLev    <<- pcaMemLev
        maxPower     <<- maxPower
        poly         <<- poly
        pcAux        <<- pcAux
        rSquared     <<- rSquared
        impFails     <<- impFails
        intVars      <<- intVars
        interact     <<- interact
        collinThresh <<- collinThresh
        minPredCor   <<- minPredCor
        nGVarCats    <<- nGVarCats
        collinVars   <<- collinVars
        patterns     <<- patterns
        frozenGVars  <<- frozenGVars
        idFills      <<- idFills
        nImps        <<- nImps
        compFormat   <<- compFormat
        miDatasets   <<- miDatasets
        miceObject   <<- miceObject
        nProcess     <<- nProcess
        moderators   <<- moderators
        intMeth      <<- intMeth
        idCols       <<- idCols
        dumNoms      <<- dumNoms
        facNoms      <<- facNoms
    },

    ##------------------ "Overloaded" / Non-Standard Mutators -----------------##
    setCall         = function(x, parent)                                       {
        if     (parent == "prepData"        ) call[[1]] <<- x
        else if(parent == "createPcAux"     ) call[[2]] <<- x
        else if(parent == "miWithPcAux"     ) call[[3]] <<- x
        else                                  stop("Invalid 'parent' argument.")
    },

    setPoly         = function(x, power = NULL)                                 {
        "Modify the list of polynomial expansions of 'data'"
        if(is.null(power)) poly          <<- x
        else               poly[[power]] <<- x
    },

    setPcAux        = function(x, type = NULL)                                  {
        "Modify the list of principal component auxiliaries"
        if     (is.null(type)      ) pcAux        <<- x
        else if(type == "linear"   ) pcAux$lin    <<- x
        else if(type == "nonLinear") pcAux$nonLin <<- x
        else                         stop("Invalid pcAux type.")
    },

    setRSquared     = function(x, type = NULL)                                  {
        "Modify the list of R-Squared values for the PcAux scores"
        if     (is.null(type)      ) rSquared        <<- x
        else if(type == "linear"   ) rSquared$lin    <<- x
        else if(type == "nonLinear") rSquared$nonLin <<- x
        else                         stop("Invalid rSquared type.")
    },

    setControl      = function(x)                                               {
        "Assign the control parameters"
        nonInts <- c("minPredCor", "collinThresh", "miceRidge")
        
        for(n in names(x)) {
            if(n %in% nonInts) field(n, x[[n]])
            else               field(n, as.integer(x[[n]]))
        }
    },

    updateImpFails   = function(x, type)                                        {
        "Update the list of imputation failure records"
        impFails[[type]] <<- x
    },

    setMethVec     = function(x, index = NULL)                                  {
        "Update the elementary imputation method vector"
        if(is.null(index)) methVec        <<- x
        else               methVec[index] <<- x
    },
    
    setNComps       = function(type)                                            {
        "Set the number of PcAux to extract"
        r2 <- rSquared[[type]]
        nc <- nComps[type]
        if(is.infinite(nc)) {
            tmp          <-  which(r2[-length(r2)] == r2[-1])
            nComps[type] <<- ifelse(length(tmp) == 0, length(r2), tmp[1])
        } else if(nc < 1 & nc > 0) {
            nComps[type] <<- sum(r2 < nc) + 1
        } else {
            nComps[type] <<- length(r2)
        }
    },
    
    ##------------------------- "Overloaded" Accessors ------------------------##
    
    getPoly         = function(power = NULL)                                    {
        "Retrieve the polynomial expansions of 'data'"
        if(is.null(power)) return(poly         )
        else               return(poly[[power]])
    },

    getPcAux        = function(type = NULL)                                     {
        "Retrieve the principal component auxiliary scores"
        if     (is.null(type)      ) return(pcAux                )
        else if(type == "linear"   ) return(pcAux$lin            )
        else if(type == "nonLinear") return(pcAux$nonLin         )
        else                         stop  ("Invalid pcAux type.")
    },

    getRSquared     = function(type = NULL)                                     {
        "Retrieve the R-Squareds for the PcAux scores"
        if     (is.null(type)      ) return(rSquared                )
        else if(type == "linear"   ) return(rSquared$lin            )
        else if(type == "nonLinear") return(rSquared$nonLin         )
        else                         stop  ("Invalid rSquared type.")
    },

    getControl      = function()                                                {
        "Retrieve the control parameters"
        list(
            miceIters    = miceIters,
            miceRidge    = miceRidge,
            collinThresh = collinThresh,
            minRespCount = minRespCount,
            minPredCor   = minPredCor,
            maxNetWts    = maxNetWts,
            nomMaxLev    = nomMaxLev,
            ordMaxLev    = ordMaxLev,
            conMinLev    = conMinLev,
            nGVarCats    = nGVarCats,
            pcaMemLev    = pcaMemLev
        )
    },

    ##---------------- Data Screening and Manipulation Methods ----------------##

    removeVars     = function(x, reason, recordOnly = FALSE)                    {
        "Remove columns from 'data' and store their meta-data"
        dropCols <-  which(colnames(data) %in% x)
        dropVars <<- rbind(dropVars, cbind(colnames(data)[dropCols], reason))
        if(!recordOnly) data <<- data[ , -dropCols]
    },

    countVarLevels = function()                                                 {
        "Count the levels for each column in 'data'"
        levelVec <<- as.integer(
            unlist(lapply(data, function(x) length(unique(na.omit(x)))))
        )
        names(levelVec) <<- colnames(data)
    },
    
    typeData       = function()                                                 {
        "Populate a vector containing each variable's type"
        cn <- colnames(data); nv <- ncol(data)
        ## Default type is continuous:
        typeVec                                  <<- rep("continuous", nv)
        typeVec[cn %in% nomVars & levelVec == 2] <<- "binary"
        typeVec[cn %in% nomVars & levelVec > 2 ] <<- "nominal"
        typeVec[cn %in% ordVars                ] <<- "ordinal"
        typeVec[cn %in% idVars                 ] <<- "id"
        typeVec[levelVec == 1                  ] <<- "constant"
        typeVec[initialPm == 1.0               ] <<- "empty"
        typeVec[cn %in% dropVars[ , 1]         ] <<- "drop"
        names(typeVec                          ) <<- colnames(data       )
    },

    castData       = function()                                                 {
        "Cast all variables to the appropriate measurement level"
        for(i in 1 : ncol(data)) {
            data[ , i] <<-
                switch(typeVec[i],
                       drop       =              data[ , i],
                       id         =              data[ , i],
                       empty      =              data[ , i],
                       constant   =              data[ , i],
                       binary     = as.factor  ( data[ , i] ),
                       nominal    = as.factor  ( data[ , i] ),
                       ordinal    = as.ordered ( data[ , i] ),
                       continuous = as.numeric ( data[ , i] )
                       )
        }
    },
    
    centerData      = function()                                                {
        conNames <- names(typeVec)[typeVec == "continuous"]
        data[ , conNames] <<-
            scale(data[ , conNames], center = TRUE, scale = FALSE)
    },
    
    checkTypes     = function()                                                 {
        "Check each variable for a sensible number of levels"
        tmpN <- (typeVec == "nominal" | typeVec == "binary") &
            levelVec > nomMaxLev
        tmpC <- typeVec == "continuous" & levelVec < conMinLev
        tmpO <- typeVec == "ordinal"    & levelVec > ordMaxLev

        if(length(tmpN) > 0) probNoms <<- names(levelVec)[tmpN]
        if(length(tmpO) > 0) probOrds <<- names(levelVec)[tmpO]
        if(length(tmpC) > 0) probCons <<- names(levelVec)[tmpC]
    },

    countResponses = function(
        countMissing = FALSE,
        asProportion = FALSE,
        strict       = FALSE,
        initialPm    = FALSE
    )                                                                           {
        "Calculate the variable-wise response counts"
        if(asProportion) {
            if(countMissing) {
                respCounts <<- colMeans(is.na(data)            )
                noMissing  <-  all     (respCounts == 0.0      )
            } else {
                respCounts <<- colMeans(!is.na(data)           )
                noMissing  <-  all     (respCounts == 1.0      )
            }
        } else {
            if(countMissing) {
                respCounts <<- colSums(is.na(data)             )
                noMissing  <-  all    (respCounts == 0         )
            } else {
                respCounts <<- colSums(!is.na(data)            )
                noMissing  <-  all    (respCounts == nrow(data))
            }
        }

        if(strict & noMissing)
            stop(paste0("The data provided are completely ",
                        "observed.\nYou may wish to check ",
                        "your data for coding errors.")
                 )

        ## Store the inital proportion of missing data:
        if(initialPm) initialPm <<- colMeans(is.na(data))
    },

    findHighPmVars = function()                                                 {
        "Flag variables with few responses"
        tmpNames   <-  setdiff   (names(respCounts), dropVars[ , 1]       )
        tmpCounts  <-  respCounts[tmpNames                                ]
        highPmVars <<- tmpNames  [tmpCounts > 0 & tmpCounts < minRespCount]
        length(highPmVars) > 0 # Find any High PM variables?
    },

    findEmptyVars  = function(remove = TRUE)                                    {
        "Flag empty variables"
        tmpNames  <-  setdiff(names(typeVec), dropVars[ , 1])
        tmpTypes  <-  typeVec[tmpNames                      ]
        emptyVars <<- tmpNames[tmpTypes == "empty"          ]
        if(length(emptyVars) > 0) {# Find any empty variables?
            removeVars(x = emptyVars, reason = "empty", recordOnly = !remove)
            outFlag <- TRUE
        } else {
            outFlag <- FALSE
        }
        outFlag
    },

    findConstCols  = function()                                                 {
        "Locate and fill constant columns in 'data'"
        creatingPcAux <-  length(pcAux$lin) == 0 # Are we in createPcAux()?
        tmpNames      <-  setdiff (names(typeVec), dropVars[ , 1])
        tmpTypes      <-  typeVec [tmpNames                      ]
        constants     <<- tmpNames[tmpTypes == "constant"        ]
        
        if(length(constants) > 0) {# Find any constant columns?
            if(creatingPcAux) {
                removeVars(x = constants, reason = "constant")
            } else {
                fillConstants()
            }
            outFlag <- TRUE
        } else {
            outFlag <- FALSE
        }
        outFlag
    },

    fillConstants   = function()                                                {
        "Fill constant columns with the appropriate value"
        tmp1    <- names  (initialPm)[initialPm == 0]
        targets <- setdiff(constants, tmp1          )
        if(length(targets) > 1) {
            tmp2 <- data.frame(
                lapply(data[ , targets],
                       FUN = function(x) {
                           x[is.na(x)] <- unique(na.omit(x))
                           x
                       })
            )
        } else {
            tmp2              <- data  [ , targets   ]
            tmp2[is.na(tmp2)] <- unique(na.omit(tmp2))
        }
        data[ , targets] <<- tmp2
    },
     
    fillNomCell     = function(name)                                            {
        "Fill single missing nominal cells via marginal sampling"
        for(n in name) {
            tmp         <- table(data[ , n])
            impVal      <- sample(levels(data[ , n]), size = 1, prob = tmp)
            data[is.na(data[ , n]), n] <<- impVal
        }
    },

    cleanCollinVars = function(x)                                               {
        "Remove one variable from all collinear pairs"
        collinVars     <<- x
        collinVarPairs <- collinVars[ , 1 : 2]
        naCount        <- nrow(data) - respCounts
        sameNaCntVec   <- NULL
        diffNaCntVec   <- NULL
        diffMaxCntVec  <- NULL
        
        ## KML 2017-MAR-09: First, drop any variable that is collinear with a key
        ##                  moderator to ensure that all moderators are retained
        if(length(moderators) > 0) {
            ## Find moderators in collinear pairs:
            modScreen <- do.call(cbind,
                                 lapply(collinVarPairs,
                                        function(x, mods) x %in% mods,
                                        mods = moderators)
                                 )
            ## Flag rows with no moderators:
            filter <- rowSums(modScreen) == 0
        } else {
            filter <- TRUE
        }
        
        if(any(!filter)) {
            ## Gather names of variables that are collinear with moderators:
            dropList <- list()
            for(i in which(!filter)) {
                tmp <- collinVarPairs[i, !modScreen[i, ]]
                if(length(tmp) == 1) dropList[[i]] <- tmp
                else                 warnFun("collinMods", map = collinVars[i, ])
            }
            
            ## Exclude variables collected above:
            ## NOTE: Need to check extent in case only moderators are collinear
            ## and no variables are excluded
            tmp <- unlist(dropList)
            if(length(tmp) > 0) 
                removeVars(x = unique(tmp), reason = "collinear")
            
            ## Redifine the collinear pairs:
            collinVarPairs <- collinVarPairs[filter, ]
        }
        
        while(nrow(collinVarPairs) > 0) {
            varCount     <- data.frame(table(unlist(collinVarPairs)))
            maxVarCount  <-
                varCount[which(varCount$Freq == max(varCount$Freq)), ]
            maxVarCommon <- intersect(names(naCount), maxVarCount[ , 1])
            
            ## Check for missing value counts if maximum counts are equal
            if(nrow(maxVarCount) > 1) {
                maxNaCountValue <- max(naCount[maxVarCommon])
                maxNaVarNames   <-
                    names(which(naCount[maxVarCommon] == maxNaCountValue)) 
                maxNaCount      <-
                    data.frame(t(append(maxNaVarNames, maxNaCountValue)))
                
                colnames(maxNaCount) <- c("var1", "count")
                
                ## Check if missing counts are same
                if(nrow(maxNaCount) > 1) {
                    maxNaCount     <- maxNaCount[1, ]
                    maxNaCount     <- as.character(maxNaCount$var1)
                    collinVarPairs <- subset(collinVarPairs,
                                             collinVarPairs[ , 1] != maxNaCount)
                    collinVarPairs <- subset(collinVarPairs,
                                             collinVarPairs[ , 2] != maxNaCount)
                    sameNaCntVec   <- append(sameNaCntVec, maxNaCount)

                } else if(nrow(maxNaCount) == 1) {
                    maxNaCount     <- as.character(maxNaCount$var1)
                    collinVarPairs <- subset(collinVarPairs,
                                             collinVarPairs[ , 1] != maxNaCount)
                    collinVarPairs <- subset(collinVarPairs,
                                             collinVarPairs[ , 2] != maxNaCount)
                    diffNaCntVec   <- append(diffNaCntVec, maxNaCount)
                }

                ## Check if maximum counts are not equal
            } else if(nrow(maxVarCount) == 1) {
                firstVar       <- as.character(maxVarCount$Var1)
                collinVarPairs <-
                    subset(collinVarPairs, collinVarPairs[ , 1] != firstVar)
                collinVarPairs <-
                    subset(collinVarPairs, collinVarPairs[ , 2] != firstVar)
                diffMaxCntVec  <- append(diffMaxCntVec, firstVar)
            }
        }
        
        varsToRemove <- c(sameNaCntVec, diffNaCntVec, diffMaxCntVec)
        if(!is.null(varsToRemove))
            removeVars(x = unique(varsToRemove), reason = "collinear")
    },
    
    createMethVec  = function(initialImp = FALSE)                               {
        "Populate a vector of elementary imputation methods"
        cn0 <- setdiff(colnames(data), c(intVars, colnames(poly)))
        cn1 <- setdiff(colnames(data), cn0)
        
        if(forcePmm) {
            methVec        <<- rep     ("pmm", ncol(data))
            names(methVec) <<- colnames(data             )
            
            ## KML 2016-JUL-31: Don't use PMM for nominal variables
            binNames <- cn0[typeVec[cn0] == "binary"]
            nomNames <- cn0[typeVec[cn0] == "nominal"]
            
            tmpIndex <- names(methVec) %in% binNames
            setMethVec(x = "logreg", index = tmpIndex)

            tmpIndex <- names(methVec) %in% nomNames
            setMethVec(x = "polyreg", index = tmpIndex)

            ## Impute binary interaction terms with logistic regression:
            if(intMeth == 1 & initialImp) {
                facFlag <- unlist(lapply(data[ , cn1], is.factor))
                if(any(facFlag)) {
                    tmpIndex <- colnames(data) %in% cn1[facFlag]
                    setMethVec(x = "logreg", index = tmpIndex)
                }
            }
            ## Don't impute ID or Dropped Variables:
            tmpIndex <- names(methVec) %in% dropVars[ , 1]
            setMethVec(x = "", index = tmpIndex)
         } else {
            methVec <<-
                sapply(typeVec[colnames(data)],
                       FUN = function(x) {
                           switch(x,
                                  continuous = "norm",
                                  ordinal    = "polr",
                                  nominal    = "polyreg",
                                  binary     = "logreg",
                                  "")
                       }
                       )
            ## Work Around: Use PMM for variables with only 1 missing datum:
            setMethVec(x = "pmm", index = colSums(is.na(data)) == 1)
        }
        ## Don't impute fully observed variables:
        setMethVec(x = "", index = colSums(is.na(data)) == 0)
    },
    
    addVars         = function(x, names = NULL)                                 {
        "Add columns to 'data'"
        if(is.null(names)) names <-  colnames  (x              )
        oldNames                 <-  colnames  (data           )
        data                     <<- data.frame(data, x        )
        colnames(data)           <<- c         (oldNames, names)
    },

    idToCharacter   = function()                                                {
        "If any IDs are factors, cast them as character objects"
        if(length(idVars) == 1) {
            if(is.factor(idCols)) idCols <<- as.character(idCols)
        } else {
            for(i in idVars) {
                if(is.factor(idCols[ , i]))
                    idCols[ , i] <<- as.character(idCols[ , i])
            }
        }
    },
    
    binGroupVars    = function(undo = FALSE)                                    {
        "Discretize continuous grouping variables"
        gvTypes  <- typeVec[groupVars                       ]
        conGVars <- names  (gvTypes)[gvTypes == "continuous"]
        if(!undo) {
            ## Define a vector defining the cut-point percentiles:
            probVec <- c(0, (c(1 : (nGVarCats - 1)) / nGVarCats), 1)
            ## Define a function to create the cut-points:
            cutFun  <- function(x, nCats, probs) {
                cut(x,
                    breaks = quantile(x, probs = probs, na.rm = TRUE),
                    labels = c(1 : nCats)
                    )
            }
            ## Bin the variables:
            frozenGVars <<- data[ , conGVars]
            if(length(conGVars) > 1) {
                data[ , conGVars] <<- data.frame(lapply(X     = frozenGVars,
                                                        FUN   = cutFun,
                                                        nCats = nGVarCats,
                                                        probs = probVec)
                                                 )
            } else {
                data[ , conGVars] <<- cutFun(frozenGVars, nGVarCats, probVec)
            }
        } else {
            tmp               <-  data[ , conGVars]
            data[ , conGVars] <<- frozenGVars
            frozenGVars       <<- tmp
        }
    },

    createPatterns  = function()                                                {
        "Create patterns to use for group-mean substitution"
        ## Deal with any continuous grouping variables:
        gVarCheck <- any(typeVec[groupVars] == "continuous")
        if(gVarCheck) binGroupVars()

        ## 'patterns' list a list of vectors made up of cross-tabulated grouping
        ## variables:
        patterns <<-
            lapply(c(length(groupVars) : 2),
                   FUN = function(x, data) {
                       tmpData <- data[ , groupVars[1 : x]]
                       apply(# Merge columns of tmpData into a single vector
                           apply(tmpData, 2, as.character),# Typecast tmpData
                           1, paste, collapse = "")
                   },
                   data = data)

        patterns[[length(groupVars)]] <<- format(data[ , groupVars[1]])

        if(gVarCheck) binGroupVars(undo = TRUE)
    },

    completeMiData  = function()                                                {
        "Complete the multiply imputed data sets"
        specialComp <- compFormat %in% c("long", "broad", "repeated")
        if(specialComp) {
            miDatasets <<- complete(miceObject, compFormat)
            pcCols <-
                grep("^linPC\\d|^nonLinPC\\d", colnames(miDatasets))
            miDatasets <<- miDatasets[ , -pcCols]
        } else {
            miDatasets <<- list()
            for(m in 1 : nImps) {
                miDatasets[[m]] <<- complete(miceObject, m)
                if(m == 1) pcCols <- grep("^linPC\\d|^nonLinPC\\d",
                                          colnames(miDatasets[[m]])
                                          )
                miDatasets[[m]] <<- miDatasets[[m]][ , -pcCols]
            }
        }
    },
    
    transformMiData = function()                                                {
        "Format imputed data sets after parallelMice()"
        ## Remove the PcAux:
        pcCols <- grep("^linPC\\d|^nonLinPC\\d", colnames(miDatasets[[1]]))
        for(m in 1 : nImps) miDatasets[[m]] <<- miDatasets[[m]][ , -pcCols]

        ## Impose the requested completion format:
        if(compFormat == "long") {
            .imp <- rep(c(1 : nImps), each = nrow(data))
            .id  <- rep(c(1 : nrow(data)), nImps       )
            miDatasets <<-
                data.frame(.imp, .id, do.call(rbind.data.frame, miDatasets))
        } else if(compFormat %in% c("broad", "repeated")) {
            for(m in 1 : nImps) {
                colnames(miDatasets[[m]]) <<-
                    paste0(colnames(miDatasets[[m]]), ".", m)
            }
            
            miDatasets <<- do.call(cbind.data.frame, miDatasets)
            
            if(compFormat == "repeated") {
                tmp        <-  rep       (c(1 : ncol(data)), nImps)
                miDatasets <<- miDatasets[ , order(tmp)           ]
            }
        }
    },
    
    computeInteract = function()                                                {
        "Calculate interaction terms"
        if(length(pcAux$lin) > 0) # Do we have linear PcAux?
            pcNames <- setdiff(colnames(pcAux$lin), idVars)
             
        ## Cast ordered factors to numeric:
        if(length(ordVars) > 0) castOrdVars()
        
        ## Interactions involving key moderators:
        if(intMeth < 3) mods <- moderators
        ## All observed variables as moderators:
        else            mods <- colnames(data)
        
        if(intMeth == 1) # Interactions among raw variables
            varCombs <- combn(colnames(data), 2)
        else             # Interactions involving linear PcAux
            varCombs <- t(expand.grid(mods, pcNames, stringsAsFactors = FALSE))
        filter   <- varCombs[1, ] %in% mods
              
        ## Generate interaction terms:
        intTerms <-
            apply(varCombs[ , filter], 2, function(x) paste0(x, collapse = "*"))
        
        ## Build a formula defining interactions:
        form <- as.formula(
            paste0("~",
                   paste(
                       paste0(intTerms, collapse = " + "),
                       paste0(unique(varCombs[ , filter]), collapse = " - "),
                       sep = " - ")
                   )
        )
               
        ## Make sure missing values are retained in dummy codes:
        oldOpt <- options(na.action = "na.pass")
        
        ## Create product variables:
        if(intMeth == 1) {
            interact <<- data.frame(model.matrix(form, data = data)[ , -1])
        } else {
            tmp           <-  data.frame(data, pcAux$lin[ , pcNames])
            colnames(tmp) <-  c(colnames(data), pcNames)
            interact      <<- data.frame(model.matrix(form, data = tmp)[ , -1])
        }
        
        ## Reset the na.action option:
        options(na.action = oldOpt$na.action)
        
        ## Remove dummy codes for empty cells:
        levVec <- unlist(
            lapply(interact, function(x) length(unique(na.omit(x))))
        )
        
        interact <<- interact[ , levVec > 1]
        intVars  <<- colnames(interact)
        
        ## Cast dummy codes as factors:
        dumFlag <- unlist(
            lapply(interact, function(x) all(unique(na.omit(x)) %in% c(0, 1)))
        )
        
        if(sum(dumFlag) > 1)
            interact[ , dumFlag] <<-
                data.frame(lapply(interact[ , dumFlag], as.factor))
        else if(sum(dumFlag) == 1)
            interact[ , dumFlag] <<- as.factor(interact[ , dumFlag])
        
        ## If any PcAux are involved, orthogonalize the interaction terms w.r.t.
        ## the linear PcAux scores:
        if(intMeth > 1)        
            for(v in 1 : ncol(interact))
                interact[ , v] <<-
                    .lm.fit(y = interact[ , v],
                            x = as.matrix(pcAux$lin[ , pcNames]))$resid
        
        ## Undo type-cast of ordered factors:
        if(length(ordVars) > 0) castOrdVars(toNumeric = FALSE)
    },
    
    computePoly     = function()                                                {
        "Compute polynomial terms"
        dataNames <- setdiff(colnames(data), c(intVars, nomVars, ordVars))
        
        ## Construct a formula to define the polynomial transformations:
        form <- as.formula(
            paste0("~",
                   paste0("I(",
                          paste(dataNames,
                                rep(c(2 : maxPower), each = length(dataNames)),
                                sep = "^"),
                          ")",
                          collapse = " + "
                          )
                   )
        )

        ## Make sure missing values are retained in dummy codes:
        oldOpt <- options(na.action = "na.pass")
       
        ## Create the polynominal terms:
        poly <<- data.frame(
            model.matrix(form, data = data[ , dataNames])[ , -1]
        )
        
        ## Reset the na.action option:
        options(na.action = oldOpt$na.action)
    },
    
    calcRSquared    = function()                                                {
        "Compute the proportion of variance explained by PcAux"
        if(length(pcAux$lin) == 0) lv <- "lin"
        else                       lv <- "nonLin"
        
        ## Compute the cumulative variance explained:
        totalVar <- sum(rSquared[[lv]], na.rm = TRUE)
        
        rSquared[[lv]][1] <<- rSquared[[lv]][1] / totalVar
        
        for(i in 2 : length(rSquared[[lv]]))
            rSquared[[lv]][i] <<-
                rSquared[[lv]][i - 1] + (rSquared[[lv]][i] / totalVar)
    },
    
    castNomVars     = function(action = 0)                                      {
        "Dummy code nominal factors"
        if(action == 0) {# Create dummy codes
            noms <- colnames(data)[colnames(data) %in% nomVars]
            
            ## Expand factors into dummy codes:
            form <- as.formula(
                paste0("~", paste0(noms, collapse = " + "))
            )
            
            ## Make sure missing values are retained in dummy codes:
            oldOpt <- options(na.action = "na.pass")
            
            ## Create/store dummy codes:
            dumNoms <<- data.frame(model.matrix(form, data = data)[ , -1])
            
            ## Reset the na.action option:
            options(na.action = oldOpt$na.action)

            ## Store factor representations:
            facNoms           <<- data.frame(data[ , noms])
            colnames(facNoms) <<- noms
            
            ## Remove dummy codes for empty factor levels:
            levVec <- unlist(
                lapply(dumNoms, function(x) length(unique(na.omit(x))))
            )
            dumNoms <<- dumNoms[ , levVec > 1]
            
            ## Cast binary interaction terms as numeric dummy codes:
            if(intMeth == 1) {
                facFlag <- unlist(lapply(data[ , intVars], is.factor))
                
                if(any(facFlag)) {
                    facInts <- intVars[facFlag]
                    dumNoms <<- data.frame(
                        dumNoms,
                        lapply(data[ , facInts],
                               function(x) as.numeric(as.character(x))
                               )
                    )
                } else {
                    facInts <- NULL
                }
            } else {
                facInts <- NULL
            }
            
            ## Replace factors in the data with dummy codes:
            data <<- data.frame(
                data[ , setdiff(colnames(data), c(noms, facInts))],
                dumNoms
            )
        } else if(action == 1) {# Undo dummy codes
            data <<- data.frame(
                data[ , setdiff(colnames(data), colnames(dumNoms))],
                facNoms
            )
        } else {# Redo dummy codes
            data <<- data.frame(
                data[ , setdiff(colnames(data), colnames(facNoms))],
                dumNoms
            )
        }
    },
    
    castOrdVars     = function(toNumeric = TRUE)                                {
        "Cast ordinal factors to numeric variables"
        ## Find ordinal variables that are still on the data set:
        ords <- colnames(data)[colnames(data) %in% ordVars]

        if(toNumeric) {
            ## Cast the ordinal variables as numeric:
            if(length(ords) > 1)
                data[ , ords] <<- data.frame(lapply(data[ , ords], as.numeric))
            else
                data[ , ords] <<- as.numeric(data[ , ords])
        } else {
            ## Cast back to ordered factors:
            if(length(ords) > 1)
                data[ , ords] <<- data.frame(lapply(data[ , ords], as.ordered))
            else
                data[ , ords] <<- as.ordered(data[ , ords])
        }
    }
     
)# END PcAuxData$methods()
