## Code to prepare `data_icd_10` dataset.

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
data_dir <- "~/Documents/github/brazildatamortality/inst/extdata/SIM/DADOS_CID10"


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
    dplyr::filter(stringr::str_detect(CAUSABAS, "X3")) %>%
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

data_icd_10 <- raw_data_tb %>%
  tidyr::unnest(data) %>%
  dplyr::mutate(date = lubridate::as_date(DTOBITO, format = "%d%m%Y"),
                death_year = lubridate::year(date),
                code_cause = stringr::str_sub(CAUSABAS, 1, 3)) %>%
  dplyr::mutate(Cause = dplyr::recode(code_cause,
                                      "X30" = "Heat",       #"Exposição a calor natural excessivo",
                                      "X31" = "Cold",       #"Exposição a frio natural excessivo",
                                      "X32" = "Sunlight",   #"Exposição à luz solar",
                                      "X33" = "Lightning",  #"Vítima de raio",
                                      "X34" = "Earthquake", #"Vítima de terremoto",
                                      "X35" = "Volcano",    #"Vítima de erupção vulcânica",
                                      "X36" = "Landslide",  #"Vítima de avalanche, desabamento de terra e outros movimentos da superfície terrestre",
                                      "X37" = "Tempest",    #"Vítima de tempestade cataclísmica",
                                      "X38" = "Flood",      #"Vítima de inundação",
                                      "X39" = "Other",      #"Exposição a outras forças da natureza e às não especificadas"
                                      .default = NA_character_),
                Sex = dplyr::recode(SEXO,
                                    "0" = "No information",
                                    "1" = "Male",
                                    "2" = "Female",
                                    .default = NA_character_),
                Education = dplyr::recode(ESC,
                                          # TODO: Check against https://en.wikipedia.org/wiki/International_Standard_Classification_of_Education
                                          "0" = "None",                  # "Sem escolaridade",
                                          "1" = "Primary",               # "Fundamental I (1ª a 4ª série)",
                                          "2" = "Lower secondary",       # "Fundamental II (5ª a 8ª série)",
                                          "3" = "Upper secondary",       # "Médio (antigo 2º Grau)",
                                          "4" = "Bachelor (incomplete)", # "Superior incompleto",
                                          "5" = "Bachelor",              # "Superior completo",
                                          "9" = "Ignored",               # "Ignorado",
                                          .default = NA_character_)) %>%
  # Remove the unused variables.
  # TODO: Rename these variables to English.
  dplyr::select(Cause, Sex, Education, death_year,
                code_cause,
                file_path,
                NUMERODO,
                TIPOBITO,
                DTOBITO,
                NATURAL,
                DTNASC,
                IDADE,
                SEXO,
                RACACOR,
                ESTCIV,
                ESC,
                OCUP,
                # TODO: What is this variable? Why is not in the raw data?
                #CODBAIRES,
                CODMUNRES,
                LOCOCOR,
                CODMUNOCOR,
                IDADEMAE,
                ESCMAE,
                OCUPMAE,
                QTDFILVIVO,
                CAUSABAS,
                FONTE,
                CAUSABAS_O)

usethis::use_data(data_icd_10,
                  overwrite = TRUE)
