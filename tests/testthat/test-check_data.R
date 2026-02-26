test_that("check_data errors when STUDYID missing", {
  df <- tibble::tibble(USUBJID = "P1")

  expect_error(check_data(df), regexp = "STUDYID", ignore.case = TRUE)
})

test_that("check_data returns list with studyid table", {
  df <- tibble::tibble(STUDYID = c("S1","S1","S2"))

  out <- capture.output(res <- check_data(df, age_in_years = TRUE)) # capture plot output

  expect_type(res, "list")
  expect_true("studyid" %in% names(res))
  expect_s3_class(res$studyid, "data.frame")
  expect_equal(res$studyid$n[res$studyid$STUDYID == "S1"], 2)
})

test_that("SEX table included when SEX column present (counts include NA)", {
  df <- tibble::tibble(STUDYID = rep("S1", 4),
                       SEX = c("M", "F", NA, "M"))

  res <- capture.output(out <- check_data(df, age_in_years = TRUE))

  expect_true("sex" %in% names(out))
  sex_df <- out$sex
  expect_true(all(c("SEX", "n") %in% colnames(sex_df)))
  # Expect 'M' count = 2
  expect_equal(as.integer(sex_df[which(sex_df$SEX == "M"), "n"]), 2L)
  # NA included
  expect_true(any(is.na(sex_df$SEX)))
})

test_that("AGE branch converts ages when age_in_years = FALSE and AGEU present; age metrics computed", {
  df <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("A","B","C","D"),
    AGE = c(6*30.417, 0.25*365.25, 20, NA), # mix: months/days/years (but convert_age_to_years expects AGEU; we'll make AGEU so conversion runs)
    AGEU = c("MONTHS", "DAYS", "YEARS", "YEARS")
  )

  # Using age_in_years = FALSE -> function will call convert_age_to_years()
  out <- capture.output(res <- check_data(df, age_in_years = FALSE))

  expect_true("age" %in% names(res))
  age_stats <- res$age
  expect_true("n_USUBJID" %in% names(age_stats))
  # n_USUBJID should equal number of unique USUBJID
  expect_equal(age_stats$n_USUBJID, length(unique(df$USUBJID)))
  # check thresholds: n_AGE_under_6M counts subjects < 0.5 years
  expect_true("n_AGE_under_6M" %in% names(age_stats))
  expect_equal(as.numeric(age_stats$AGE_min), 0.25)
})

test_that("when age_in_years = TRUE, convert_age_to_years is not required", {
  df <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("A","B"),
    AGE = c(0.2, 30)
  )

  res <- capture.output(out <- check_data(df, age_in_years = TRUE))

  expect_true("age" %in% names(out))
  expect_equal(out$age$AGE_min, min(df$AGE, na.rm = TRUE))
})

test_that("testcd processing: name normalization, blanks -> NA, results precedence and summary returned", {
  # create a domain-like table with mixed sources
  df <- tibble::tibble(
    STUDYID = c("S1","S1","S1","S1"),
    USUBJID = c("a","b","c","d"),
    LBTESTCD = c("T1","T1","T1","T1"),
    LBSTRESN = c(1.5, NA, NA, NA),
    LBSTRESC = c(NA, "", "c_val", NA),
    LBMODIFY  = c(NA, "mod_val", NA, NA),
    LBORRES   = c(NA, "or_val", NA, "5.0"),
    LBORRESU  = c(NA, "U_OR", NA, "U_OR")
  )

  res <- capture.output(out <- check_data(df, age_in_years = TRUE))

  expect_true("testcd" %in% names(out))
  testcd_tbl <- out$testcd
  expect_s3_class(testcd_tbl, "data.frame")
  # There should be a row for STUDYID S1 & TESTCD T1
  expect_true(any(testcd_tbl$STUDYID == "S1" & testcd_tbl$TESTCD == "T1"))
  # min should be numeric (from STRESN and ORRES)
  expect_true("min" %in% colnames(testcd_tbl))
  # n_UNITS should count unique UNITS (expect at least 1)
  expect_true("n_UNITS" %in% colnames(testcd_tbl))
  expect_true(testcd_tbl$n_UNITS[1] == 1)
  expect_true(testcd_tbl$UNITS[1] == "U_OR")
})

test_that("outcome branch for INTP triggers when VISITDY/EPOCH present and TESTCD INTP exists", {
  df <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("001"),
    PFTESTCD = c("INTP"),
    VISITDY = 3,
    EPOCH = c("FOLLOW-UP"),
    PFSTRESC = c("WILD TYPE")
  )

  out <- capture.output(res <- check_data(df, age_in_years = TRUE))

  expect_true("testcd" %in% names(res))
  expect_true("outcome" %in% names(res))
  expect_true(res$outcome$`n_INTP_<DAY7` == 1)
})

test_that("outcome branch for WHOMAL01 triggers only when STRESC==ACPR and timing matches", {
  df <- tibble::tibble(
    STUDYID = c("S1","S1"),
    USUBJID = c("001","002"),
    RSTESTCD = c("WHOMAL01","WHOMAL01"),
    RSSTRESC = c("ACPR","NO"),
    VISITDY = c(1, 1),
    EPOCH = c("BASELINE", "BASELINE")
  )

  out <- capture.output(res <- check_data(df, age_in_years = TRUE))

  expect_true(res$outcome$`n_WHOMAL01_<DAY2` == 1)
})

test_that("missingness vector computed and present in returned list", {
  df <- tibble::tibble(
    STUDYID = c("S","S","S"),
    A = c(1, NA, 3),
    B = c(NA, NA, NA)
  )

  out <- capture.output(res <- check_data(df, age_in_years = TRUE))

  expect_true("missingness" %in% names(res))
  miss <- res$missingness
  expect_true("A" %in% names(miss) & "B" %in% names(miss))
  # A proportion missing = 1/3 rounded to 3 decimals = 0.333
  expect_equal(as.numeric(miss["A"]), round(1/3, 3))
  expect_equal(as.numeric(miss["B"]), 1.000)
})

test_that("STRESC is created if it does not exist in input data frame", {
  df <- tibble::tibble(
    STUDYID = c("S1","S1","S1","S1"),
    USUBJID = c("a","b","c","d"),
    LBTESTCD = c("T1","T1","T1","T1"),
    LBSTRESN = c(1.5, NA, NA, NA),
    LBMODIFY  = c(NA, "mod_val", NA, NA),
    LBORRES   = c(NA, "or_val", NA, "5.0"),
    LBORRESU  = c(NA, "U_OR", NA, "U_OR")
  )

  out <- capture.output(res <- check_data(df))

  expect_equal(nrow(res$testcd), 1L)
})
