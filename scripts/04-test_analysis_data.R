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

# Check that IDs are unique
if (setequal(unique(focal_data$ID), focal_data$ID)) {
  message("Test Passed: IDs are unique.")
} else {
  stop("Test Failed: IDs are not unique.")
}

# Check that all "Closed" entries have Completion dates
test_data1 <- focal_data %>% filter(STATUS == "Closed")
if (all(!is.na(test_data1$COMPLETED_DATE))) {
  message("Test Passed: All Closed entries have Completion dates.")
} else {
  stop("Test Failed: Some Closed entries do not have Completion dates.")
}

# Check that all "Closed" entries have Issued dates
if (all(!is.na(test_data1$ISSUED_DATE))) {
  message("Test Passed: All Closed entries have Issued dates.")
} else {
  stop("Test Failed: Some Closed entries do not have Issued dates.")
}

# Check that all non-"Closed" entries do not have Completion dates
test_data2 <- focal_data %>% filter(STATUS != "Closed")
if (all(is.na(test_data2$COMPLETED_DATE))) {
  message("Test Passed: No non-Closed entries have Completion dates.")
} else {
  stop("Test Failed: Some non-Closed entries have Completion dates.")
}

# Check that all entries have Application dates
if (all(!is.na(focal_data$APPLICATION_DATE))) {
  message("Test Passed: All entries have recorded Application dates.")
} else {
  stop("Test Failed: Some entries have no recorded application dates.")
}
