## code to prepare `RP_RPTESTB` dataset goes here

RP_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/RP_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(RP_RPTESTB, overwrite = TRUE)

rm(RP_RPTESTB)
