test_that("create_malaria_pcr_table full_joins prepared domain outputs", {
 pf <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    PFTESTCD = "INTP",
    PFSTDY = "1",
    PFORRES = 1,
    PFORRESU = "units",
    PFSTRESN = 1,
    PFSTRESU = "U"
  )

  rs <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    RSTESTCD = "WHOMAL01",
    RSSTDY = "1",
    RSORRES = "acpr",
    RSORRESU = NA,
    RSSTRESC = "ACPR",
    RSSTRESU = NA
  )

  ds <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    DSTERM   = "COMPLETED",
    DSDECOD = "COMPLETED",
    DSMODIFY = NA_character_,
    DSSTDY = "1",
  )

  out <- create_malaria_pcr_table(pf_domain = pf, rs_domain = rs, ds_domain = NULL)

  expect_true("STUDYID" %in% colnames(out))
  expect_true("USUBJID" %in% colnames(out))
  expect_true(any(grepl("^INTP", colnames(out))))
  expect_true(any(grepl("^WHOMAL01", colnames(out))))

  out_ds <- create_malaria_pcr_table(pf_domain = pf, rs_domain = rs, ds_domain = ds)

  expect_true("DISPOSITION" %in% colnames(out_ds))
  expect_equal(nrow(out_ds), nrow(out))
})

test_that("replicate malaria pcr table to verify output", {
  pf <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    PFTESTCD = "INTP",
    PFSTDY = "1",
    PFORRES = 1,
    PFORRESU = "units",
    PFSTRESN = 1,
    PFSTRESU = "U"
  )

  rs <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    RSTESTCD = "WHOMAL01",
    RSSTDY = "1",
    RSORRES = "acpr",
    RSORRESU = NA,
    RSSTRESC = "ACPR",
    RSSTRESU = NA
  )

  ds <- tibble::tibble(
    STUDYID = "S1",
    USUBJID = "P1",
    DSTERM   = "COMPLETED",
    DSDECOD = "COMPLETED",
    DSMODIFY = NA_character_,
    DSSTDY = "1",
  )

  out_table <- create_malaria_pcr_table(pf_domain = pf, rs_domain = rs, ds_domain = ds)
  out_prepare <- prepare_domain(pf, "pf", print_messages = FALSE) %>%
    full_join(prepare_domain(rs, "rs", print_messages = FALSE)) %>%
    full_join(prepare_domain(ds, "ds", print_messages = FALSE))

  expect_identical(out_table, out_prepare)
})
