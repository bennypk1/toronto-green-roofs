#### Preamble ####
# Purpose: Downloads and saves the current version of the "Current and Future Climate" dataset
# Author: Benedict Cummins-Mburu
# Last Updated: 6 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(opendatatoronto)

#### Download data ####
CFC_reference <- search_packages("Current and Future Climate")
CFC_CSV_id <- list_package_resources(CFC_reference)[2, 2]
CFC_CSV <- get_resource(CFC_CSV_id)

#### Save data ####
write_csv(CFC_CSV, "data/01-raw_data/raw_data.csv")
