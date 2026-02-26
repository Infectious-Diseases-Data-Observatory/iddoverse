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

test_that("create_participant_table selects baseline VISITDY == 1 from sc domain and left_joins to DM", {
  dm <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    AGE = c(35),
    SEX = c("M")
  )

  sc <- tibble::tibble(
    STUDYID = c("S","S"),
    USUBJID = c("P1","P1"),
    SCTESTCD = c("MARISTAT","EDULEVEL"),
    SCSTRESN = c(NA, NA),
    SCSTRESU = c(NA, NA),
    SCSTRESC = c("MARRIED", "SECONDARY"),
    SCORRES = c("partnered",  "stage 11"),
    SCORRESU = c(NA, NA),
    VISITDY = c(1, 1),
    EPOCH = c("BASELINE", "BASELINE")
  )

  out <- create_participant_table(dm_domain = dm, sc_domain = sc)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX") %in% colnames(out)))
  expect_true(any(grepl("^EDULEVEL", colnames(out))))
  expect_true(any(grepl("^MARISTAT", colnames(out))))

  edulevel_col <- grep("^EDULEVEL", colnames(out), value = TRUE)[1]
  maristat_col <- grep("^MARISTAT", colnames(out), value = TRUE)[1]
  expect_false(is.na(out[[edulevel_col]][1]))
  expect_false(is.na(out[[maristat_col]][1]))

  expect_equal(out$USUBJID[1], "P1")
})

test_that("create_participant_table selects baseline VISITDY == 1 from LB domain and left_joins to DM", {
  dm <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    AGE = c(35),
    SEX = c("M")
  )

  lb <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    LBTESTCD = c("G6PD"),
    LBSTRESN = c(10),
    LBSTRESU = c("U/g Hb"),
    LBSTRESC = c("10"),
    LBORRES = c("ten"),
    LBORRESU = c("units"),
    VISITDY = c(1),
    EPOCH = c("BASELINE")
  )

  out <- create_participant_table(dm_domain = dm, lb_domain = lb)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX") %in% colnames(out)))
  expect_true(any(grepl("^G6PD", colnames(out))))

  G6PD_col <- grep("^G6PD", colnames(out), value = TRUE)[1]
  expect_false(is.na(out[[G6PD_col]][1]))

  expect_equal(out$USUBJID[1], "P1")
})

test_that("create_participant_table selects baseline VISITDY == 1 from MB domain and left_joins to DM", {
  dm <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    AGE = c(35),
    SEX = c("M")
  )

  mb <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    MBTESTCD = c("HIV"),
    MBSTRESN = c(NA),
    MBSTRESU = c(NA),
    MBSTRESC = c("POSITIVE"),
    MBORRES = c("+"),
    MBORRESU = c("no units"),
    VISITDY = c(1),
    EPOCH = c("BASELINE")
  )

  out <- create_participant_table(dm_domain = dm, mb_domain = mb)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX") %in% colnames(out)))
  expect_true(any(grepl("^HIV", colnames(out))))

  hiv_col <- grep("^HIV", colnames(out), value = TRUE)[1]
  expect_false(is.na(out[[hiv_col]][1]))

  expect_equal(out$USUBJID[1], "P1")
})

test_that("create_participant_table selects baseline VISITDY == 1 from rp domain and left_joins to DM", {
  dm <- tibble::tibble(
    STUDYID = c("S"),
    USUBJID = c("P1"),
    AGE = c(35),
    SEX = c("M")
  )

  rp <- tibble::tibble(
    STUDYID = c("S","S"),
    USUBJID = c("P1","P1"),
    RPTESTCD = c("EGESTAGE","PREGIND"),
    RPSTRESN = c(28, NA),
    RPSTRESU = c("WEEKS", NA),
    RPSTRESC = c("28", "POSITIVE"),
    RPORRES = c("28w",  "pos"),
    RPORRESU = c("wks", NA),
    VISITDY = c(1, 1),
    EPOCH = c("BASELINE", "BASELINE")
  )

  out <- create_participant_table(dm_domain = dm, rp_domain = rp)

  expect_true(all(c("STUDYID", "USUBJID", "AGE", "SEX") %in% colnames(out)))
  expect_true(any(grepl("^EGESTAGE", colnames(out))))
  expect_true(any(grepl("^PREGIND", colnames(out))))

  egestage_col <- grep("^EGESTAGE", colnames(out), value = TRUE)[1]
  pregind_col <- grep("^PREGIND", colnames(out), value = TRUE)[1]
  expect_false(is.na(out[[egestage_col]][1]))
  expect_false(is.na(out[[pregind_col]][1]))

  expect_equal(out$USUBJID[1], "P1")
})

test_that("create_participant_table slices baseline VISITDY == 1 correctly", {
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

test_that("anthro is derived if columns are present, and conversely", {
  dm <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("P1", "P2"),
    AGE = c(2, 36),
    AGEU = c("YEARS", "WEEKS"),
    SEX = c("M", "F")
  )

  vs_with <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("P1","P1","P2", "P2"),
    VSTESTCD = c("HEIGHT", "WEIGHT", "HEIGHT","WEIGHT"),
    VSTEST = c("Height", "Weight", "Height","Weight"),
    VSSTRESN = c(58, 14, 68, 16.5),
    VSSTRESU = c("cm", "kg", "cm", "kg"),
    VSORRES = c("5-8", "1-4", "68", "16 1/2"),
    VSORRESU = c("CM", "KG", "CM", "KG"),
    VISITDY = 1,
    EPOCH = "BASELINE"
  )

  vs_without <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = c("P1", "P2"),
    VSTESTCD = c("HEIGHT", "HEIGHT"),
    VSTEST = c("Height", "Height"),
    VSSTRESN = c(48, 54),
    VSSTRESU = c("cm", "cm"),
    VSORRES = c("4-8", "5-4"),
    VSORRESU = c("CM", "CM"),
    VISITDY = 1,
    EPOCH = "BASELINE"
  )

  out_anthro <- create_participant_table(dm_domain = dm, vs_domain = vs_with)
  out_without_anthro <- create_participant_table(dm_domain = dm, vs_domain = vs_without)

  expect_true(all(c("HEIGHT_cm", "HAZ", "WAZ_FLAG", "WHZ") %in% colnames(out_anthro)))
  expect_true(all(c("HEIGHT_cm") %in% colnames(out_without_anthro)))
  expect_false(all(c("WEIGHT_kg", "HAZ", "WAZ_FLAG", "WHZ") %in% colnames(out_without_anthro)))

  expect_equal(as.integer(out_anthro[1, "HAZ_FLAG"]), 1L)
  expect_equal(as.integer(out_anthro[2, "WHZ_FLAG"]), 1L)
})
