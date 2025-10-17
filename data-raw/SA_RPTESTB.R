## code to prepare `SA_RPTESTB` dataset goes here

SA_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/SA_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(SA_RPTESTB, overwrite = TRUE)

rm(SA_RPTESTB)
