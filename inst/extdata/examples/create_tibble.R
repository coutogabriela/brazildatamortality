# Take the original data and put it together into a single tibble

library(read.dbc)
library(dplyr)
library(ggplot2)
library(lubridate)
library(skimr)
library(stringr)

# TODO: Gabriela actualiza para tu disco externo.
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
  list.files(pattern = ".*[.]dbc",
             full.names = TRUE,
             recursive = TRUE) %>%
  # TODO: Remove this line.
  #head(3) %>%
  tibble::tibble() %>%
  dplyr::rename(file_path = ".") %>%
  dplyr::mutate(data = purrr::map(file_path, process_data))

data_tb <- raw_data_tb %>%
  tidyr::unnest(data)

# TODO: Gabriela actualiza para tu computadora.
data_tb %>%
  saveRDS("/home/alber-d005/Documents/brazildatamortality/data_tb.rds")
