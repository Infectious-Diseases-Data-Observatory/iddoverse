# iddoverse

<!-- badges: start -->

 <img src="man/figures/iddoverse_hexsticker_solid.png" align="right" height="120"/>

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/iddoverse)](https://CRAN.R-project.org/package=iddoverse)
[![R-CMD-check.yaml](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/actions/workflows/check-standard.yaml)
[![test-coverage.yaml](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/actions/workflows/test-coverage.yaml)

<!-- badges: end -->

<br>

## Purpose

To create analysis ready datasets ('analysis datasets') for researchers 
using data stored in the Infectious Diseases Data Observatory (IDDO) repository.

These reusable
functions aim to provide a toolbox for researchers to modify the
analysis dataset to their study-specific needs, speeding up the time it
takes to create analysable datasets.

## Installation

You can install the development version of `iddoverse` from
[GitHub](https://github.com/) with the following code in the R console:

``` r
# uncomment below line if you have not installed 'devtools' on your machine
# install.packages("devtools")
devtools::install_github("Infectious-Diseases-Data-Observatory/iddoverse")
library(iddoverse)
```

We recommend re-installing regularly as the package is developing
constantly. Versions starting with ‘0.’
should be expected to change without notification.

## Why is this useful?

The package assists researchers to transform their datasets (transferred from IDDO),
minimising the time spent on data transformation before analysis can begin. These functions specifically work on
SDTM (Study Data Tabulation Model) data stored by IDDO. MAPPER data from IDDO is not supported
in this package.

Functions are documented and have example code. A [vignette](https://infectious-diseases-data-observatory.github.io/iddoverse/articles/iddoverse.html)
provides a demostration/tutorial of the functions and data in the package.

## Citation

To cite `iddoverse` in publications, see
[CITATION](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/blob/main/inst/CITATION)

## Issues

Improvements to the code are constantly being made, if you notice
errors, bugs, want to suggest improvements or have ideas for better
functionality, please describe them in
[Issues](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues).

## Contact

Please contact Rhys Peploe (<rhys.peploe@iddo.org> or
<rhyspeploe1998@gmail.com>) if you would like to know more, need support or are
interested in contributing to the package.
