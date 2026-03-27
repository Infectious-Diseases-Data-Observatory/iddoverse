---
title: "Welcome to the iddoverse: An R package for converting IDDO-SDTM data into 
analysis datasets"
tags:
- R
- Infectious Diseases
- Data Transformation
- Study Data Tabulation Model
date: "27 March 2026" 
output: word_document 
authors:
- name: Rhys Peploe 
  orcid: "0009-0001-1669-3716" 
  affiliation: 1, 2
- name: James Wilson
  affiliation: 1, 2
- name: Jennifer Lee
  orcid: "0000-0002-0391-4575"
  affiliation: 1, 2
- name: Samantha Strudwick
  ordic: "0000-0002-2946-8366"
  affiliation: 1, 2
- name: Hannah Jauncey
  orcid: "0000-0003-1141-5781"
  affiliation: 1, 2
- name: James A Watson
  orcid: "0000-0001-5524-0325"
  affiliation: 1, 2
- name: Prabin Dahal
  orcid: "0000-0002-2158-846X"
  affiliation: 1, 2
bibliography: paper.bib
affiliations:
- name: Infectious Diseases Data Observatory (IDDO), Oxford, United Kingdom
  index: 1
- name: Centre for Tropical Medicine and Global Health, Nuffield Department of Medicine, Oxford, United Kingdom
  index: 2
---

# Summary

Study Data Tabulation Model (SDTM), developed by the Clinical Data Interchange Standards Consortium (CDISC), is an internationally adopted 
data storage standard [@cdisc].  The model provides a coherent framework for harmonising data from 
multiple clinical studies. Using a modified implementation of SDTM, the Infectious Diseases Data Observatory (IDDO) has developed a standardised
repository of individual participant data from clinical studies spanning diseases of global health importance [@iddo]. Generating datasets amenable
to analysis (‘analysis datasets’) from SDTM format requires complex transformations, which necessitates expenditure of additional time and resource by end-users. 

The `iddoverse` package provides a suite of functions that transforms datasets from SDTM format into analysis datasets. Assuming a foundational 
familiarity with the R software [@r_core], the package is intended for epidemiologists, statisticians, and data scientists with a diverse 
range of programming ability. Advanced knowledge of SDTM is not required, thereby removing a potential challenge for data requesters, especially
those in Low- and Middle- Income Countries (LMICs) where SDTM training and expertise is often more difficult to access. Overall, the `iddoverse`
package aims to reduce time spent on data manipulation and facilitate the generation of reproducible analysis datasets [@patel]. 

# Statement of Need

In the context of infectious diseases, IDDO maximises the scientific utility of existing clinical data through the promotion of data reuse
and the adoption of a responsible open-access data model [@pisani_lessons; @pisani_sharing]. By pooling multiple datasets, scientists can address 
important questions using individual participant data meta-analysis (IPD-MA) techniques. To achieve this, IDDO standardises clinical study
data from disparate sources into SDTM format, thereby providing a consistent and comprehensive method to harmonise data. The result is 
a controlled, open-access database, which enables the global research community to address questions of public health relevance that would 
otherwise not be possible using a standalone study.  A key challenge, however, is the effort and time required for transformation of data 
to an analysis-ready format.  This mandates a working knowledge of the SDTM format and nomenclature, in addition to a good knowledge of IDDO’s 
specific implementation of SDTM (a necessary modification to existing implementation guidelines due to heterogeneity in legacy data [@iddo_KKSS]).
End-users unfamiliar with IDDO’s SDTM implementation can therefore encounter challenges in utilising the data.  

# State of the Field

The challenges associated with transforming SDTM formatted data into analysis datasets are not unique to IDDO and several pre-existing tools fully,
or partially, support the transformation process [@pharmaverse; @chen; @ichihashi]. These tools were designed to work on the standard 
implementation of SDTM and assume a working knowledge of CDISC standards. Other tools to generate analysis datasets are either private or follow 
commercial business models, which are not feasible in academic and resource limited settings [@icon; @quanticate; @iddi].  

The `iddoverse` package is tailored to IDDO’s SDTM implementation and is designed to be used by those unfamiliar with the format. Additionally, 
the package has been developed for researchers across the globe, specifically those in LMICs, and is not developed for commercial purpose nor 
for pharmaceutical regulatory submission. 

# SDTM Data

Data stored in SDTM format comprises a series of subsets called domains, with each domain corresponding to a specific data topic. 
Domains are tabular and usually stored in a long format; typically a row per event per participant, which can result in multiple rows 
per participant, per day. The package provides several synthetic datasets generated for user familiarisation and documentation. SDTM 
findings domains, such as the microbiology (MB) domain, can have up to 4 columns for capturing the test results (i.e. `MBORRES`, `MBSTRESC` & `MBSTRESN`) 
and a selection of over 20 timing variables. The MB domain, for example (see `MB_RPTESTB` below), has one row for every microbiology test and the test 
result conducted in the study. Whilst this preserves the intricacies of the study data, it also creates complexity for analysis. 
The `iddoverse` package aims to minimise this analytical burden whilst maximising the retention of data granularity. 

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

