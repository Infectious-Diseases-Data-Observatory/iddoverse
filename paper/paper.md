---
title: "Welcome to the iddoverse: An R package for converting IDDO-SDTM data into 
analysis datasets"
tags:
- R
- Infectious Diseases
- Data Transformation
- Study Data Tabulation Model
date: "17 December 2025" 
output: word_document 
authors:
- name: Rhys Peploe 
  orcid: "0009-0001-1669-3716" 
  affiliation: 1, 2
- name: everyone else (to do later)
bibliography: paper.bib
affiliations:
- name: Infectious Diseases Data Observatory (IDDO), Oxford, United Kingdom
  index: 1
- name: Centre for Tropical Medicine and Global Health, Nuffield Department of Medicine, Oxford, United Kingdom
  index: 2
---

# Summary

Study Data Tabulation Model (SDTM) developed by the Clinical Data Interchange Standards Consortium (CDISC) is an internationally used, standardised format 
designed for data storage and provides a coherent framework for harmonising data from multiple clinical trials [@cdisc]. 
The Infectious Diseases Data Observatory (IDDO), a group that has championed open-access scientific resources in the context of poverty 
related infectious diseases, has developed a repository to collate data from clinical trials for infectious diseases using SDTM. 
Under SDTM, data from trials are stored across several datasets in a long format linked by unique participant or study 
identification key. Generating analysis ready datasets (‘analysis datasets’) requires several complex transformations of the SDTM 
across different domains, which necessitates further time and resource for the end-users.

The `iddoverse` package provides a reproducible suite of functions which allows users to transform datasets from SDTM to analysis datasets and 
is intended for epidemiologists, statisticians and data scientists with a diverse range of programming ability, but with some familiarity with 
R software [@r_core]. Advanced knowledge of the SDTM ontology is not required which removes hurdles for data requesters, especially those in 
Low- and Middle- Income Countries (LMICs), where SDTM training and expertise is harder to access. Consequently, the time spent on 
data manipulation will be reduced, expediting the research, whilst also ensuring reproducibility and increasing the accessibility of the SDTM format.

# Statement of need

Clinical studies are key elements in global scientific research, especially for infectious diseases which disproportionately affect 
communities in LMICs [@iddo]. IDDO exists to promote the reuse of individual participant data by curating submitted data from 
various sources in-house, to produce freely available harmonised datasets, enabling scientists to answer new research questions
from existing data. In order to store the data in a centralised database, IDDO uses the SDTM data format, 
where data is split into a series of subsets called domains, each corresponding to a specific type of data. Most
domains are stored in a long data format, typically multiple rows per participant, per day, which is burdensome to analyse and often
requires significant data manipulation to transform into a format which can then be analysed. This also mandates a working knowledge 
of the SDTM format and nomenclature, as well as, the IDDO implementation of SDTM, since IDDO has adjusted elements of the CDISC standard in 
order to curate highly heterogeneous legacy data [@iddo_KKSS]. Consequently, this creates a skill and knowledge based barrier to accessing 
the data in the IDDO repository, particularly for researchers in LMICs.

Existing tools to convert SDTM data [@pharmaverse; @ichihashi; @chen] are designed to work on the standard implementation of SDTM and 
used by an audience accustomed to the CDISC standards, thus, these packages are of limited use to
requesters of the data IDDO stores, due to the IDDO-SDTM implementation and that requesters are often not familiar with SDTM. Other tools to generate analysis datasets are private or 
subscription based business models which are not feasible in resource limited settings. 

The `iddoverse` package minimises the barriers to accessing the data in the IDDO repository by providing reproducible functions which
transforms the IDDO-SDTM data and removes some knowledge requirements to using the data. In addition, the audience of `iddoverse` are
people who do not have a working knowledge of SDTM and is also open source. The purpose of this package is not for pharmaceutical 
regulatory submission, so the output is more flexible for performing statistical analysis on than those developed for regulatory purposes.

# Using the iddoverse package

MB_RPTESTB (below) is an example microbiology (MB) domain which is included in the package and contains 14 plasmodium falciparum tests from 
3 individuals and 39 columns. SDTM domains, such as the MB domain, can have up to 3 columns for the results and a variety of over 20 timing variables, 
while this preserves the intricacies in the trial data, it also creates complexity for analysis.

