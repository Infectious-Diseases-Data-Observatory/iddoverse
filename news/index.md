# Changelog

## iddoverse 0.8.0

## iddoverse 0.7.2

## iddoverse 0.7.1

## iddoverse 0.7.0

- Merge pull request
  [\#28](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues/28),
  large overhaul of functions to move to fewer, multi-domain functions
- removal of single domain functions
- issues
  [\#11](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues/11)
  and
  [\#23](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues/23)
  resolved

## iddoverse 0.6.2

- Added EVLINT

## iddoverse 0.6.1

- APHO and APVS functions created
- Removed DISEASE parameter for some MIMBA functions
- Exports and documentation changes for MIMBA functions
- Renaming DATA in AP MIMBA domains

## iddoverse 0.6.0

- Further changes to MiMBa functions
- New functions for LB, DS, VS domains

## iddoverse 0.5.1

- Changes to RP and PO MiMBa codes

## iddoverse 0.5.0

- New functions for associated persons, and MIMBA project, which will be
  documented and tidied in future releases
- Fixed error when DISEASE is blank in PREP_DM
- SC domain included in ANALYSE_FOLLOW_UP

## iddoverse 0.4.2

- Minor updates to README.md, information on detaching the package
- Uploaded data, code, abstract and poster for the 2024 CDISC Europe
  Interchange, where the iddoverse was presented

## iddoverse 0.4.1

- Documented and exported new functions from v0.4.1
- Few good practice changes ‘T’ -\> TRUE

## iddoverse 0.4.0

- styler package implemented, improvements to comply with good
  practices.
- Data, code and poster for the CDISC Europe Interchange 2024 uploaded
- New functions using screening as a filter instead of DERIVE_TIMING:
  ANALYSE_HR0SCR_BASELINE, PREP_VS_SCR_BL, PREP_VS_SCR_TEMP_BL
- New functions using hour 0 as a filter instead of DERIVE_TIMING:
  ANALYSE_HR0SCR_BASELINE, PREP_LB_HR0_BL, PREP_MBSPEC_HR0_BL,
  PREP_MB_HR0_BL, PREP_MB_HR0_BL_MAL
- MBSPEC: Output variable name change, edit to names_glue in pivot_wider
  function. Previously there was duplicated elements in the variable
  name in analysis dataset, this is rectified.

## iddoverse 0.3.1

- Data exported with package as opposed to read.csv
- Data documented
- Resolved uninitiated DISEASE variable in ANALYSE functions
- Creation of PREP_DS_OUT_EVD (Ebola Virus Disease)

## iddoverse 0.3.0

- Units have been including alongside all variable which having a
  –ORRESU or –STRESU is possible (issue
  [\#18](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues/18)).
  Units are now matched with the equivalent result so STRESU will be
  used if STRESC or STRESN are and likewise if MODIFY or ORRES are
  reported in the output, ORRESU will be the units
- Error in DERIVE_ANTHRO when there is no under 5s, issue
  [\#19](https://github.com/Infectious-Diseases-Data-Observatory/iddoverse/issues/19)
- Removed SPECIES from MB domains

## iddoverse 0.2.2

- Vignette created
- str_to_upper(AGEU) in DERIVE_AGE_YEARS & DERIVE_AGE_DAYS
- for loop added into PREP_SA_BL to convert SAOCCUR & SAPRESP

## iddoverse 0.2.1

- All variable names are defined relative to the corresponding dataset
  using the .data\$ function or calling the dataframe name before the \$
- Removed dependence on LB domain in ANALYSE_FOLLOW_UP()
- Increased use for as.character and str_to_upper for consistency

## iddoverse 0.2.0

- Significant changes to VL outcome including function name changes,
  rewriting of code to match other PREP functions, removal of domain
  dependency and generally a clear look
- Documentation updates to reflect change

## iddoverse 0.1.2

- Enhanced ANALYSE_FOLLOW_UP by not depending on LB domain. Fixed by
  creating a empty dataset in the absence of LB, and removing empty rows
  at the end of merging
- Uploaded test data STUDYID: RPTESTB
- Added AGE_DAYS as a DM default for FU analysis too to track growth
  standards at any point

## iddoverse 0.1.1

- Resolved coercing error in DERIVE_BMI by removing as.numeric
- Added JOIN\_ functions into ANALYSE_FOLLOW_UP

## iddoverse 0.1.0

- Added a `NEWS.md` file to track changes to the package.
- All current functions now uploaded to iddoverse github
- changed names of certain functions for standardised nomenclature:
- namely:
- - PREP_DS_OUT_VL \<- PREP_DS_VL_OUT,
- - PREP_MB_BL_MAL \<- PREP_MB_MAL_BL,
- - PREP_MB_BL_VL \<- PREP_MB_VL_BL,
- - PREP_MB_FU_MAL \<- PREP_MB_MAL_FU,
- - PREP_MB_FU_VL \<- PREP_MB_VL_FU,
- - PREP_RS_OUT_VL \<- PREP_RS_VL_OUT
- citation and documentation improved
