test_that("findings domain: STRESN → STRESC → MODIFY → ORRES precedence, TESTCD mapping and units", {
  lb <- tibble::tibble(
    STUDYID = "STUDY1",
    USUBJID = c("S1", "S2", "S3", "S4"),
    LBTESTCD = c("HGB", "ALT", "ALT", "HGB"),
    LBSTDY = c("1", "2", "3", "4"),
    LBORRES = c("fourteen", "sechs", "0", ""),
    LBORRESU = c("U_ORRES", "U_ORRES", "U_ORRES", ""),
    LBMODIFY = c("14_mod", "six", NA_character_, ""),
    LBSTRESN = c(14, NA_real_, NA_real_, ""),
    LBSTRESU = c("U", NA_character_, NA_character_, ""),
    LBSTRESC = c("14_char", NA_character_, NA_character_, "")
  )

  out <- prepare_domain(lb, "LB", print_messages = FALSE)

  # id cols present
  expect_true(all(c("STUDYID", "USUBJID", "TIME", "TIME_SOURCE") %in% colnames(out)))

  # pivot produces TESTCD_UNITS column
  # so expect i.e. "HGB_U" when unit = "U"
  expect_true(all(c("HGB_U", "ALT_U_ORRES", "HGB_NA") %in% colnames(out)))
  expect_equal(as.character(out$HGB_U[1]), "14") # STRESN placed into RESULTS and pivoted
  expect_equal(as.character(out$ALT_U_ORRES[2]), "six")
  expect_equal(as.character(out$ALT_U_ORRES[3]), "0")
  expect_equal(as.character(out$HGB_NA[4]), as.character(NA))
  # TIME_SOURCE should have domain prefix removed (LBSTDY -> STDY)
  expect_equal(out$TIME_SOURCE[1], "STDY")
})

test_that("include_LOC/include_METHOD produce expected column-name patterns", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = "S1",
    LBTESTCD = "HGB",
    LBSTDY = "1",
    LBSTRESN = 7, LBSTRESU = "U",
    LBORRES = "seven", LBORRESU = "units",
    LBLOC = "L1", LBMETHOD = "M1"
  )

  out_none <- prepare_domain(lb, "LB", include_LOC = FALSE, include_METHOD = FALSE, variables_include = c("HGB"), timing_variables = c("LBSTDY"), print_messages = FALSE)
  out_loc <- prepare_domain(lb, "LB", include_LOC = TRUE, include_METHOD = FALSE, variables_include = c("HGB"), timing_variables = c("LBSTDY"), print_messages = FALSE)
  out_method <- prepare_domain(lb, "LB", include_LOC = FALSE, include_METHOD = TRUE, variables_include = c("HGB"), timing_variables = c("LBSTDY"), print_messages = FALSE)
  out_both <- prepare_domain(lb, "LB", include_LOC = TRUE, include_METHOD = TRUE, variables_include = c("HGB"), timing_variables = c("LBSTDY"), print_messages = FALSE)

  # When both included, names_glue = "{TESTCD}_{LOC}_{METHOD}_{UNITS}_{.value}"
  # After removing _RESULTS we expect column "HGB_L1_M1_U"
  expect_true("HGB_L1_M1_U" %in% colnames(out_both))
  expect_true("HGB_L1_U" %in% colnames(out_loc))
  expect_true("HGB_M1_U" %in% colnames(out_method))
  expect_true("HGB_U" %in% colnames(out_none))

  expect_equal(as.character(out_both$HGB_L1_M1_U[1]), "7")
  expect_equal(as.character(out_loc$HGB_L1_U[1]), "7")
  expect_equal(as.character(out_method$HGB_M1_U[1]), "7")
  expect_equal(as.character(out_none$HGB_U[1]), "7")
})

test_that("include_LOC warns and is reset to FALSE if domain does not have LOC", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = "S1",
    LBTESTCD = "HGB", LBSTDY = "1",
    LBSTRESN = 7, LBSTRESU = "U",
    LBORRES = "seven", LBORRESU = "units"
  )

  expect_warning(out <- prepare_domain(lb, "LB", include_LOC = TRUE, print_messages = FALSE),
                 regexp = "does not have a location", ignore.case = TRUE)
  # no LOC in output column names
  expect_false(any(grepl("_L", colnames(out)) & grepl("_U", colnames(out))))
})

