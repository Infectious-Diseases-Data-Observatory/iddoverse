---
title: "Welcome to the `iddoverse`: An R package for converting IDDO-SDTM data into analysis
  datasets"
tags:
- R
- Infectious Diseases
- Data Transformation
- SDTM
- Analysis Datasets
date: "10 November 2025" 
output: word_document
authors:
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

Study Data Tabulation Model (SDTM) is a standardised format designed for data storage;
it provides a coherent framework for pooling data from multiple studies and clinical trials, 
which the Infectious Diseases Data Observatory (IDDO) adapts in order to collate study data and make it available for reuse.
However, SDTM is not a suitable format for analysis, with several complex transformations
required before further work is possible.

The `iddoverse` package provides a reproducible set of functions which allows any user of the 
IDDO data repository to convert dataset from long to wider formats 
which are more recognisable and easier to analyse, whilst providing customisation to allow for a broad range of uses.

The package is intended for a broad audience of programming ability and
does not require advanced knowledge of the SDTM standard, which removes hurdles for data requesters, especially external collaborators
and those in Low- and Middle- Income Countries, where SDTM training and expertise is harder to access.
Constructing the `iddoverse` demonstrates that standardising the generation of analysis
datasets is possible when using variants of SDTM, whilst still allowing analysts to modify the
output. Consequently, the time spent on data manipulation will be reduced, allowing research to begin sooner, whilst also
ensuring reproducibility and increasing the accessibility of the SDTM format.

# Statement of need

Clinical studies are key elements in global scientific research, especially for infectious diseases which 
disproportionately affect communities in low- and middle-income countries (LMICs) [@iddo]. However, often the data
from these studies are analysed just once or twice by the study team. The Infectious Diseases Data Observatory (IDDO) exists to promote the reuse of individual 
participant data across the global infectious disease community. IDDO curates submitted 
data from various sources in-house, to produce freely available harmonised datasets, 
enabling scientists to answer new research questions from existing data. 

In order to store the data in a centralised database, which allows the pooling of different studies, IDDO use
the Clinical Data Interchange Standards Consortium's (CDISC) [@cdisc] international data standard Study
Data Tabulation Model (SDTM). In SDTM, data is split into a series of subsets called domains, each corresponding
to a specific type of data. Most domains are stored in a long data format, typically multiple rows per participant, per day, 
which is burdensome to analyse and often requires significant data manpiulation to transform into a format which can then be analysed. 
This also mandates a working knowledge of the SDTM format and nomenclature as well as the IDDO implementation of SDTM, since
IDDO has adjusted elements of the standard in order to curate highly heterogeneous legacy data [@iddo_KKSS]. Consequently, 
this creates a skill and knowledge based barrier to accessing the data in the IDDO repository.

Organisations and individuals have created tools to support the transformation of SDTM to analysis datasets, such as the Pharmaverse [@pharmaverse] R [@r_core] packages,
however, these do not work for non-standard implementation of SDTM and are of limited use to data requestors of the data IDDO stores, moreover, 
these tools are designed for an audience well acustomed to the CDISC standards, whereas, the researchers using the IDDO repository often are 
not familar with SDTM. This warrants an alternative tool to solve this gap, we propose the `iddoverse` R package, a disease agnostic transformation 
tool aimed at researchers using the IDDO repository and designed to be understandable by a wide range of people regardless of their data standard
knowledge or programming ability. This will broaden the user audience of the data IDDO holds, increasing the accessibility of data and accelerate 
research by minimising the data transformation time.

# Using the iddoverse package


 
# Acknowledgements

This research was supported by the Wellcome Trust [222410/Z/21/Z].

# References
