## code to prepare `DS_RPTESTB` dataset goes here

DS_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/DS_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(DS_RPTESTB, overwrite = TRUE)

rm(DS_RPTESTB)
