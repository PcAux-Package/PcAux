### Title:        PcAuxData Simple Accessor and Mutator Definitions
### Author:       Kyle M. Lang
### Contributors: Pavel Panko 
### Created:      2015-OCT-30
### Modified:     2018-MAY-25
### Note:         These methods are not currently used. The following
###               definitions are included mostly for "future-proofing,"
###               so that the PcAuxData class will still be valid if future
###               implementations of R's Reference Classes require stricter
###               field access protocols.

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


PcAuxData$methods(
    ## Simple Mutators ##
    setData         = function(x) { data         <<- x                         },
    setSeed         = function(x) { seed         <<- x                         },
    setMiceIters    = function(x) { miceIters    <<- x                         },
    setMiceRidge    = function(x) { miceRidge    <<- x                         },
    setMaxNetWts    = function(x) { maxNetWts    <<- x                         },
    setForcePmm     = function(x) { forcePmm     <<- x                         },
    setTypeVec      = function(x) { typeVec      <<- x                         },
    setRespCounts   = function(x) { respCounts   <<- x                         },
    setInitialPm    = function(x) { initialPm    <<- x                         },
    setNomVars      = function(x) { nomVars      <<- x                         },
    setOrdVars      = function(x) { ordVars      <<- x                         },
    setIdVars       = function(x) { idVars       <<- x                         },
    setDropVars     = function(x) { dropVars     <<- x                         },
    setNomMaxLev    = function(x) { nomMaxLev    <<- x                         },
    setOrdMaxLev    = function(x) { ordMaxLev    <<- x                         },
    setConMinLev    = function(x) { conMinLev    <<- x                         },
    setProbNoms     = function(x) { probNoms     <<- x                         },
    setProbOrds     = function(x) { probOrds     <<- x                         },
    setProbCons     = function(x) { probCons     <<- x                         },
    setLevelVec     = function(x) { levelVec     <<- x                         },
    setSimMode      = function(x) { simMode      <<- x                         },
    setHighPmVars   = function(x) { highPmVars   <<- x                         },
    setEmptyVars    = function(x) { emptyVars    <<- x                         },
    setConstants    = function(x) { constants    <<- x                         },
    setMinRespCount = function(x) { minRespCount <<- x                         },
    setVerbose      = function(x) { verbose      <<- x                         },
    setGroupVars    = function(x) { groupVars    <<- x                         },
    setIntVars      = function(x) { intVars      <<- x                         },
    setPcaMemLev    = function(x) { pcaMemLev    <<- x                         },
    setMaxPower     = function(x) { maxPower     <<- x                         },
    setInteract     = function(x) { interact     <<- x                         },
    setCollinThresh = function(x) { collinThresh <<- x                         },
    setMinPredCor   = function(x) { minPredCor   <<- x                         },
    setNGVarCats    = function(x) { nGVarCats    <<- x                         },
    setCollinVars   = function(x) { collinVars   <<- x                         },
    setPatterns     = function(x) { patterns     <<- x                         },
    setFrozenGVars  = function(x) { frozenGVars  <<- x                         },
    setIdFills      = function(x) { idFills      <<- x                         },
    setNImps        = function(x) { nImps        <<- x                         },
    setCompFormat   = function(x) { compFormat   <<- x                         },
    setMiDatasets   = function(x) { miDatasets   <<- x                         },
    setMiceObject   = function(x) { miceObject   <<- x                         },
    setModerators   = function(x) { moderators   <<- x                         },
    setIntMeth      = function(x) { intMeth      <<- x                         },
    setIdCols       = function(x) { idCols       <<- x                         },

    ## Simple Accessors ##
    getData         = function()  { data                                       },
    getSeed         = function()  { seed                                       },
    getMiceIters    = function()  { miceIters                                  },
    getMiceRidge    = function()  { miceRidge                                  },
    getMaxNetWts    = function()  { maxNetWts                                  },
    getForcePmm     = function()  { forcePmm                                   },
    getTypeVec      = function()  { typeVec                                    },
    getMethVec      = function()  { methVec                                    },
    getNComps       = function()  { nComps                                     },
    getRespCounts   = function()  { respCounts                                 },
    getInitialPm    = function()  { initialPm                                  },
    getNomVars      = function()  { nomVars                                    },
    getOrdVars      = function()  { ordVars                                    },
    getIdVars       = function()  { idVars                                     },
    getDropVars     = function()  { dropVars                                   },
    getNomMaxLev    = function()  { nomMaxLev                                  },
    getOrdMaxLev    = function()  { ordMaxLev                                  },
    getConMinLev    = function()  { conMinLev                                  },
    getProbNoms     = function()  { probNoms                                   },
    getProbOrds     = function()  { probOrds                                   },
    getProbCons     = function()  { probCons                                   },
    getLevelVec     = function()  { levelVec                                   },
    getSimMode      = function()  { simMode                                    },
    getHighPmVars   = function()  { highPmVars                                 },
    getEmptyVars    = function()  { emptyVars                                  },
    getConstants    = function()  { constants                                  },
    getMinRespCount = function()  { minRespCount                               },
    getVerbose      = function()  { verbose                                    },
    getGroupVars    = function()  { groupVars                                  },
    getIntVars      = function()  { intVars                                    },
    getPcaMemLev    = function()  { pcaMemLev                                  },
    getMaxPower     = function()  { maxPower                                   },
    getInteract     = function()  { interact                                   },
    getCollinThresh = function()  { collinThresh                               },
    getMinPredCor   = function()  { minPredCor                                 },
    getNGVarCats    = function()  { nGVarCats                                  },
    getCollinVars   = function()  { collinVars                                 },
    getPatterns     = function()  { patterns                                   },
    getFrozenGVars  = function()  { frozenGVars                                },
    getIdFills      = function()  { idFills                                    },
    getImpsFails    = function()  { impFails                                   },
    getNImps        = function()  { nImps                                      },
    getCompFormat   = function()  { compFormat                                 },
    getMiDatasets   = function()  { miDatasets                                 },
    getMiceObject   = function()  { miceObject                                 },
    getModerators   = function(x) { moderators                                 },
    getIntMeth      = function(x) { intMeth                                    },
    getIdCols       = function(x) { idCols                                     }

    )


                    
