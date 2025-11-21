#' Convert AGE to years.
#'
#' Convert the AGE of all subjects to years and change the AGEU to "YEARS".
#'
#' @param data data frame containing the AGE and AGEU variables; typically the
#'   Demographics (DM) domain.
#'
#' @return data frame with AGE in years as opposed to the original values.
#'
#' @export
#'
#' @examples
#' DM_RPTESTB
#'
#' convert_age_to_years(DM_RPTESTB)
#'
convert_age_to_years <- function(data) {
  data <- data %>%
    mutate(AGEU = str_to_upper(.data$AGEU))

  if(nrow(data) == 0){
    # skip to end if empty
    # rlang::warn("Dataset is empty, returning input data")
  } else{
    if(!any(data$AGEU %in% c("DAYS", "WEEKS", "MONTHS", "YEARS"))){
      rlang::abort("There exists a non-standard AGEU (age units) which is not DAYS, WEEKS, MONTHS or YEARS. Convert this manually before using convert_age_to_years")
    }

    for (i in seq(1, nrow(data), 1)) {
      if (is.na(data$AGEU[i])) {
        next
      } else if (data$AGEU[i] == "DAYS") {
        data$AGE[i] <- data$AGE[i] / 365.25
        data$AGEU[i] <- "YEARS"
      } else if (data$AGEU[i] == "WEEKS") {
        data$AGE[i] <- data$AGE[i] / 52
        data$AGEU[i] <- "YEARS"
      } else if (data$AGEU[i] == "MONTHS") {
        data$AGE[i] <- data$AGE[i] / 12
        data$AGEU[i] <- "YEARS"
      } else {
        data$AGE[i] <- data$AGE[i]
        data$AGEU[i] <- "YEARS"
      }
    }

    data = data %>%
      select(-AGEU) %>%
      rename("AGE_YEARS" = "AGE")
  }

  return(data)
}
