## code to prepare `RS_RPTESTB` dataset goes here

RS_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/RS_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(RS_RPTESTB, overwrite = TRUE)

rm(RS_RPTESTB)
