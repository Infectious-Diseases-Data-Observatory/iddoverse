## code to prepare `PF_RPTESTB` dataset goes here

PF_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/PF_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(PF_RPTESTB, overwrite = TRUE)

rm(PF_RPTESTB)
