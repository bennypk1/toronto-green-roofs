#### Preamble ####
# Purpose: Test Simulated Green Roof & Space Data
# Author: Benedict Cummins-Mburu
# Last Updated: 22 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
focal_data <- read_csv("data/00-simulated_data/simulated_data.csv")

#### Test data ####

toronto_all_fsas <- c(
  "M1B",
  "M1C",
  "M1E",
  "M1G",
  "M1H",
  "M1J",
  "M1K",
  "M1L",
  "M1M",
  "M1N",
  "M1P",
  "M1R",
  "M1S",
  "M1T",
  "M1V",
  "M1W",
  "M1X",
  "M2H",
  "M2J",
  "M2K",
  "M2L",
  "M2M",
  "M2N",
  "M2P",
  "M2R",
  "M3A",
  "M3B",
  "M3C",
  "M3H",
  "M3J",
  "M3K",
  "M3L",
  "M3M",
  "M3N",
  "M4A",
  "M4B",
  "M4C",
  "M4E",
  "M4G",
  "M4H",
  "M4J",
  "M4K",
  "M4L",
  "M4M",
  "M4N",
  "M4P",
  "M4R",
  "M4S",
  "M4T",
  "M4V",
  "M4W",
  "M4X",
  "M4Y",
  "M5A",
  "M5B",
  "M5C",
  "M5E",
  "M5G",
  "M5H",
  "M5J",
  "M5K",
  "M5L",
  "M5M",
  "M5N",
  "M5P",
  "M5R",
  "M5S",
  "M5T",
  "M5V",
  "M5W",
  "M5X",
  "M6A",
  "M6B",
  "M6C",
  "M6E",
  "M6G",
  "M6H",
  "M6J",
  "M6K",
  "M6L",
  "M6M",
  "M6N",
  "M6P",
  "M6R",
  "M6S",
  "M7A",
  "M8V",
  "M8W",
  "M8X",
  "M8Y",
  "M8Z",
  "M9A",
  "M9B",
  "M9C",
  "M9L",
  "M9M",
  "M9N",
  "M9P",
  "M9R",
  "M9V",
  "M9W"
)

# check that all FSAs in simulated dataset are valid toronto FSAs
if (all(focal_data$CFSAUID %in% toronto_all_fsas)) {
  message(
    "Test Passed: All FSAs in simulated dataset are valid toronto FSAs."
  )
} else {
  stop(
    "Test Failed: At least one FSA in simulated dataset is NOT a valid toronto FSA."
  )
}

# check that all COVERAGEs are valid proportions AND strictly not unity
if (all(focal_data$GREEN_SPACE_COVERAGE >= 0)) {
  message(
    "Test Passed: Green space coverage is always non-negative."
  )
} else {
  stop(
    "Test Failed: Green space coverage is negative somewhere."
  )
}
if (all(focal_data$GREEN_SPACE_COVERAGE < 1)) {
  message(
    "Test Passed: Green space coverage is always strictly less that 1."
  )
} else {
  stop(
    "Test Failed: Green space coverage is 1 or greater somewhere."
  )
}
if (all(focal_data$GREEN_ROOF_COVERAGE < 1)) {
  message(
    "Test Passed: Green roof coverage is always strictly less that 1."
  )
} else {
  stop(
    "Test Failed: Green roof coverage is 1 or greater somewhere."
  )
}
if (all(focal_data$GREEN_ROOF_COVERAGE >= 0)) {
  message(
    "Test Passed: Green roof coverage is always non-negative."
  )
} else {
  stop(
    "Test Failed: Green roof coverage is negative somewhere."
  )
}

# Check that FSAs are unique
if (setequal(unique(focal_data$CFSAUID), focal_data$CFSAUID)) {
  message("Test Passed: IDs are unique.")
} else {
  stop("Test Failed: IDs are not unique.")
}