```r
> library(iddoverse)
> library(tidyverse)
> MB_RPTESTB %>% 
    select(STUDYID, USUBJID, MBTESTCD, MBORRES, MBORRESU, MBSTRESN, MBSTRESU, 
           MBDY, VISITDY, everything())
# A tibble: 14 × 39
   STUDYID USUBJID  MBTESTCD MBORRES MBORRESU MBSTRESN MBSTRESU  MBDY VISITDY
   <chr>   <chr>    <chr>      <dbl> <chr>       <dbl> <chr>    <dbl>   <dbl>
 1 RPTESTB RPTESTB… PFALCIPA     899 10^6/L        899 10^6/L       1       1
 2 RPTESTB RPTESTB… PFALCIPA       0 10^6/L          0 10^6/L       3       3
 3 RPTESTB RPTESTB… PFALCIPA     450 10^6/L        450 10^6/L      85      85
 4 RPTESTB RPTESTB… PFALCIPA    2987 10^6/L       2987 10^6/L     181     182
 5 RPTESTB RPTESTB… PFALCIPA      66 /500 WBC     1056 10^6/L       1       1
 6 RPTESTB RPTESTB… PFALCIPA       3 /500 WBC       48 10^6/L       4       3
 7 RPTESTB RPTESTB… PFALCIPA       0 /500 WBC        0 10^6/L      86      85
 8 RPTESTB RPTESTB… PFALCIPA       0 /500 WBC        0 10^6/L     182     182
 9 RPTESTB RPTESTB… PFALCIPA       0 /500 WBC        0 10^6/L     273     273
10 RPTESTB RPTESTB… PFALCIPA       0 /500 WBC        0 10^6/L     362     366
11 RPTESTB RPTESTB… PFALCIPA     989 10^6/L        989 10^6/L       2       1
12 RPTESTB RPTESTB… PFALCIPA       0 10^6/L          0 10^6/L       5       3
13 RPTESTB RPTESTB… PFALCIPA     167 10^6/L        167 10^6/L      85      85
14 RPTESTB RPTESTB… PFALCIPA       0 10^6/L          0 10^6/L     184     182
# ℹ 30 more variables: DOMAIN <chr>, MBSEQ <dbl>, MBGRPID <lgl>,
#   MBREFID <lgl>, MBTEST <chr>, MBMODIFY <lgl>, MBTSTDTL <chr>,
#   MBCAT <lgl>, MBSTRESC <dbl>, MBSTAT <lgl>, MBREASND <lgl>, MBNAM <lgl>,
#   MBSPEC <chr>, MBSPCCND <lgl>, MBLOC <chr>, MBMETHOD <chr>,
#   VISITNUM <dbl>, VISIT <chr>, EPOCH <chr>, MBDTC <chr>, MBTPT <lgl>,
#   MBTPTNUM <lgl>, MBELTM <lgl>, MBTPTREF <lgl>, MBSTRF <lgl>,
#   MBEVINTX <lgl>, MBSTRTPT <lgl>, MBSTTPT <lgl>, MBCDSTDY <lgl>, …
```

The core function within the `iddoverse` package is `prepare_domain()` which takes a single IDDO-SDTM 
domain, amalgamates the data so that there is one 'best choice' result and timing
variable, then pivots the rows by the best choice time variable (`TIME`, `TIME_SOURCE`), the study id
(`STUDYID`) and participant number (`USUBJID`), demonstrated below. 
The different events/findings/tests then become columns and the dataset is populated with the associated result, providing a condensed dataset 
which is more digestible for researchers and can be easily merged with other data. 

