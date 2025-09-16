#' Create table of malaria specific PCR data
#'
#' Joins the pharmacogenomics genetics (PF) and disease response and clinical
#' classification (RS)  IDDO-SDTM domains together to create a single data
#'
#' @param pf_domain The name of the pharmacogenomics genetics (PF) domain in the
#'   global environment.
#' @param rs_domain The name of the disease response and clinical classification
#'   (RS) domain in the global environment.
#'
#' @returns An analysis dataset, one row per person, per timepoint.
#'
#' @export
#'
create_malaria_pcr_table <- function(pf_domain, rs_domain){
  full_join(
    prepare_domain("PF", pf_domain, variables_include = "INTP"),
    prepare_domain("RS", rs_domain, variables_include = "WHOMAL01")
  )
}


