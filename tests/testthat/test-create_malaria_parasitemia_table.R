test_that("replicate labs table to verify output", {
  mb <- tibble::tibble(
    STUDYID = c("ST1", "ST1", "ST1", "ST2"), USUBJID = c("S1","S1", "S2", "S3"),
    MBTESTCD = c("PFALCIPA","PVIVAXA", "PFALCIPA", "TCRZI"),
    MBSTDY = c("1","1", "1", "1"),
    MBSTRESN = c(101, 151, 98, 34), MBSTRESU = c("U","U", "U", "CYC"),
    MBORRES = c("one-zero-one", "151", "ninty-eight", "34"),
    MBORRESU = c("units", "units", "units", "cycle number")
  )

  out_table <- create_malaria_parasitemia_table(mb_domain = mb)
  out_prepare <- prepare_domain(mb, "MB",
                                variables_include = c(
                                  "PFALCIPA", "PFALCIPS", "PFALCIP",
                                  "PVIVAXA", "PVIVAXS", "PVIVAX"), print_messages = FALSE)

  expect_identical(out_table, out_prepare)
  expect_false(any(grepl("^TCRUZI", colnames(out_table))))
  expect_false(any(grepl("^TCRUZI", colnames(out_prepare))))
})

test_that("check labs table additional parameters", {
  mb <- tibble::tibble(
    STUDYID = c("ST1", "ST1", "ST1", "ST2"), USUBJID = c("S1","S1", "S2", "S3"),
    MBTESTCD = c("PFALCIPA","PVIVAXA", "PFALCIPA", "TCRZI"),
    MBSTDY = c("1","1", "1", "1"), VISITDY = 1,
    MBSTRESN = c(101, 151, 98, 34), MBSTRESU = c("U","U", "U", "CYC"),
    MBORRES = c("one-zero-one", "151", "ninty-eight", "34"),
    MBORRESU = c("units", "units", "units", "cycle number"),
    MBMETHOD = c("M1", "M1", "M2", "M3")
  )

  out_table <- create_malaria_parasitemia_table(mb_domain = mb,
                                                variables = "PFALCIPA",
                                                include_method = TRUE,
                                                timing_variables = "VISITDY")
  out_prepare <- prepare_domain(mb, "MB",
                                variables_include = "PFALCIPA",
                                timing_variables = "VISITDY",
                                include_METHOD = TRUE, print_messages = FALSE)

  expect_identical(out_table, out_prepare)
  expect_true("PFALCIPA_M1_U" %in% names(out_table))
  expect_true("PFALCIPA_M2_U" %in% names(out_table))
  expect_true("PFALCIPA_M1_U" %in% names(out_prepare))
  expect_true("PFALCIPA_M2_U" %in% names(out_prepare))

  expect_false(any(grepl("^PVIVAX", colnames(out_table))))
  expect_false(any(grepl("^TCRUZI", colnames(out_prepare))))
})
