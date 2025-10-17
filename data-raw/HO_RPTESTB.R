## code to prepare `HO_RPTESTB` dataset goes here

HO_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/HO_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(HO_RPTESTB, overwrite = TRUE)

rm(HO_RPTESTB)
