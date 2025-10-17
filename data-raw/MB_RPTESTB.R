## code to prepare `MB_RPTESTB` dataset goes here

MB_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/MB_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(MB_RPTESTB, overwrite = TRUE)

rm(MB_RPTESTB)
