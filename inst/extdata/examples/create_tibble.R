# Take the original data (1996-2019) and put it together into a single tibble

library(read.dbc)
library(dplyr)
library(ggplot2)
library(lubridate)
library(skimr)
library(stringr)
library(usethis)

# Path to a data directory.
data_dir <- "~/Documents/brazildatamortality/inst/extdata/SIM"

# Helper function. Read and format the raw data.
process_data <- function(x) {
  x %>%
    read.dbc::read.dbc(as.is = TRUE) %>%
    tibble::as_tibble() %>%
    # NOTE: Filter deaths by natural causes.
    dplyr::filter(stringr::str_detect(CAUSABAS, "X3")) %>%
    dplyr::mutate(date = lubridate::as_date(DTOBITO,
                                            format = "%d%m%Y")) %>%
    return()
}

raw_data_tb <- data_dir %>%
  list.files(pattern = ".*[.](dbc|DBC)",
             full.names = TRUE,
             recursive = TRUE) %>%
  tibble::tibble() %>%
  dplyr::rename(file_path = ".") %>%
  dplyr::mutate(data = purrr::map(file_path, process_data))

data_tb <- raw_data_tb %>%
  tidyr::unnest(data)

usethis::use_data(data_tb)
