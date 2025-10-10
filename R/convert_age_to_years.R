#' Convert AGE to years.
#'
#' Convert the AGE of all subjects to years and change the AGEU to
#'   "YEARS".
#'
#' @param data data frame containing the AGE and AGEU variables; typically the
#'   Demographics (DM) domain.
#'
#' @return data frame with AGE and AGEU in years as opposed to the original
#'   values.
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

  for (i in seq(1, nrow(data), 1)) {
    if (is.na(data$AGEU[i])) {
      next
    } else if (data$AGEU[i] == "DAYS") {
      data$AGE[i] <- floor(data$AGE[i] / 365.25)
      data$AGEU[i] <- "YEARS"
    } else if (data$AGEU[i] == "WEEKS") {
      data$AGE[i] <- floor(data$AGE[i] / 52)
      data$AGEU[i] <- "YEARS"
    } else if (data$AGEU[i] == "MONTHS") {
      data$AGE[i] <- floor(data$AGE[i] / 12)
      data$AGEU[i] <- "YEARS"
    } else {
      data$AGE[i] <- floor(data$AGE[i])
      data$AGEU[i] <- "YEARS"
    }
  }
  return(data)
}
