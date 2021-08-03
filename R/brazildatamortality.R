#' Merge the data comming from ICD 9 and ICD 10.
#'
#' @return A tibble with mortality data of Brazil.
#' @export
get_data <- function() {

    data_9  <- brazildatamortality::data_icd_9
    data_10 <- brazildatamortality::data_icd_10

    data_10 <- data_10 %>%
        dplyr::select(birth_date, cause, death_city, death_date, education,
                      job, locus, marital, residence_city, sex, color_race,
                      literacy, age_unit, age_value)
    data_9  <- data_9  %>%
        dplyr::select(birth_date, cause, death_city, death_date, education,
                      job, locus, marital, residence_city, sex, age_unit,
                      age_value) %>%
        dplyr::mutate(color_race = NA,
                      literacy = NA)

    data_tb <- data_9 %>%
        dplyr::bind_rows(data_10) %>%
        dplyr::mutate(death_year = lubridate::year(death_date),
                      death_month = as.integer(lubridate::month(death_date)),
                      age = dplyr::case_when(
                   age_unit == "> 100 years" ~ Inf,
                   age_unit == "Years"   ~ as.double(age_value),
                   age_unit == "Months"  ~ as.double(age_value)/12,
                   age_unit == "Days"    ~ as.double(age_value)/365,
                   age_unit == "Hours"   ~ as.double(age_value)/(365 * 24),
                   age_unit == "Minutes" ~ as.double(age_value)/(365 * 24 * 60)
                      )) %>%
        tidyr::drop_na(cause, death_date) %>%
        return()
}
