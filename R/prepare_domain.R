#' Prepare IDDO-SDTM domain for analysis
#'
#' Amalgamate domain data and pivot wider to convert the IDDO-SDTM format data
#' into a more analysable format. Function works on one domain and requires the
#' two letter domain name as well as the domain data file.
#'
#' @param domain Character. The two letter domain name of the data.
#' @param data Domain data frame.
#' @param include_LOC Boolean. Should the location (--LOC) be included in the
#'   output. Default is FALSE.
#' @param include_METHOD Boolean. Should the method (--METHOD) be included in
#'   the output. Default is FALSE.
#' @param variables_include Character list. List of variables to include in the
#'   output. Default is to include all available variables.
#' @param timing_variables Character list. List of timing variables which are to
#'   be used to separate time points, this is hierarchical so the order is taken
#'   into account. Default is: --HR, --DY, --STDY, VISITDY, VISITNUM, VISIT,
#'   EPOCH, --EVLINT, --EVINTX.
#'
#'   (using default for example) Each row will be initially summarised based on
#'   the --HR (study hour) variable, if that is missing then the --DY (study
#'   day) variable is used, and so on. The output will be one row per
#'   participant, per time point, where the time point for each row is the first
#'   available variable listed in timing_variables.
#' @param values_fn Function. The function which will determine which data row
#'   is used in the output, in the event there are multiple rows for the same
#'   subject with the same time points (as listed in timing_variables). Default
#'   is first(), i.e. if there is two rows from the same day and time, the first
#'   record will be taken, the second will be dropped. Choice of
#'   timing_variables will impact the number of rows affected.
#'
#' @returns A dataframe which has been cleaned and subset based on the input
#'   parameters.
#'
#' @export
#'
#' @examples
#'
#' prepare_domain("DM", DM_RPTESTB)
#'
#' # Select just ARMCD, AGE & SEX
#' prepare_domain("DM", DM_RPTESTB, variables_include = c("ARMCD", "AGE", "SEX"))
#'
#' # Change which timing_variables are used to summarise the data
#' prepare_domain("lb", LB_RPTESTB, timing_variables = c("VISITNUM", "VISITDY"))
#'
#' # Include location in the output and change the values_fn to select the last result
#' prepare_domain("vs", VS_RPTESTB, include_LOC = TRUE, values_fn = dplyr::last)
#'
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

  findings_domains <- c("LB", "MB", "VS", "RS", "DD", "RP", "SC", "MP", "PF",
                        "AU", "PC") # "MS"

  event_domains <- c("SA", "HO", "ER", "PO") # "DS"

  domain <- str_to_upper(domain)

  variables_include <- str_to_upper(variables_include)

  timing_variables <- timing_variables[which(timing_variables %in% names(data))]

  if(include_LOC == TRUE & !(str_c(domain, "LOC") %in% names(data))){
    rlang::warn(str_c("This dataset does not have a location (", domain, "LOC) variable, yet include_LOC is TRUE"))
    include_LOC = FALSE
  }

  if(include_METHOD == TRUE & !(str_c(domain, "METHOD") %in% names(data))){
    rlang::warn(str_c("This dataset does not have a method (", domain, "METHOD) variable, yet include_METHOD is TRUE"))
    include_METHOD = FALSE
  }

  if(domain %in% special_domains){
    data <- data %>%
      convert_blanks_to_na()

    if(length(variables_include) > 0){
      data <- data %>%
        select(.data$STUDYID, .data$USUBJID, any_of(variables_include))
    }

    if("AGEU" %in% names(data)){
      data = data %>%
        convert_age_to_years()
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
        filter(.data$TESTCD %in% variables_include)
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
      group_by(.data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE, .data$TESTCD) %>%
      dplyr::summarise(n = dplyr::n()) %>%
      ungroup() %>%
      filter(.data$n > 1)

    print(str_c("Number of rows where values_fn has been used to pick record in the ", domain, " domain: ", nrow(value_fun_check)))

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
      filter(.data$EVENT %in% variables_include)

    if(any(is.na(data$PRESP))) {
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
      filter(.data$n > 1)

    print(str_c("Number of rows where values_fn has been used to pick record in the ", domain, " domain: ", nrow(value_fun_check)))

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

  }

  else if(domain == "DS"){
    data <- data %>%
      convert_blanks_to_na() %>%
      mutate(across(
        (ends_with("TERM") | ends_with("DECOD") | ends_with("MODIFY")),
        function(x) str_to_upper(as.character(x)))) %>%
      mutate(across(
        any_of(timing_variables),
        function(x) as.character(x))) %>%
      mutate(EVENT = as.character(NA),
             TIME = as.character(NA),
             TIME_SOURCE = as.character(NA))

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
      filter(.data$n > 1)

    print(str_c("Number of rows where values_fn has been used to pick record in the ", domain, " domain: ", nrow(value_fun_check)))

    data <- data %>%
      select(.data$STUDYID, .data$USUBJID, .data$TIME, .data$TIME_SOURCE, .data$EVENT)
  }

  if("TIME_SOURCE" %in% names(data)){
    data <- data %>%
      mutate(TIME_SOURCE = sub(paste0("^", domain), "", .data$TIME_SOURCE))
  }

  return(data)
}
