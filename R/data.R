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
#' \item{IDADEMAE}{MOTHER AGE)
#' \item{ESCMAE}{MOTHER EDUCATION}
#' \item{OCUPMAE}{MOTHER JOB}
#' \item{QTDFILVIVO}{N.CHILDREN}
#' \item{QTDFILMORT}{DELETE}
#' \item{GRAVIDEZ}{DELETE}
#' \item{GESTACAO}{DELETE}
#' \item{PARTO}{{DELETE}
#' \item{OBITOPARTO}{DELETE}
#' \item{PESO}{DELETE}
#' \item{OBITOGRAV}{DELETE}
#' \item{OBITOPUERP}{DELETE}
#' \item{ASSISTMED}{HEALTH CARE}
#' \item{EXAME}{DELETE}
#' \item{CIRURGIA}{DELETE}
#' \item{NECROPSIA}{DELETE}
#' \item{CAUSABAS}{CAUSE}
#' \item{LINHAA}{DELETE}
#' \item{LINHAB}{DELETE}
#' \item{LINHAC}{DELETE}
#' \item{LINHAD}{DELETE}
#' \item{LINHAII}{DELETE}
#' \item{CIRCOBITO}{DELETE}
#' \item{ACIDTRAB}{DELETE}
#' \item{FONTE}{SOURCE}
#' \item{date}{DELETE}
#' \item{CODESTAB}{DELETE}
#' \item{ATESTANTE}{DELETE}
#' \item{UFINFORM}{DELETE}
#' \item{HORAOBITO}{DELETE}
#' \item{CODBAIOCOR}{DELETE}
#' \item{NUMERODN}{DELETE}
#' \item{TPASSINA}{DELETE}
#' \item{DTATESTADO}{DELETE}
#' \item{TPPOS}{TODO:{DELETE}
#' \item{DTINVESTIG}{DELETE}
#' \item{CAUSABAS_O}{CAUSE}
#' \item{DTCADASTRO}{DELETE}
#' \item{FONTEINV}{DELETE}
#' \item{DTRECEBIM}{DELETE}
#' \item{CODINST}{DELETE}
#' \item{CB_PRE}{DELETE}
#' \item{MORTEPARTO}{DELETE}
#' \item{TPOBITOCOR}{DELETE}
#' \item{ORIGEM}{DELETE}
#' \item{DTCADINF}{DELETE}
#' \item{DTCADINV}{DELETE}
#' \item{NUMERODV}{DELETE}
#' \item{NUMSUS}{DELETE}
#' \item{COMUNSVOIM}{DELETE}
#' \item{DTRECORIG}{DELETE}
#' \item{DTRECORIGA}{DELETE}
#' \item{CAUSAMAT}{DELETE}
#' \item{ESC2010}{DELETE}
#' \item{ESCMAE2010}{DELETE}
#' \item{STDOEPIDEM}{DELETE}
#' \item{STDONOVA}{DELETE}
#' \item{CODMUNCART}{DELETE}
#' \item{CODCART}{DELETE}
#' \item{NUMREGCART}{DELETE}
#' \item{DTREGCART}{DELETE}
#' \item{SERIESCFAL}{DELETE}
#' \item{ESCMAEAGR1}{DELETE}
#' \item{ESCFALAGR1}{DELETE}
#' \item{SERIESCMAE}{DELETE}
#' \item{SEMAGESTAC}{DELETE}
#' \item{TPMORTEOCO}{DELETE}
#' \item{EXPDIFDATA}{DELETE}
#' \item{DIFDATA}{DELETE}
#' \item{DTCONINV}{DELETE}
#' \item{DTCONCASO}{DELETE}
#' \item{NUDIASOBIN}{DELETE}
#' \item{CODMUNNATU}{DELETE}
#' \item{ESTABDESCR}{DELETE}
#' \item{CRM}{DELETE}
#' \item{NUMEROLOTE}{DELETE}
#' \item{STCODIFICA}{DELETE}
#' \item{CODIFICADO}{DELETE}
#' \item{VERSAOSIST}{DELETE}
#' \item{VERSAOSCB}{DELETE}
#' \item{ATESTADO}{DELETE}
#' \item{NUDIASOBCO}{DELETE}
#' \item{FONTES}{DELETE}
#' \item{TPRESGINFO}{DELETE}
#' \item{TPNIVELINV}{DELETE}
#' \item{NUDIASINF}{DELETE}
#' \item{FONTESINF}{DELETE}
#' \item{ALTCAUSA}{DELETE}
#' \item{CONTADOR}{DELETE}
#' }
#' @source \url{http://www.TODO_update_url.info/}
"data_icd_10"
