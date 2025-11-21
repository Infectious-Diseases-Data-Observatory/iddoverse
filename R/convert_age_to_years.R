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
#' # Display AGEU in YEARS
#' convert_age_to_years(DM_RPTESTB, remove_AGEU = FALSE)
#'
convert_age_to_years <- function(data, remove_AGEU = TRUE) {
  data <- data %>%
    mutate(AGEU = str_to_upper(.data$AGEU))

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

  if(remove_AGEU == TRUE){
    data <- data %>%
      select(-.data$AGEU) %>%
      rename("AGE_YEARS" = "AGE")
  }

  return(data)
}