# Software Design

The guiding design philosophy has been to promote greater confidence amongst researchers using data from the IDDO 
repository by semi-automating the data transformation from SDTM format into analysis datasets. As a result, a greater 
proportion of the scientific community can benefit from the powerful database IDDO has built over the past 15 years 
and contribute towards the global fight against infectious diseases. 

The `iddoverse` suite (Figure 1) comprises several functions. Most functions are domain-agnostic and can be applied 
across special purpose, findings, and event domains. This approach contrasts with the earlier developmental versions 
of the package (pre version 0.7.0) which had predominately domain-specific functions. Previously, a static selection 
of SDTM timing variables was used, which proved to be too restrictive and impacted the generalisability of the function, so 
a customisable set has now been implemented.  

A key limitation is that the iddoverse functions cannot address every need of researchers due to the large variability 
in the datasets within, and across, diseases. The objective has been to provide assistance and automation of analysis
datasets, whilst keeping the solution generalisable and customisable by the user. 

![Figure 1: Flowchart of functions within the `iddoverse` package.](figures/Function Flowchart.tif)

# iddoverse Functions

A core function within the `iddoverse` package is `prepare_domain()`. This function enables the transformation of a 
single IDDO-SDTM domain. In order to reduce the number of results and timing columns, the function amalgamates data 
into one ‘best choice’ for ‘time’ and ‘result’.  For the ‘best result’, the standardised numeric result (i.e. `MBSTRESN`) 
is taken first for each row.  If this standardised numeric result is missing for a given row, the standardised character value 
(i.e. `MBSTRESC`) will instead be populated as the best choice result for that given row (Figure 2). If both standardised results 
are absent from a row, the modified result (i.e. `MBMODIFY`) will be used, where present. The original contributed result from the study 
(i.e. `MBORRES`) is utilised if no other options are available. Note that `MBMODIFY` is used by IDDO specifically for a handful of 
diseases and will not be relevant to most. The hierarchy of timing variables is study dependent – it is therefore a customisable 
parameter to enable researchers to select the most appropriate variable(s) for their analysis. By choosing a ‘best choice’ timing 
and result, potential confusion surrounding multiple columns is removed. 

![Figure 2: Hierarchy of best choice results/events/findings in `prepare_domain()`. `STRESN` or `DECOD` would be used in the first instance and, where rows are missing this information, they are populated with the variables under them in order. The two letter domain code preceeds these variable names.](figures/Hierarchy Choices.tif)

The `prepare_domain()` function then pivots the rows by the best choice time variable (`TIME`, `TIME_SOURCE`), the study ID (`STUDYID`) 
and participant number (`USUBJID`). The different events/findings/tests are transformed into columns, and the dataset is populated 
with the associated result. Several domains can then be analysed separately, or joined together by the uniquely identifying keys: `STUDYID`, `USUBJID`, `TIME` and `TIME_SOURCE`. 

```r
> prepare_domain(MB_RPTESTB, "mb")
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

Parameters provide customisation options such as variable selection, inclusion of information for test methodology or location, 
and the mechanism for handling rows that are not uniquely separable in the pivot process. 

Additionally, the package contains functions to create standardised analysis datasets, such as `create_participant_table()`. These 
functions merge various domain analysis datasets together by using the `prepare_domain()` multiple times to extract specific variables 
from their source domains. The choice of which variables to include is based on subject matter expertise. The purpose of these tables
is to provide most of the key information required for analyses, for instance the information typically presented in Table 1 of clinical study publications.  

`iddoverse` also provides functions that check and summarise data, which confers support for exploratory data analysis and informs the 
selection of parameters within `prepare_domain()`. Additionally, some utility and support functions exist to derive or convert certain variables.  

# Research Impact Statement

Research which has used the `iddoverse` includes malaria studies conducted by the Liverpool School of Tropical Medicine and the 
Mahidol-Oxford Tropical Medicine Research Unit in Thailand (unpublished at time of writing). Published works which have used the `iddoverse` 
package include research on factors associated with death from Ebola [@trokon] and two visceral leishmaniasis meta-analyses 
[@munir; @kumar]. Additionally, the package is being used internally by IDDO to create summaries to check, and subsequently 
improve, the quality of the data standardisation.  

Since February 2026, all researchers accessing the IDDO data repository have been provided with information on how to use and access the 
`iddoverse` package, thus increasing the number and diversity of users and organisations. 

In a survey conducted by IDDO, several users of the IDDO data repository have reported confusion with the variety of timing variables and 
result columns. Users will benefit from the `iddoverse` package as a solution to this complexity. 

# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z]. 

Special thanks to Dr Caitlin Naylor for their project management support during the project. 

# AI Usage Disclosure 

Artificial Intelligence (AI) models were not used in documentation writing, paper authoring or dataset generation. ChatGPT 5.2 [@chat] was used 
to suggest unit tests using R code for the development of `testthat` script files. This code was manually verified for quality and correctness, 
tested and modified before adding to the package. AI models were not used in the code creation for any of the exported functions in the package.  

# References
