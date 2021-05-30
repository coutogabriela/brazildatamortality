## Code to prepare `data_icd_10` dataset.

library(dplyr)
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
data_dir <- "~/Documents/github/brazildatamortality/inst/extdata/SIM"


#---- Helper functions ----

# Helper function. Read and format the raw data.
#
# @param x A quosure that reads a file into a data.frame.
# @return  A tibble.
process_data <- function(x) {
  x <- rlang::eval_tidy(x)
  x %>%
    tibble::as_tibble() %>%
    # NOTE: Filter deaths by natural causes.
    dplyr::filter(stringr::str_detect(CAUSABAS, "X3")) %>%
    dplyr::mutate(date = lubridate::as_date(DTOBITO,
                                            format = "%d%m%Y")) %>%
    return()
}

#---- Script ----

raw_data_tb <- data_dir %>%
  list.files(pattern = ".*[.](dbc|DBC)",
             full.names = TRUE,
             recursive = TRUE) %>%
  tibble::tibble() %>%
  dplyr::rename(file_path = ".") %>%
  dplyr::mutate(raw_data = purrr::map(file_path,
                            ~rlang::quo(read.dbc::read.dbc(.,
                                                           as.is = TRUE)))) %>%
  dplyr::mutate(data = purrr::map(raw_data, process_data))

data_icd_10 <- raw_data_tb %>%
  tidyr::unnest(data)

usethis::use_data(data_icd_10,
                  overwrite = TRUE)
