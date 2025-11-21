test_that("AGEU -> AGE_DAYS conversion", {
  df <- tibble::tibble(
    STUDYID = "S",
    USUBJID = c("P1", "P2", "P3", "P4", "P5"),
    SEX = c("M", "F", "F", "M", "F"),
    AGE_YEARS = c(2.5, 1, 0.02, 4.996, 5.05),
    WEIGHT_kg = c(3.5, 4.0, 10.0, 18.0, 20.0),
    HEIGHT_cm = c(50.0, 60.0, 85.0, 100.0, 105.0)
  )

  # run function
  out <- derive_anthro_scores(df)

  # Should return only rows that pass the <5yrs filter.
  expect_true(nrow(out) == 4)
  expect_false("P5" %in% out$USUBJID)
  # AGE_DAYS is removed in returned data
  expect_false("AGE_DAYS" %in% colnames(out))
})

test_that("function returns zero-row data frame when no children < 5 yrs present", {
  df <- tibble::tibble(
    STUDYID = "S",
    USUBJID = c("A", "B"),
    SEX = c(1, 2),
    AGE_YEARS = c(6, 10),
    WEIGHT_kg = c(20, 30),
    HEIGHT_cm = c(110, 140)
  )

  out <- derive_anthro_scores(df)

  expect_true(nrow(out) == 0)
  # return should be a data.frame / tibble
  expect_s3_class(out, "data.frame")
})

test_that("derived anthro columns (HAZ/WAZ/WHZ and flags) exist and are numeric/characters as expected", {
  # Small plausible child where anthro_zscores should produce numeric z-scores and flags
  df <- tibble::tibble(
    STUDYID = "S",
    USUBJID = "C1",
    SEX = 1,
    AGE_YEARS = 2.0,
    WEIGHT_kg = 12.0,
    HEIGHT_cm = 88.0
  )

  out <- derive_anthro_scores(df)

  # check new columns exist
  expect_true(all(c("HAZ", "HAZ_FLAG", "WAZ", "WAZ_FLAG", "WHZ", "WHZ_FLAG") %in% colnames(out)))

  # HAZ/WAZ/WHZ should be numeric (NA allowed), flags typically numeric/character depending on anthro; assert presence and types
  expect_true(is.numeric(out$HAZ) | is.integer(out$HAZ))
  expect_true(is.numeric(out$WAZ) | is.integer(out$WAZ))
  expect_true(is.numeric(out$WHZ) | is.integer(out$WHZ))

  # flags should be interger (0 or 1)
  expect_true(is.integer(out$WHZ_FLAG))
  expect_true(is.integer(out$WHZ_FLAG))
  expect_true(is.integer(out$WHZ_FLAG))
})

test_that("rows with NA AGE are excluded (AGE_DAYS becomes NA and filter removes when both conditions are NA/false)", {
  df <- tibble::tibble(
    STUDYID = "S",
    USUBJID = c("NA_age", "Valid"),
    SEX = c(1, 1),
    AGE_YEARS = c(NA_real_, 3.0),
    WEIGHT_kg = c(NA_real_, 12.0),
    HEIGHT_cm = c(NA_real_, 88.0)
  )

  out <- derive_anthro_scores(df)

  # "Valid" should be included; "NA_age" should be excluded because AGE is NA and AGE_DAYS is NA -> filter fails
  expect_true("Valid" %in% out$USUBJID)
  expect_false("NA_age" %in% out$USUBJID)
})


