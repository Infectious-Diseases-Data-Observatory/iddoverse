# Create table of laboratory test results

Uses the IDDO-SDTM laboratory test results (LB) domain to create a
single dataset with various lab test result information summarised.

## Usage

``` r
create_labs_table(
  lb_domain,
  variables = c("ALB", "ALT", "AST", "BILI", "CREAT", "CD4", "G6PD", "HCT", "HGB",
    "HGBMET", "INTLK6", "K", "PLAT", "SODIUM", "WBC"),
  include_method = FALSE,
  timing_variables = c("LBHR", "LBDY", "LBSTDY", "VISITDY", "VISITNUM", "VISIT", "EPOCH",
    "LBEVLINT", "LBEVINTX"),
  values_funct = first
)
```

## Arguments

- lb_domain:

  A laboratory/LB domain data frame.

- variables:

  Character list. A list of variables to be included in the output
  dataset.

- include_method:

  Boolean. Should LBMETHOD be included in the output for all variables.

- timing_variables:

  Character list. List of timing variables which are to be used to
  separate time points, this is hierarchical so the order is taken into
  account. Default is: LBHR, LBDY, LBSTDY, VISITDY, VISITNUM, VISIT,
  EPOCH, LBEVLINT, LBEVINTX.

  (using default for example) Each row will be initially summarised
  based on the –HR (study hour) variable, if that is missing then the
  –DY (study day) variable is used, and so on. The output will be one
  row per participant, per time point, where the time point for each row
  is the first available variable listed in timing_variables.

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
create_labs_table(LB_RPTESTB)
#> [1] "Number of rows where values_fn has been used to pick record in the LB domain: 0"
#> # A tibble: 9 × 6
#>   STUDYID USUBJID     TIME  TIME_SOURCE `HGB_g/L` `PLAT_10^9/L`
#>   <chr>   <chr>       <chr> <chr>       <chr>     <chr>        
#> 1 RPTESTB RPTESTB_001 1     DY          95        NA           
#> 2 RPTESTB RPTESTB_001 3     DY          NA        181          
#> 3 RPTESTB RPTESTB_001 42    DY          88        NA           
#> 4 RPTESTB RPTESTB_002 1     DY          101       NA           
#> 5 RPTESTB RPTESTB_002 4     DY          NA        100          
#> 6 RPTESTB RPTESTB_002 40    DY          99        NA           
#> 7 RPTESTB RPTESTB_003 2     DY          98        NA           
#> 8 RPTESTB RPTESTB_003 5     DY          NA        90           
#> 9 RPTESTB RPTESTB_003 3     VISITNUM    102       NA           

# Change which timing_variables are used to summarise the data, select just Hemoglobin
create_labs_table(LB_RPTESTB,
                  variables = c("HGB"),
                  timing_variables = c("EPOCH", "VISIT"))
#> [1] "Number of rows where values_fn has been used to pick record in the LB domain: 0"
#> # A tibble: 6 × 5
#>   STUDYID USUBJID     TIME      TIME_SOURCE `HGB_g/L`
#>   <chr>   <chr>       <chr>     <chr>       <chr>    
#> 1 RPTESTB RPTESTB_001 BASELINE  EPOCH       95       
#> 2 RPTESTB RPTESTB_001 FOLLOW UP EPOCH       88       
#> 3 RPTESTB RPTESTB_002 BASELINE  EPOCH       101      
#> 4 RPTESTB RPTESTB_002 FOLLOW UP EPOCH       99       
#> 5 RPTESTB RPTESTB_003 BASELINE  EPOCH       98       
#> 6 RPTESTB RPTESTB_003 FOLLOW UP EPOCH       102      
```
