#### Preamble ####
# Purpose: Explore the spatial distribution of Green Roofs and Green Spaces in Toronto.
# Author: Benedict Cummins-Mburu
# Last Updated: 11 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
library(forcats)
library(canadianmaps)
library(scales)
GR_analysis_data <- read_csv("data/02-analysis_data/GR_analysis_data.csv")
GS_analysis_data <- read_csv("data/02-analysis_data/GS_analysis_data.csv")

### FSA-against-outcome Plotting Function ###

MFSA_data_raw <- FSA[str_detect(FSA$CFSAUID, "^M"), c("geometry", "CFSAUID")]

get_spatial_summary <- function(data_long) {
  spatial_summary <- data_long %>%
    filter(!is.na(CFSAUID)) %>%
    group_by(CFSAUID) %>%
    summarize(
      COUNT = n(),
      TOTAL_AREA = sum(G_AREA)
    )
  MFSA_data_augmented <- left_join(
    MFSA_data_raw,
    spatial_summary,
    by = "CFSAUID"
  )
  MFSA_data_augmented <- MFSA_data_augmented %>%
    mutate(COUNT = ifelse(is.na(COUNT), 0, COUNT))
  return(MFSA_data_augmented)
}

plot_map <- function(data_long, count = FALSE) {
  # transform data
  spatial_summary_data <- get_spatial_summary(data_long)
  # set target outcome
  target_fill <- if (count) "COUNT" else "TOTAL_AREA"
  target_transformation <- if (count) "identity" else "log10"
  # plot
  p <- ggplot(data = spatial_summary_data) +
    # Use geom_sf and wrap the fill in aes()
    geom_fsa(data = spatial_summary_data, fill = "COUNT") +
    scale_fill_gradient(
      low = "#e5f5e0",
      high = "#006d2c",
      trans = target_transformation,
      na.value = "grey90",
      labels = scales::label_comma() # Makes legend readable (e.g. 1,000)
    ) +
    theme_void()
  # return
  return(p)
}

### Spatial Distribution of Total Area and Counts ###

plot_map(GR_analysis_data, count = TRUE)
get_spatial_summary(GS_analysis_data)

### Spatial Correlations ###
