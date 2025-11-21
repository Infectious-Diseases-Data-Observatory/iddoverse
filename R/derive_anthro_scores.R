#' Calculate WHO growth standards using the anthro() package.
#'
#' Calculates the Height for Age (HAZ), Weight for Age (WAZ) and Weight for
#' Height (WHZ) z-scores which are used to measure growth against the WHO
#' population standards. This is only for children less than 5 years old.
#'
#' The function can be applied to a dataset with subjects greater than 5 years
#' old too, but those subjects will be filtered out.
#'
#' @param data data frame that contains the AGE_YEARS, WEIGHT & HEIGHT
#'   variables, typically held in the Demographics (DM) and Vital Signs (VS)
#'   domains. Domains should have prepare_domain applied beforehand.
#'
#' @return data frame with only only 5 year olds included and additional columns
#'   for WAZ, HAZ and WHZ scores, along with flags for each.
#'
#' @export
#'
#' @importFrom anthro anthro_zscores
#'
#' @examples
#' # Merge the DM (AGE_YEARS, SEX) and VS (WEIGHT, HEIGHT) domains together
#' data = merge(
#'   prepare_domain("dm", DM_RPTESTB),
#'   prepare_domain("vs", VS_RPTESTB)
#'   )
#'
#' derive_anthro_scores(data)
#'
derive_anthro_scores <- function(data) {
  data_anthro <- data %>%
    mutate(AGE_DAYS = floor(.data$AGE_YEARS * 365.25)) %>%
    filter(.data$AGE_YEARS < 5 | AGE_DAYS < 1826)

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
      select(-AGE_DAYS)

    return(bind_anthro)
  }
}