test_that("include_METHOD warns and is reset to FALSE if domain does not have METHOD", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = "S1",
    LBTESTCD = "HGB", LBSTDY = "1",
    LBSTRESN = 7, LBSTRESU = "U",
    LBORRES = "seven", LBORRESU = "units"
  )

  expect_warning(out <- prepare_domain(lb, "LB", include_METHOD = TRUE, print_messages = FALSE),
                 regexp = "does not have a method", ignore.case = TRUE)
  # no METHOD token present in column names
  expect_false(any(grepl("_M", colnames(out)) & grepl("_U", colnames(out))))
})

test_that("spaces in generated column names are replaced with underscores", {
  lb <- tibble::tibble(
    STUDYID = "S", USUBJID = "P1",
    LBTESTCD = "TEST", LBSTDY = "1",
    LBSTRESN = 5, LBSTRESU = "per litre",
    LBORRES = "five", LBORRESU = "pL"
  )
  out <- prepare_domain(lb, "LB", variables_include = c("TEST"), print_messages = FALSE)
  # generated column should use underscore rather than space
  expect_true(any(grepl("per_litre", colnames(out))))
})

test_that("variables_include filters to requested TESTCDs before pivot", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = c("S1","S1", "S2"),
    LBTESTCD = c("HGB","ALT", "HGB"),
    LBSTDY = c("1","1", "1"),
    LBSTRESN = c(10, 99, 22), LBSTRESU = c("U","U", "U"),
    LBORRES = c("ten", "ninty-nine", "twenty two"), LBORRESU = "units"
  )

  out <- prepare_domain(lb, "LB", variables_include = c("hgB"), print_messages = FALSE)

  # ALT should be filtered out before pivot
  expect_false(any(grepl("^ALT", colnames(out))))
  expect_true(any(grepl("^HGB", colnames(out))))
})

test_that("values_fn controls which duplicate record is chosen", {
  lb <- tibble::tibble(
    STUDYID = "S1", USUBJID = "P1",
    LBTESTCD = "HGB",
    LBSTDY = "1",
    LBSTRESN = c(10, 11), LBSTRESU = c("U", "U"),
    LBORRES = c("ten", "eleven"), LBORRESU = "units"
  )

  # By default values_fn = first -> expect 10
  out_first <- prepare_domain(lb, "LB", values_fn = dplyr::first, print_messages = FALSE)
  col_first <- grep("^HGB", colnames(out_first), value = TRUE)
  expect_equal(as.character(out_first[[col_first]][1]), "10")

  # Using last() should pick 11
  out_last <- prepare_domain(lb, "LB", values_fn = dplyr::last, print_messages = FALSE)
  col_last <- grep("^HGB", colnames(out_last), value = TRUE)
  expect_equal(as.character(out_last[[col_last]][1]), "11")
})

test_that("timing_variables argument is filtered to present variables and used to set TIME and TIME_SOURCE", {
  lb <- tibble::tibble(
    STUDYID = "S", USUBJID = c("P1", "P2"),
    LBTESTCD = "HGB",
    # LBHR absent
    LBSTDY = c("5", NA_character_), VISIT = "DAY 5",
    LBSTRESN = 9, LBSTRESU = "U",
    LBORRES = "nine", LBORRESU = "units"
  )

  # provide timing_variables where first entry does not exist; prepare_domain should ignore missing ones
  out <- prepare_domain(lb, "LB", timing_variables = c("LBHR", "LBSTDY", "VISIT"), print_messages = FALSE)
  expect_equal(out$TIME[1], "5")
  expect_equal(out$TIME[2], "DAY 5")
  expect_equal(out$TIME_SOURCE[1], "STDY") # LBSTDY -> STDY after replacement
  expect_equal(out$TIME_SOURCE[2], "VISIT")
})

