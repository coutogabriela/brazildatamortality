## Code to prepare `data_icd_9` dataset.

library(dplyr)
library(ensurer)
library(furrr)
library(future)
library(ggplot2)
library(lubridate)
library(purrr)
library(read.dbc)
library(rlang)
library(skimr)
library(stringr)
library(usethis)

# Path to a data directory of mortality data from:
# Ministerio da saude do Brasil.
# Sistema de Informação sobre Mortalidade (SIM).

#data_dir <- "C:/Users/PGCST/Documents/Gabriela/SIM/DADOS_CID9_DBC"
data_dir <- "./inst/extdata/SIM/DADOS_CID9/Rio_de_Janeiro"
stopifnot(dir.exists(data_dir))


#---- Helper functions ----

# Helper function. Read, filter, and format a file of raw data.
#
# @param x A quosure that reads a file into a data.frame.
# @return  A tibble.
process_data <- function(x) {
     x <- rlang::eval_tidy(x)
     x %>%
         tibble::as_tibble() %>%
         # NOTE: Filter deaths by natural causes.
         dplyr::filter(stringr::str_detect(CAUSABAS, "^90")) %>%
         return()
}



#---- Read data ----

# Check https://www.brodrigues.co/blog/2021-03-19-no_loops_tidyeval/
future::plan(multisession,
             workers = future::availableCores())
raw_data_tb <- data_dir %>%
    list.files(pattern = ".*[.](dbc|DBC)",
               full.names = TRUE,
               recursive = TRUE) %>%
    tibble::tibble() %>%
    dplyr::rename(file_path = ".") %>%
    dplyr::mutate(raw_data = purrr::map(file_path,
                                        ~rlang::quo(read.dbc::read.dbc(.,
                                                            as.is = TRUE)))) %>%
    dplyr::mutate(data = furrr::future_map(raw_data, process_data))



#---- Recode variables ----

valid_interval <- list(
    lubridate::as_date("700101", format = "%y%m%d"),
    lubridate::as_date("991231", format = "%y%m%d")
)

data_icd_9 <- raw_data_tb %>%
    tidyr::unnest(data) %>%
    dplyr::mutate(len_dataobito = stringr::str_length(DATAOBITO)) %>%
    dplyr::filter(len_dataobito >= 4) %>%
    dplyr::select(-len_dataobito) %>%
    # NOTE: Dates with only year & month are assigned to the month's first day.
    dplyr::mutate(DATAOBITO = if_else(stringr::str_length(DATAOBITO) == 4,
                                     paste0(DATAOBITO, "01"),
                                     DATAOBITO)) %>%
    # NOTE: Dates with day 00 are assigned to the month's first day.
    dplyr::mutate(DATAOBITO = if_else(
        stringr::str_sub(DATAOBITO, 5, 6) == "00",
        paste0(stringr::str_sub(DATAOBITO, 1, 4), "01"),
        DATAOBITO)
    ) %>%
    ensurer::ensure_that(all(stringr::str_length(.$DATAOBITO) == 6),
                         err_desc = "Invalid number of digits in DATAOBITO") %>%
    dplyr::mutate(
        death_date = lubridate::as_date(DATAOBITO, format = "%y%m%d"),
        birth_date = lubridate::as_date(DATANASC,  format = "%Y%m%d"),
        code_cause = stringr::str_sub(CAUSABAS, 1, 3)
    ) %>%
    tidyr::drop_na(death_date) %>%
    ensurer::ensure_that(all(.$death_date >= valid_interval[[1]]),
                         all(.$death_date <= valid_interval[[2]]),
                         err_desc = "Death dates out of valid interval") %>%
    dplyr::mutate(cause = dplyr::recode(code_cause,
                                        #"Accident caused by excessive Heat" "X30"
                                        "900" = "Heat",
                                        #"Accident caused by excessive Cold" "X31"
                                        "901" = "Cold",
                                        #"Accident caused by lightning" "X33"
                                        "907" = "Lightning",
                                        #"Accident caused due to cataclysmic storms" "X37 e X38"
                                        "908"  = "Cataclismyc and Floods",
                                        #"Accident caused due to earth surface movement" "X34, X35 e X36"
                                        "909" = "Earth surface movement and Eruption",
                                        .default = NA_character_),
                  sex = dplyr::recode(SEXO,
                                      "0" = "No information",
                                      "1" = "Male",
                                      "2" = "Female",
                                      .default = NA_character_),
                  marital = dplyr::recode(ESTCIVIL,
                                          "0" = "No information",
                                          "1" = "Single",
                                          "2" = "Married",
                                          "3" = "Widow",
                                          "4" = "Separated",
                                          "5" = "Other",
                                          .default = NA_character_),
                  locus = dplyr::recode(LOCOCOR,
                                        "0" = "No information",
                                        "1" = "Hospital",
                                        "2" = "Street",
                                        "3" = "Home",
                                        "4" = "Other",
                                        .default = NA_character_),
                  # TODO: Review using the international reference https://en.wikipedia.org/wiki/International_Standard_Classification_of_Education#ISCED_2011_levels_of_education_and_comparison_with_ISCED_1997
                  education = dplyr::recode(INSTRUCAO,
                                            "O" = "Ignored",
                                            "1" = "None",
                                            "2" = "Primary",
                                            "3" = "Secondary",
                                            "4" = "Barchelor",
                                            .default = NA_character_)) %>%
    tidyr::separate(IDADE, into = c("age_unit", "age_value"), sep = 1) %>%
    dplyr::mutate(age_unit = dplyr::recode(age_unit,
                                           "0" = "Ignored",
                                           "1" = "Hours",
                                           "2" = "Days",
                                           "3" = "Months",
                                           "4" = "Years",
                                           "5" = "> 100 years",
                                           .default = NA_character_,
                                           .missing = NA_character_)) %>%
    dplyr::select(birth_date,
                  cause,
                  residence_city = MUNIRES,
                  #
                  death_city = MUNIOCOR,
                  death_date,
                  education,
                  job = OCUPACAO,
                  #
                  locus,
                  marital,
                  sex,
                  age_unit,
                  age_value)

usethis::use_data(data_icd_9,
                  overwrite = TRUE)

# TODO: Get town codes from IBGE and add it to this package.
# TODO: Find if occupation is relevant to the analysis.
