#### Preamble ####
# Purpose: Downloads and saves the current version of the "Building Permits - Green Roofs" dataset from Open Data Toronto
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
library(opendatatoronto)

#### Download data ####
CFC_reference <- search_packages("Building Permits - Green Roofs")
CFC_CSV_id <- list_package_resources(CFC_reference)[2, 2]
CFC_CSV <- get_resource(CFC_CSV_id)

#### Save data ####
write_csv(CFC_CSV, "data/01-raw_data/raw_data.csv")
