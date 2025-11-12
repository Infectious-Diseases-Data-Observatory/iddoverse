---
title: "Welcome to the iddoverse: An R package for converting IDDO-SDTM data to analysis
  datasets"
tags:
- R
- Infectious Diseases
date: "10 November 2025"
output: word_document
authors:
- name: Rhys Peploe
  orcid: "0009-0001-1669-3716"
  affiliation: 1, 2
- name: Dr James Wilson
  orcid: XXX
  affiliation: 1, 2
- name: Caitlin Naylor
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
which the Infectious Diseases Data Observatory (IDDO) adapts in order to collate study data and make it availible for reuse.
However, SDTM is not a suitable format for analysis, with several complex transformations
required before further work is possible.

The `iddoverse` package provides a reproducible set of functions which allows any user of the 
Infectious Diseases Data Observatory (IDDO) data repository to convert dataset from long to wider formats 
which are more recognisable and easier to analyse, whilst providing customisation to allow for a broad range of uses.

The package is intended for a broad audience of programming ability and
does not require advanced knowledge of the SDTM standard, which removes hurdles for data requesters, especially external collaborators
and those in Low- and Middle- Income Countries, where SDTM training and expertise is harder to access.
Constructing the {iddoverse} demonstrates that standardising the generation of analysis
datasets is possible when using variants of SDTM, whilst still allowing analysts to modify the
output. Consequently, the time spent on data manipulation will be reduced, allowing research to begin sooner, whilst also
ensuring reproducibility and increasing the accessibility of the SDTM format.

# Statement of need

The Infectious Diseases Data Observatory (IDDO) exists to promote the reuse of individual 
participant data across the global infectious disease community. IDDO curates submitted 
data from many different sources in-house, to produce freely available harmonised datasets, 
enabling scientists to answer new research questions from existing data. It also provides
the methods, governance and infrastructure to translate clinical data into evidence 
to improve health outcomes worldwide.

Deliver an accessible and trusted infectious disease data platform which acts as the central repository for evidence of optimal management and treatment efficacy for selected infectious diseases

In order to store the data in a centralised database, which allows the pooling of different studies, IDDO use
the Clinical Data Interchange Standards Consortium (CDISC) international data standard Study
Data Tabulation Model (SDTM). In SDTM, data is split into a series of subsets called domains, each corresponding
to a specific type of data. Most domains are stored in a long data format, as shown in Table 1.




# The iddoverse package

# Acknowledgements

This research was supported by the Wellcome Trust [XXXX].

# References
