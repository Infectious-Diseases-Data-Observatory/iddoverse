# iddoverse

<!-- badges: start -->

 <img src="man/figures/logo.png" align="right" height="120"/>

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/iddoverse)](https://CRAN.R-project.org/package=iddoverse)

<!-- badges: end -->

The `iddoverse` contains R functions to convert IDDO-curated SDTM 
domains into analysis ready datasets('analysis datasets'). These reusable
functions aim to provide a toolbox for researchers to modify the
analysis dataset to their study-specific needs, speeding up the time it
takes to create analysable data.

This package takes inspiration from the `pharmaverse`, specifically the
[`admiral`](https://github.com/pharmaverse/admiral) R package, however,
IDDO-SDTM formats are not strictly compliant with standards required by
pharmacutical companies and the target audience of the `iddoverse` are 
researchers who do not have a working knowledge of SDTM, unlike the `pharmaverse`.

    IDDO - Infectious Disease Data Observatory
    SDTM - Study Data Tabulation Model, an internation data storage model from CDISC which is used by IDDO.

## Installation

You can install the development version of `iddoverse` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools") #if you have not previously installed 'devtools' on your machine
devtools::install_github("Infectious-Diseases-Data-Observatory/iddoverse")
library(iddoverse)
```

We recommend updating the install regularly as the package is developing
constantly. Versions starting with ‘0.’
should be expected to change without notification.

It is best to remove the package and reinstall the current version:

``` r
detach("package:iddoverse", unload = TRUE)

devtools::install_github("Infectious-Diseases-Data-Observatory/iddoverse")
library(iddoverse)
```

## Why is this useful?

The package will assist researchers manpiulate their datasets transferred from IDDO,
 minimising the time spent on data transformation before analysis can begin. 

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
