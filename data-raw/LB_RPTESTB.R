## code to prepare `LB_RPTESTB` dataset goes here

LB_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/LB_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(LB_RPTESTB, overwrite = TRUE)

rm(LB_RPTESTB)
