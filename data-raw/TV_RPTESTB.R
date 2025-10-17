## code to prepare `TV_RPTESTB` dataset goes here

TV_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/TV_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(TV_RPTESTB, overwrite = TRUE)

rm(TV_RPTESTB)
