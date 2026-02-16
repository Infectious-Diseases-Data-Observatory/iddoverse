test_that("replicate labs table to verify output", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = c("S1","S1", "S2"),
    LBTESTCD = c("HGB","ALT", "HGB"),
    LBSTDY = c("1","1", "1"),
    LBSTRESN = c(10, 99, 22), LBSTRESU = c("U","U", "U"),
    LBORRES = c("ten", "ninty-nine", "twenty two"), LBORRESU = "units"
  )

  out_table <- create_labs_table(lb_domain = lb)
  out_prepare <- prepare_domain(lb, "lb", print_messages = FALSE)

  expect_identical(out_table, out_prepare)
})

test_that("check labs table additional parameters", {
  lb <- tibble::tibble(
    STUDYID = "ST1", USUBJID = c("S1","S1", "S2"),
    LBTESTCD = c("HGB","ALT", "HGB"),
    LBSTDY = c("1","1", "1"), VISITDY = 1,
    LBSTRESN = c(10, 99, 22), LBSTRESU = c("U","U", "U"),
    LBORRES = c("ten", "ninty-nine", "twenty two"), LBORRESU = "units",
    LBMETHOD = c("M1", "M1", "M2")
  )

  out_table <- create_labs_table(lb_domain = lb, variables = "HGB",
                                 include_method = TRUE, timing_variables = "VISITDY")
  out_prepare <- prepare_domain(lb, "lb", variables_include = "HGB",
                                include_METHOD = TRUE, timing_variables = "VISITDY",
                                print_messages = FALSE)

  expect_identical(out_table, out_prepare)
  expect_true("HGB_M1_U" %in% names(out_table))
  expect_true("HGB_M2_U" %in% names(out_table))
  expect_true("HGB_M1_U" %in% names(out_prepare))
  expect_true("HGB_M2_U" %in% names(out_prepare))

  expect_false(any(grepl("^ALT", colnames(out_table))))
  expect_false(any(grepl("^ALT", colnames(out_prepare))))
})
