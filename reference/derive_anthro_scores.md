# Calculate WHO growth standards using the anthro() package.

Calculates the Height for Age (HAZ), Weight for Age (WAZ) and Weight for
Height (WHZ) z-scores which are used to measure growth against the WHO
population standards. This is only for children less than 5 years old.

## Usage

``` r
derive_anthro_scores(data)
```

## Arguments

- data:

  data frame that contains the AGE_YEARS, WEIGHT & HEIGHT variables,
  typically held in the Demographics (DM) and Vital Signs (VS) domains.
  Domains should have prepare_domain applied beforehand.

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
  prepare_domain("dm", DM_RPTESTB),
  prepare_domain("vs", VS_RPTESTB)
  )
#> [1] "Number of rows where values_fn has been used to pick record in the VS domain: 0"

derive_anthro_scores(data)
#>   STUDYID     USUBJID DOMAIN SUBJID RFSTDTC DTHDTC DTHFL SITEID INVID INVNAM
#> 1 RPTESTB RPTESTB_003     DM      3 2023/02   <NA>  <NA> OXFORD    NA     NA
#> 2 RPTESTB RPTESTB_003     DM      3 2023/02   <NA>  <NA> OXFORD    NA     NA
#> 3 RPTESTB RPTESTB_003     DM      3 2023/02   <NA>  <NA> OXFORD    NA     NA
#>   BRTHDTC AGE_YEARS AGETXT SEX  RACE  ETHNIC ARMCD       ARM COUNTRY   DMDTC
#> 1      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#> 2      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#> 3      NA         4     NA   M White British   TRT TREATMENT      UK 2023/02
#>   DMDY TIME TIME_SOURCE BMI_kg/m2 HEIGHT_cm TEMP_C WEIGHT_kg   HAZ HAZ_FLAG
#> 1    1    2          DY      0.01        84   37.2       9.6 -4.61        0
#> 2    1    5          DY      <NA>      <NA>   37.1      <NA>    NA       NA
#> 3    1    3    VISITNUM      <NA>      <NA>   37.7      <NA>    NA       NA
#>     WAZ WAZ_FLAG  WHZ WHZ_FLAG
#> 1 -4.11        0 -2.2        0
#> 2    NA       NA   NA       NA
#> 3    NA       NA   NA       NA
```
