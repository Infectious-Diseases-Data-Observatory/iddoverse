test_that("create_participant_table errors when optional domain is missing required VISITDY/EPOCH", {
  dm <- tibble::tibble(STUDYID = "S", USUBJID = "P1")
  sc <- tibble::tibble(STUDYID = "S", USUBJID = "P1", EDULEVEL = "HIGH")

  expect_error(create_participant_table(dm_domain = dm, sc_domain = sc),
               regexp = "VISITDY|EPOCH", ignore.case = TRUE)
})

test_that("create_participant_table with DM only returns DM columns", {
  dm <- tibble::tibble(
    STUDYID = c("S1", "S1"),
    USUBJID = c("P1", "P2"),
    AGE = c(30, 40),    # no AGEU -> prepare_domain will not call convert_age_to_years()
    SEX = c("M", "F"),
    ARMCD = c("A", "B")
  )

  out <- create_participant_table(dm_domain = dm,
                                  lb_domain = NULL,
                                  mb_domain = NULL,
                                  rp_domain = NULL,
                                  sc_domain = NULL,
                                  vs_domain = NULL)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX", "ARMCD") %in% colnames(out)))
  expect_equal(nrow(out), nrow(dm))
  expect_false("AGE_YEARS" %in% colnames(out))
})

test_that("create_participant_table selects baseline VISITDY == 1 from VS domain and left_joins to DM", {
  dm <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    AGE = c(5),
    SEX = c("M")
  )

  # Create VS domain entries. Use VSTESTCD + VSTRESN + VSTRESU so prepare_domain will pivot a column like HEIGHT_cm
  vs <- tibble::tibble(
    STUDYID = c("S","S","S"),
    USUBJID = c("P1","P1","P1"),
    VSTESTCD = c("HEIGHT","HEIGHT","WEIGHT"),
    VSTEST = c("Height","Height","Weight"),
    VSSTRESN = c(160, 162, 60),   # numeric results (two heights, one weight)
    VSSTRESU = c("cm", "cm", "kg"),
    VSORRES = c("one-six-zero", "one-six-two", "60.00"),
    VSORRESU = c("CM", "CM", "KG"),
    VISITDY = c(1, 2, 1),
    EPOCH = c("BASELINE", "TREATMENT", "BASELINE")
  )

  out <- create_participant_table(dm_domain = dm, vs_domain = vs)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX") %in% colnames(out)))
  expect_true(any(grepl("^HEIGHT", colnames(out))))
  expect_true(any(grepl("^WEIGHT", colnames(out))))

  height_col <- grep("^HEIGHT", colnames(out), value = TRUE)[1]
  weight_col <- grep("^WEIGHT", colnames(out), value = TRUE)[1]
  expect_false(is.na(out[[height_col]][1]))
  expect_false(is.na(out[[weight_col]][1]))

  expect_equal(out$USUBJID[1], "P1")
})

test_that("create_participant_table selects baseline VISITDY == 1 from VS domain and left_joins to DM", {
  dm <- tibble::tibble(STUDYID = "S", USUBJID = c("A","B"))

  # Create VS domain entries. Use VSTESTCD + VSTRESN + VSTRESU so prepare_domain will pivot a column like HEIGHT_cm
  vs <- tibble::tibble(
    STUDYID = c("S","S","S"),
    USUBJID = c("A","A","B"),
    VSTESTCD = "HEIGHT",
    VSSTRESN = c(160, 161, 158),   # numeric results (two heights, one weight)
    VSSTRESU = "cm",
    VSORRES = c("one-six-zero", "one-six-two", "one-five-eight"),
    VSORRESU = "CM",
    VISITDY = c(1, 1, 1),
    VSHR = c(0, 12, 0),
    EPOCH = "BASELINE"
  )

  out <- create_participant_table(dm_domain = dm, vs_domain = vs)

  expect_equal(nrow(out), 2)

  height_cols <- grep("^HEIGHT", colnames(out), value = TRUE)
  expect_true(length(height_cols) >= 1)

  expect_equal(out[[height_cols[1]]][which(out$USUBJID == "A")], "160")
})

test_that("create_participant_table removes all-NA columns from final output", {
  dm <- tibble::tibble(STUDYID = "S", USUBJID = "P1", AGE = 30, UNUSED = NA_real_)

  out <- create_participant_table(dm_domain = dm)

  expect_false("UNUSED" %in% colnames(out))
})

test_that("if AGEU present, AGE is converted to years", {
  dm <- tibble::tibble(
    STUDYID = c("S1", "S1", "S1"),
    USUBJID = c("P1", "P2", "P3"),
    AGE = c(30, 40, 24),
    AGEU = c("YEARS", "DAYS", "MONTHS"),
    SEX = c("M", "F", "M"),
    ARMCD = c("A", "B", "B")
  )

  out <- create_participant_table(dm_domain = dm,
                                  lb_domain = NULL,
                                  mb_domain = NULL,
                                  rp_domain = NULL,
                                  sc_domain = NULL,
                                  vs_domain = NULL)

  expect_true(all(c("STUDYID", "USUBJID", "AGE_YEARS", "SEX", "ARMCD") %in% colnames(out)))
  expect_true(as.numeric(out[2, "AGE_YEARS"]) < 0.11)
  expect_equal(as.numeric(out[3, "AGE_YEARS"]), 2)
  expect_false("AGE" %in% colnames(out))
})
