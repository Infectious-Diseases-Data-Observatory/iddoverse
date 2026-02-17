# Create table of malaria specific PCR data

Joins the pharmacogenomics genetics (PF) and disease response and
clinical classification (RS) IDDO-SDTM domains together to create a
single dataset.

## Usage

``` r
create_malaria_pcr_table(
  pf_domain,
  rs_domain,
  ds_domain = NULL,
  values_funct = first
)
```

## Arguments

- pf_domain:

  A pharmacogenomics genetics/PF domain data frame

- rs_domain:

  A disease response and clinical classification/RS domain data frame.

- ds_domain:

  A disposition/DS domain data frame

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
create_malaria_pcr_table(PF_RPTESTB, RS_RPTESTB)
#> [1] "Number of rows where values_fn has been used to pick record in the PF domain: 0"
#> [1] "Number of rows where values_fn has been used to pick record in the RS domain: 0"
#> Joining with `by = join_by(STUDYID, USUBJID, TIME, TIME_SOURCE)`
#> # A tibble: 3 × 6
#>   STUDYID USUBJID     TIME  TIME_SOURCE INTP_NA       WHOMAL01_NA               
#>   <chr>   <chr>       <chr> <chr>       <chr>         <chr>                     
#> 1 RPTESTB RPTESTB_001 46    DY          RECRUDESCENCE LATE PARASITOLOGICAL FAIL…
#> 2 RPTESTB RPTESTB_002 50    DY          INDETERMINATE ACPR                      
#> 3 RPTESTB RPTESTB_003 43    DY          REINFECTION   ACPR                      
```
