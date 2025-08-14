create_malaria_pcr_table <- function(pf_domain, rs_domain){
  full_join(
    prepare_domain("PF", pf_domain, variables_include = "INTP"),
    prepare_domain("rs", rs_domain, variables_include = "WHOMAL01")
  )
}


