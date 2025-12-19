#' Perform data checks on IDDO-SDTM data
#'
#' Provides a variety of checks and summaries on IDDO-SDTM data including
#' summarising the number of rows by study ID (STUDYID), the number
#' of participants under 6 month, 18 years and over 90 years, and the number of
#' units used by each test (TESTCD) and study ID.
#'
#' @param data A dataset using IDDO-SDTM columns
#'
#' @returns A list with various summaries/checks, the number of which is
#' dependent on what variables are present in the input data. A plot is also
#' returned showing the missingness in each variable.
#'
#' @export
#'
#' @examples
#' check_data(DM_RPTESTB)
#'
#' check_data(LB_RPTESTB)
#'
check_data <- function(data, age_in_years = FALSE){
  studyid = data %>%
    count(STUDYID)

  return_list = list(studyid = studyid)

  if("SEX" %in% names(data)){
    sex = data.frame(
      table(data$SEX, useNA = "always")
    ) %>%
      rename("SEX" = "Var1",
             "n" = "Freq")

    return_list = append(return_list, list(sex = sex))
  }

  if("AGE" %in% names(data)){
    if(age_in_years == FALSE){
      data = data %>%
        convert_age_to_years() %>%  #-------- needs AGEU
        rename("AGE" = "AGE_YEARS")
    }

    age = tibble(
      n_USUBJID = length(unique(data$USUBJID)),
      AGE_min = min(data$AGE, na.rm = TRUE),
      AGE_max = max(data$AGE, na.rm = TRUE),
      n_missing_AGE = nrow(data[which(is.na(data$AGE)),"AGE"]),
      n_AGE_under_6M = nrow(data[which(as.numeric(data$AGE) < 0.5),"AGE"]),
      n_AGE_under_18Y = nrow(data[which(as.numeric(data$AGE) < 18),"AGE"]),
      n_AGE_over_90Y = nrow(data[which(as.numeric(data$AGE) > 90),"AGE"])
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
    if(all(!(str_detect(names(data), "MODIFY")))){
      testcd_data = testcd_data %>%
        mutate(MODIFY = NA)
    }

    names(testcd_data)[which(str_ends(names(testcd_data), "TESTCD"))] = "TESTCD"
    names(testcd_data)[which(str_ends(names(testcd_data), "LOC"))] = "LOC"
    names(testcd_data)[which(str_ends(names(testcd_data), "METHOD"))] = "METHOD"
    names(testcd_data)[which(str_ends(names(testcd_data), "SPEC"))] = "SPEC"
    names(testcd_data)[which(str_ends(names(testcd_data), "STRESC"))] = "STRESC"
    names(testcd_data)[which(str_ends(names(testcd_data), "STRESN"))] = "STRESN"
    names(testcd_data)[which(str_ends(names(testcd_data), "STRESU"))] = "STRESU"
    names(testcd_data)[which(str_ends(names(testcd_data), "MODIFY"))] = "MODIFY"
    names(testcd_data)[which(str_ends(names(testcd_data), "ORRES"))] = "ORRES"
    names(testcd_data)[which(str_ends(names(testcd_data), "ORRESU"))] = "ORRESU"

    testcd_data = testcd_data %>%
      convert_blanks_to_na() %>%
      mutate(RESULTS = as.character(STRESN),
             UNITS = as.character(STRESU))

    testcd_data[which(is.na(testcd_data$RESULTS)), "RESULTS"] =
      as.character(testcd_data[which(is.na(testcd_data$RESULTS)), "STRESC"])

    modify_index = which(is.na(testcd_data$RESULTS))

    testcd_data[modify_index, "RESULTS"] =
      as.character(testcd_data[modify_index, "MODIFY"])

    orres_index = which(is.na(testcd_data$RESULTS))

    testcd_data[orres_index, "RESULTS"] =
      as.character(testcd_data[orres_index, "ORRES"])

    testcd_data[modify_index, "UNITS"] <-
      as.character(testcd_data[modify_index, "ORRESU"])

    suppressWarnings({
      testcd = testcd_data %>%
        group_by(STUDYID, TESTCD) %>%
        summarise(min = min(as.numeric(RESULTS), na.rm = TRUE),
                  q5 = quantile(as.numeric(RESULTS), na.rm = TRUE, probs = 0.05),
                  q25 = quantile(as.numeric(RESULTS), na.rm = TRUE, probs = 0.25),
                  q50 = quantile(as.numeric(RESULTS), na.rm = TRUE, probs = 0.5),
                  q75 = quantile(as.numeric(RESULTS), na.rm = TRUE, probs = 0.75),
                  q95 = quantile(as.numeric(RESULTS), na.rm = TRUE, probs = 0.95),
                  max = max(as.numeric(RESULTS), na.rm = TRUE),
                  n_UNITS = length(na.omit(unique(UNITS))),
                  UNITS = str_flatten(na.omit(unique(UNITS)), collapse = ", "),
                  n_LOC = length(na.omit(unique(LOC))),
                  LOC = str_flatten(na.omit(unique(LOC)), collapse = ", "),
                  n_METHOD = length(na.omit(unique(METHOD))),
                  METHOD = str_flatten(na.omit(unique(METHOD)), collapse = ", "),
                  n_SPEC = length(na.omit(unique(SPEC))),
                  SPEC = str_flatten(na.omit(unique(SPEC)), collapse = ", ")) %>%
        ungroup()
    })

    testcd[which(is.infinite(testcd$min)), "min"] = NA
    testcd[which(is.infinite(testcd$max)), "max"] = NA

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
    geom_segment(mapping = aes(y = 0, yend = proportion_missing), colour = "#14B1E7",
                 linewidth = 1.2) +
    geom_point(colour = "#E31B23", size = 3) +
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
