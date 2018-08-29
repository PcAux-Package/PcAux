\name{createPcAux}
\alias{createPcAux}
\title{
  Extract Principal Component Auxiliaries for Missing Data Analysis
}
\description{
  Extract principal component scores for use as the auxiliary variables
  in a principled missing data analysis as described by Howard,
  Rhemtulla, and Little (2015). 
}
\usage{
createPcAux(pcAuxData,
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
}
\arguments{
  \item{pcAuxData}{
    An object of class PcAuxData returned from \code{prepData}. 
  }
  \item{nComps}{
    A two-element, numeric vector giving the number of linear and
    nonlinear, respectively, component scores to extract. See the
    \emph{Details} section for more information.
  }
  \item{interactType}{
    An integer code indicating which method is used to incorporate
    interactions into the initial, single imputation model. See the
    \emph{Details} section for more information. Defaults to
    \code{interactType = 1L}.
  }
  \item{maxPolyPow}{
    An integer giving the maximum power used when constructing the
    polynomial terms. Setting \code{maxPolyPow = 1L} has the effect of
    excluding any polynomial terms from the imputation model. Defaults
    to \code{maxPolyPow = 3L}. 
  }
  \item{simMode}{
    A logical switch turning 'Simulation Mode' on or off. In Simulation
    Mode all of the automatic data checks will be suppressed. This mode
    is intended for use when \code{pcAux} is being called as part of a
    Monte Carlo simulation study in which the data properties are
    well-known by the user. This mode should not be used for
    'real-world' data analysis. Defaults to \code{simMode = FALSE}.
  }
  \item{seed}{
    An optional integer used to seed the random number generator used by the
    imputation algorithm. Defaults to \code{seed = NULL} which leaves
    the default random number generator unaltered.
  }
  \item{verbose}{
    An integer code in {0, 1, 2} defining the verbosity of output printed to the
    screen. \code{verbose = 0} prints no output; \code{verbose = 1}
    prints all output except for the messages returned by \pkg{mice};
    \code{verbose = 2} prints all output, including the messages
    returned by \pkg{mice}. Warnings are always printed, regardless of the value
    assigned to \code{verbose}. Defaults to \code{verbose = 2}.
  }
  \item{doImputation}{
    A logical switch indicating whether the data should be imputed
    before extracting the principal component scores. Set to
    \code{FALSE} if the data element in \code{pcAuxData} has no missing
    values (e.g., the imputation was done elsewhere). Defaults to
    \code{doImputation = TRUE}.
  }
  \item{castData}{
    A logical switch indicating whether the data element in
    \code{pcAuxData} should have its variables re-typed. Keep as
    \code{FALSE} unless the data have been manipulated after running
    \code{prepData}. Defaults to \code{castData = FALSE}.
  }
  \item{control}{
    An optional list of control parameters (see 'Details').
  }
  \item{...}{
   Not currently used.
  }
}
\details{
  The number of component scores requested via the \code{nComps}
  argument can be defined in two ways: as simple counts, or in terms of
  the proportion of variance in the data explained by the set of
  extracted components. When specifying \code{nComps}, positive integer
  arguments are interpreted as counts of components; real-valued
  arguments in [0, 1.0) are interpreted as proportions of
  variance explained. Additionally, two special options are available. A
  value of \code{Inf} will employ the smallest number of component
  scores such that adding one more component score does not explain a
  differentiably larger amount of variance. Specifying any negative
  value will employ all possible component scores.
  
  The \code{interactType} argument can take any of the values in {0, 1, 2,
    3}. \code{interactType = 0} includes no interaction terms.
  \code{iteractType = 1} incorporates all two-way interactions between
  the observed variables and the variables specified in the
    \code{moderators} argument of \code{prepData}. \code{iteractType =
    2} incorporates all two-way interactions between the linear
    principal component scores and the variables specified in the
    \code{moderators} argument of \code{prepData}. \code{iteractType
    = 3} incorporates all two-way interactions between linear principal
  component scores and the raw observed variables. Note that
  \code{interactType == 2} or \code{interactType == 3} will produce a
  set of "non-linear" component scores in the \code{pcAux$nonLin} field
    of the PcAuxData object (in addition to the "linear" component
    scores in the \code{pcAux$lin} field), while \code{interactType ==
    0} and \code{interactType == 1} will produce component scores only
    in the \code{pcAux$lin} field. 
  
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
      for removal. Note that any variable specified in the 'moderators'
      argument of \code{prepData} will be retained, regardless of its
      collinearity with other variables. Defaults to \code{collinThresh = 0.95}.
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
    \item{pcaMemLevel:}{
      An integer code representing a trade-off between memory usage and
      numerical accuracy in the algorithm used to extract the principal
      component scores. A value of '0L' (the default) will extract the PC
      scores with the stats::prcomp() package for maximal accuracy. A
      value of '1L' will use the PcAux:::simplePca() subroutine to extract
      the PC scores with considerably lower memory usage but, possibly,
      less numerical accuracy than the prcomp() approach. Leaving this
      option at the default value should be sufficient for most
      applications.
    }
    \item{checkStatus: }{
      The steps at which to record system and OS status. Can take
      values: \code{"none"}, \code{"start"}, or \code{"all"}. Defaults
      to \code{"none"}. 
    }
  }
}
\value{
  An Reference Class object of class PcAuxData with fields for each of
  the \code{createPcAux} function's arguments (except for the raw data
  which are removed to save resources) and the following modified or
  additional fields: 
  \itemize{
    \item{call: }{
      A list containing the matched function call to \code{PcAux}.
    }
    \item{pcAux: }{
      A list of length 2. The first element contains the linear principal
      component auxiliary scores. The second element contains the
      non-linear principal component auxiliary scores.
    }
    \item{rSquared: }{
      A list of length 2. The first element contains the cumulative
      proportion of variance explained by the linear principal component
      auxiliary scores. The second element contains the cumulative
      proportion of variance explained by the non-linear principal
      component auxiliary scores.
    }
    \item{typeVec: }{
      A character vector giving the types assigned to each variable in
      \code{rawData}. 
    }
    \item{methVec: }{
      A character vector giving the elementary imputation methods used
      by \pkg{mice}.
    }
    \item{respCounts: }{
      An integer vector giving the variable-wise counts of any missing
      data in \code{rawData} that remain after the initial single
      imputation. Any variables with non-zero entries in respCounts are
      dropped from the data before extracting the principal component
      scores to keep the PCA from using listwise-deletion.
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
    \item{dummyVars: }{
      A character vector containing the names of the dummy-coded
      representations of the nominal variables.
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
    \item{impFails: }{
      A named list of length 4 with elements: 'firstPass', 'pmm',
      'groupMean', and 'grandMean' containing the names of any variables
      that were not successfully imputed via the named imputation
      strategy. 'First Pass' imputation refers to the ideal approach
      that assigns the elementary imputation methods according to each
      variables declared type. The remaining three methods are
      less-optimal fall-back approaches. 
    }
    \item{patterns: }{
      If the imputation process falls back to group mean substitution,
      this field contains a list of the concatenated grouping patterns
      used to define the strata within which the group means were
      computed. This list will have length equal to
      \code{length(groupVars)}.
    }
    \item{frozenGVars: }{
      If group mean substitution is attempted and some grouping
      variables are continuous, this field contains the binned versions
      of the continuous grouping variables that were used for the group
      mean substitution.
    }
    \item{idFills: }{
      A list containing the values used to deterministically fill any
      missing data that occurred on the ID variables. The length of this
      argument will equal the number of incomplete ID variables in
      \code{rawData}.
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
  \code{\link{prepData}}, \code{\link{miWithPcAux}}
}
\examples{
## Load data:
data(iris2)

## Prepare the data:
cleanData <- prepData(rawData   = iris2,
                      nomVars   = "Species",
                      ordVars   = "Petal.Width",
                      idVars    = "ID",
                      dropVars  = "Junk",
                      groupVars = "Species")

## Create the principal component auxiliaries:
pcAuxOut <- createPcAux(pcAuxData = cleanData, nComps = c(3, 0))
}