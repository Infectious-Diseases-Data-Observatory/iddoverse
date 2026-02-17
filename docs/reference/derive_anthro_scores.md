# Calculate WHO growth standards using the anthro() package.

Calculates the Height for Age (HAZ), Weight for Age (WAZ) and Weight for
Height (WHZ) z-scores which are used to measure growth against the WHO
population standards. This is only for children less than 5 years old.

## Usage

``` r
derive_anthro_scores(data, age_in_years = TRUE)
```

## Arguments

- data:

  data frame that contains the AGE_YEARS, WEIGHT & HEIGHT variables,
  typically held in the Demographics (DM) and Vital Signs (VS) domains.
  Domains should have prepare_domain applied beforehand.

- age_in_years:

  Boolean. Is the AGE column in years. Default is FALSE, and function
  will call `convert_age_to_years` if FALSE, otherwise will not convert
  age.

## Value

data frame with only only 5 year olds included and additional columns
for WAZ, HAZ and WHZ scores, along with flags for each.

## Details

The function can be applied to a dataset with subjects greater than 5
years old too, but those subjects will be filtered out.

## Examples

``` r
# Merge the DM (AGE_YEARS, SEX) and VS (WEIGHT, HEIGHT) domains together
data = merge(
  prepare_domain(DM_RPTESTB, "dm"),
  prepare_domain(VS_RPTESTB, "vs")
  )
#> [1] "Number of rows where values_fn has been used to pick record in the VS domain: 0"

derive_anthro_scores(data)
#> Joining with `by = join_by(STUDYID, USUBJID, DOMAIN, SUBJID, RFSTDTC, DTHDTC,
#> DTHFL, SITEID, INVID, INVNAM, BRTHDTC, AGE_YEARS, AGETXT, SEX, RACE, ETHNIC,
#> ARMCD, ARM, COUNTRY, DMDTC, DMDY, TIME, TIME_SOURCE, `BMI_kg/m2`, HEIGHT_cm,
#> TEMP_C, WEIGHT_kg)`
#>   STUDYID     USUBJID DOMAIN SUBJID RFSTDTC  DTHDTC DTHFL SITEID INVID INVNAM
#> 1 RPTESTB RPTESTB_001     DM      1 2023/01 2023/08     Y OXFORD    NA     NA
#> 2 RPTESTB RPTESTB_001     DM      1 2023/01 2023/08     Y OXFORD    NA     NA
#> 3 RPTESTB RPTESTB_001     DM      1 2023/01 2023/08     Y OXFORD    NA     NA
#> 4 RPTESTB RPTESTB_002     DM      2 2023/01    <NA>  <NA> OXFORD    NA     NA
#> 5 RPTESTB RPTESTB_002     DM      2 2023/01    <NA>  <NA> OXFORD    NA     NA
#> 6 RPTESTB RPTESTB_002     DM      2 2023/01    <NA>  <NA> OXFORD    NA     NA
#> 7 RPTESTB RPTESTB_003     DM      3 2023/02    <NA>  <NA> OXFORD    NA     NA
#> 8 RPTESTB RPTESTB_003     DM      3 2023/02    <NA>  <NA> OXFORD    NA     NA
#> 9 RPTESTB RPTESTB_003     DM      3 2023/02    <NA>  <NA> OXFORD    NA     NA
#>   BRTHDTC AGE_YEARS AGETXT SEX  RACE  ETHNIC ARMCD       ARM COUNTRY   DMDTC
#> 1      NA        67     NA   F White British   PBO   PLACEBO      UK 2023/01
#> 2      NA        67     NA   F White British   PBO   PLACEBO      UK 2023/01
#> 3      NA        67     NA   F White British   PBO   PLACEBO      UK 2023/01
#> 4      NA        18     NA   F White   Irish   TRT TREATMENT      UK 2023/01
#> 5      NA        18     NA   F White   Irish   TRT TREATMENT      UK 2023/01
#> 6      NA        18     NA   F White   Irish   TRT TREATMENT      UK 2023/01
#> 7      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#> 8      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#> 9      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#>   DMDY      TIME TIME_SOURCE BMI_kg/m2 HEIGHT_cm TEMP_C WEIGHT_kg   HAZ
#> 1    1         1          DY      21.5       167   36.2        60    NA
#> 2    1         3          DY      <NA>      <NA>   37.4      <NA>    NA
#> 3    1        42          DY      <NA>      <NA>   37.5      <NA>    NA
#> 4    1         1          DY      20.5       143   37.5        42    NA
#> 5    1         4          DY      <NA>      <NA>   37.2      <NA>    NA
#> 6    1        40          DY      <NA>      <NA>   37.9      <NA>    NA
#> 7    1         2          DY      0.01        84   37.2       9.6 -4.61
#> 8    1         5          DY      <NA>      <NA>   37.1      <NA>    NA
#> 9    1 FOLLOW UP       EPOCH      <NA>      <NA>   37.7      <NA>    NA
#>   HAZ_FLAG   WAZ WAZ_FLAG  WHZ WHZ_FLAG
#> 1       NA    NA       NA   NA       NA
#> 2       NA    NA       NA   NA       NA
#> 3       NA    NA       NA   NA       NA
#> 4       NA    NA       NA   NA       NA
#> 5       NA    NA       NA   NA       NA
#> 6       NA    NA       NA   NA       NA
#> 7        0 -4.11        0 -2.2        0
#> 8       NA    NA       NA   NA       NA
#> 9       NA    NA       NA   NA       NA
```
