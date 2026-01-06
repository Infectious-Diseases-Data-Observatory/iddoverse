# Create table of participant details and baseline characteristics.

Joins several IDDO-SDTM domains together to create a single dataset with
participant demographics, characteristics and baseline test results or
findings. Baseline timing is defined as actual study day (–DY) = 1,
planned study day (VISITDY) = 1 or epoch (EPOCH) = BASELINE.

## Usage

``` r
create_participant_table(
  dm_domain,
  lb_domain = NULL,
  mb_domain = NULL,
  rp_domain = NULL,
  sc_domain = NULL,
  vs_domain = NULL
)
```

## Arguments

- dm_domain:

  A demographics/DM domain data frame.

- lb_domain:

  A laboratory/LB domain data frame.

- mb_domain:

  A microbiology/MB domain data frame.

- rp_domain:

  A reproductive system findings/RP domain data frame.

- sc_domain:

  A subject characteristics/SC domain data frame.

- vs_domain:

  A vital signs/VS domain data frame.

## Value

An analysis dataset, one row per participant.

## Examples

``` r
create_participant_table(dm_domain = DM_RPTESTB,
                         lb_domain = LB_RPTESTB,
                         vs_domain = VS_RPTESTB)
#> [1] "Number of rows where values_fn has been used to pick record in the VS domain: 0"
#> Joining with `by = join_by(STUDYID, USUBJID)`
#> [1] "Number of rows where values_fn has been used to pick record in the LB domain: 0"
#> Joining with `by = join_by(STUDYID, USUBJID)`
#> # A tibble: 3 × 14
#>   STUDYID USUBJID      AGE SEX   RFSTDTC RACE  ETHNIC ARMCD COUNTRY SITEID DTHFL
#>   <chr>   <chr>      <dbl> <chr> <chr>   <chr> <chr>  <chr> <chr>   <chr>  <chr>
#> 1 RPTESTB RPTESTB_0…    67 F     2023/01 White Briti… PBO   UK      OXFORD Y    
#> 2 RPTESTB RPTESTB_0…    18 F     2023/01 White Irish  TRT   UK      OXFORD NA   
#> 3 RPTESTB RPTESTB_0…    48 M     2023/02 White Briti… TRT   UK      OXFORD NA   
#> # ℹ 3 more variables: `BMI_kg/m2` <chr>, HEIGHT_cm <chr>, WEIGHT_kg <chr>

```
