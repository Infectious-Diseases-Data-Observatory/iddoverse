#' Create table of participant details and baseline characteristics.
#'
#' Joins several IDDO-SDTM domains together to create a single dataset with
#' participant demographics, characteristics and baseline test results or
#' findings. Baseline timing is defined as actual study day (--DY) = 1, planned
#' study day (VISITDY) = 1 or epoch (EPOCH) = BASELINE.
#'
#' @param dm_domain A demographics/DM domain data frame.
#' @param lb_domain A laboratory/LB domain data frame.
#' @param mb_domain A microbiology/MB domain data frame.
#' @param rp_domain A reproductive system findings/RP domain data frame.
#' @param sc_domain A subject characteristics/SC domain data frame.
#' @param vs_domain A vital signs/VS domain data frame.
#'
#' @returns An analysis dataset, one row per participant.
#'
#' @export
#'
#' @examples
#' create_participant_table(dm_domain = DM_RPTESTB,
#'                          lb_domain = LB_RPTESTB,
#'                          vs_domain = VS_RPTESTB)
#'
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
            (.data$TIME == 1 & .data$TIME_SOURCE == "SCDY") |
              (.data$TIME == 1 & .data$TIME_SOURCE == "VISITDY") |
              (.data$TIME == "BASELINE" & .data$TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(.data$TIME, .data$TIME_SOURCE)) %>%
          group_by(.data$USUBJID) %>%
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
            (.data$TIME == 1 & .data$TIME_SOURCE == "VSDY") |
              (.data$TIME == 1 & .data$TIME_SOURCE == "VISITDY") |
              (.data$TIME == "BASELINE" & .data$TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(.data$TIME, .data$TIME_SOURCE)) %>%
          group_by(.data$USUBJID) %>%
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
            (.data$TIME == 1 & .data$TIME_SOURCE == "LBDY") |
              (.data$TIME == 1 & .data$TIME_SOURCE == "VISITDY") |
              (.data$TIME == "BASELINE" & .data$TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(.data$TIME, .data$TIME_SOURCE)) %>%
          group_by(.data$USUBJID) %>%
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
            (.data$TIME == 1 & .data$TIME_SOURCE == "MBDY") |
              (.data$TIME == 1 & .data$TIME_SOURCE == "VISITDY") |
              (.data$TIME == "BASELINE" & .data$TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(.data$TIME, .data$TIME_SOURCE)) %>%
          group_by(.data$USUBJID) %>%
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
            (.data$TIME == 1 & .data$TIME_SOURCE == "RPDY") |
              (.data$TIME == 1 & .data$TIME_SOURCE == "VISITDY") |
              (.data$TIME == "BASELINE" & .data$TIME_SOURCE == "EPOCH")
          ) %>%
          select(-c(.data$TIME, .data$TIME_SOURCE)) %>%
          group_by(.data$USUBJID) %>%
          slice(1) %>%
          ungroup()
        )

  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
