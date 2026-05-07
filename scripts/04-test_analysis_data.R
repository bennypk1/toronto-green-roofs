#### Preamble ####
# Purpose: Tests the structure and validity of the cleaned "Current and Future Climate" dataset
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT
# Notes:
#   - Exact same tests as in: <01-test_simulated_data.R>

#### Setup ####
library(tidyverse)
focal_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Test data ####

# Check that the dataset has 1 + (2 * 3 * 4) = 25 rows and 13 rows
if (all(dim(focal_data) == c(25, 13))) {
  message(
    "Test Passed: The dataset has the correct number of rows and columns."
  )
} else {
  stop(
    "Test Failed: Dataset either doesn't have 25 rows or doesn't have 13 columns."
  )
}

# Check that column names are as expected (not necessarily in a specific order)
expected_column_names <- c(
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
for (col in names(focal_data)) {
  if (!(col %in% expected_column_names)) {
    stop("Test Failed: One of the column names is unexpected.")
  }
}
for (col in expected_column_names) {
  if (!(col %in% names(focal_data))) {
    stop(
      "Test Failed: One of the expected column names is not present in the data."
    )
  }
}
message("Test Passed: Column naming structure is as expected.")

# Check that the 3-uples: (Climate.Scenario, Time.Horizon, Distribution) are unique for each row
test_data3 <- focal_data %>%
  select(Climate.Scenario, Time.Horizon, Distribution)
if (nrow(test_data3) == nrow(unique(test_data3))) {
  message("Test Passed: No entries have the same first 3 identifying columns.")
} else {
  stop(
    "Test Failed: two or more entries have the same first 3 identifying columns."
  )
}

# Check that Climate Scenario entries are valid AND comprehensive
if (
  setequal(
    unique(focal_data$Climate.Scenario),
    c("OBSERVED_TORONTO_AVERAGE", "SSP2-4.5", "SSP5-8.5")
  )
) {
  message("Test Passed: Climate scenarios are valid and comprehensive.")
} else {
  stop(
    "Test Failed: Climate scenarios are either not valid or not comprehensive."
  )
}

# Check that Time Horizon entries are valid AND comprehensive
if (
  setequal(
    focal_data$Time.Horizon,
    c("1971-2000", "2015-2040", "2041-2070", "2071-2100")
  )
) {
  message("Test Passed: Time horizons are valid and comprehensive.")
} else {
  stop("Test Failed: Time horizons are either not valid or not comprehensive.")
}

# Check that Distribution entries are valid AND comprehensive
if (
  setequal(
    focal_data$Distribution,
    c("MEDIAN", "90th_PERCENTILE", "10th_PERCENTILE")
  )
) {
  message("Test Passed: Distributions are valid and comprehensive.")
} else {
  stop("Test Failed: Distributions are either not valid or not comprehensive.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(focal_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check that relevant columns are non-negative
for (col_name in names(focal_data)) {
  if (
    str_extract(col_name, "[^_]+$")[[1]] %in% c("DAYS", "FREQUENCY", "INDEX")
  ) {
    if (any(focal_data[, col_name] < 0)) {
      stop("Test Failed: A column has negative values and isn't supposed to.")
    }
  }
}
message("Test Passed: No non-negative columns have negative values.")
