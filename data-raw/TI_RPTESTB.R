## code to prepare `TI_RPTESTB` dataset goes here

TI_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/TI_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(TI_RPTESTB, overwrite = TRUE)

rm(TI_RPTESTB)
