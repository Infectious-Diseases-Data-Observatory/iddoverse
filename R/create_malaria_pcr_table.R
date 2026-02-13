#' Create table of malaria specific PCR data
#'
#' Joins the pharmacogenomics genetics (PF) and disease response and clinical
#' classification (RS) IDDO-SDTM domains together to create a single dataset.
#'
#' @param pf_domain A pharmacogenomics genetics/PF domain data frame
#' @param rs_domain A disease response and clinical classification/RS domain
#'   data frame.
#' @param ds_domain A disposition/DS domain data frame
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
#' create_malaria_pcr_table(PF_RPTESTB, RS_RPTESTB)
#'
create_malaria_pcr_table <- function(pf_domain, rs_domain, ds_domain = NULL,
                                     values_funct = first){


  data_pf <- prepare_domain(pf_domain, "PF",  variables_include = "INTP",
                            values_fn = values_funct)


  data_rs <- prepare_domain(rs_domain, "RS", variables_include = "WHOMAL01",
                            values_fn = values_funct)

  data <- full_join(data_pf, data_rs)

  if(!is.null(ds_domain)){
    data_ds <- prepare_domain(ds_domain, "DS", values_fn = values_funct)

    data <- full_join(data, data_ds)
  }

  return(data)
}


