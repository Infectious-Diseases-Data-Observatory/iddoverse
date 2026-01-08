# Prepare IDDO-SDTM domain for analysis

Amalgamate domain data and pivot wider to convert the IDDO-SDTM format
data into a more analysable format. Function works on one domain and
requires the two letter domain name as well as the domain data file.

## Usage

``` r
prepare_domain(
  domain,
  data,
  include_LOC = FALSE,
  include_METHOD = FALSE,
  variables_include = c(),
  timing_variables = c(str_c(domain, "HR"), str_c(domain, "DY"), str_c(domain, "STDY"),
    "VISITDY", "VISITNUM", "VISIT", "EPOCH", str_c(domain, "EVLINT"), str_c(domain,
    "EVINTX")),
  values_fn = first,
  print_messages = TRUE
)
```

## Arguments

- domain:

  Character. The two letter domain name of the data. Domain options:
  "DM", "LB", "MB", "VS", "RS", "DD", "RP", "SC", "MP", "PF", "AU",
  "PC", "SA", "HO", "ER", "PO"

- data:

  Domain data frame.

- include_LOC:

  Boolean. Should the location (–LOC) be included in the output. Default
  is FALSE.

- include_METHOD:

  Boolean. Should the method (–METHOD) be included in the output.
  Default is FALSE.

- variables_include:

  Character list. List of variables to include in the output. Default is
  to include all available variables.

- timing_variables:

  Character list. List of timing variables which are to be used to
  separate time points, this is hierarchical so the order is taken into
  account. Default is: –HR, –DY, –STDY, VISITDY, VISITNUM, VISIT, EPOCH,
  –EVLINT, –EVINTX.

  (using default for example) Each row will be initially summarised
  based on the –HR (study hour) variable, if that is missing then the
  –DY (study day) variable is used, and so on. The output will be one
  row per participant, per time point, where the time point for each row
  is the first available variable listed in timing_variables.

- values_fn:

  Function. The function which will determine which data row is used in
  the output, in the event there are multiple rows for the same subject
  with the same time points (as listed in timing_variables). Default is
  first(), i.e. if there is two rows from the same day and time, the
  first record will be taken, the second will be dropped. Choice of
  timing_variables will impact the number of rows affected.

- print_messages:

  Boolean. Should messages from the function be generated and shown in
  the user's console. Default is TRUE.

## Value

A dataframe which has been cleaned and subset based on the input
parameters.

## Examples

``` r
prepare_domain("DM", DM_RPTESTB)
#> # A tibble: 3 × 21
#>   STUDYID DOMAIN USUBJID SUBJID RFSTDTC DTHDTC DTHFL SITEID INVID INVNAM BRTHDTC
#>   <chr>   <chr>  <chr>    <dbl> <chr>   <chr>  <chr> <chr>  <lgl> <lgl>  <lgl>  
#> 1 RPTESTB DM     RPTEST…      1 2023/01 2023/… Y     OXFORD NA    NA     NA     
#> 2 RPTESTB DM     RPTEST…      2 2023/01 NA     NA    OXFORD NA    NA     NA     
#> 3 RPTESTB DM     RPTEST…      3 2023/02 NA     NA    OXFORD NA    NA     NA     
#> # ℹ 10 more variables: AGE_YEARS <dbl>, AGETXT <lgl>, SEX <chr>, RACE <chr>,
#> #   ETHNIC <chr>, ARMCD <chr>, ARM <chr>, COUNTRY <chr>, DMDTC <chr>,
#> #   DMDY <dbl>

# Select just ARMCD, AGE & SEX
prepare_domain("DM", DM_RPTESTB, variables_include = c("ARMCD", "AGE", "SEX"))
#> # A tibble: 3 × 5
#>   STUDYID USUBJID     ARMCD   AGE SEX  
#>   <chr>   <chr>       <chr> <dbl> <chr>
#> 1 RPTESTB RPTESTB_001 PBO      67 F    
#> 2 RPTESTB RPTESTB_002 TRT      18 F    
#> 3 RPTESTB RPTESTB_003 TRT      48 M    

# Change which timing_variables are used to summarise the data
prepare_domain("lb", LB_RPTESTB, timing_variables = c("VISITNUM", "VISITDY"))
#> [1] "Number of rows where values_fn has been used to pick record in the LB domain: 0"
#> # A tibble: 9 × 7
#>   STUDYID USUBJID     TIME  TIME_SOURCE HCG_NA   `HGB_g/L` `PLAT_10^9/L`
#>   <chr>   <chr>       <chr> <chr>       <chr>    <chr>     <chr>        
#> 1 RPTESTB RPTESTB_001 1     VISITNUM    NA       95        NA           
#> 2 RPTESTB RPTESTB_001 2     VISITNUM    NA       NA        181          
#> 3 RPTESTB RPTESTB_001 3     VISITNUM    NA       88        NA           
#> 4 RPTESTB RPTESTB_002 1     VISITNUM    NEGATIVE 101       NA           
#> 5 RPTESTB RPTESTB_002 2     VISITNUM    NA       NA        100          
#> 6 RPTESTB RPTESTB_002 3     VISITNUM    NA       99        NA           
#> 7 RPTESTB RPTESTB_003 1     VISITNUM    NA       98        NA           
#> 8 RPTESTB RPTESTB_003 2     VISITNUM    NA       NA        90           
#> 9 RPTESTB RPTESTB_003 3     VISITNUM    NA       102       NA           

# Include location in the output and change the values_fn to select the last result
prepare_domain("vs", VS_RPTESTB, include_LOC = TRUE, values_fn = dplyr::last)
#> [1] "Number of rows where values_fn has been used to pick record in the VS domain: 0"
#> # A tibble: 9 × 9
#>   STUDYID USUBJID    TIME  TIME_SOURCE `BMI_NA_kg/m2` HEIGHT_NA_cm TEMP_AXILLA_C
#>   <chr>   <chr>      <chr> <chr>       <chr>          <chr>        <chr>        
#> 1 RPTESTB RPTESTB_0… 1     DY          21.5           167          36.2         
#> 2 RPTESTB RPTESTB_0… 3     DY          NA             NA           37.4         
#> 3 RPTESTB RPTESTB_0… 42    DY          NA             NA           37.5         
#> 4 RPTESTB RPTESTB_0… 1     DY          20.5           143          NA           
#> 5 RPTESTB RPTESTB_0… 4     DY          NA             NA           NA           
#> 6 RPTESTB RPTESTB_0… 40    DY          NA             NA           NA           
#> 7 RPTESTB RPTESTB_0… 2     DY          0.01           84           37.2         
#> 8 RPTESTB RPTESTB_0… 5     DY          NA             NA           37.1         
#> 9 RPTESTB RPTESTB_0… 3     VISITNUM    NA             NA           37.7         
#> # ℹ 2 more variables: TEMP_ORAL_CAVITY_C <chr>, WEIGHT_NA_kg <chr>
```
