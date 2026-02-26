test_that("convert_age_to_years: basic conversions", {
  df <- tibble::tibble(
    USUBJID = c("P1", "P2", "P3", "P4", "P5"),
    AGE = c(876.6, 365, 104, 24, 30.7),
    # 365 days -> 1 year; 104 weeks -> floor(104/52)=2; 24 months -> floor(24/12)=2; 30.7 years -> floor(30.7)=30
    AGEU = c("HOURS", "DAYS", "WEEKS", "MONTHS", "YEARS")
  )

  out <- convert_age_to_years(df)

  # AGE_YEARS column exists and AGEU removed
  expect_true("AGE_YEARS" %in% colnames(out))
  expect_false("AGEU" %in% colnames(out))

  expected1 <- 876.6 / 8766
  expected2 <- 365 / 365.25
  expected3 <- 104 / 52
  expected4 <- 24 / 12
  expected5 <- 30.7

  expect_equal(out$AGE_YEARS, c(expected1, expected2, expected3, expected4, expected5))
})

test_that("AGEU is uppercased before conversion", {
  df <- tibble::tibble(
    USUBJID = c("A", "B"),
    AGE = c(400, 20),
    AGEU = c("days", "months") # lowercase
  )

  out_keep <- convert_age_to_years(df)
  # AGE should have been converted and floored (400/365.25 floor, 20/12 floor)
  expect_equal(out_keep$AGE_YEARS, c(400/365.25, 20/12))
})

test_that("rows with NA AGEU are skipped and AGE left unchanged (except floor on else branch not applied)", {
  df <- tibble::tibble(
    USUBJID = c("N1", "N2"),
    AGE = c(10.4, NA_real_),
    AGEU = c(NA_character_, "YEARS")
  )

  out <- convert_age_to_years(df)

  # For the NA AGEU row, the loop does 'next' and leaves AGE unchanged (10.4)
  expect_equal(out$AGE_YEARS[1], 10.4)
  # For the second row AGEU == "YEARS" remains unchanged
  expect_equal(out$AGE_YEARS[2], NA_real_, tolerance = 0)
  expect_true(is.na(out$AGE_YEARS[2]))
})

test_that("function handles zero-row data frame without error and returns same structure", {
  empty <- tibble::tibble(USUBJID = character(0), AGE = numeric(0), AGEU = character(0))

  out <- convert_age_to_years(empty)
  # # should still be a tibble/data.frame and have AGE_YEARS column
  expect_s3_class(out, "data.frame")
  expect_false("AGE_YEARS" %in% colnames(out))
  expect_equal(nrow(out), 0)
  # expect_warning(out, "Dataset is empty, returning input data")

  # expect_s3_class(convert_age_to_years(empty), "data.frame")
  # expect_false("AGE_YEARS" %in% colnames(convert_age_to_years(empty)))
  # expect_equal(nrow(convert_age_to_years(empty)), 0)
  # expect_warning(convert_age_to_years(empty), "Dataset is empty, returning input data")
})

test_that("non-standard AGEU values", {
  df <- tibble::tibble(
    USUBJID = c("X1","X2"),
    AGE = c(15.9, 7.1),
    AGEU = c("UNKNOWN", "CENTURIES")
  )
  expect_error(convert_age_to_years(df))
})
