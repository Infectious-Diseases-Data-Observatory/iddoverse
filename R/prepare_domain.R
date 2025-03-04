prepare_domain <- function(domain, data,
                           include_LOC = FALSE,
                           include_METHOD = FALSE,
                           variables_include = c(),
                           timing_variables = c(
                             str_c(domain, "HR"), str_c(domain, "DY"),
                             str_c(domain, "STDY"), "VISITDY", "VISITNUM",
                             "VISIT", "EPOCH", str_c(domain, "EVLINT"), str_c(domain, "EVINTX")),
                           values_fn = first){
  special_domains <- c("DM")

  findings_domains <- c("LB", "MB", "VS", "RS", "MP") # MP, DD, PE, PF, RP, SC  ## loc method

  event_domains <- c("SA", "HO", "ER", "PO") # "DS",

  intervention_domains <- c("IN")

  domain <- str_to_upper(domain)

  variables_include <- str_to_upper(variables_include)

  timing_variables <- timing_variables[which(timing_variables %in% names(data))]

  if(domain %in% special_domains){
    data <- data %>%
      convert_blanks_to_na()

    if(length(variables_include) > 0){
      data <- data %>%
        select(any_of(variables_include))
    }

  } else if(domain %in% findings_domains){
    data <- data %>%
      convert_blanks_to_na() %>%
      mutate(across(
        ((contains("STRES") & !ends_with("U")) | ends_with("ORRES")),
        function(x) str_to_upper(as.character(x)))) %>%
      mutate(across(
        any_of(timing_variables),
        function(x) as.character(x))) %>%
      mutate(RESULTS = as.character(NA),
             UNITS = as.character(NA),
             TESTCD = as.character(NA),
             TIME = as.character(NA),
             TIME_SOURCE = as.character(NA),
             LOC = as.character(NA),
             METHOD = as.character(NA))

    data[, "TESTCD"] <-
      data[, str_c(domain, "TESTCD")]
    data[, "LOC"] <-
      data[, str_c(domain, "LOC")]
    data[, "METHOD"] <-
      data[, str_c(domain, "METHOD")]

    if(length(variables_include) > 0){
      data <- data %>%
        filter(TESTCD %in% variables_include)
    }

    ## amalgamate
    data[, "RESULTS"] <-
      data[, str_c(domain, "STRESN")]
    data[which(is.na(data$RESULTS)), "RESULTS"] <-
      data[which(is.na(data$RESULTS)), str_c(domain, "STRESC")]

    data[which(!is.na(data$RESULTS)), "UNITS"] <-
      data[which(!is.na(data$RESULTS)), str_c(domain, "STRESU")]

    ## if in modify_domains then add modify

    data[which(is.na(data$RESULTS)), "RESULTS"] <-
      data[which(is.na(data$RESULTS)), str_c(domain, "ORRES")]
    data[which(!is.na(data$RESULTS)), "UNITS"] <-
      data[which(!is.na(data$RESULTS)), str_c(domain, "ORRESU")]

    ## time
    for(i in 1:length(timing_variables)){
      data[which(is.na(data$TIME)), "TIME"] <-
        data[which(is.na(data$TIME)), timing_variables[i]]

      data[which(is.na(data$TIME_SOURCE) & !is.na(data$TIME)), "TIME_SOURCE"] <-
        timing_variables[i]
    }

    ## pivot
    if(include_LOC == FALSE & include_METHOD == FALSE){
      data <- data %>%
        pivot_wider(
          id_cols = c(
            .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
          ),
          names_from = .data$TESTCD,
          values_from = c(.data$RESULTS, .data$UNITS),
          names_sort = TRUE, names_vary = "slowest",
          names_glue = "{TESTCD}_{.value}",
          values_fn = values_fn
        )
    } else if(include_LOC == TRUE & include_METHOD == FALSE){
      data <- data %>%
      pivot_wider(
        id_cols = c(
          .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
        ),
        names_from = .data$TESTCD,
        values_from = c(.data$RESULTS, .data$UNITS, .data$LOC),
        names_sort = TRUE, names_vary = "slowest",
        names_glue = "{TESTCD}_{.value}",
        values_fn = values_fn
      )
    }else if(include_LOC == FALSE & include_METHOD == TRUE){
      data <- data %>%
      pivot_wider(
        id_cols = c(
          .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
        ),
        names_from = .data$TESTCD,
        values_from = c(.data$RESULTS, .data$UNITS, .data$METHOD),
        names_sort = TRUE, names_vary = "slowest",
        names_glue = "{TESTCD}_{.value}",
        values_fn = values_fn
      )
    }else{
      data <- data %>%
        pivot_wider(
          id_cols = c(
            .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
          ),
          names_from = .data$TESTCD,
          values_from = c(.data$RESULTS, .data$UNITS, .data$LOC, .data$METHOD),
          names_sort = TRUE, names_vary = "slowest",
          names_glue = "{TESTCD}_{.value}",
          values_fn = values_fn
        )
    }

    ## colnames
    colnames(data) <- gsub("_RESULTS", "", colnames(data))
    # colnames(pivot_data) <- gsub("_UNITS", "U", colnames(pivot_data))

    ## clean names
    data = data %>%
      clean_names(case = "all_caps") %>%
      arrange(USUBJID, str_rank(.data$TIME, numeric = TRUE))

    # return(pivot_data)
  } else if(domain %in% event_domains){
    data <- data %>%
      convert_blanks_to_na() %>%
      mutate(across(
        (ends_with("TERM") | ends_with("DECOD") | ends_with("MODIFY")),
        function(x) str_to_upper(as.character(x)))) %>%
      mutate(across(
        any_of(timing_variables),
        function(x) as.character(x))) %>%
      mutate(EVENT = as.character(NA),
             OCCUR = as.character(NA),
             PRESP = as.character(NA),
             TIME = as.character(NA),
             TIME_SOURCE = as.character(NA))

    data[, "OCCUR"] <-
      data[, str_c(domain, "OCCUR")]
    data[, "PRESP"] <-
      data[, str_c(domain, "PRESP")]

    data[, "EVENT"] <-
      data[, str_c(domain, "DECOD")]
    data[which(is.na(data$EVENT)), "EVENT"] <-
      data[which(is.na(data$EVENT)), str_c(domain, "MODIFY")]
    data[which(is.na(data$EVENT)), "EVENT"] <-
      data[which(is.na(data$EVENT)), str_c(domain, "TERM")]

    data <- data %>%
      filter(EVENT %in% variables_include)

    if (any(is.na(data$PRESP))) {
      data[which(is.na(data$PRESP)), "PRESP"] <- "N"
      data[which(data$PRESP == "N"), "OCCUR"] <- "Y"
    }

    for(i in 1:length(timing_variables)){
      data[which(is.na(data$TIME)), "TIME"] <-
        data[which(is.na(data$TIME)), timing_variables[i]]

      data[which(is.na(data$TIME_SOURCE) & !is.na(data$TIME)), "TIME_SOURCE"] <-
        timing_variables[i]
    }

    data <- data %>%
      pivot_wider(
        id_cols = c(
          .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE
        ),
        names_from = .data$EVENT,
        values_from = c(.data$PRESP, .data$OCCUR),
        names_sort = TRUE, names_vary = "slowest",
        names_glue = "{EVENT}_{.value}",
        values_fn = values_fn
      )

    colnames(data) <- gsub("_EVENT", "", colnames(data))

    data = data %>%
      clean_names(case = "all_caps") %>%
      arrange(USUBJID, str_rank(.data$TIME, numeric = TRUE))
  }

  return(data)
}
