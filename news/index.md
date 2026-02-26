# Changelog

## iddoverse 0.9.0

- create_participant_table: baseline timing EPOCH == BASELINE then
  VISITDY == 1, change from any of VISITDY == 1, DY == 1 and EPOCH ==
  BASELINE
- prepare_domain: data first, domain second in parameter order to align
  with tidy principles, changes to downstream functions, examples,
  documentation, tests and vignette
- prepare_domain: added a print message describing the timing variables
  used in console
- table_variables: data first, domain second in parameter order to align
  with tidy principles
- prepare_domain: default timing changed to HR, DY, STDY, CDSTDY,
  VISITDY, EPOCH (removed VISIT, VISITNUM, EVLINT, EVLINTX)
- hexsticker logo includes package name
- unit tests for all functions
- GitHub action for website deployment

## iddoverse 0.8.2

- Additional unit tests in prepare_domain & check_data
- Redrafted vignette
- Redrafted paper based on updated journal guidelines
- Changes to derive_anthro_scores so all data is retained in output not
  just the under 5s
- create_clinical_hist_table.R: DM domain removed

## iddoverse 0.8.1

- Drafted and deployed vignette and website
- Add check for required columns in functions
- Redrafted paper
- Improved check_data() outputs and mechanisms

## iddoverse 0.8.0

- prepare_domain.R: Removed ‘–’ from TIME_SOURCE (i.e. DY instead of
  –DY)
- Initialised files for iddoverse paper, first draft of journal paper
- convert_age_to_years.R: removed floor command, output in decimals.
  AGEU removed.
- utils.R: Global variables added
