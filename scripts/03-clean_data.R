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
  mutate(POSTAL = str_sub(POSTAL, 1, 2)) %>% # removed last postal code digit ; not spatially descriptive
  filter(STATUS %in% c("Inspection", "Closed")) # restricting scope to 2 main types of permits

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
