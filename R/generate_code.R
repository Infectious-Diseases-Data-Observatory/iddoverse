generate_code <- function(data){
  domain = str_to_upper(readline("What domain is your data? (i.e. DM, LB):  "))

  code = str_c("prepare_domain('", domain, "', ", deparse(substitute(data)))

  method = readline(str_c("Do you want ", domain, "METHOD included in the output dataset? Yes or No:  "))

  loc = readline(str_c("Do you want ", domain, "LOC included in the output dataset? Yes or No:  "))

  if(str_to_upper(method) == "YES"){
    code = str_c(code, ", include_METHOD = TRUE")
  }

  if(str_to_upper(loc) == "YES"){
    code = str_c(code, ", include_LOC = TRUE")
  }

  print("You can use table_variables() to check the available variables in the data.")
  print("If you require all available variables, then leave this blank and press enter.")

  variables = readline("List the variables you want in the output dataset; seperate them with a comma (,):  ")

  if(variables != ""){
    code = str_c(code, ", variables_include = c(", variables, ")")  # (variables %>% strsplit(","))[[1]]
  }

  code = str_c(code, ")")

  print(code)
}
