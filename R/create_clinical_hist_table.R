create_clinical_hist_table <- function(dm_domain, sa_domain){
  data <- prepare_domain("dm", dm_domain, variables_include = c("STUDYID", "USUBJID"))

  data_sa <- sa_domain %>%
      filter(SACAT == "MEDICAL HISTORY")

  # if(!is.null(sa_domain)){
    data <- data %>%
      full_join(prepare_domain("SA", data_sa,
                               variables_include = c(
                                 "fever", "anemia",
                                 "malaria", "hiv")))
  # }


  data <- data %>%
    remove_empty("cols")

  return(data)
}
