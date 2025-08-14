create_malaria_parasitemia_table <- function(mb_domain,
                                             variables = c(
                                               "PFALCIPA", "PFALCIPS", "PFALCIP",
                                               "PVIVAXA", "PVIVAXS", "PVIVAX"),
                                             include_method = FALSE,
                                             include_location = FALSE,
                                             timing_variables = c(
                                               "MBHR", "MBDY", "MBSTDY", "VISITDY", "VISITNUM",
                                               "VISIT", "EPOCH", "MBEVLINT", "MBEVINTX"),
                                             values_funct = first){

  prepare_domain("mb", mb_domain,
                 include_METHOD = include_method,
                 include_LOC = include_location,
                 variables_include = variables,
                 timing_variables = timing_variables,
                 values_fn = values_funct)
}
