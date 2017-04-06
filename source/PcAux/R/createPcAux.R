### Title:        Create Principal Component Auxiliary Variables
### Author:       Kyle M. Lang
### Contributors: Steven Chesnut
### Created:      2015-SEP-17
### Modified:     2017-MAR-26

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


createPcAux <- function(pcAuxData,
                        nComps,
                        interactType = 1L,
                        maxPolyPow   = 3L,
                        simMode      = FALSE,
                        seed         = NULL,
                        verbose      = 2L,
                        doImputation = TRUE,
                        castData     = !doImputation,
                        control,
                        ...)
{
    pcAuxData$setCall(match.call(), parent = "createPcAux")
    
    ## Check for problems with the input values:
    if(missing(pcAuxData)) errFun("noPcAuxData")
    if(missing(nComps))    errFun("noNComps")
    if(!simMode)           checkInputs(parent = "createPcAux")
    
    ## Add elements to an extant instance of the PcAuxData class:
    pcAuxData$nComps   <- nComps
    pcAuxData$forcePmm <- TRUE # Don't give imputation options other than PMM
    pcAuxData$intMeth  <- as.integer(interactType)
    pcAuxData$maxPower <- as.integer(maxPolyPow)
    pcAuxData$simMode  <- simMode
    pcAuxData$verbose  <- as.integer(verbose)
    
    if(!missCheck(seed)) pcAuxData$seed <- as.integer(seed)
    
    ## Make sure the control list is fully populated:
    if(!missCheck(control)) pcAuxData$setControl(x = control)
    
    ## Check for extant moderators when interactType == 1 or 2:
    check <- interactType %in% c(1, 2) & missCheck(pcAuxData$moderators)
    if(check) {
        pcAuxData$moderators <- colnames(pcAuxData$data)
        warnFun("noMods")
    }
    
    ## Re-cast the data if needed
    if(castData) castData(map = pcAuxData)
    
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
    }
    
    ## Compute interactions for use during initial imputation:
    if(pcAuxData$intMeth == 1) {
        pcAuxData$computeInteract()
        pcAuxData$data     <- with(pcAuxData, data.frame(data, interact))
        pcAuxData$interact <- "Removed to save resources"
    }
        
    ## Compute polynomials for use during initial imputation:
    if(pcAuxData$maxPower > 1) {
        pcAuxData$computePoly()
        pcAuxData$data <- with(pcAuxData, data.frame(data, poly))
        if(pcAuxData$intMeth == 1) pcAuxData$poly <- "Removed to save resources"
    }
    
    ## Execute the initial, single imputation:
    if(doImputation) doSingleImputation(map = pcAuxData)
    
    ## Extract the linear principal component scores:
    doPCA(map = pcAuxData)
    
    ## Are we constructing seperate non-linear PcAux?
    if(pcAuxData$nComps[2] != 0) {
        ## Undo dummy coding to facilitate interaction calculation:
        if(!missCheck(pcAuxData$nomVars)) pcAuxData$castNomVars(action = 1)
        
        ## Construct and orthogonalize interaction terms:
        if(pcAuxData$intMeth > 1) pcAuxData$computeInteract()
        
        ## Extract the nonlinear principal component scores:
        doPCA(map = pcAuxData)
    }

    ## Remove unnecessary representation of nominal variables:
    pcAuxData$facNoms <- "Removed to save resources"
    pcAuxData$dumNoms <- "Removed to save resources"
    
    pcAuxData
}# END createPcAux()
