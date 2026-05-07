#### Preamble ####
# Purpose: Simulate a simplified version of the "Current and Future Climate" dataset from Open Data Toronto
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
set.seed(416)

#### Simulate data ####

# Define Possible Entries
distributions <- c(
  "MEDIAN",
  "90th_PERCENTILE",
  "10th_PERCENTILE"
)
scenarios <- c(
  "SSP2-4.5",
  "SSP5-8.5"
)
times <- c(
  "1971-2000",
  "2015-2040",
  "2041-2070",
  "2071-2100"
)

# Initialize dataframe with base data
simulated_data <- data.frame(
  Climate.Scenario = "OBSERVED_TORONTO_AVERAGE",
  Time.Horizon = "1971-2000",
  Distribution = "MEDIAN",

  ANNUAL_MEAN_TEMPERATURE = rnorm(1, mean = 5, sd = 4),
  ANNUAL_MAXIMUM_TEMPERATURE = rnorm(1, mean = 10, sd = 4),
  ANNUAL_MINIMUM_TEMPERATURE = rnorm(1, mean = 10, sd = 4),

  DAYS_ABOVE_35C = runif(1, min = 0, max = 20),
  DAYS_BELOW_MINUS_20C = runif(1, min = 0, max = 20),
  GROWING_DEGREE_DAYS_BASE_0C = runif(1, min = 100, max = 300),
  TEMPERATURE_BASED_HEAT_WARNING_FREQUENCY = runif(1, min = 0, max = 5),

  ANNUAL_TOTAL_PRECIPITATION = runif(1, min = 0, max = 200),
  ANNUAL_TOTAL_DRY_DAYS = runif(1, min = 0, max = 200),
  SIMPLE_DAILY_INTENSITY_INDEX = runif(1, min = 2, max = 7)
)

# Update iteratively accross all scenarios, timeframes, and distributions
for (scenario in scenarios) {
  for (time in times) {
    for (distribution in distributions) {
      new_row <- data.frame(
        Climate.Scenario = scenario,
        Time.Horizon = time,
        Distribution = distribution,

        ANNUAL_MEAN_TEMPERATURE = rnorm(1, mean = 5, sd = 4),
        ANNUAL_MAXIMUM_TEMPERATURE = rnorm(1, mean = 10, sd = 4),
        ANNUAL_MINIMUM_TEMPERATURE = rnorm(1, mean = 10, sd = 4),

        DAYS_ABOVE_35C = runif(1, min = 0, max = 20),
        DAYS_BELOW_MINUS_20C = runif(1, min = 0, max = 20),
        GROWING_DEGREE_DAYS_BASE_0C = runif(1, min = 100, max = 300),
        TEMPERATURE_BASED_HEAT_WARNING_FREQUENCY = runif(1, min = 0, max = 5),

        ANNUAL_TOTAL_PRECIPITATION = runif(1, min = 0, max = 200),
        ANNUAL_TOTAL_DRY_DAYS = runif(1, min = 0, max = 200),
        SIMPLE_DAILY_INTENSITY_INDEX = runif(1, min = 2, max = 7)
      )
      simulated_data = rbind(simulated_data, new_row)
    }
  }
}

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
