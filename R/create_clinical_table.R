#' Creates table of key clinical features
#'
#' Uses several IDDO-SDTM domains to create a single dataset with various
#' demographic, microbiology, physiology, clinical and vital sign information
#' summarised.
#'
#' @param dm_domain A demographics/DM domain data frame.
#' @param mb_domain A microbiology/MB domain data frame.
#' @param mp_domain A morphology and physiology/MP domain data frame.
#' @param sa_domain A clinical and adverse events/SA domain data frame.
#' @param vs_domain A vital signs/VS domain data frame.
#' @param timing_variables Character list. List of timing variables which are to
#'   be used to separate time points, this is hierarchical so the order is taken
#'   into account. Default is: --HR, --DY, --STDY, VISITDY, VISITNUM, VISIT,
#'   EPOCH,
#'   --EVLINT, --EVINTX.
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
#'
#' create_clinical_table(dm_domain = DM_RPTESTB,
#'                       sa_domain = SA_RPTESTB,
#'                       vs_domain = VS_RPTESTB)
#'
#' create_clinical_table(dm_domain = DM_RPTESTB,
#'                       sa_domain = SA_RPTESTB,
#'                       vs_domain = VS_RPTESTB)
#'
create_clinical_table <- function(dm_domain, mb_domain = NULL, mp_domain = NULL,
                                  sa_domain = NULL, vs_domain = NULL,
                                  timing_variables = c(
                                    str_c(domain, "HR"), str_c(domain, "DY"),
                                    str_c(domain, "STDY"), "VISITDY", "VISITNUM",
                                    "VISIT", "EPOCH", str_c(domain, "EVLINT"), str_c(domain, "EVINTX")),
                                  values_funct = first){
  data <- prepare_domain("dm", dm_domain, variables_include = c("STUDYID", "USUBJID"))

  if(!is.null(mb_domain)){
    domain <- "MB"
    data <- data %>%
      full_join(prepare_domain("mb", mb_domain, variables_include = c("MTB", "HIV"),
                               timing_variables = timing_variables,
                               values_fn = values_funct))
  }

  if(!is.null(mp_domain)){
    domain <- "MP"
    data <- data %>%
      full_join(prepare_domain("mp", mp_domain, include_LOC = TRUE,
                               timing_variables = timing_variables,
                               values_fn = values_funct))
  }


  if(!is.null(vs_domain)){
    domain <- "VS"
    data <- data %>%
      full_join(prepare_domain("vs", vs_domain,
                               timing_variables = timing_variables,
                               values_fn = values_funct))
  }

  if(!is.null(sa_domain)){
    domain <- "SA"
    data <- data %>%
      full_join(prepare_domain("sa", sa_domain,
                               variables_include = c(
                                 "vomiting", "nausea", "fever",  "diarrhea",
                                 "abdominal pain", "jaundice", "bleeding",
                                 "anemia", "anorexia", "blood transfusion"),
                               timing_variables = timing_variables,
                               values_fn = values_funct))
  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
