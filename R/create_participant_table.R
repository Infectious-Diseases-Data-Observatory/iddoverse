#' Create table of participant details and baseline characteristics.
#'
#' Joins several IDDO-SDTM domains together to create a single dataset with
#' participant demographics, characteristics and baseline test results or
#' findings.
#'
#' @param dm_domain The name of the demographics (DM) domain in the global
#'   environment.
#' @param lb_domain The name of the laboratory test results (LB) domain in the
#'   global environment.
#' @param mb_domain The name of the microbiology (MB) domain in the global
#'   environment.
#' @param rp_domain The name of the reproductive system findings (RP) domain in
#'   the global environment.
#' @param sc_domain The name of the subject characteristics (SC) domain in the
#'   global environment.
#' @param vs_domain The name of the vital signs (VS) domain in the global
#'   environment.
#'
#' @returns An analysis dataset, one row per participant.
#'
#' @export
#'
create_participant_table <- function(dm_domain,
                                     lb_domain = NULL,
                                     mb_domain = NULL,
                                     rp_domain = NULL,
                                     sc_domain = NULL,
                                     vs_domain = NULL){
  data <- prepare_domain("dm", dm_domain,
                         variables_include = c("STUDYID", "USUBJID",
                                               "AGE", "AGEU", "SEX","RFSTDTC",
                                               "RACE", "ETHNIC", "ARMCD", "COUNTRY",
                                               "SITEID", "DTHFL", "DTHDY", "DTHHR"))

  if(!is.null(sc_domain)){
    data <- data %>%
      left_join(
        prepare_domain("sc", sc_domain,
                       variables_include = c("EDULEVEL", "MARISTAT"),
                       timing_variables = c("SCDY", "VISITDY", "EPOCH"))%>%
          filter(
            (TIME == 1 & TIME_SOURCE == "SCDY") |
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(vs_domain)){
    data <- data %>%
      left_join(
        prepare_domain("vs", vs_domain,
                       variables_include = c("HEIGHT", "WEIGHT", "BMI", "MUARMCIR"),
                       timing_variables = c("VSDY", "VISITDY", "EPOCH")) %>%
          filter(
            (TIME == 1 & TIME_SOURCE == "VSDY") |
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(lb_domain)){
    data <- data %>%
      left_join(
        prepare_domain("lb", lb_domain,
                       variables_include = c("G6PD"),
                       timing_variables = c("LBDY", "VISITDY", "EPOCH")) %>%
          filter(
            (TIME == 1 & TIME_SOURCE == "LBDY") |
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(mb_domain)){
    data <- data %>%
      left_join(
        prepare_domain("mb", mb_domain,
                       variables_include = c("HIV"),
                       timing_variables = c("MBDY", "VISITDY", "EPOCH")) %>%
          filter(
            (TIME == 1 & TIME_SOURCE == "MBDY") |
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(rp_domain)){
    data <- data %>%
      left_join(
        prepare_domain("rp", rp_domain,
                               variables_include = c("PREGIND", "EGESTAGE"),
                               timing_variables = c("RPDY", "VISITDY", "EPOCH")) %>%
          filter(
            (TIME == 1 & TIME_SOURCE == "RPDY") |
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
        )

  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
