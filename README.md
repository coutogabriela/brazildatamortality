
<!-- README.md is generated from README.Rmd. Please edit that file -->

# brazildatamortality

<!-- badges: start -->
<!-- badges: end -->

This package contains both the data and the figures presented in the
paper “Natural Hazards Fatalities in Brazil, 1979–2019”. Below is the
abstract of the aforementioned paper.

The impact of natural hazards on nations and societies is a global
challenge and concern. Studies worldwide have been conducted within and
among countries, to examine the spatial distribution and temporal
evolution of fatalities and their consequences in societies. In Brazil,
no studies have comprehensively identified fatalities associated with
all natural hazards and their singularities by decade, region, sex, age,
and other victim characteristics. This study develops a deep analysis on
the Brazilian Data Mortality of the Brazilian Ministry of Health, from
1979 to 2019, identifying the natural hazards that kill the greatest
number of people in Brazil and its surrounding particularities.
Lightning is the deadliest natural hazard in Brazil during this period,
with a gradual decrease in the number of fatal victims. Hydrogeological
fatalities increases from 2000, and the most fatalities develop from
2010 to 2019. Despite Brazil being a tropical country affected by severe
droughts, extreme heat had the lowest number of fatalities, almost
irrelevant when compared with that of other natural hazards. The period
from December to March is with the higher number of fatalities, and the
Southeast region is the most populous regions were the most are fatally
affected. The number of male victims is double that of female victims,
of all ages, and unmarried victims died the most. Thus, it is
fundamental to recognize and make public the knowledge of different
natural hazards’ impacts on communities and societies, namely people and
their livelihoods, to evaluate challenges and recognize opportunities to
reduce natural hazards’ impacts on Brazil.

## Installation

You can install the development version of brazildatamortality from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("coutogabriela/brazildatamortality")
```

## Example

This basic example shows the deaths in Brazil by cause and year:

``` r

library(brazildatamortality)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(ggplot2)

get_data() %>%
    ggplot() +
    geom_bar(aes(x = death_year, fill = cause)) +
    xlab("Year") +
    ylab("Number of fatalities") +
    labs(fill = "Fatality cause") +
    ggtitle("Deaths by natural hazard in Brazil")
```

<img src="man/figures/README-example-1.png" width="100%" />

This package contains:

-   two datasets corresponding to fatalities by natural hazards (one
    from 1979 to 1995 and the other from 1996 to 2019).
-   two datasets corresponding to Brazil’s administrative divisions
    (state and town)
-   one dataset corresponding to a hexagonal approximation of the
    Brazilian state division.
