#### Preamble ####
# Purpose: Explore the "Current and Future Climate" dataset by visually showcasing various climate trends.
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

# Pivot "Distribution" longer for plotting
climate_metrics <- c(
  "ANNUAL_MEAN_TEMPERATURE",
  "ANNUAL_MAXIMUM_TEMPERATURE",
  "ANNUAL_MINIMUM_TEMPERATURE",
  "DAYS_ABOVE_35C",
  "DAYS_BELOW_MINUS_20C",
  "GROWING_DEGREE_DAYS_BASE_0C",
  "TEMPERATURE_BASED_HEAT_WARNING_FREQUENCY",
  "ANNUAL_TOTAL_PRECIPITATION",
  "ANNUAL_TOTAL_DRY_DAYS",
  "SIMPLE_DAILY_INTENSITY_INDEX"
)
wider_data <- pivot_wider(
  analysis_data,
  names_from = Distribution,
  values_from = all_of(climate_metrics)
)

### Generic Response Plotting Function ###

plot_projections <- function(data, var_name) {
  # filter for relevant data
  relevant_columns <- c(
    paste0(var_name, "_10th_PERCENTILE"),
    paste0(var_name, "_MEDIAN"),
    paste0(var_name, "_90th_PERCENTILE")
  )
  relevant_projection_data <- data %>%
    select(all_of(c(relevant_columns, "Climate.Scenario", "Time.Horizon"))) %>%
    filter(Climate.Scenario != "OBSERVED_TORONTO_AVERAGE")

  relevant_projection_data %>%
    ggplot(
      aes(x = Time.Horizon, group = Climate.Scenario, colour = Climate.Scenario)
    ) +
    geom_ribbon(
      aes(
        ymin = !!sym(relevant_columns[1]),
        ymax = !!sym(relevant_columns[3]),
        fill = Climate.Scenario
      ),
      alpha = 0.2,
      color = NA
    ) +
    geom_line(
      aes(y = !!sym(relevant_columns[2])),
      linewidth = 1.2
    ) +
    geom_point(
      aes(y = !!sym(relevant_columns[2])),
      size = 3
    ) +
    labs(
      title = paste("Toronto Climate Projections:", var_name),
      x = "Time Horizon",
      y = var_name,
      fill = "Scenario",
      color = "Scenario"
    ) +
    theme_classic() +
    theme(
      legend.position = "bottom",
      axis.text.x = element_text(angle = 35, hjust = 1)
    )
}

plot_projections(wider_data, "SIMPLE_DAILY_INTENSITY_INDEX")


### Visualize Temperature Trends ####
temperature_trends_plotting_data <- analysis_data


#### Save Figures ####
saveRDS(
  first_model,
  file = "data/first_model.rds"
)
