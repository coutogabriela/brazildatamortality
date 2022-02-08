#' Deaths due to natural events in Brazil from 1996 to 2019.
#'
#' A dataset containing information of causes of death caused by exposure to
#' forces of nature from 1996 to 2019. This data is based on death certificates
#' that capture more than 50 variables. Original source: World Health
#' Organization - International Statistic Classification of Diseases and Related
#' Health Problems 10th revision ICD10.
#'
#' @format A data frame with XXXX rows and 12 variables:
#' \describe{
#'   \item{age_unit}{Units of age}
#'   \item{age_value}{Age}
#'   \item{birth_date}{Date of birth}
#'   \item{cause}{Cause of death}
#'   \item{residence_city}{Code of the city of residence}
#'   \item{color_race}{Skin color or ethnicity}
#'   \item{death_city}{Code of the city of death}
#'   \item{death_date}{Date of the death}
#'   \item{education}{Education level}
#'   \item{job}{Code of profession}
#'   \item{literacy}{Number of years of education}
#'   \item{locus}{Place of death}
#'   \item{marital}{Marital status}
#'   \item{sex}{Sex}
#' }
#' @source \url{http://www.diamondse.info/}
"data_icd_10"



#' Deaths due to natural events in Brazil from XXXX to 1995.
#'
#' TODO: Add description.
#'
#' @format A data frame with XXXX rows and 10 variables:
#' \describe{
#'   \item{age_unit}{Units of age}
#'   \item{age_value}{Age}
#'   \item{birth_date}{Data of birth}
#'   \item{cause}{Cause of death}
#'   \item{residence_city}{Code of the city of residence}
#'   \item{death_city}{Code of the city of death}
#'   \item{death_date}{Date of the death. If the day of the month is unavailable, it is assumed the first day of the month}
#'   \item{education}{Education level}
#'   \item{job}{Code of profession}
#'   \item{locus}{Place of death}
#'   \item{marital}{Marital status}
#'   \item{sex}{Sex}
#' }
#' @source \url{http://www.diamondse.info/}
"data_icd_9"



#' States of Brazil as sf simple features.
#'
#' Spatial limits of the Brazilian states in 2010 (simplified). These data was
#' obtained from the package geobr. For more detail see \url{https://github.com/ipeaGIT/geobr}.
#'
#' @format A data frame with 27 rows and 6 variables:
#' \describe{
#'   \item{code_state}{Code of the state}
#'   \item{abbrev_state}{Abbreviated name of the state}
#'   \item{name_state}{Name of the state}
#'   \item{code_region}{Code of the state's region}
#'   \item{name_region}{Name of the state's region}
#'   \item{geom}{Geometry}
#' }
#' @source \url{http://www.diamondse.info/}
"state_sf"



#' Hexagonal representation of the states of Brazil.
#'
#' Brazilian states (see state_sf) represented as hexagons using simple
#' features.
#'
#' @format A data frame with 27 rows and 6 variables:
#' \describe{
#'   \item{code_state}{Code of the state}
#'   \item{abbrev_state}{Abbreviated name of the state}
#'   \item{name_state}{Name of the state}
#'   \item{code_region}{Code of the state's region}
#'   \item{name_region}{Name of the state's region}
#'   \item{geometry}{Geometry}
#' }
#' @source \url{http://www.diamondse.info/}
"state_hex"



#' Towns of Brazil as sf simple features.
#'
#' Spatial limits of the Brazilian towns in 2010 (simplified). These data was
#' obtained from the package geobr. For more detail see \url{https://github.com/ipeaGIT/geobr}.
#'
#' @format A data frame with 5567 rows and 9 variables:
#' \describe{
#'   \item{code_muni}{Code of the municipality}
#'   \item{name_muni}{Name of the municipality}
#'   \item{code_state}{Code of the sate}
#'   \item{abbrev_state}{Abbreviated name of the state}
#'   \item{code_meso}{Code of the meso-region}
#'   \item{name_meso}{Name of the meso-region}
#'   \item{code_micro}{Code of the micro-region}
#'   \item{name_micro}{Name of the micro-region}
#'   \item{name_state}{Name of the state}
#'   \item{code_region}{Code of the region}
#'   \item{name_region}{Name of the region}
#'   \item{geom}{Geometry}
#' }
#' @source \url{http://www.diamondse.info/}
"town_sf"
