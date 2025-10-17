## code to prepare `VS_RPTESTB` dataset goes here

VS_RPTESTB <- read_csv("inst/extdata/Synthetic_Data_RPTESTB/VS_RPTESTB.csv",
                       show_col_types = FALSE, guess_max = Inf)

usethis::use_data(VS_RPTESTB, overwrite = TRUE)

rm(VS_RPTESTB)
