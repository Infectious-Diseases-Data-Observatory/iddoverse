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

Study Data Tabulation Model (SDTM) is a standardised format designed for data
storage; it provides a coherent framework for pooling data from multiple studies
and clinical trials, which the Infectious Diseases Data Observatory (IDDO)
adapts in order to collate study data and make it available for reuse. However,
SDTM is not a suitable format for analysis, with several complex transformations
required before further work is possible. 

The `iddoverse` package provides a reproducible set of functions which allows 
any user of the IDDO data repository to convert datasets from long to wider 
formats ('analysis datasets') which are more recognisable and easier to analyse, whilst providing
customisation to allow for a range of use cases. The package is intended for a 
broad audience of programming ability and does not require advanced knowledge 
of the SDTM standard, which removes hurdles for data requesters, especially 
external collaborators and those in Low- and Middle- Income Countries, where 
SDTM training and expertise is harder to access.

Constructing the `iddoverse` demonstrates that standardising the generation of
analysis datasets is possible when using variants of SDTM, whilst still allowing
analysts to modify the output. Consequently, the time spent on data manipulation
will be reduced, allowing research to begin sooner, whilst also ensuring
reproducibility and increasing the accessibility of the SDTM format. 

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
diseases. Owners of clinical data are encouraged to share their data
after they have conducted their research, which IDDO then standardises to our
IDDO-SDTM format through a bespoke curation process. The data is then 
placed securely in the repository and made data freely available to
researchers through a data access application. Once approved, the
IDDO-SDTM data is transferred securely to the data requesters. Users could then
utilise the functions in the `iddoverse` to support their research. 

# Using the iddoverse package 

The package transforms
IDDO-SDTM domains from long to wider data formats, taking events, findings or tests which were
listed individually by rows, and pivots them into columns, which is more typical for
analysis. This is done one domain at a time through the `prepare_domain()` function.
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
these tables is to provide most of the key information for an analysis. These cannot answer every
need for every research question, nor would we want to attempt to make an all
encompassing solution due to the large amount of variance, but these
standardised tables do provide a wealth of key information with minimal
user input, ideal for those who are not experienced R or programming users.

`iddoverse` also contains functions to check and summarise the IDDO-SDTM
data for the user, this supports
with exploratory data analysis and can inform the choice of parameter options
within `prepare_domain`. Additionally, some utility and support functions exist
to derive or convert certain variables. Synthetic data has been 
packaged within `iddoverse` to provide IDDO-SDTM examples for documentation 
and can be used to gain familiarity or test code before and whilst
awaiting the data access application to be finalised.

In conclusion, the `iddoverse` R package provides users of the IDDO data 
repository a variety of functions and datasets to assist them in their research
by speeding up data pre-processing. The package also increases the accessibility of the
repository and will allow more people to confidently use the data, whilst minimising 
duplicated effort of researchers having to code solutions to manipulate the data. Creating a range of
standardised analysis datasets from custom-SDTM implementation is shown to be possible and 
`iddoverse` provides a framework for other organisations whom to do not use SDTM
for pharmaceutical regulatory submission.

# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z]. 

# References
