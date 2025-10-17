#' Calculate WHO growth standards using the anthro() package.
#'
#' Calculates the Height for Age (HAZ), Weight for Age (WAZ) and Weight for
#' Height (WHZ) z-scores which are used to measure growth against the WHO
#' population standards. This is only for children less than 5 years old.
#'
#' The function can be applied to a dataset with subjects greater than 5 years
#' old too, but those subjects will be filtered out.
#'
#' @param data data frame that contains the AGE, AGEU, WEIGHT & HEIGHT
#'   variables, typically held in the Demographics (DM) and Vital Signs (VS)
#'   domains.
#'
#' @return data frame with only only 5 year olds included and additional columns
#'   for WAZ, HAZ and WHZ scores, along with flags for each.
#'
#' @export
#'
#' @importFrom anthro anthro_zscores
#'
#' @examples
#' data = full_join(
#'   prepare_domain("dm", DM_RPTESTB),
#'   full_join(prepare_domain("vs", VS_RPTESTB)
#'   )
#'
#' derive_anthro_scores(data)
#'
#'
derive_anthro_scores <- function(data) {
  data <- data %>%
    mutate(
      AGEU = str_to_upper(.data$AGEU),
      AGE_DAYS = NA
    )

  for (i in seq(1, nrow(data), 1)) {
    if (is.na(data$AGEU[i])) {
      next
    } else if (data$AGEU[i] == "DAYS") {
      data$AGE_DAYS[i] <- floor(data$AGE[i])
    } else if (data$AGEU[i] == "WEEKS") {
      data$AGE_DAYS[i] <- floor(data$AGE[i] * 7)
    } else if (data$AGEU[i] == "MONTHS") {
      data$AGE_DAYS[i] <- floor(data$AGE[i] * 30.417)
    } else if (data$AGEU[i] == "YEARS") {
      data$AGE_DAYS[i] <- floor(data$AGE[i] * 365.25)
    }
  }

  data_anthro <- data %>%
    filter(data$AGE < 5 | data$AGE_DAYS < 1826)

  if (nrow(data_anthro) == 0) {
    return(data_anthro)
  } else {
    bind_anthro <- cbind(
      data_anthro,
      anthro_zscores(
        sex = data_anthro$SEX,
        age = as.numeric(data_anthro$AGE_DAYS),
        weight = as.numeric(data_anthro$WEIGHT_kg),
        lenhei = as.numeric(data_anthro$HEIGHT_cm)
      ) %>%
        dplyr::select(
          "zlen", "flen", "zwei",
          "fwei", "zwfl", "fwfl"
        )
    ) %>%
      rename(
        "HAZ" = "zlen",
        "HAZ_FLAG" = "flen",
        "WAZ" = "zwei",
        "WAZ_FLAG" = "fwei",
        "WHZ" = "zwfl",
        "WHZ_FLAG" = "fwfl"
      ) %>%
      select(-.data$AGE_DAYS)

    return(bind_anthro)
  }
}
