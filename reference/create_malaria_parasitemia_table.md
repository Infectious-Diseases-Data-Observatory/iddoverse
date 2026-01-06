# Create table of parasitemia data specifically for malaria parasites.

Uses the IDDO-SDTM microbiology (MB) domain to create a single dataset
with various microbiology information summarised.

## Usage

``` r
create_malaria_parasitemia_table(
  mb_domain,
  variables = c("PFALCIPA", "PFALCIPS", "PFALCIP", "PVIVAXA", "PVIVAXS", "PVIVAX"),
  include_method = FALSE,
  include_location = FALSE,
  timing_variables = c("MBHR", "MBDY", "MBSTDY", "VISITDY", "VISITNUM", "VISIT", "EPOCH",
    "MBEVLINT", "MBEVINTX"),
  values_funct = first
)
```

## Arguments

- mb_domain:

  A microbiology/MB domain data frame.

- variables:

  Character list. A list of variables to be included in the output
  dataset.

- include_method:

  Boolean. Should MBMETHOD be included in the output for all variables.

- include_location:

  Boolean. Should MBLOC be included in the output for all variables.

- timing_variables:

  Character list. List of timing variables which are to be used to
  separate time points, this is hierarchical so the order is taken into
  account. Default is: MBHR, MBDY, MBSTDY, VISITDY, VISITNUM, VISIT,
  EPOCH, MBEVLINT, MBEVINTX.

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
create_malaria_parasitemia_table(MB_RPTESTB)
#> [1] "Number of rows where values_fn has been used to pick record in the MB domain: 0"
#> # A tibble: 14 × 5
#>    STUDYID USUBJID     TIME  TIME_SOURCE `PFALCIPA_10^6/L`
#>    <chr>   <chr>       <chr> <chr>       <chr>            
#>  1 RPTESTB RPTESTB_001 1     DY          899              
#>  2 RPTESTB RPTESTB_001 3     DY          0                
#>  3 RPTESTB RPTESTB_001 85    DY          450              
#>  4 RPTESTB RPTESTB_001 181   DY          2987             
#>  5 RPTESTB RPTESTB_002 1     DY          1056             
#>  6 RPTESTB RPTESTB_002 4     DY          48               
#>  7 RPTESTB RPTESTB_002 86    DY          0                
#>  8 RPTESTB RPTESTB_002 182   DY          0                
#>  9 RPTESTB RPTESTB_002 273   DY          0                
#> 10 RPTESTB RPTESTB_002 362   DY          0                
#> 11 RPTESTB RPTESTB_003 2     DY          989              
#> 12 RPTESTB RPTESTB_003 5     DY          0                
#> 13 RPTESTB RPTESTB_003 85    DY          167              
#> 14 RPTESTB RPTESTB_003 184   DY          0                

# Change which timing_variables are used to summarise the data
create_malaria_parasitemia_table(MB_RPTESTB, timing_variables = "EPOCH")
#> [1] "Number of rows where values_fn has been used to pick record in the MB domain: 3"
#> # A tibble: 9 × 5
#>   STUDYID USUBJID     TIME      TIME_SOURCE `PFALCIPA_10^6/L`
#>   <chr>   <chr>       <chr>     <chr>       <chr>            
#> 1 RPTESTB RPTESTB_001 BASELINE  EPOCH       899              
#> 2 RPTESTB RPTESTB_001 TREATMENT EPOCH       0                
#> 3 RPTESTB RPTESTB_001 FOLLOW UP EPOCH       450              
#> 4 RPTESTB RPTESTB_002 BASELINE  EPOCH       1056             
#> 5 RPTESTB RPTESTB_002 TREATMENT EPOCH       48               
#> 6 RPTESTB RPTESTB_002 FOLLOW UP EPOCH       0                
#> 7 RPTESTB RPTESTB_003 BASELINE  EPOCH       989              
#> 8 RPTESTB RPTESTB_003 TREATMENT EPOCH       0                
#> 9 RPTESTB RPTESTB_003 FOLLOW UP EPOCH       167              

# Adding include_method = TRUE provides the method in the column of the analysis dataset
create_malaria_parasitemia_table(MB_RPTESTB, include_method = TRUE)
#> [1] "Number of rows where values_fn has been used to pick record in the MB domain: 0"
#> # A tibble: 14 × 5
#>    STUDYID USUBJID     TIME  TIME_SOURCE `PFALCIPA_MICROSCOPY_10^6/L`
#>    <chr>   <chr>       <chr> <chr>       <chr>                       
#>  1 RPTESTB RPTESTB_001 1     DY          899                         
#>  2 RPTESTB RPTESTB_001 3     DY          0                           
#>  3 RPTESTB RPTESTB_001 85    DY          450                         
#>  4 RPTESTB RPTESTB_001 181   DY          2987                        
#>  5 RPTESTB RPTESTB_002 1     DY          1056                        
#>  6 RPTESTB RPTESTB_002 4     DY          48                          
#>  7 RPTESTB RPTESTB_002 86    DY          0                           
#>  8 RPTESTB RPTESTB_002 182   DY          0                           
#>  9 RPTESTB RPTESTB_002 273   DY          0                           
#> 10 RPTESTB RPTESTB_002 362   DY          0                           
#> 11 RPTESTB RPTESTB_003 2     DY          989                         
#> 12 RPTESTB RPTESTB_003 5     DY          0                           
#> 13 RPTESTB RPTESTB_003 85    DY          167                         
#> 14 RPTESTB RPTESTB_003 184   DY          0                           
```
