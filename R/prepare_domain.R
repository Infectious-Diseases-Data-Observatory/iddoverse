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

  findings_domains <- c("LB", "MB", "VS", "RS", "DD", "RP", "SC", "MP") # PE, PF

  event_domains <- c("SA", "HO", "ER", "PO") # , "DS"

  intervention_domains <- c("IN")

  domain <- str_to_upper(domain)

  variables_include <- str_to_upper(variables_include)

  timing_variables <- timing_variables[which(timing_variables %in% names(data))]

  if(include_LOC == TRUE & !(str_c(domain, "LOC") %in% names(data))){
    rlang::warn("This dataset does not have a location (LOC) variable, yet include_LOC is TRUE")
    include_LOC = FALSE
  }

  if(include_METHOD == TRUE & !(str_c(domain, "METHOD") %in% names(data))){
    rlang::warn("This dataset does not have a method (METHOD) variable, yet include_METHOD is TRUE")
    include_METHOD = FALSE
  }

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

    if(include_LOC == TRUE){
      data[, "LOC"] <-
        data[, str_c(domain, "LOC")]
    }

    if(include_METHOD == TRUE){
      data[, "METHOD"] <-
        data[, str_c(domain, "METHOD")]
    }

    if(length(variables_include) > 0){
      data <- data %>%
        filter(TESTCD %in% variables_include)
    }

    if(str_c(domain, "STRESN") %in% names(data)){
      data[, "RESULTS"] <-
        data[, str_c(domain, "STRESN")]
    }

    if(str_c(domain, "STRESC") %in% names(data)){
      data[which(is.na(data$RESULTS)), "RESULTS"] <-
        data[which(is.na(data$RESULTS)), str_c(domain, "STRESC")]
    }

    if(str_c(domain, "STRESN") %in% names(data) |
       str_c(domain, "STRESC") %in% names(data)){
      data[which(!is.na(data$RESULTS)), "UNITS"] <-
        data[which(!is.na(data$RESULTS)), str_c(domain, "STRESU")]
    }

    if(str_c(domain, "MODIFY") %in% names(data)){
      data[which(is.na(data$RESULTS)), "RESULTS"] <-
        data[which(is.na(data$RESULTS)), str_c(domain, "MODIFY")]
    }

    orres_index = which(is.na(data$RESULTS))

    data[orres_index, "RESULTS"] <-
      data[orres_index, str_c(domain, "ORRES")]
    data[orres_index, "UNITS"] <-
      data[orres_index, str_c(domain, "ORRESU")]

    for(i in 1:length(timing_variables)){
      data[which(is.na(data$TIME)), "TIME"] <-
        data[which(is.na(data$TIME)), timing_variables[i]]

      data[which(is.na(data$TIME_SOURCE) & !is.na(data$TIME)), "TIME_SOURCE"] <-
        timing_variables[i]
    }

    value_fun_check <- data %>%
      group_by(.data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE) %>%
      dplyr::summarise(n = dplyr::n()) %>%
      ungroup() %>%
      filter(n > 1)

    print(str_c("Number of rows where values_fn has been used to pick record: ", nrow(value_fun_check)))

    if(include_LOC == FALSE & include_METHOD == FALSE){
      data <- data %>%
        pivot_wider(
          id_cols = c(
            .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
          ),
          names_from = c(.data$TESTCD, .data$UNITS),
          values_from = c(.data$RESULTS),
          names_sort = TRUE, names_vary = "slowest",
          names_glue = "{TESTCD}_{UNITS}_{.value}",
          values_fn = values_fn
        )
    } else if(include_LOC == TRUE & include_METHOD == FALSE){
      data <- data %>%
      pivot_wider(
        id_cols = c(
          .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
        ),
        names_from = c(.data$TESTCD, .data$LOC, .data$UNITS),
        values_from = c(.data$RESULTS),
        names_sort = TRUE, names_vary = "slowest",
        names_glue = "{TESTCD}_{LOC}_{UNITS}_{.value}",
        values_fn = values_fn
      )
    }else if(include_LOC == FALSE & include_METHOD == TRUE){
      data <- data %>%
      pivot_wider(
        id_cols = c(
          .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
        ),
        names_from = c(.data$TESTCD, .data$METHOD, .data$UNITS),
        values_from = c(.data$RESULTS),
        names_sort = TRUE, names_vary = "slowest",
        names_glue = "{TESTCD}_{METHOD}_{UNITS}_{.value}",
        values_fn = values_fn
      )
    }else{
      data <- data %>%
        pivot_wider(
          id_cols = c(
            .data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE # timing vars
          ),
          names_from = c(.data$TESTCD, .data$LOC, .data$METHOD, .data$UNITS),
          values_from = c(.data$RESULTS),
          names_sort = TRUE, names_vary = "slowest",
          names_glue = "{TESTCD}_{LOC}_{METHOD}_{UNITS}_{.value}",
          values_fn = values_fn
        )
    }

    colnames(data) <- gsub("_RESULTS", "", colnames(data))
    colnames(data) <- gsub(" ", "_", colnames(data))
    # colnames(pivot_data) <- gsub("_UNITS", "U", colnames(pivot_data))

    # data = data %>%
      # clean_names(case = "parsed") %>%
      # arrange(USUBJID, str_rank(.data$TIME, numeric = TRUE))

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

    if(str_c(domain, "DECOD") %in% names(data)){
      data[, "EVENT"] <-
        data[, str_c(domain, "DECOD")]
    }

    if(str_c(domain, "MODIFY") %in% names(data)){
      data[which(is.na(data$EVENT)), "EVENT"] <-
        data[which(is.na(data$EVENT)), str_c(domain, "MODIFY")]
    }

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

    value_fun_check <- data %>%
      group_by(.data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE) %>%
      dplyr::summarise(n = dplyr::n()) %>%
      ungroup() %>%
      filter(n > 1)

    print(str_c("Number of rows where values_fn has been used to pick record: ", nrow(value_fun_check)))

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
      clean_names(case = "all_caps")
    # %>%
    #   arrange(USUBJID, stringr::str_rank(.data$TIME, numeric = TRUE))
  }

  return(data)
}
