create_clinical_table <- function(dm_domain, mb_domain = NULL, mp_domain = NULL,
                                  sa_domain = NULL, vs_domain = NULL){
  data <- prepare_domain("dm", dm_domain, variables_include = c("STUDYID", "USUBJID"))

  if(!is.null(sa_domain)){
    data <- data %>%
      full_join(prepare_domain("sa", sa_domain,
                               variables_include = c(
                                 "vomiting", "nausea", "fever",  "diarrhea",
                                 "abdominal pain", "jaundice", "bleeding",
                                 "anemia", "anorexia", "blood transfusion")))
  }

  if(!is.null(mb_domain)){
    data <- data %>%
      full_join(prepare_domain("mb", mb_domain, variables_include = c("MTB", "HIV")))
  }


  if(!is.null(mp_domain)){
    data <- data %>%
      full_join(prepare_domain("mp", mp_domain, include_LOC = TRUE))
  }


  if(!is.null(vs_domain)){
    data <- data %>%
      full_join(prepare_domain("vs", vs_domain))
  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
