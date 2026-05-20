#### Preamble ####
# Purpose:
# Author: Benedict Cummins-Mburu
# Last Updated: 20 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
set.seed(416)

#### Simulate data ####

# setup
toronto_FSAs <- c(
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
  "M5M",
  "M5N",
  "M5P",
  "M5R",
  "M5S",
  "M5T",
  "M5V",
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

# initialize simulated dataframe
simulated_data <- data.frame(
  CFSAUID = character(),
  GREEN_ROOF_COVERAGE = numeric(),
  GREEN_SPACE_COVERAGE = numeric(),
  geometry = character()
)

# populated dataframe
for (FSA in toronto_FSAs) {
  curr_data <- data.frame(
    CFSAUID = FSA,
    GREEN_ROOF_COVERAGE = rbeta(1, 3, 4),
    GREEN_SPACE_COVERAGE = rbeta(1, 3, 4),
    geometry = "{geoJSON goes here, we are not writing tests to test it's validity at this time."
  )
  simulated_data <- rbind(simulated_data, curr_data)
}

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
