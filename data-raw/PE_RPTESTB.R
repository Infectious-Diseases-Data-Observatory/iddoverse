## code to prepare `PE_RPTESTB` dataset goes here

PE_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/PE_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(PE_RPTESTB, overwrite = TRUE)

rm(PE_RPTESTB)
