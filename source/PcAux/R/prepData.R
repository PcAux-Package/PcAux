### Title:        Data Preperation
### Author:       Kyle M. Lang
### Contributors: Byung Jung
### Created:      2016-JAN-19
### Modified:     2017-MAR-23

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


prepData <- function(rawData,
                     moderators = NULL,
                     nomVars    = NULL,
                     ordVars    = NULL,
                     idVars     = NULL,
                     dropVars   = NULL,
                     groupVars  = NULL,
                     simMode    = FALSE,
                     nProcess   = 1L,
                     verbose    = 2L,
                     control,
                     ...)
{
    ## Check for problems with the input values:
    if(missing(rawData)) errFun("noData")
    if(!simMode)         checkInputs(parent = "prepData")
    
    if(missCheck(dropVars)) dropVars <- "NONE_DEFINED"
            
    ## Initialize a new instance of the PcAuxData class
    ## to store all of the data and metadata for this run:
    pcAuxData <- PcAuxData(data     = rawData,
                           dropVars = dropVars,
                           simMode  = simMode,
                           nProcess = as.integer(nProcess),
                           verbose  = as.integer(verbose)
                           )

    pcAuxData$setCall(match.call(), parent = "prepData")
    
    ## Make sure the control list is fully populated:
    if(!missCheck(control)) pcAuxData$setControl(x = control)
    
    ## Check for special variable arguments and fill the appropriate slots in the
    ## pcAuxData object:
    if(!missCheck(idVars)) {
        pcAuxData$idVars <- idVars
        pcAuxData$idCols <- as.data.frame(pcAuxData$data[ , idVars])
        pcAuxData$data   <-
            pcAuxData$data[ , setdiff(colnames(pcAuxData$data), idVars)]
    }
    if(!missCheck(groupVars))  pcAuxData$groupVars  <- groupVars
    if(!missCheck(nomVars))    pcAuxData$nomVars    <- nomVars
    if(!missCheck(ordVars))    pcAuxData$ordVars    <- ordVars
    if(!missCheck(moderators)) pcAuxData$moderators <- moderators
                                           
### Pre-process the data ###
    
    ## Cast the variables to their declared types:
    castData(map = pcAuxData)

    if(!simMode) {# Don't clean data in simMode
        ## Remove constant and empty columns:
        cleanData(map = pcAuxData)

        ## Find any (bivariate) collinear variables:
        findCollin(map = pcAuxData)
    }
    pcAuxData
}# END prepData()