create_labs_table <- function(lb_domain,
                              variables = c("ALB", "ALT", "AST", "BILI", "CREAT",
                                            "CD4", "G6PD", "HCT", "HGB", "HGBMET",
                                            "INTLK6", "K", "PLAT", "SODIUM", "WBC"),
                              include_method = FALSE,
                              timing_variables = c(
                                "LBHR", "LBDY", "LBSTDY", "VISITDY", "VISITNUM",
                                "VISIT", "EPOCH", "LBEVLINT", "LBEVINTX"),
                              values_funct = first){

  prepare_domain("LB", lb_domain,
                 include_METHOD = include_method,
                 variables_include = variables,
                 timing_variables = timing_variables,
                 values_fn = values_funct)
}

