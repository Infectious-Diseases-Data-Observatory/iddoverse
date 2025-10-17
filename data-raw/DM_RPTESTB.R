## code to prepare `DM_RPTESTB` dataset goes here

DM_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/DM_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(DM_RPTESTB, overwrite = TRUE)

rm(DM_RPTESTB)
