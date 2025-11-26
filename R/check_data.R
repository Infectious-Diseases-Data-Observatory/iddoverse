check_data <- function(data){
  studyid = data %>%
    count(STUDYID)

  return_list = list(studyid = studyid)

  if("AGE" %in% names(data)){
    data = data %>%
      convert_age_to_years() %>%  #-------- needs AGEU
      rename("AGE" = "AGE_YEARS")

    age = tibble(
      n_USUBJID = length(unique(data$USUBJID)),
      AGE_min = min(data$AGE, na.rm = TRUE),
      AGE_max = max(data$AGE, na.rm = TRUE),
      n_missing_AGE = nrow(data[which(is.na(data$AGE)),"AGE"]),
      n_AGE_under_18 = nrow(data[which(as.numeric(data$AGE) < 18),"AGE"]),
      n_AGE_over_90 = nrow(data[which(as.numeric(data$AGE) > 90),"AGE"])
    )

    return_list = append(return_list, list(age = age))
  }

  if(any(str_detect(names(data), "TESTCD"))){
    testcd_data = data

    if(all(!(str_detect(names(data), "LOC")))){
      testcd_data = testcd_data %>%
        mutate(LOC = NA)
    }
    if(all(!(str_detect(names(data), "METHOD")))){
      testcd_data = testcd_data %>%
        mutate(METHOD = NA)
    }
    if(all(!(str_detect(names(data), "SPEC")))){
      testcd_data = testcd_data %>%
        mutate(SPEC = NA)
    }

    names(testcd_data)[which(str_detect(names(testcd_data), "TESTCD"))] = "TESTCD"
    names(testcd_data)[which(str_detect(names(testcd_data), "LOC"))] = "LOC"
    names(testcd_data)[which(str_detect(names(testcd_data), "METHOD"))] = "METHOD"
    names(testcd_data)[which(str_detect(names(testcd_data), "SPEC"))] = "SPEC"
    names(testcd_data)[which(str_detect(names(testcd_data), "STRESC"))] = "STRESC"
    names(testcd_data)[which(str_detect(names(testcd_data), "STRESN"))] = "STRESN"
    names(testcd_data)[which(str_detect(names(testcd_data), "STRESU"))] = "STRESU"

    ## --------- almagamate data orres, modify ---------------------------

    testcd = testcd_data %>%
      group_by(STUDYID, TESTCD) %>%
      summarise(min = min(STRESN, na.rm = TRUE),
                max = max(STRESN, na.rm = TRUE),
                n_levels = length(na.omit(unique(STRESC))),
                n_UNITS = length(na.omit(unique(STRESU))),
                UNITS = str_flatten(na.omit(unique(STRESU)), collapse = ", "),
                n_LOC = length(na.omit(unique(LOC))),
                LOC = str_flatten(unique(LOC), collapse = ", "),
                n_METHOD = length(na.omit(unique(METHOD))),
                METHOD = str_flatten(unique(METHOD), collapse = ", "),
                n_SPEC = length(na.omit(unique(SPEC))),
                SPEC = str_flatten(unique(SPEC), collapse = ", ")) %>%
      ungroup()

    #---- suppress/replace warning msg when inf??

    return_list = append(return_list, list(testcd= testcd))

    if(any(testcd_data$TESTCD == "INTP")){ ## add other outcomes for DS, RS -----------
      outcome_data = testcd_data %>%
        filter(TESTCD == "INTP",
               VISITDY < 7 | EPOCH == "BASELINE")

      outcome = outcome_data %>%
        count(STUDYID) %>%
        rename("n_PF_INTP_<VISITDY_7" = "n")

      return_list = append(return_list, list(outcome = outcome))
    }
  }

  missingness = sapply(data, function(x) filter(data, is.na(x)) %>% nrow()/nrow(data)) %>%
    round(3)

  missingness_table = tibble(
    column = names(data),
    proportion_missing = missingness
    )

  missingness_plot = ggplot(
    missingness_table, aes(x = reorder(column, -proportion_missing), y = proportion_missing)
    ) +
    geom_point(colour = "#E31B23") +
    geom_segment(mapping = aes(y = 0, yend = proportion_missing), colour = "#14B1E7") +
    theme_minimal() +
    labs(x = "Column", y = "Proportion of Column Missing") +
    coord_flip() +
    scale_x_discrete(limits = rev) +
    geom_text(mapping = aes(label = column, y = proportion_missing + 0.08),
              size = 3.5, colour = "#435C6D") +
    theme(axis.text.y = element_blank(),
          axis.text.x = element_text(colour = "#435C6D"),
          axis.title = element_text(colour = "#435C6D")) +
    ggplot2::scale_y_continuous(breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1.0))

  print(missingness_plot)

  return_list = append(return_list, list(missingness = missingness))

  return(return_list)
}
