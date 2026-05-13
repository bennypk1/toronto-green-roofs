#### Preamble ####
# Purpose: Explore the spatial distribution of Green Roofs and Green Spaces in Toronto.
# Author: Benedict Cummins-Mburu
# Last Updated: 12 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
GR_analysis_data <- read_csv("data/02-analysis_data/GR_analysis_data.csv")
GS_analysis_data <- read_csv("data/02-analysis_data/GS_analysis_data.csv")
summary_analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Generate Tables ####

Table_1 <- GR_analysis_data %>%
  select(c(ID, G_AREA, CFSAUID)) %>%
  head(4)

Table_2 <- GS_analysis_data %>%
  select(c(ID, G_AREA, CFSAUID)) %>%
  head(4)

Table_3 <- summary_analysis_data %>%
  mutate(geometry = paste0(str_sub(geometry, 1, 10), "...")) %>%
  select(c(
    CFSAUID,
    geometry,
    GREEN_ROOF_COVERAGE,
    GREEN_SPACE_COVERAGE
  )) %>%
  head(4)

#### Save Tables ####

saveRDS(Table_1, "plots/tables/Table_1.rds")
saveRDS(Table_2, "plots/tables/Table_2.rds")
saveRDS(Table_3, "plots/tables/Table_3.rds")
