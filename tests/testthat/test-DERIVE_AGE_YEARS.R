test_that("convert_age_To_years works", {
  input_df <- data.frame(
    AGE = c(5, 16, 58, 60, 50),
    AGEU = c("YEARS", "MONTHS", "years", "MONTHS", "WEEKS")
  )

  output_df <- data.frame(
    AGE = c(5, 1, 58, 5, 0),
    AGEU = c("YEARS", "YEARS", "YEARS", "YEARS", "YEARS")
  )

  expect_equal(convert_age_to_years(input_df), output_df)
})
