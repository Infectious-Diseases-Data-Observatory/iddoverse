test_that("create_clinical_hist_table errors when required SACAT column missing", {
  sa_incomplete <- tibble::tibble(STUDYID = "S", USUBJID = "P1")

  expect_error(create_clinical_hist_table(sa_incomplete), regexp = "SACAT", ignore.case = TRUE)
})

test_that("create_clinical_hist_table handles case where no MEDICAL HISTORY rows exist", {
  sa_no_med_hist <- tibble::tibble(
    STUDYID = "S", USUBJID = "P1", SACAT = "OTHER", SATERM = "fever",
    SAOCCUR = "Y", SAPRESP = "Y", SADY = 24
  )

  res <- suppressMessages(create_clinical_hist_table(sa_domain = sa_no_med_hist))

  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 0)
})

test_that("create_clinical_hist_table filters SACAT == 'MEDICAL HISTORY' and removes empty columns", {
  sa <- tibble::tibble(
    STUDYID = c("S","S","S"),
    USUBJID = c("P1","P1","P2"),
    SACAT = c("MEDICAL HISTORY", "MEDICAL HISTORY", "OTHER"),
    SATERM = c("fever","anemia","malaria"),
    SAHR = c(NA, NA, NA),
    SASTDY = c("0","0","1"),
    SAOCCUR = "Y", SAPRESP = "Y",
    DUMMY_A = c(NA, NA, NA)
  )

  out_table <- create_clinical_hist_table(sa_domain = sa)
  out_prepare <- prepare_domain(sa %>% filter(SACAT == "MEDICAL HISTORY"),
                                "sa", variables_include = c("ANEMIA", "FEVER"),
                                print_messages = FALSE)

  expect_identical(out_table, out_prepare)

  expect_true(all(out_table$USUBJID %in% c("P1")))
  expect_false("DUMMY_A" %in% colnames(out_table))

  expect_true(all(c("ANEMIA_PRESP","FEVER_OCCURRENCE") %in% colnames(out_table)))

})

test_that("create_clinical_hist_table uses correct custom timing variables", {
  sa <- tibble::tibble(
    STUDYID = c("S","S","S"),
    USUBJID = c("P1","P1","P2"),
    SACAT = c("MEDICAL HISTORY", "MEDICAL HISTORY", "OTHER"),
    SATERM = c("fever","anemia","malaria"),
    SAHR = c(NA, NA, NA),
    SASTDY = c("0","0","1"),
    VISIT = c("2 weeks before", "last week", "yday"),
    SAOCCUR = "Y", SAPRESP = "Y"
  )

  out_table <- create_clinical_hist_table(sa_domain = sa,
                                          timing_variables = "VISIT")
  out_prepare <- prepare_domain(sa %>% filter(SACAT == "MEDICAL HISTORY"),
                                "sa", variables_include = c("ANEMIA", "FEVER"),
                                print_messages = FALSE,
                                timing_variables = "VISIT")

  expect_identical(out_table, out_prepare)

  expect_true(all(c("ANEMIA_PRESP","FEVER_OCCURRENCE") %in% colnames(out_table)))

  expect_equal(nrow(out_table), 2)
})
