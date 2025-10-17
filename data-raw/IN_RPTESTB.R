## code to prepare `IN_RPTESTB` dataset goes here

IN_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/IN_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(IN_RPTESTB, overwrite = TRUE)

rm(IN_RPTESTB)
