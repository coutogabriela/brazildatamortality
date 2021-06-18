## Code to prepare `data_icd_9` dataset.

library(dplyr)
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

data_icd_9 <- raw_data_tb %>%
    tidyr::unnest(data) %>%
    dplyr::mutate(death_date = lubridate::as_date(DATAOBITO, format = "%y%m%d"),
                  birth_date = lubridate::as_date(DATANASC,  format = "%Y%m%d"),
                  code_cause = stringr::str_sub(CAUSABAS, 1, 3)) %>%
    dplyr::mutate(cause = dplyr::recode(code_cause,
                                        "9000" = "Heat",         #"Accident caused by excessive Heat"
                                        "9009" = "Heat",         #"Accident caused by excessive Heat"
                                        "9010" = "Cold",         #"Accident caused by excessive Cold"
                                        "9019" = "Cold",         #"Accident caused by excessive Cold"
                                        "908"  = "Cataclismyc",  #"Accident caused by cataclysmic storms"
                                        "908X" = "Storms",       # TODO: What is 908X?
                                        "9082" = "Floods",       #"Accident caused by floods"
                                        "909X" = "Earth surface movement", # TODO: What is 909X?
                                        "9090" = "Earthquake",   #"Accident caused by cataclysmic earth surface movement/Earthquakes"
                                        "9091" = "Volcano",      #"Accident caused by volcanic eruption"
                                        "9092" = "Landslides",   #"Accident caused by cataclysmic earth surface movement/Avalanche, landslides or mudslide"
                                        "9093" = "Landslides",   #"Accident caused by cataclysmic earth surface movement/Collapse of man-made structure"
                                        "9094" = "Earthquake",   #"Tidalwave cause by earthquake"
                                        "9098" = "Other",        #"Other cataclysmic earth surface movement"
                                        "9099" = "Other",        #"Unspecified cataclysmic earth surface movement"
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
                  literacy = dplyr::recode(INSTRUCAO,
                                           "O" = "Ignored",
                                           "1" = "None",
                                           "2" = "Primary",
                                           "3" = "Secondary",
                                           "4" = "Barchelor",
                                           .default = NA_character_)) %>%

    dplyr::select(birth_date,
                  cause,
                  city = MUNIRES,
                  #
                  death_city = MUNIOCOR,
                  death_date,
                  #
                  job = OCUPACAO,
                  literacy,
                  locus,
                  marital,
                  sex)

usethis::use_data(data_icd_9,
                  overwrite = TRUE)

# TODO: Get town codes from IBGE and add it to this package.
# TODO: Find if occupation is relevant to the analysis.
