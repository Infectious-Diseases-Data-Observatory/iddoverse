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
create_clinical_table <- function(dm_domain, mb_domain = NULL, mp_domain = NULL,
                                  sa_domain = NULL, vs_domain = NULL,
                                  values_funct = first){
  data <- prepare_domain(dm_domain, "dm", variables_include = "")

  if(!is.null(mb_domain)){
    data <- data %>%
      full_join(prepare_domain(mb_domain, "mb",  variables_include = c("MTB", "HIV"),
                               values_fn = values_funct))
  }

  if(!is.null(mp_domain)){
    data <- data %>%
      full_join(prepare_domain(mp_domain, "mp",  include_LOC = TRUE,
                               values_fn = values_funct))
  }


  if(!is.null(vs_domain)){
    data <- data %>%
      full_join(prepare_domain(vs_domain, "vs",
                               values_fn = values_funct))
  }

  if(!is.null(sa_domain)){
    data <- data %>%
      full_join(prepare_domain(sa_domain, "sa",
                               variables_include = c(
                                 "vomiting", "nausea", "fever",  "diarrhea",
                                 "abdominal pain", "jaundice", "bleeding",
                                 "anemia", "anorexia", "blood transfusion"),
                               values_fn = values_funct))
  }

  data <- data %>%
    remove_empty("cols")

  return(data)
}
