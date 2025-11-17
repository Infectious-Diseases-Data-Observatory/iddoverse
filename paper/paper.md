---
title: "Welcome to the iddoverse: An R package for converting IDDO-SDTM data
into analysis datasets" 
tags:
- R
- Infectious Diseases
- Data Transformation
- Study Data Tabulation Model
date: "10 November 2025" 
output: word_document authors:
- name: Rhys Peploe
  orcid: "0009-0001-1669-3716" 
  affiliation: 1, 2
- name: Dr James Wilson
  orcid: XXX 
  affiliation: 1, 2
- name: Dr Caitlin Naylor
  orcid: XXX 
  affiliation: 1, 2
- name: Dr Kasia Stepniewska
  orcid: "0000-0002-1713-6209" 
  affiliation: XXX
- name: Dr James A Watson
  orcid: "0000-0001-5524-0325" 
  affiliation: 1, 2
- name: Dr Prabin Dahal
  orcid: "0000-0002-2158-846X" 
  affiliation: 1, 2 
bibliography: paper.bib
affiliations:
- name: Infectious Diseases Data Observatory (IDDO), Oxford, United Kingdom
  index: 1
- name: Centre for Tropical Medicine and Global Health, Nuffield Department of Medicine,
University of Oxford, Oxford, United Kingdom 
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

#Statement of need 

Clinical studies are key elements in global scientific
research, especially for infectious diseases which disproportionately affect
communities in low- and middle-income countries (LMICs) [@iddo]. However, often
the data from these studies are analysed just once or twice by the study team.
The Infectious Diseases Data Observatory (IDDO) exists to promote the reuse of
individual participant data across the global infectious disease community. IDDO
curates submitted data from various sources in-house, to produce freely
available harmonised datasets, enabling scientists to answer new research
questions from existing data. In order to store the data in a centralised
database, which allows the pooling of different studies, IDDO uses the Clinical
Data Interchange Standards Consortium's (CDISC) [@cdisc] international data
standard, the Study Data Tabulation Model (SDTM). In SDTM, data is split into a
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
work for non-standard implementation of SDTM and are of limited use to
requesters of the data IDDO stores, moreover, these tools are designed for an
audience well accustomed to the CDISC standards, whereas, the researchers using
the IDDO repository often are not familiar with SDTM. Other tools to generate analysis
datasets are private or subscription based business models which are not feasible 
in resource limited settings. This warrants an
alternative, open source solution to solve this gap, we propose the `iddoverse` R package, a
disease agnostic transformation tool aimed at researchers using the IDDO
repository and designed to be understandable by a wide range of people
regardless of their data standard knowledge or programming ability. This will
broaden the user audience of the data IDDO holds, increasing the accessibility
of data and accelerate research by minimising the data transformation time [@patel]. 

#IDDO Data Lifecycle 

IDDO hosts a data repository spanning multiple infectious
diseases. Owners of clinical data are encouraged to share their data with IDDO
after they have conducted their research, which IDDO then standardises to our
IDDO-SDTM format through a bespoke curation process. After the data is curated,
it is placed securely in the repository and made data freely available to
researchers through a data access application, which includes a data access
committee and scientific review of the research plan. Once approved, the
IDDO-SDTM data is transferred securely to the data requesters. Users could then
utilise the functions in the `iddoverse` to support their research. 

# Using the iddoverse package 

The package primarily transforms
IDDO-SDTM domains from long to wider data formats, taking events, findings or tests which were
listed individually by rows, and pivots them into columns, which is more typical for
analysis. This is done one domain at a time through the `prepare_domain()` function and there
are parameter options to customise the output. We take a SDTM domain with often
up to 3 columns for the results or events and a variety of over 20 timing
variables, amalgamate the data so that there is one 'best choice' result and
timing variable, then pivot the rows by the best choice time variable, the
study id and participant number (`USUBJID`). The different events/findings/tests
then become columns and the dataset is populated with the values attached to
those events/findings/tests. These best choices follow a hierarchical
list of variables, so for a given row, if the first
variable in the hierarchy list is not present, the second will be used unless that is 
also empty and so on. The result of this function is a dataset with the
study and participant information, the best choice time, which SDTM variable that
time came from and the various event/finding/result values from the data.
Customisation options include which variables to subset the output on (default
is to pivot all variables/events/tests), whether to add a column for the method
or location of a test, changing the timing variables used or the hierarchy order
and what should happen to rows in the event that they are not uniquely separable
in the pivot process. 

Additionally, the package contains functions to create
standardised analysis datasets, such as `create_participant_table()`. These use the 
`prepare_domain()` function multiple times to extract specific variables from the 
domains they reside in. The choice of which variables to include were based on subject 
matter expertise, though we continue to welcome additional suggestions and feedback 
via our Github repository. The purpose of 
these tables is to provide most of the key information for an analysis, both disease agnostic
versions and themed functions for a particular disease. These cannot answer every
need for every research question, nor would we want to attempt to make an all
encompassing solution, because, there is simply to much variance, but these
standardised tables do provide a large amount of key information with minimal
user input, ideal for those who are not experienced R or programming users.

`iddoverse` also contains functions to check and summarise the IDDO-SDTM
data for the user, this supports
with exploratory data analysis and can inform the choice of parameter options
within `prepare_domain`. Additionally, some utility and support functions exist
to derive or convert certain variables. Synthetic, example data (`STUDYID: RPTESTB`) has been 
packaged within `iddoverse` to provide IDDO-SDTM examples for the documentation 
of functions, and can be used to gain familiarity or test code before and whilst
awaiting the data access application to be finalised.

In conclusion, the `iddoverse` R package provides users of the IDDO data 
repository a variety of functions and datasets to assist them in their research
by speeding up data pre-processing. The package also increases the accessibility of the
repository and will allow more people to confidently use the data, whilst minimising 
duplicated effort of researchers having to code solutions to manipulate the IDDO-SDTM data. Creating a range of
standardised analysis datasets from custom-SDTM implementation is shown to be possible and 
`iddoverse` provides a framework for other organisations whom to do not use SDTM
for pharmaceutical regulatory submission.

# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z]. 

# References
