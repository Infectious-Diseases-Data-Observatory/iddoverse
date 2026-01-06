# Tabulate function to display variables in a given domain

Uses table() to display the variables contained within an SDTM formatted
data frame. Additionally can be split by STUDYID to display the options
across multiple studies.

## Usage

``` r
table_variables(domain, data, by_STUDYID = FALSE)
```

## Arguments

- domain:

  Character. The two letter code for the domain which matches the data.
  Character string. Domains included: "DM", "LB", "RP", "MB", "MP",
  "SA", "IN", "VS", "DS", "RS", "PO", "SC", "HO", "ER" & "DD".

- data:

  Domain data frame.

- by_STUDYID:

  Boolean. Split data by STUDYID if TRUE. Default is FALSE.

## Value

For Demographics (DM) domain, a character list with the column names.
For all other domains, a table class object listing the variables under
–TESTCD or INTRT, MPLOC, DSDECOD; where – is the two letter domain name.

## Examples

``` r
table_variables("LB", LB_RPTESTB)
#> 
#>  HCG  HGB PLAT 
#>    1    6    3 

table_variables("VS", VS_RPTESTB, by_STUDYID = TRUE)
#>          
#>           BMI HEIGHT TEMP WEIGHT
#>   RPTESTB   3      3    9      3
```
