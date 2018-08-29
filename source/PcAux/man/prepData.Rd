\name{prepData}
\alias{prepData}
\title{
  Prepare Data for Extracting Principal Component Auxiliaries
}
\description{
  Data cleaning to facilitate execution of a principled missing data
  analysis that uses principal component scores as the auxiliary
  variables as described by Howard, Rhemtulla, and Little (2015).
}
\usage{
prepData(rawData,
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
}
\arguments{
  \item{rawData}{
    A data frame from which to extract the auxiliary principal
    components.
  }
  \item{moderators}{
    An optional character vector containing names of any moderator
    variables to include in the initial, single imputation model. The
    variables supplied here will be interacted with all other observed
    variables when specifying the initial single imputation model's
    systematic component. The exact method by which this moderation is
    incorporated depends on the \code{interactType} argument in
    \code{createPcAux} (see the documentation for \code{createPcAux} for
    more information).
  }
  \item{nomVars}{
    An optional character vector containing names of any nominal
    variables (i.e., unordered factors) that exist in \code{rawData}.
  }
  \item{ordVars}{
    An optional character vector containing names of any ordinal
    variables (i.e., ordered factors) that exist in \code{rawData}.
  }
  \item{idVars}{
    An optional character vector containing names of any ID variables
    that exist in \code{rawData}. Any columns flagged as ID variables
    should not be represented in \code{nomVars}, \code{ordVars},
    \code{dropVars}, or \code{groupVars}
  }
  \item{dropVars}{
    An optional character vector containing names of any nuisance
    variables that  should be dropped before extracting the auxiliary
    principal component scores.
  }
  \item{groupVars}{
    An optional character vector containing names of any grouping
    variables that can be used to create the strata that define the
    groups used by the fall-back group-mean substitution. If continuous
    grouping variables are specified, they are binned via the
    \code{cut()} function with \code{breaks = control$nGVarCuts}.
  }
  \item{simMode}{
    A logical switch turning 'Simulation Mode' on or off. In Simulation
    Mode all of the automatic data checks will be suppressed. This mode
    is intended for use when \code{prepData} is being called as part of
    a Monte Carlo simulation study in which the data properties are
    well-known by the user. This mode should not be used for
    'real-world' data analysis. Defaults to \code{simMode = FALSE}.
  }
  \item{nProcess}{
    An integer indicating the number of processors to use when
    using parallel processing for the collinearity checks. A value of
    \code{nProcess = 1L} results in serial processing. Must be less than
    or equal to the available number of logical processing
    cores. Defaults to \code{nProcess = 1L}.
  }
  \item{verbose}{
    An integer code in {0, 1, 2} defining the verbosity of output printed to the
    screen. \code{verbose = 0} prints no output; \code{verbose = 1}
    prints all output except for the messages returned by \pkg{mice};
    \code{verbose = 2} prints all output, including the messages
    returned by \pkg{mice}. Warnings are always printed, regardless of the value
    assigned to \code{verbose}. Defaults to \code{verbose = 2}.
  }
  \item{control}{
    An optional list of control parameters (see 'Details').
  }
  \item{...}{
    Not currently used.
  }
}
\details{
  The \code{control} argument is a key-paired list with the following
  possible entries:
  \itemize{
    \item{miceIters: }{
      Number of EM iterations supplied to the \code{maxit} argument of
      mice() during the initial single imputation. Defaults to
      \code{miceIters = 10L}.
    }
    \item{miceRidge: }{
      Value of the ridge penalty parameter used to stabilize the
      imputation models used by mice(). Defaults to \code{miceRidge =
	1e-5}.
    }
    \item{collinThresh: }{
      The strength of linear association used to flag collinear variable
      for removal. Defaults to \code{collinThresh = 0.95}.
    }
    \item{minRespCount: }{
      The minimum number of observations allowed on each variable without
      triggering a warning. Defaults to \code{floor(0.05 * nrow(rawData))}.
    }
    \item{minPredCor: }{
      The minimum magnitude of correlation supplied to the
      \code{mincor} argument of mice::quickpred() when constructing the
      predictor matrix used by mice() during the initial single
      imputation. Defaults to \code{minPredCor = 0.1}.
    }
    \item{maxNetWts: }{
      The maximum number of network weights used by nnet() to fit the
      polytomous regression models used to impute nominal variables with
      mice(). Defaults to \code{maxNetWts = 10000L}.
    }
    \item{nomMaxLev: }{
      The maximum number of response levels for nominal variables that
      won't trigger a warning. Defaults to \code{nomMaxLev = 10L}.
    }
    \item{ordMaxLev: }{
      The maximum number of response levels for ordinal variables that
      won't trigger a warning. Defaults to \code{ordMaxLev = 10L}.
    }
    \item{conMinLev: }{
      The minimum number of unique responses for continuous variables that
      won't trigger a warning. Defaults to \code{minConLev = 10L}.
    }
    \item{nGVarCats: }{
      The number of categories into which continuous grouping variables
      will be split, if applicable. Defaults to \code{nGVarCats = 3L}.
    }
    \item{checkStatus: }{
      The steps at which to record system and OS status. Can take
      values: \code{"none"}, \code{"start"} or \code{"all"}. Defaults to
      \code{"none"}.
    }
  }
}
\value{
  An Reference Class object of class PcAuxData with fields for each of
  the \code{prepData} function's arguments and the following additional,
  non-trivial fields:
  \itemize{
    \item{call: }{
      A list containing the matched function call to \code{prepData}.
    }
    \item{typeVec: }{
      A character vector giving the types assigned to each variable in
      \code{rawData}.
    }
    \item{initialPm: }{
      A numeric vector giving the initial, variable-wise percents
      missing for \code{rawData} before any treatment.
    }
    \item{dropVars: }{
      A two-column character matrix. The first column contains the names
      of all variables dropped from the analysis. The second column
      contains the reason that the corresponding variable was dropped.
    }
    \item{probNoms: }{
      A character vector giving the variable names for any nominal
      variables with more levels than \code{control$nomMaxLev}.
    }
    \item{probOrds: }{
      A character vector giving the variable names for any ordinal
      variables with more levels than \code{control$ordMaxLev}.
    }
    \item{probCons: }{
      A character vector giving the variable names for any continuous
      variables with fewer levels than \code{control$conMinLev}.
    }
    \item{levelVec: }{
      An integer vector giving the number of unique, non-missing, levels
      for each variable in \code{rawData}.
    }
    \item{highPmVars: }{
      A character vector containing the names of variables with fewer
      observed responses than \code{control$minRespCount}.
    }
    \item{emptyVars: }{
      A character vector giving the names of empty columns in
      \code{rawData}.
    }
    \item{constants: }{
      A character vector giving the names of constant columns in
      \code{rawData}.
    }
    \item{collinVars: }{
      A three-column character matrix. The first two columns contain the
      names of pairs of approximately collinear variables. The third
      column contains their observed linear association.
    }
    \item{idFills: }{
      A list containing the values used to deterministically fill any
      missing data that occurred on the ID variables. The length of this
      argument will equal the number of incomplete ID variables in
      \code{rawData}.
    }
    \item{corPairs: }{
      A dataframe containing unique variable pairs and their linear
      associations.
    }
  }
}
\references{
  Howard, W. H., Rhemtulla, M., & Little, T. D. (2015). Using principal
  components as auxiliary variables in missing data estimation.
  Multivariate Behavioral Research. 50(3). 285-299.
}
\author{
  Kyle M. Lang
}
\seealso{
  \code{\link{createPcAux}}, \code{\link{miWithPcAux}}
}
\examples{
## Load data:
data(iris2)

## Prepare the data:
newData <- prepData(rawData   = iris2,
                    nomVars   = "Species",
                    ordVars   = "Petal.Width",
                    idVars    = "ID",
                    dropVars  = "Junk",
                    groupVars = "Species")
}
