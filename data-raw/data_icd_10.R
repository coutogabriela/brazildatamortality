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

#data_dir <- "C:/Users/PGCST/Documents/Gabriela/SIM/DADOS_CID10_DBC"
data_dir <- "./inst/extdata/SIM/DADOS_CID10/Rio_de_Janeiro"
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
    dplyr::mutate(death_date = lubridate::as_date(DTOBITO, format = "%d%m%Y"),
                  birth_date = lubridate::as_date(DTNASC, format = "%d%m%Y"),
                  death_year = lubridate::year(death_date),
                  code_cause = stringr::str_sub(CAUSABAS, 1, 3)) %>%
    dplyr::mutate(cause = dplyr::recode(code_cause,
                                        "X30" = "Heat",
                                        "X31" = "Cold",
                                        "X32" = "Sunlight",
                                        "X33" = "Lightning",
                                        "X34" = "Earthquake",
                                        "X35" = "Volcano",
                                        "X36" = "Landslide",
                                        "X37" = "Cataclismyc",
                                        "X38" = "Flood",
                                        "X39" = "Other",
                                        .default = NA_character_),
                  sex = dplyr::recode(SEXO,
                                      "0" = "No information",
                                      "1" = "Male",
                                      "2" = "Female",
                                      .default = NA_character_),
                  literacy = dplyr::recode(ESC,
                                            "1" = "None",
                                            "2" = "1 to 3",
                                            "3" = "4 to 7",
                                            "4" = "8 to 11",
                                            "5" = "12 or more",
                                            "9" = "Ignored",
                                            .default = NA_character_),
                  # TODO: Review using the international reference https://en.wikipedia.org/wiki/International_Standard_Classification_of_Education#ISCED_2011_levels_of_education_and_comparison_with_ISCED_1997
                  education = dplyr::recode(ESC2010,
                                            "0" = "None",
                                            "1" = "Primary",
                                            "2" = "Primary",
                                            "3" = "Secondary",
                                            "4" = "Barchelor incomplete",
                                            "5" = "Barchelor",
                                            .default = NA_character_),
                  marital = dplyr::recode(ESTCIV,
                                          "1" = "Single",
                                          "2" = "Married",
                                          "3" = "Widow",
                                          "4" = "Separated",
                                          "5" = "Ignored",
                                          .default = NA_character_),
                  locus = dplyr::recode(LOCOCOR,
                                        "9" = "Ignored",
                                        "1" = "Hospital",
                                        "2" = "Healh Stablishment",
                                        "3" = "Home",
                                        "4" = "Public place",
                                        "5" = "Other",
                                        .default = NA_character_),
                  # NOTE: Pardos see: https://en.wikipedia.org/wiki/Pardo_Brazilians#cite_note-33
                  color_race = dplyr::recode(RACACOR,
                                             "1" = "White",
                                             "2" = "Black",
                                             "3" = "Yellow",
                                             "4" = "Mixed",
                                             "5" = "Indigenous",
                                             .default = NA_character_)) %>%
    dplyr::select(cause,
                  sex,
                  education,
                  literacy,
                  death_year,
                  marital,
                  locus,
                  color_race,
                  job = OCUP,
                  city = CODMUNRES,
                  death_city = CODMUNOCOR)

    usethis::use_data(data_icd_10,
                      overwrite = TRUE)
