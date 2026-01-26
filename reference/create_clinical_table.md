# Creates table of key clinical features

Uses several IDDO-SDTM domains to create a single dataset with various
demographic, microbiology, physiology, clinical and vital sign
information summarised.

## Usage

``` r
create_clinical_table(
  dm_domain,
  mb_domain = NULL,
  mp_domain = NULL,
  sa_domain = NULL,
  vs_domain = NULL,
  values_funct = first
)
```

## Arguments

- dm_domain:

  A demographics/DM domain data frame.

- mb_domain:

  A microbiology/MB domain data frame.

- mp_domain:

  A morphology and physiology/MP domain data frame.

- sa_domain:

  A clinical and adverse events/SA domain data frame.

- vs_domain:

  A vital signs/VS domain data frame.

- values_funct:

  Function. The function which will determine which data row is used in
  the output, in the event there are multiple rows for the same subject
  with the same time points (as listed in timing_variables). Default is
  first(), i.e. if there is two rows from the same day and time, the
  first record will be taken, the second will be dropped. Choice of
  timing_variables will impact the number of rows affected.

## Value

An analysis dataset, one row per person, per timepoint.

## Examples

``` r
create_clinical_table(dm_domain = DM_RPTESTB,
                      sa_domain = SA_RPTESTB,
                      vs_domain = VS_RPTESTB)
#> [1] "Number of rows where values_fn has been used to pick record in the VS domain: 0"
#> Joining with `by = join_by(STUDYID, USUBJID)`
#> [1] "Number of rows where values_fn has been used to pick record in the SA domain: 0"
#> Joining with `by = join_by(STUDYID, USUBJID, TIME, TIME_SOURCE)`
#> # A tibble: 10 × 10
#>    STUDYID USUBJID     TIME  TIME_SOURCE `BMI_kg/m2` HEIGHT_cm TEMP_C WEIGHT_kg
#>    <chr>   <chr>       <chr> <chr>       <chr>       <chr>     <chr>  <chr>    
#>  1 RPTESTB RPTESTB_001 1     DY          21.5        167       36.2   60       
#>  2 RPTESTB RPTESTB_001 3     DY          NA          NA        37.4   NA       
#>  3 RPTESTB RPTESTB_001 42    DY          NA          NA        37.5   NA       
#>  4 RPTESTB RPTESTB_002 1     DY          20.5        143       37.5   42       
#>  5 RPTESTB RPTESTB_002 4     DY          NA          NA        37.2   NA       
#>  6 RPTESTB RPTESTB_002 40    DY          NA          NA        37.9   NA       
#>  7 RPTESTB RPTESTB_003 2     DY          0.01        84        37.2   9.6      
#>  8 RPTESTB RPTESTB_003 5     DY          NA          NA        37.1   NA       
#>  9 RPTESTB RPTESTB_003 3     VISITNUM    NA          NA        37.7   NA       
#> 10 RPTESTB RPTESTB_001 -18   STDY        NA          NA        NA     NA       
#> # ℹ 2 more variables: FEVER_PRESP <chr>, FEVER_OCCURRENCE <chr>
```