test_that("event domain: EVENT chosen from DECOD/MODIFY/TERM and PRESP/OCCUR defaults applied and pivoted", {
  sa <- tibble::tibble(
    STUDYID = "S", USUBJID = c("P1", "P2"),
    SATERM = "fever",
    SADECOD = NA_character_,
    SAMODIFY = NA_character_,
    VISITDY = "1",
    # PRESP missing should be defaulted to "N", OCCUR to "Y"
    SAPRESP = NA_character_,
    SAOCCUR = c(NA_character_, "N")
  )

  out <- prepare_domain(sa, "SA", variables_include = c("FEVER"), print_messages = FALSE) # variables_include used by event_domains path

  expect_true(all(c("STUDYID", "USUBJID", "TIME", "TIME_SOURCE") %in% colnames(out)))
  # Pivoted columns like FEVER_PRESP and FEVER_OCCUR should exist (clean_names -> all caps)
  expect_true(any(grepl("^FEVER_PRESP", colnames(out))))
  expect_true(any(grepl("^FEVER_OCCUR", colnames(out))))
  # PRESP default set to "N" and OCCUR set to "Y" for rows where PRESP was NA
  fev_presp <- out %>% dplyr::pull(which(str_detect(colnames(out), "FEVER_PRESP")))
  fev_occur <- out %>% dplyr::pull(which(str_detect(colnames(out), "FEVER_OCCUR")))
  expect_equal(as.character(fev_presp[1]), "N")
  expect_equal(as.character(fev_occur[1]), "Y")
  expect_equal(as.character(fev_occur[2]), "N")
})

test_that("DS domain returns STUDYID, USUBJID, TIME, TIME_SOURCE, DISPOSITION columns", {
  ds <- tibble::tibble(
    STUDYID = "S", USUBJID = c("A","B","C"),
    DSTERM = c("t1","t2","t3"),
    DSMODIFY = c(NA, "MOD", NA),
    DSDECOD = c(NA, NA, "DEC"),
    DSSTDY = 28
  )

  out <- prepare_domain(ds, "DS", print_messages = FALSE)
  expect_true(all(c("STUDYID", "USUBJID", "TIME", "TIME_SOURCE", "DISPOSITION") %in% colnames(out)))
  expect_equal(out$TIME_SOURCE[1], "STDY")
  expect_true("MOD" %in% out$DISPOSITION)
  expect_true("DEC" %in% out$DISPOSITION)
})

test_that("special domain DM: convert blanks to NA and variables_include selection works", {
  dm <- tibble::tibble(
    STUDYID = "S", USUBJID = c("X1", "X2"),
    BIRTHDT = c(NA, "1980-01-01"),
    ARMCD = c("A", "")
  )

  out <- prepare_domain(dm, "DM", variables_include = c("ARMCD", "BIRTHDT"), print_messages = FALSE)
  # blanks converted to NA
  expect_true(is.na(out$ARMCD[2]))
  # only STUDYID, USUBJID and requested variables included
  expect_true(all(c("STUDYID", "USUBJID", "ARMCD", "BIRTHDT") %in% colnames(out)))
  # not adding TIME columns for DM
  expect_false("TIME" %in% colnames(out))
})

test_that("check print_messages parameter option", {
  sa <- tibble::tibble(
    STUDYID = "S", USUBJID = c("P1", "P2"),
    SATERM = "fever",
    SADECOD = NA_character_,
    SAMODIFY = NA_character_,
    VISITDY = "1",
    SAPRESP = NA_character_,
    SAOCCUR = c(NA_character_, "N")
  )

  expect_output(prepare_domain(sa, "SA", variables_include = c("FEVER"), print_messages = TRUE),
                 regexp = "Number of rows where values_fn has been used to pick record")
})

test_that("prepare_domain errors when required STUDYID or USUBJID missing", {
  df_missing <- tibble::tibble(USUBJID = "P1") # STUDYID missing
  expect_error(prepare_domain(df_missing, "LB"), regexp = "STUDYID|USUBJID", ignore.case = TRUE)

  df_missing2 <- tibble::tibble(STUDYID = "S1") # USUBJID missing
  expect_error(prepare_domain(df_missing2, "LB"), regexp = "STUDYID|USUBJID", ignore.case = TRUE)
})

