#### Preamble ####
# Purpose: Cleans and saves the raw "Building Permits - Green Roofs" dataset downloaded from Open Data Toronto
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

focal_column_names <- c(
  "PERMIT_NUM",
  "REVISION_NUM",
  "PERMIT_TYPE",
  "STRUCTURE_TYPE",
  "APPLICATION_DATE",
  "ISSUED_DATE",
  "COMPLETED_DATE",
  "STATUS",
  "POSTAL",
  "GREEN_ROOF_AREA",
  "ECO_ROOF"
)
cleaned_data <- raw_data %>%
  select(all_of(focal_column_names)) %>%
  mutate(
    APPLICATION_DATE = as.POSIXct(APPLICATION_DATE),
    ISSUED_DATE = as.POSIXct(ISSUED_DATE),
    COMPLETED_DATE = as.POSIXct(ISSUED_DATE),
  ) %>%
  filter(STATUS == "Closed") %>% # restricting scope to just those permits that indicate the complete installation of a green roof
  select(c(-STATUS))

# Issues:
# - A single entry is marked as "Closed" but does not have a completion or issue date. It is kept in the dataset for now.
# - 28 closed permits have a recorded green roof area of 0 for no clear reason
# - 28 closed permits are revisions of previously closed permits

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
