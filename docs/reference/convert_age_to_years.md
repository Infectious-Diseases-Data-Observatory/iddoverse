# Convert AGE to years.

Convert the AGE of all subjects to years and change the AGEU to "YEARS".

## Usage

``` r
convert_age_to_years(data)
```

## Arguments

- data:

  data frame containing the AGE and AGEU variables; typically the
  Demographics (DM) domain.

## Value

data frame with AGE in years as opposed to the original values.

## Examples

``` r
DM_RPTESTB
#> # A tibble: 3 × 22
#>   STUDYID DOMAIN USUBJID SUBJID RFSTDTC DTHDTC DTHFL SITEID INVID INVNAM BRTHDTC
#>   <chr>   <chr>  <chr>    <dbl> <chr>   <chr>  <chr> <chr>  <lgl> <lgl>  <lgl>  
#> 1 RPTESTB DM     RPTEST…      1 2023/01 2023/… Y     OXFORD NA    NA     NA     
#> 2 RPTESTB DM     RPTEST…      2 2023/01 NA     NA    OXFORD NA    NA     NA     
#> 3 RPTESTB DM     RPTEST…      3 2023/02 NA     NA    OXFORD NA    NA     NA     
#> # ℹ 11 more variables: AGE <dbl>, AGETXT <lgl>, AGEU <chr>, SEX <chr>,
#> #   RACE <chr>, ETHNIC <chr>, ARMCD <chr>, ARM <chr>, COUNTRY <chr>,
#> #   DMDTC <chr>, DMDY <dbl>

convert_age_to_years(DM_RPTESTB)
#> # A tibble: 3 × 21
#>   STUDYID DOMAIN USUBJID SUBJID RFSTDTC DTHDTC DTHFL SITEID INVID INVNAM BRTHDTC
#>   <chr>   <chr>  <chr>    <dbl> <chr>   <chr>  <chr> <chr>  <lgl> <lgl>  <lgl>  
#> 1 RPTESTB DM     RPTEST…      1 2023/01 2023/… Y     OXFORD NA    NA     NA     
#> 2 RPTESTB DM     RPTEST…      2 2023/01 NA     NA    OXFORD NA    NA     NA     
#> 3 RPTESTB DM     RPTEST…      3 2023/02 NA     NA    OXFORD NA    NA     NA     
#> # ℹ 10 more variables: AGE_YEARS <dbl>, AGETXT <lgl>, SEX <chr>, RACE <chr>,
#> #   ETHNIC <chr>, ARMCD <chr>, ARM <chr>, COUNTRY <chr>, DMDTC <chr>,
#> #   DMDY <dbl>
```
