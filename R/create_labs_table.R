#' Create table of laboratory test results
#'
#' Uses the IDDO-SDTM laboratory test results (LB) domain to create a single
#' dataset with various lab test result information summarised.
#'
#' @param lb_domain A laboratory/LB domain data frame.
#' @param variables Character list. A list of variables to be included in the
#'   output dataset.
#' @param include_method Boolean. Should LBMETHOD be included in the output for
#'   all variables.
#' @param timing_variables Character list. List of timing variables which are to
#'   be used to separate time points, this is hierarchical so the order is taken
#'   into account. Default is: LBHR, LBDY, LBSTDY, VISITDY, VISITNUM, VISIT,
#'   EPOCH, LBEVLINT, LBEVINTX.
#'
#'   (using default for example) Each row will be initially summarised based on
#'   the --HR (study hour) variable, if that is missing then the --DY (study
#'   day) variable is used, and so on. The output will be one row per
#'   participant, per time point, where the time point for each row is the first
#'   available variable listed in timing_variables.
#' @param values_funct Function. The function which will determine which data
#'   row is used in the output, in the event there are multiple rows for the
#'   same subject with the same time points (as listed in timing_variables).
#'   Default is first(), i.e. if there is two rows from the same day and time,
#'   the first record will be taken, the second will be dropped. Choice of
#'   timing_variables will impact the number of rows affected.
#'
#' @returns An analysis dataset, one row per person, per timepoint.
#'
#' @export
#'
#' @examples
#' create_labs_table(LB_RPTESTB)
#'
#' # Change which timing_variables are used to summarise the data, select just Hemoglobin
#' create_labs_table(LB_RPTESTB,
#'                   variables = c("HGB"),
#'                   timing_variables = c("EPOCH", "VISIT"))
#'
create_labs_table <- function(lb_domain,
                              variables = c("ALB", "ALT", "AST", "BILI", "CREAT",
                                            "CD4", "G6PD", "HCT", "HGB", "HGBMET",
                                            "INTLK6", "K", "PLAT", "SODIUM", "WBC"),
                              include_method = FALSE,
                              timing_variables = c(
                                "LBHR", "LBDY", "LBSTDY", "VISITDY", "VISITNUM",
                                "VISIT", "EPOCH", "LBEVLINT", "LBEVINTX"),
                              values_funct = first){

  prepare_domain("LB", lb_domain,
                 include_METHOD = include_method,
                 variables_include = variables,
                 timing_variables = timing_variables,
                 values_fn = values_funct)
}

