#' Creates table of medical history features
#'
#' Uses the IDDO-SDTM clinical and adverse events (SA) domain to create a single
#' dataset with various historic clinical information summarised. Historic
#' refers to events that occurred before the study start.
#'
#' @param dm_domain A demographics/DM domain data frame.
#' @param sa_domain A clinical and adverse events/SA domain data frame.
#' @param timing_variables Character list. List of timing variables which are to be used to
#'   separate time points, this is hierarchical so the order is taken into
#'   account. Default is: SAHR, SADY, SASTDY, VISITDY, VISITNUM, VISIT, EPOCH,
#'   SAEVLINT, SAEVINTX.
#'
#'   (using default for example) Each row will be initially summarised based on
#'   the --HR (study hour) variable, if that is missing then the --DY (study
#'   day) variable is used, and so on. The output will be one row per
#'   participant, per time point, where the time point for each row is the first
#'   available variable listed in timing_variables.
#' @param values_funct Function. The function which will determine which data row is used
#'   in the output, in the event there are multiple rows for the same subject
#'   with the same time points (as listed in timing_variables). Default is
#'   first(), i.e. if there is two rows from the same day and time, the first
#'   record will be taken, the second will be dropped. Choice of
#'   timing_variables will impact the number of rows affected.
#'
#' @returns An analysis dataset, one row per person, per timepoint.
#'
#' @export
#'
#' @examples
#' create_clinical_hist_table(DM_RPTESTB, SA_RPTESTB)
#'
#' # Change which timing_variables are used to summarise the data
#' create_clinical_hist_table(DM_RPTESTB, SA_RPTESTB,
#'                            timing_variables = c("VISITDY", "EPOCH"))
#'
create_clinical_hist_table <- function(dm_domain, sa_domain,
                                       timing_variables = c(
                                         "SAHR", "SADY", "SASTDY", "VISITDY", "VISITNUM",
                                         "VISIT", "EPOCH", "SAEVLINT", "SAEVINTX"),
                                       values_funct = first){
  assert_data_frame(sa_domain, required_vars = exprs(SACAT))

  data_dm <- prepare_domain("dm", dm_domain, variables_include = c("STUDYID", "USUBJID"))

  data_sa <- sa_domain %>%
      filter(SACAT == "MEDICAL HISTORY")

  data <- data_dm %>%
    right_join(prepare_domain("SA",
                              data_sa,
                             variables_include = c(
                               "fever", "anemia",
                               "malaria", "hiv"),
                             timing_variables = timing_variables, values_fn = values_funct))

  data <- data %>%
    remove_empty("cols")

  return(data)
}
