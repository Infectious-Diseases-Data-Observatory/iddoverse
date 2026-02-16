# Tabulate function to display variables in a given domain

Uses table() to display the variables contained within an SDTM formatted
data frame. Additionally can be split by STUDYID to display the options
across multiple studies.

## Usage

``` r
table_variables(data, domain, by_STUDYID = FALSE)
```

## Arguments

- data:

  Domain data frame.

- domain:

  Character. The two letter code for the domain which matches the data.
  Domains included: "DM", "LB", "RP", "MB", "MP", "SA", "IN", "VS",
  "DS", "RS", "PO", "SC", "HO", "ER", "DD", "PF", "AU", "PC", "PE".

- by_STUDYID:

  Boolean. Split data by STUDYID if TRUE. Default is FALSE.

## Value

For Demographics (DM) domain, a character list with the column names.
For all other domains, a table class object listing the variables under
–TESTCD or INTRT, MPLOC, DSDECOD; where – is the two letter domain name.

## Examples

``` r
table_variables(LB_RPTESTB, "LB")
#> 
#>  HCG  HGB PLAT 
#>    1    6    3 

table_variables(VS_RPTESTB, "VS", by_STUDYID = TRUE)
#>          
#>           BMI HEIGHT TEMP WEIGHT
#>   RPTESTB   3      3    9      3
```
