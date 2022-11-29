# PcAux

---

## Archive Notice

PcAux development no longer uses this repository. So, the repository has been
archived. You can find the new home of PcAux development at
<https://github.com/Statscamp/PcAux>.

Below, you can find the original README information for this repository.

---

This is the repository for the PcAux package which was formerly called "quark."

- Licensing information is given in the [LICENSE] file.
- Built tarballs of the PcAux package are available in the [builds][] directory.
- Stand-alone documentation is available in the [documentation][docs] directory.
- The source files for the most recent stable version of PcAux are available in
  the [source][src] directory.

PcAux is beta software, so please report any bugs that you encounter in the
issues section of the project page. You may also leave requests for new features
in the issues section.

Thank you for your interest in the PcAux project! I hope you find our software
useful!

## Installation
The best way to install PcAux is to use the `devtools::install_github` function.

1. First, make sure that you have **devtools** installed on your system
2. Next, execute the following lines:

        library(devtools)
        install_github("PcAux-Package/PcAux/source/PcAux")
    
3. Finally, load **PcAux** and enjoy:

        library(PcAux)

If the **devtools**-based approach does not work, you can download one of the
built tar-balls from the [builds][] directory and manually install the package
from source by executing the following lines:

        install.packages("/SAVE_PATH/PcAux_VERSION.tar.gz",
                         repos = NULL,
                         type  = "source")

Where *SAVE_PATH* is replaced by the (relative or absolute) file path to the
location where you saved the tar-ball, and *VERSION* is replaced with the correct
version number for the tar-ball that you downloaded.

## Example
A basic missing data treatment using **PcAux** might look like the following:

1. First, load and prepare your data:

        data(iris2)
        cleanData <- prepData(rawData   = iris2,
                              nomVars   = "Species",
                              ordVars   = "Petal.Width",
                              idVars    = "ID",
                              dropVars  = "Junk",
                              groupVars = "Species")

2. Next, create a set of principal component auxiliary variables:

        pcAuxOut <- createPcAux(pcAuxData = cleanData,
                                nComps    = c(3, 2))

3. Finally, use the principal component auxiliaries as the predictors in a
   multiple imputation run:

        miOut <- miWithPcAux(rawData   = iris2,
                             pcAuxData = pcAuxOut,
                             nImps     = 5)

You can also work directly with the principal component auxiliaries:

- You can merge the principal component auxiliaries back onto your raw data (e.g.,
  for use with the Graham, 2003, saturated correlates approach).

        outData <- mergePcAux(pcAuxData = pcAuxOut, rawData = iris2)

- You can also create a stand-alone predictor matrix that can be used to
  correctly incorporate the principal component auxiliaries into a separate
  MI run using the **mice** package.

        predMat <- makePredMatrix(mergedData = outData)

[builds]:  https://github.com/PcAux-Package/PcAux/tree/master/builds/
[docs]:    https://github.com/PcAux-Package/PcAux/tree/master/documentation/
[src]:     https://github.com/PcAux-Package/PcAux/tree/master/source/PcAux
[LICENSE]: https://github.com/PcAux-Package/PcAux/blob/master/LICENSE
