test_that("create_clinical_table full_joins prepared domain outputs and removes empty columns (integration)", {
  dm <- tibble::tibble(STUDYID = c("S","S"), USUBJID = c("A","B"),
                       AGE = c(30, 40))
  mb <- tibble::tibble(STUDYID = "S", USUBJID = "A",
                       MBTESTCD = "MTB", MBSTDY = "1",
                       MBSTRESN = 1, MBSTRESC = "1",
                       MBORRES = "one",
                       MBORRESU = "units", MBSTRESU = "U")
  mp <- tibble::tibble(STUDYID = "S", USUBJID = "A",
                       MPLOC = "SPLEEN", MPTESTCD = "WIDTH",
                       MPSTDY = "1", MPSTRESN = 2,
                       MPSTRESC = "2", MPORRES = "two",
                       MPORRESU = "units", MPSTRESU = "U")
  vs <- tibble::tibble(STUDYID = "S", USUBJID = "A",
                       VSTESTCD = "SYSBP", VSTEST = "Systolic",
                       VSSTDY = "1",
                       VSSTRESN = 120, VSSTRESC = "120",
                       VSORRES = "one,twenty",
                       VSORRESU = "units", VSSTRESU = "U")
  sa <- tibble::tibble(STUDYID = "S", USUBJID = "A",
                       SACAT = "OTHER", SATERM = "headache",
                       SAOCCUR = "Y", SAPRESP = NA,
                       SASTDY = 1)

  out <- suppressMessages(create_clinical_table(dm_domain = dm, mb_domain = mb,
                                                mp_domain = mp, sa_domain = sa,
                                                vs_domain = vs))

  expect_true(any(grepl("^MTB", colnames(out))) &
                any(grepl("^WIDTH_", colnames(out))) &
                any(grepl("^SYSBP", colnames(out))))

  expect_false(any(grepl("^HEADACHE", colnames(out))))

  # remove_empty should remove any fully-NA columns: assert no column is entirely NA
  if(nrow(out) > 0){
    all_na_cols <- sapply(out, function(col) all(is.na(col)))
    expect_false(any(all_na_cols))
  }
})

test_that("create_clinical_table handles NULL optional domains and returns DM data", {
  dm <- tibble::tibble(STUDYID = "S", USUBJID = "P1")

  out <- create_clinical_table(dm_domain = dm, mb_domain = NULL, mp_domain = NULL, sa_domain = NULL, vs_domain = NULL)

  expect_true(all(c("STUDYID", "USUBJID") %in% colnames(out)))
  expect_false(all(c("AGE") %in% colnames(out)))
})

