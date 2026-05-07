#### Preamble ####
# Purpose: Cleans and saves the raw "Current and Future Climate" dataset downloaded from Open Data Toronto
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT
# Notes:
#    - The only necessary cleaning was dimention shaping

#### Setup ####
library(tidyverse)
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

#### Clean data ####

# Shape the data
focal_column_names <- c(
  "Climate.Scenario",
  "Time.Horizon",
  "Distribution",
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
cleaned_data <- raw_data %>%
  select(all_of(focal_column_names)) %>%
  filter(Distribution != "OVERALL_TREND")

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
