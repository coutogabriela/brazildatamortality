library(dplyr)
library(ensurer)
library(geobr)
library(geogrid)
library(sf)
library(tibble)
library(usethis)



#---- Brazilian states ----

state_sf <- geobr::read_state(year = 2010,
                              simplified = TRUE,
                              showProgress = FALSE) %>%
    ensurer::ensure_that(all(sf::st_is_valid(.)),
                         err_desc = "Invalid states found!")


# Get Brazilian states as hexagons.
state_cells <-  state_sf %>%
    geogrid::calculate_grid(grid_type = "hexagonal",
                            seed = 4)

state_hex <- geogrid::assign_polygons(state_sf, state_cells) %>%
    dplyr::select(abbrev_state) %>%
    dplyr::left_join(sf::st_set_geometry(state_sf, NULL),
                     by = "abbrev_state") %>%
    ensurer::ensure_that(all(sf::st_is_valid(.)),
                         err_desc = "Invalid hexagons found!")



#---- Brazilian towns ----

town_sf <- geobr::read_municipality(year = 2010,
                                    simplified = TRUE,
                                    showProgress = FALSE) %>%
    dplyr::mutate(code_muni = as.character(code_muni)) %>%
    # NOTE: Some downloaded towns are invalid.
    sf::st_make_valid() %>%
    ensurer::ensure_that(all(sf::st_is_valid(.)),
                         err_desc = "Invalid towns found!")

meso_sf <- geobr::read_meso_region(year = 2010,
                                   simplified = TRUE,
                                   showProgress = FALSE) %>%
    dplyr::select(abbrev_state, code_meso, name_meso) %>%
    ensurer::ensure_that(all(sf::st_is_valid(.)),
                         err_desc = "Invalid meso regions found!")

town_meso_sf <- town_sf %>%
    sf::st_centroid() %>%
    sf::st_intersection(meso_sf)

if (nrow(town_meso_sf) != nrow(town_sf)) {
    towns_missing <- setdiff(town_sf$code_muni, town_meso_sf$code_muni)
    towns_missing <- town_sf[town_sf$code_muni %in% towns_missing, ]
    warning(sprintf("Some towns lay outside the meso regions: %s",
                    paste(paste(towns_missing$name_muni,
                                towns_missing$abbrev_state,
                                sep = " "),
                          collapse = ", ")))
    plot(towns_missing["name_muni"])
}

town_meso_tb <- town_meso_sf %>%
    sf::st_set_geometry(NULL) %>%
    tibble::as_tibble() %>%
    dplyr::select(code_muni, code_meso, name_meso)

town_sf <- town_sf %>%
        dplyr::left_join(town_meso_tb, by = "code_muni")

micro_sf <-  geobr::read_micro_region(year = 2010,
                                      simplified = TRUE,
                                      showProgress = FALSE) %>%
    dplyr::select(abbrev_state, code_micro, name_micro) %>%
    ensurer::ensure_that(all(sf::st_is_valid(.)),
                         err_desc = "Invalid micro regions found!")

town_micro_sf <- town_sf %>%
    sf::st_centroid() %>%
    sf::st_intersection(micro_sf)

if (nrow(town_micro_sf) != nrow(town_sf)) {
    towns_missing <- setdiff(town_sf$code_muni, town_micro_sf$code_muni)
    towns_missing <- town_sf[town_sf$code_muni %in% towns_missing, ]
    warning(sprintf("Some towns lay outside the micro regions: %s",
                    paste(paste(towns_missing$name_muni,
                                towns_missing$abbrev_state,
                                sep = " "),
                          collapse = ", ")))
    plot(towns_missing["name_muni"])
}

town_micro_tb <- town_micro_sf %>%
    sf::st_set_geometry(NULL) %>%
    tibble::as_tibble() %>%
    dplyr::select(code_muni, code_micro, name_micro)

town_sf <- town_sf %>%
        dplyr::left_join(town_micro_tb, by = "code_muni")

state_tb <- state_sf %>%
    sf::st_set_geometry(NULL) %>%
    tibble::as_tibble() %>%
    dplyr::select(abbrev_state, name_state, code_region, name_region)

town_sf <- town_sf %>%
    dplyr::left_join(state_tb, by = "abbrev_state")

# Save data to package.
usethis::use_data(state_sf, state_hex,
                  town_sf,
                  overwrite = TRUE)
