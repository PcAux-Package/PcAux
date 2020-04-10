### Title:        Create Principal Component Auxiliary Variables
### Author:       Kyle M. Lang
### Contributors: Steven Chesnut, Pavel Panko, Luke Waggenspack
### Created:      2015-SEP-17
### Modified:     2020-APR-10

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


createPcAux <- function(pcAuxData,
                        nComps,
                        interactType = 0L,
                        maxPolyPow   = 1L,
                        simMode      = FALSE,
                        seed         = NULL,
                        verbose      = 2L,
                        doImputation = TRUE,
                        castData     = !doImputation,
                        control,
                        ...)
{
    pcAuxData$setCall(match.call(), parent = "createPcAux")

    ## Set initial time and status check 
    pcAuxData$setTime()
    if(pcAuxData$checkStatus == "start" | pcAuxData$checkStatus == "all")
        pcAuxData$setStatus()

    
    ## Check for problems with the input values:
    if(missing(pcAuxData)) errFun("noPcAuxData")
    if(missing(nComps))    errFun("noNComps")
    if(!simMode)           checkInputs()
    
    ## Add elements to an extant instance of the PcAuxData class:
    pcAuxData$nComps   <- nComps
    pcAuxData$forcePmm <- FALSE # Don't give imputation options other than PMM
    pcAuxData$intMeth  <- as.integer(interactType)
    pcAuxData$maxPower <- as.integer(maxPolyPow)
    pcAuxData$simMode  <- simMode
    pcAuxData$verbose  <- as.integer(verbose)
    
    if(!missCheck(seed)) pcAuxData$seed <- as.integer(seed)
    
    ## Make sure the control list is fully populated:
    if(!missCheck(control)) pcAuxData$setControl(x = control)
    
    pcAuxData$setTime("dataCheck")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("dataCheck")
    
    ## Check for extant moderators:
    check <- missCheck(pcAuxData$moderators)
    if(check) {
        pcAuxData$moderators <- colnames(pcAuxData$data)
        if(pcAuxData$intMeth ==1 | pcAuxData$intMeth == 2)
            warnFun("noMods", map = pcAuxData)
    }

    pcAuxData$setTime("modExt")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("modExt")
    
    ## Re-cast the data if needed
    if(castData | interactType == 1) castData(map = pcAuxData)

    pcAuxData$setTime("cast")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("cast")
    
    if(doImputation) {
        ## Check for and treat any nominal variables that are missing only one
        ## datum:
        singleMissNom <-
            with(pcAuxData, (nrow(data) - respCounts == 1) &
                            (typeVec == "binary" | typeVec == "nominal")
                 )
        ## KML 2016-NOV-14: Ignore dropped variables
        singleMissNom <- setdiff(names(singleMissNom)[singleMissNom],
                                 pcAuxData$dropVars[ , 1])
        
        if(length(singleMissNom) > 0) pcAuxData$fillNomCell(singleMissNom)

        pcAuxData$setTime("doImp")
        if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("doImp")
    }
    
    ## Compute interactions for use during initial imputation:
    if(pcAuxData$intMeth == 1) {
        pcAuxData$computeInteract()
        pcAuxData$data     <- with(pcAuxData, data.frame(data, interact))
        pcAuxData$interact <- "Removed to save resources"
    }

    pcAuxData$setTime("compInt")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("compInt")
    
    ## Compute polynomials for use during initial imputation:
    if(pcAuxData$maxPower > 1) {
        pcAuxData$computePoly()
        pcAuxData$data <- with(pcAuxData, data.frame(data, poly))
        if(pcAuxData$intMeth == 1) pcAuxData$poly <- "Removed to save resources"
    }
    
    pcAuxData$setTime("compPoly")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("compPoly")
    
    ## Execute the initial, single imputation:
    if(doImputation) {

        doSingleImputation(map = pcAuxData)

        ## Use imputed data to update nominal variable representations:
        if(length(pcAuxData$nomVars) > 0) pcAuxData$codeNomVars()
   
        pcAuxData$setTime("doSingle")
        if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("doSingle")
    }
    
    ## Extract the linear principal component scores:
    doPCA(map = pcAuxData)

    pcAuxData$setTime("doPCA")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("doPCA")
    
    ## Are we constructing seperate non-linear PcAux?
    if(pcAuxData$nComps[2] != 0) {
        ## Undo dummy coding to facilitate interaction calculation:
        if(!missCheck(pcAuxData$nomVars))
            pcAuxData$castNomVars(toNumeric = FALSE)
        
        ## Construct and orthogonalize interaction terms:
        if(pcAuxData$intMeth > 1) pcAuxData$computeInteract()
        
        ## Extract the nonlinear principal component scores:
        doPCA(map = pcAuxData)

        pcAuxData$setTime("doNLinear")
        if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("doNLinear")
    }

    ## Remove unnecessary representation of nominal variables:
    pcAuxData$facNoms <- "Removed to save resources"
    pcAuxData$dumNoms <- "Removed to save resources"

    pcAuxData$setTime("rmVars")
    if(pcAuxData$checkStatus == "all") pcAuxData$setStatus("rmVars")
    
    pcAuxData
}# END createPcAux()
