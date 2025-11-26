---
title: "Welcome to the iddoverse: An R package for converting IDDO-SDTM data into 
analysis datasets"
tags:
- R
- Infectious Diseases
- Data Transformation
- Study Data Tabulation Model
date: "20 November 2025" 
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
- name: Centre for Tropical Medicine and Global Health, Nuffield Department of Medicine,
  index: 2
---

# Summary

Study Data Tabulation Model (SDTM) developed by the Clinical
Data Interchange Standards Consortium's (CDISC) [@cdisc] is a standardised format 
designed for data storage and provides a coherent framework for harmonising data 
from multiple clinical trials into a common format. The Infectious Diseases Data
Observatory (IDDO), a group that has championed open-access scientific resources 
in the context of poverty related infectious diseases, has developed a repository 
to collate data from clinical trials for infectious diseases using SDTM as the common format.
Under STDM, data from trials are stored across several domains in a long format 
linked by unique participant or study identification key. Generating analysis 
ready datasets (‘analysis datasets’) requires several complex transformations of 
the SDTM across different domains, which necessitates further time and resource 
for the end-users.

The `iddoverse` package provides a reproducible suite of functions which allows 
users to transform datasets from SDTM to analysis datasets, whilst also providing
options to customise these outputs for a range of use cases. The `iddoverse` package 
is intended for epidemiologists, statisticians and data scientists with a diverse range of
programming ability, but with some familiarity with R software. Advanced knowledge 
of the SDTM ontology which removes hurdles for data requesters, especially
those in Low- and Middle- Income Countries, where 
SDTM training and expertise is harder to access.

The iddoverse package provides a user-friendly, replicable framework for generating 
analysis datasets using IDDO’s SDTM format, whilst still allowing 
analysts to modify the output. Consequently, the time spent on data manipulation 
will be reduced, expediting the research, whilst also ensuring reproducibility and 
increasing the accessibility of the SDTM format. 

# Statement of need 

Clinical studies are key elements in global scientific
research, especially for infectious diseases which disproportionately affect
communities in low- and middle-income countries (LMICs) [@iddo]. However, often
the data from these studies are analysed just once or twice.
IDDO exists to promote the reuse of
individual participant data by
curating submitted data from various sources in-house, to produce freely
available harmonised datasets, enabling scientists to answer new research
questions from existing data. In order to store the data in a centralised
database, IDDO uses the Clinical
Data Interchange Standards Consortium's (CDISC) [@cdisc] international data
standard, SDTM, where data is split into a
series of subsets called domains, each corresponding to a specific type of data.
Most domains are stored in a long data format, typically multiple rows per
participant, per day, which is burdensome to analyse and often requires
significant data manipulation to transform into a format which can then be
analysed. This also mandates a working knowledge of the SDTM format and
nomenclature, as well as, the IDDO implementation of SDTM, since IDDO has adjusted
elements of the standard in order to curate highly heterogeneous legacy data
[@iddo_KKSS]. Consequently, this creates a skill and knowledge based barrier to
accessing the data in the IDDO repository, particularly for researchers in LMICs. 

Organisations and individuals have
created tools to support the transformation of SDTM to analysis datasets, such
as the pharmaverse [@pharmaverse] R [@r_core] packages, however, these do not
work for non-standard implementation of SDTM, thus, are of limited use to
requesters of the data IDDO stores. Moreover, these tools are designed for an
audience accustomed to the CDISC standards, whereas, the researchers using
the IDDO repository often are not familiar with SDTM. Other tools to generate analysis
datasets are private or subscription based business models which are not feasible
in resource limited settings. This warrants an
alternative, open source solution to solve this gap, we propose the `iddoverse` R package, a
disease agnostic transformation tool aimed at researchers using the IDDO
repository and designed to be understandable by a wide range of people
regardless of their data standard knowledge or programming ability. This will
broaden the user audience of the data IDDO holds, increasing the accessibility
of data and accelerate research by minimising the data transformation time [@patel]. 

# IDDO Data Lifecycle 

IDDO hosts a data repository spanning multiple infectious
diseases, driven by data sharing. Investigators of clinical studies are encouraged to share their data
 through a secured portal for the purpose of a specific study group aimed at 
 answering a particular research question of public health importance. After the data are uploaded
 to the IDDO portal, the data are standardised to the
IDDO-SDTM format through a bespoke curation process. The standardised data is then 
placed securely in the repository and is available as an open-access resource to
the research community. Access to the data is managed by a data access committee, which remains independent to IDDO. 
Once the application is approved, the
IDDO-SDTM data are transferred securely to the data requesters. Users could then
utilise the functions in the `iddoverse` to generate analysis datasets to support their research. 

# Using the iddoverse package 

The package transforms
IDDO-SDTM domains from long to wider data formats, taking events, findings or tests which were
listed individually by rows per participant, and pivots them into columns, which is more typical for
analysis. This is performed on one domain at a time through the `prepare_domain()` function.
`prepare_domain()` takes a SDTM domain with often
up to 3 columns for the results and a variety of over 20 timing
variables, amalgamates the data so that there is one 'best choice' result and
timing variable, then pivot the rows by the best choice time variable, the
study id and participant number (`USUBJID`). The different events/findings/tests
then become columns and the dataset is populated with the associated result. 
These best choices follow a hierarchical
list of variables, so for a given row, if the first
variable in the hierarchy list is not present, the second will be used unless that is 
also empty, and so on. Customisation options include which variables to subset the output on, 
whether to add a column for the method
or location of a test, changing the timing variables used or the hierarchy order
and what should happen to rows in the event that they are not uniquely separable
in the pivot process. 

Additionally, the package contains functions to create
standardised analysis datasets, such as `create_participant_table()`. These use the 
`prepare_domain()` function multiple times to extract specific variables from the 
domains they reside in. The choice of which variables to include are based on subject 
matter expertise. The purpose of 
these tables is to provide most of the key information for an analysis, such as
the information typically presented in Table 1 of clinical trials. 
A key limitation is that these functions cannot address every needs of the
researchers and neither it would be possible to attempt to make an all-encompassing 
solution due to the large variability in the dataset within and across the diseseses. 
However, these standardised tables do provide useful key information with minimal 
user input, ideal for those who are not an experienced R or programming users. 

`iddoverse` also contains functions to check and summarise the IDDO-SDTM
data for the user, this supports
with exploratory data analysis and can inform the choice of parameter options
within `prepare_domain`. Additionally, some utility and support functions exist
to derive or convert certain variables. Synthetic data have been 
packaged within `iddoverse` to provide IDDO-SDTM examples for documentation 
and can be used to gain familiarity or test the user's code whilst
awaiting the data access to be granted.

In conclusion, the `iddoverse` R package provides users of the IDDO data 
repository a variety of functions and example datasets to assist their research
by speeding up data pre-processing. The package also increases the accessibility of the
repository and will allow more people to confidently use the IDDO-SDTM data, whilst minimising 
duplicated effort of researchers having to code solutions to manipulate the data. Creating a range of
standardised analysis datasets from custom-SDTM implementation is shown to be possible and 
`iddoverse` provides a framework for other organisations whom to do not use SDTM
for pharmaceutical regulatory submission.

# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z]. 

# References
