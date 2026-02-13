test_that("DM domain returns column names", {
  dm <- tibble::tibble(STUDYID = "S", USUBJID = "P1", AGE = 10, SEX = "M")

  res <- table_variables(dm, "DM", by_STUDYID = FALSE)

  expect_equal(res, colnames(dm))
})

test_that("LB domain without by_STUDYID returns a table of LBTESTCD including NA", {
  lb <- tibble::tibble(
    STUDYID = c("S1","S1","S2","S2","S2", NA),
    USUBJID = paste0("P", seq_len(6)),
    LBTESTCD = c("HGB","HGB","ALT","ALT","ALT", NA),
    LBORRES = c(10,11,25,26,27, NA)
  )

  res <- table_variables(lb, "LB", by_STUDYID = FALSE)

  expect_s3_class(res, "table")

  # counts for HGB and ALT should be present
  expect_equal(as.integer(res["HGB"]), 2L)
  expect_equal(as.integer(res["ALT"]), 3L)

  # NA is included
  expect_true(any(is.na(names(res)) | names(res) == "NA"))

  # useNA = "ifany" should produce an NA count > 0
  expect_true(res[is.na(names(res))] >= 1 | any(is.na(names(res))))
})

test_that("LB domain with by_STUDYID returns a contingency table STUDYID x LBTESTCD", {
  lb <- tibble::tibble(
    STUDYID = c("S1","S1","S2","S2","S2", NA),
    USUBJID = paste0("P", seq_len(6)),
    LBTESTCD = c("HGB","HGB","ALT","ALT","ALT", NA),
    LBORRES = c(10,11,25,26,27, NA)
  )

  res <- table_variables(lb, "LB", by_STUDYID = TRUE)

  expect_s3_class(res, "table")

  # dims: rows = unique STUDYID including NA, cols = unique LBTESTCD including NA
  expect_true(all(c("S1","S2") %in% rownames(res)))
  expect_true(all(c("HGB","ALT") %in% colnames(res)))

  # check counts: S1 has 2 HGB
  expect_equal(as.integer(res["S1","HGB"]), 2L)

  # S2 has 3 ALT
  expect_equal(as.integer(res["S2","ALT"]), 3L)
})

test_that("VS domain behaves similarly to LB", {
  vs <- tibble::tibble(
    STUDYID = c("S1","S2","S2"),
    USUBJID = c("A","B","C"),
    VSTESTCD = c("SYSBP","DIABP","SYSBP"),
    VSTEST = c("Systolic","Diastolic","Systolic")
  )

  res_no_split <- table_variables(vs, "VS", by_STUDYID = FALSE)

  expect_s3_class(res_no_split, "table")

  expect_equal(as.integer(res_no_split["SYSBP"]), 2L)

  res_split <- table_variables(vs, "VS", by_STUDYID = TRUE)

  expect_s3_class(res_split, "table")

  # S2 has one SYSBP
  expect_equal(as.integer(res_split["S2","SYSBP"]), 1L)
})

test_that("domains that uppercase text (SA/IN/PO) count case-insensitively and by_STUDYID works", {
  sa <- tibble::tibble(
    STUDYID = c("S1","S1","S2"),
    USUBJID = c("A","B","C"),
    SATERM = c("fever","Fever","rash")
  )

  # non-split should uppercase and group 'fever'/'Fever' together
  res_sa <- table_variables(sa, "SA", by_STUDYID = FALSE)

  expect_s3_class(res_sa, "table")

  # uppercased 'FEVER' should have count 2
  expect_equal(as.integer(res_sa["FEVER"]), 2L)

  # split by STUDYID
  res_sa_split <- table_variables(sa, "SA", by_STUDYID = TRUE)

  expect_s3_class(res_sa_split, "table")

  # S1 has FEVER count 2
  expect_equal(as.integer(res_sa_split["S1","FEVER"]), 2L)
})

test_that("NA handling for categorical variables includes NA counts", {
  lb <- tibble::tibble(
    STUDYID = c("S1","S1","S2","S2","S2", NA),
    USUBJID = paste0("P", seq_len(6)),
    LBTESTCD = c("HGB","HGB","ALT","ALT","ALT", NA),
    LBORRES = c(10,11,25,26,27, NA)
  )

  # LB has one NA LBTESTCD
  res <- table_variables(lb, "LB", by_STUDYID = FALSE)

  # find NA entry in names(res)
  na_index <- which(is.na(names(res)))
  expect_true(length(na_index) >= 1)
  expect_true(as.integer(res[na_index]) >= 1)
})

test_that("unknown/unsupported domain returns warning", {
  df <- tibble::tibble(STUDYID = "S", USUBJID = "P1")

  expect_warning(table_variables(df, "XX", by_STUDYID = FALSE),
                 regexp = "domain not included in table_variables")
})
