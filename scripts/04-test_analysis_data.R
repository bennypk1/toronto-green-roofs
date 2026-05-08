#### Preamble ####
# Purpose: Tests the structure and validity of the cleaned "Building Permits - Green Roofs" dataset
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

# Check that dates are coherent
if (all(focal_data$COMPLETED_DATE > focal_data$ISSUED_DATE, na.rm = TRUE)) {
  message(
    "Test Passed: All completion dates are in the future of their issue dates."
  )
} else {
  stop(
    "Test Failed: At least one completion date is before or on date of issuance."
  )
}
if (all(focal_data$ISSUED_DATE > focal_data$APPLICATION_DATE, na.rm = TRUE)) {
  message(
    "Test Passed: All issuance dates are in the future of their application dates."
  )
} else {
  stop(
    "Test Failed: At least one issuance date is before or on date of application."
  )
}
