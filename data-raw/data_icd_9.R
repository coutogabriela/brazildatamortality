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

data_dir <- "C:/Users/PGCST/Documents/Gabriela/SIM/DADOS_CID9_DBC"
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
        dplyr::filter(stringr::str_detect(CAUSABAS, "^(900.0|900.9|901.0|901.9|908|908.2|909.0|909.1|909.2|909.3|909.4|909.8|909.9)")) %>%
        return()
}


#---- Read data ----

# Check https://www.brodrigues.co/blog/2021-03-19-no_loops_tidyeval/
future::plan(multisession,
             workers = future::availableCores())
raw_data_tb_2 <- data_dir %>%
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

# falta birth (DATANASC)
# falta age (DATAOBITO - DATANASC)
# falta death_month (DATAOBITO apenas %m%)


data_icd_9 <- raw_data_tb %>%
    tidyr::unnest(data) %>%
    dplyr::mutate(date = lubridate::as_date(DATAOBITO, format = "%Y%m%d"), #Y são apenas 2 dígitos
                  death_year = lubridate::year(date),
#                 death_month = lubridate::month(date) %>%
#    dplyr::mutate(birth = lubridate::as_date(DATANASC, format = %Y%m%d)) %>%
#    dplyr::mutate(age = lubridate::as_date(death_year - birth)) %>%
                  code_cause = stringr::str_sub(CAUSABAS, 1, 3)) %>%
    dplyr::mutate(cause = dplyr::recode(code_cause,
                                        "909.0" = "Heat",         #"Accident caused by excessive Heat"
                                        "909.9" = "Heat",         #"Accident caused by excessive Heat"
                                        "901.0" = "Cold",         #"Accident caused by excessive Cold"
                                        "901.9" = "Cold",         #"Accident caused by excessive Cold"
                                        "908" = "Cataclismyc",    #"Accident caused by cataclysmic storms"
                                        "908.2" = "Floods",       #"Accident caused by floods"
                                        "909.0" = "Earthquake",   #"Accident caused by cataclysmic earth surface movement/Earthquakes"
                                        "909.1" = "Volcano",      #"Accident caused by volcanic eruption"
                                        "909.2" = "Landslides",   #"Accident caused by cataclysmic earth surface movement/Avalanche, landslides or mudslide"
                                        "909.3" = "Landslides",   #"Accident caused by cataclysmic earth surface movement/Collapse of man-made structure"
                                        "909.4" = "Earthquake",   #"Tidalwave cause by earthquake"
                                        "909.8" = "Other",        #"Other cataclysmic earth surface movement"
                                        "909.9" = "Other",        #"Unspecified cataclysmic earth surface movement"
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
                 literacy = dplyr::recode(INSTRUCAO,
                                    "O" = "Ignored",
                                    "1" = "None",
                                    "2" = "Primary",
                                    "3" = "Secondary",
                                    "4" = "Barchelor",
                                        .default = NA_character_)) %>%

dplyr::select(cause,
              sex,
              literacy,
              death_year,
              #death_month,
              #age
              marital,
              locus,
              job = OCUPACAO,
              city = MUNIRES,
              death_city = MUNIOCOR)

dplyr::select(-code_cause,
              -file.path,
              -date,
              -fetal,
              -date = DTOBITO,
              -cityzenship = NATURAL,
              -birth = DTNASC)


usethis::use_data(2_data_icd_9,
                      overwrite = TRUE)



# como rodar "death_city" - "MUNIOCOR" Municipio de ocorrencia/distribuição no território (dado disponivel no IBGE)
# como rodar "city" - "MUNIRES" - Municipio de residencia (dado disponivel no IBGE)
# como rodar "job" - "OCUPACAO" - Tabelas disponíveis para CID9  "TAB_OCUP.csv" e CID10 "TABOCUP.csv"




