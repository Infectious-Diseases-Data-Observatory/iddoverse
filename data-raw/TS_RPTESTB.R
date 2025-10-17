## code to prepare `TS_RPTESTB` dataset goes here

TS_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/TS_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(TS_RPTESTB, overwrite = TRUE)

rm(TS_RPTESTB)
