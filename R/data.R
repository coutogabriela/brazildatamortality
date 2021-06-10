#'
#'
#' Original source:
#' World Health Organization
#' International Statistic Classification of Diseases and Related Health Problems 10th revision
#' ICD10
#'
#' Based on death certificate that captures more than 50 variables as:
#' entity and municipality of registry,
#' entity,
#' municipality and locality of habitual residence;
#' entity, municipality and locality of occurrence of death; sex, age, occupation, schooling, conjugal status, among others
#'
#' Deaths due to natural events in Brazil from 1996 to 2019.
#'
#' A dataset containing information of causes of death those caused by exposure to forces of nature
#' CID10 from 1996 to 2019
#'
#'
#' @format A data frame with 5862 rows and 105 variables:
#' \describe{
#' \item{Cause}{Cause of death.}
#' \item{Sex}{Sex.}
#' \item{Education}{Education level.}
#' \item{death_year}{Year of the death.}
#' \item{code_cause}{Identifier of the cause of death.}
#' \item{file_path}{Path to the file from which the data is comming from.}
#' \item{NUMERODO}{DEATH CERTIFICATE NUMBER}
#' \item{TIPOBITO}{FETAL}
#' \item{DTOBITO}{DATE}
#' \item{NATURAL}{CITIZENSHIP}
#' \item{DTNASC}{BIRTH}
#' \item{IDADE}{AGE}
#' \item{SEXO}{SEX}
#' \item{RACACOR}{RACE}
#' \item{ESTCIV}{MARITAL}
#' \item{ESC}{EDUCATION}
#' \item{OCUP}{JOB}
#' \item{CODBAIRES}{NEIGHBOURHOOD}
#' \item{CODMUNRES}{CITY}
#' \item{LOCOCOR}{DEATH PLACE}
#' \item{CODMUNOCOR}{CITY CODE}
#' \item{IDADEMAE}{MOTHER AGE}
#' \item{ESCMAE}{MOTHER EDUCATION}
#' \item{OCUPMAE}{MOTHER JOB}
#' \item{QTDFILVIVO}{N.CHILDREN}
#' \item{ASSISTMED}{HEALTH CARE}
#' \item{CAUSABAS}{CAUSE}
#' \item{FONTE}{SOURCE}
#' \item{CAUSABAS_O}{CAUSE}
#' }
#' @source \url{http://www.TODO_update_url.info/}
"data_icd_10"