```r
> prepare_domain("mb", MB_RPTESTB)
[1] "Number of rows where values_fn has been used to pick record in the MB domain: 0"
# A tibble: 14 × 5
   STUDYID USUBJID     TIME  TIME_SOURCE `PFALCIPA_10^6/L`
   <chr>   <chr>       <chr> <chr>       <chr>            
 1 RPTESTB RPTESTB_001 1     DY          899              
 2 RPTESTB RPTESTB_001 3     DY          0                
 3 RPTESTB RPTESTB_001 85    DY          450              
 4 RPTESTB RPTESTB_001 181   DY          2987             
 5 RPTESTB RPTESTB_002 1     DY          1056             
 6 RPTESTB RPTESTB_002 4     DY          48               
 7 RPTESTB RPTESTB_002 86    DY          0                
 8 RPTESTB RPTESTB_002 182   DY          0                
 9 RPTESTB RPTESTB_002 273   DY          0                
10 RPTESTB RPTESTB_002 362   DY          0                
11 RPTESTB RPTESTB_003 2     DY          989              
12 RPTESTB RPTESTB_003 5     DY          0                
13 RPTESTB RPTESTB_003 85    DY          167              
14 RPTESTB RPTESTB_003 184   DY          0 
```

These best choices follow a hierarchical list of variables, so
for a given row, if the first variable in the hierarchy list is not present, the second will be used unless that is also empty, and so on. 
Parameters provide custionisation options including which variables to subset the output on, whether to add a column for the method or location of a test, changing 
the timing variables used or the hierarchy order and what should happen to rows in the event that they are not uniquely separable in the pivot process.

![Hierarchy of results/events/findings in `prepare_domain()`. `STRESN` or `DECOD` would be used in the first instance and where rows are missing this information, they are populated with the variables under them in order.](figures/Hierarchy Choices.tif)

Additionally, the package contains functions to create standardised analysis datasets, such as `create_participant_table()`. These use the `prepare_domain()` function multiple times to extract specific variables from the domains they reside in. 
The choice of which variables to include are based on subject matter expertise. The purpose of these tables is to provide most of the key information for an analysis, such as the information typically presented in Table 1 of clinical trials. 
A key limitation is that these functions cannot address every need of researchers and neither it would be possible to attempt to make an all-encompassing solution due to the large variability in the dataset within and across diseases. 
However, these standardised tables do provide useful key information with minimal user input, ideal for those who are not experienced R or programming users.

![Flowchart of functions within the `iddoverse` package.](figures/Function Flowchart.tif)

`iddoverse` also contains functions to check and summarise the IDDO-SDTM data for the user, this supports with exploratory data analysis and
can inform the choice of parameter options within `prepare_domain`. Additionally, some utility and support functions exist to derive or convert
certain variables. Synthetic data, as seen in the example code, have been packaged within `iddoverse` to provide IDDO-SDTM examples for documentation and can be used to gain
familiarity or test the user's code whilst awaiting the data access to be granted.

```r
> check_data(DM_RPTESTB)
$studyid
# A tibble: 1 × 2
  STUDYID     n
  <chr>   <int>
1 RPTESTB     3

$age
# A tibble: 1 × 7
  n_USUBJID AGE_min AGE_max n_missing_AGE n_AGE_under_6M n_AGE_under_18Y
      <int>   <dbl>   <dbl>         <int>          <int>           <int>
1         3       4      67             0              0               1
# ℹ 1 more variable: n_AGE_over_90Y <int>

$missingness
STUDYID  DOMAIN USUBJID  SUBJID RFSTDTC  DTHDTC   DTHFL  SITEID   INVID 
  0.000   0.000   0.000   0.000   0.000   0.667   0.667   0.000   1.000 
 INVNAM BRTHDTC     AGE  AGETXT     SEX    RACE  ETHNIC   ARMCD     ARM 
  1.000   1.000   0.000   1.000   0.000   0.000   0.000   0.000   0.000 
COUNTRY   DMDTC    DMDY 
  0.000   0.000   0.000 
```

In conclusion, the `iddoverse` R package provides users of the IDDO data repository a variety of functions and example datasets to assist their research 
by speeding up data pre-processing. The package also increases the accessibility of the repository and will allow more people to confidently use the IDDO-SDTM 
data, whilst minimising duplicated effort of researchers having to code solutions to manipulate the data and allowing analysts to modify the output. 
Creating a range of standardised analysis datasets from custom-SDTM implementation is shown to be possible and `iddoverse` provides a user-friendly, 
replicable framework for other organisations whom to do not use SDTM for pharmaceutical regulatory submission.

# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z].

# References
