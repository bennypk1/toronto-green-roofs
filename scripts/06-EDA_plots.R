#### Preamble ####
# Purpose: Explore the "Building Permits - Green Roofs" with figures and tables
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
library(canadianmaps)
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")


### Spatial Distribution of Green Roofs in Toronto ###

# Setup plotting data
green_roof_distribution <- analysis_data %>%
  mutate(CFSAUID = POSTAL) %>%
  filter(!is.na(CFSAUID)) %>%
  group_by(CFSAUID) %>%
  summarize(COUNT = n(), TOTAL_AREA = sum(GREEN_ROOF_AREA))
MFSA_data_raw <- FSA[str_detect(FSA$CFSAUID, "^M"), c("geometry", "CFSAUID")]
MFSA_data_augmented <- left_join(
  MFSA_data_raw,
  green_roof_distribution,
  by = "CFSAUID"
)
# Plot
ggplot() +
  geom_fsa(data = MFSA_data_augmented, fill = "COUNT") +
  theme_classic() +
  labs(
    title = "Toronto FSA Data Distribution",
    subtitle = "Filtered for 'M' Postal Regions"
  )

this <- MFSA_data_augmented[
  MFSA_data_augmented$COUNT == max(MFSA_data_augmented$COUNT, na.rm = TRUE),
]
