#' Tabulate function to display variables in a given domain
#'
#' Uses table() to display the variables contained within an SDTM
#' formatted data frame. Additionally can be split by STUDYID to display the
#' options across multiple studies.
#'
#' @param domain Character. The two letter code for the domain which matches the data.
#'   Character string. Domains included: "DM", "LB", "RP", "MB", "MP", "SA",
#'   "IN", "VS", "DS", "RS", "PO", "SC", "HO", "ER" & "DD".
#' @param data Domain data frame.
#' @param by_STUDYID Boolean. Split data by STUDYID if TRUE. Default is FALSE.
#'
#' @return For Demographics (DM) domain, a character list with the column names.
#'   For all other domains, a table class object listing the variables under
#'   --TESTCD or INTRT, MPLOC, DSDECOD; where -- is the two letter domain name.
#'
#' @export
#'
#' @examples
#' table_variables("LB", LB_RPTESTB)
#'
#' table_variables("VS", VS_RPTESTB, by_STUDYID = TRUE)
#'
table_variables <- function(domain, data, by_STUDYID = FALSE) {
  domain <- str_to_upper(domain)

  if (by_STUDYID == FALSE) {
    if (domain == "DM") {
      return(colnames(data))
    } else if (domain == "LB") {
      return(table(data$LBTESTCD, useNA = "ifany"))
    } else if (domain == "RP") {
      return(table(data$RPTESTCD, useNA = "ifany"))
    } else if (domain == "MB") {
      return(table(data$MBTESTCD, useNA = "ifany"))
    } else if (domain == "MP") {
      return(table(data$MPLOC, useNA = "ifany"))
    } else if (domain == "SA") {
      return(table(str_to_upper(data$SATERM), useNA = "ifany"))  ###
    } else if (domain == "IN") {
      return(table(str_to_upper(data$INTRT), useNA = "ifany"))   ###
    } else if (domain == "VS") {
      return(table(data$VSTESTCD, useNA = "ifany"))
    } else if (domain == "DS") {
      return(table(data$DSDECOD, useNA = "ifany"))               ###
    } else if (domain == "RS") {
      return(table(data$RSTESTCD, useNA = "ifany"))
    } else if (domain == "PO") {
      return(table(str_to_upper(data$POTERM), useNA = "ifany"))  ###
    } else if (domain == "SC") {
      return(table(data$SCTESTCD, useNA = "ifany"))
    } else if (domain == "HO") {
      return(table(data$HOTERM, useNA = "ifany"))                ###
    } else if (domain == "ER") {
      return(table(data$ERTERM, useNA = "ifany"))                ###
    } else if (domain == "DD") {
      return(table(data$DDTEST, useNA = "ifany"))
    }
  } else {
    if (domain == "DM") {
      return(colnames(data))
    } else if (domain == "LB") {
      return(table(data$STUDYID, data$LBTESTCD, useNA = "ifany"))
    } else if (domain == "RP") {
      return(table(data$STUDYID, data$RPTESTCD, useNA = "ifany"))
    } else if (domain == "MB") {
      return(table(data$STUDYID, data$MBTESTCD, useNA = "ifany"))
    } else if (domain == "MP") {
      return(table(data$STUDYID, data$MPLOC, useNA = "ifany"))
    } else if (domain == "SA") {
      return(table(data$STUDYID, str_to_upper(data$SATERM), useNA = "ifany"))
    } else if (domain == "IN") {
      return(table(data$STUDYID, str_to_upper(data$INTRT), useNA = "ifany"))
    } else if (domain == "VS") {
      return(table(data$STUDYID, data$VSTESTCD, useNA = "ifany"))
    } else if (domain == "DS") {
      return(table(data$STUDYID, data$DSDECOD, useNA = "ifany"))
    } else if (domain == "RS") {
      return(table(data$STUDYID, data$RSTESTCD, useNA = "ifany"))
    } else if (domain == "PO") {
      return(table(data$STUDYID, str_to_upper(data$POTERM), useNA = "ifany"))
    } else if (domain == "SC") {
      return(table(data$STUDYID, data$SCTESTCD, useNA = "ifany"))
    } else if (domain == "HO") {
      return(table(data$HOTERM, useNA = "ifany"))                ###
    } else if (domain == "ER") {
      return(table(data$ERTERM, useNA = "ifany"))                ###
    } else if (domain == "DD") {
      return(table(data$DDTEST, useNA = "ifany"))
    }
  }
}
