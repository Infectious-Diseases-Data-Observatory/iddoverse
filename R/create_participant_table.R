#' Create table of participant details and baseline characteristics.
#'
#' Joins several IDDO-SDTM domains together to create a single dataset with
#' participant demographics, characteristics and baseline test results or
#' findings. Baseline timing is defined as planned
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
  data <- prepare_domain(dm_domain, "dm",
                         variables_include = c("STUDYID", "USUBJID", "AGEU",
                                               "AGE", "SEX","RFSTDTC",
                                               "RACE", "ETHNIC", "ARMCD", "COUNTRY",
                                               "SITEID", "DTHFL", "DTHDY", "DTHHR"))

  if(!is.null(sc_domain)){
    assert_data_frame(sc_domain, required_vars = exprs(VISITDY, EPOCH))

    data <- data %>%
      left_join(
        prepare_domain(sc_domain, "sc",
                       variables_include = c("EDULEVEL", "MARISTAT"),
                       timing_variables = c("VISITDY", "EPOCH"))%>%
          filter(
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          arrange(USUBJID, TIME_SOURCE) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(vs_domain)){
    assert_data_frame(vs_domain, required_vars = exprs(VISITDY, EPOCH))

    data <- data %>%
      left_join(
        prepare_domain(vs_domain, "vs",
                       variables_include = c("HEIGHT", "WEIGHT", "BMI", "MUARMCIR"),
                       timing_variables = c("VISITDY", "EPOCH")) %>%
          filter(
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          arrange(USUBJID, TIME_SOURCE) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(lb_domain)){
    assert_data_frame(lb_domain, required_vars = exprs(VISITDY, EPOCH))

    data <- data %>%
      left_join(
        prepare_domain(lb_domain, "lb",
                       variables_include = c("G6PD"),
                       timing_variables = c("VISITDY", "EPOCH")) %>%
          filter(
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          arrange(USUBJID, TIME_SOURCE) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(mb_domain)){
    assert_data_frame(mb_domain, required_vars = exprs(VISITDY, EPOCH))

    data <- data %>%
      left_join(
        prepare_domain(mb_domain, "mb",
                       variables_include = c("HIV"),
                       timing_variables = c("VISITDY", "EPOCH")) %>%
          filter(
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          arrange(USUBJID, TIME_SOURCE) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
      )
  }

  if(!is.null(rp_domain)){
    assert_data_frame(rp_domain, required_vars = exprs(VISITDY, EPOCH))

    data <- data %>%
      left_join(
        prepare_domain(rp_domain, "rp",
                       variables_include = c("PREGIND", "EGESTAGE"),
                       timing_variables = c("VISITDY", "EPOCH")) %>%
          filter(
              (TIME == 1 & TIME_SOURCE == "VISITDY") |
              (TIME == "BASELINE" & TIME_SOURCE == "EPOCH")
          ) %>%
          arrange(USUBJID, TIME_SOURCE) %>%
          select(-c(TIME, TIME_SOURCE)) %>%
          group_by(USUBJID) %>%
          slice(1) %>%
          ungroup()
        )

  }

  if("HEIGHT_cm" %in% names(data) &
     "WEIGHT_kg" %in% names(data) &
     "SEX" %in% names(data) &
     "AGE_YEARS" %in% names(data)){

    data = data %>%
      derive_anthro_scores()
  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
