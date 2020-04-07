This page is intended to assist users in contributing to the the PcAux project. 

Here are some good ways to start: 

* Post issues - either bug reports or feature requests. 
* Comment on issues - keep the discussion going by asking for clarification or proposing implementation on open issues.
* Post reproducible examples - certain issues may need to be clarified by posting a minimally-reproducible example, called a reprex. You can use the `reprex` package, but are not required to. 
* Send pull requests - potential new features or bug fixes can be submitted in the form of a pull request. The etiquette for submitting pull requests is discussed in detail below. 

To submit a pull request to the PcAux project: 

* Fork the PcAux repository to your user repository.
* Create a feature branch (preferably named in accordance to the bug/feature you are addressing). 
* Pull down your branched fork of PcAux to your local machine. 
* Make the necessary change in your user fork of PcAux.
* Change the modification date of any scripts you have altered (and in the DESCRIPTION file) and add yourself as a contributor, if you are not already one. Address the relevant changes that you have made in the [Changelog](https://github.com/PcAux-Package/PcAux/blob/develop/CHANGELOG.md). 
* Check that the package still works after you have made your changes using either `R CMD check` or `devtools::check()`.
* Run the unit tests that are in the `test` directory, and if you are adding a new feature, write the appropriate tests to the `unitTests.R` script. You will need to build and install the package to run the unit tests.
* Push the changes to your feature branch. 
* Submit a pull request to the main PcAux repository by proposing to merge your fork's feature branch to the development branch of PcAux.
* When you make your pull request, please make certain that it addresses _only_ _one_ issue. Make sure to reference the issue number you are addressing, as well. 
* A PcAux team member will review your pull request and likely make comments or ask for additional changes. 
* Once all of the changes have been approved, the reviewing PcAux team member will merge the pull request to the development branch of PcAux.

TL;DR for making changes:

* Identify issue
* Fork PcAux 
* Create branch on your fork
* Edit branch
* Change script dates, DESCRIPTION date
* Add contributor credits to script & add changes to the changelog
* Run checks (devtools::check())
* Build & install your version of PcAux
* Run unit tests
* Push changes to remote 
* Create pull request referencing issue number
