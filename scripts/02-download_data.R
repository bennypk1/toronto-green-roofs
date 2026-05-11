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
GR_reference <- search_packages("Building Permits - Green Roofs")
GS_reference <- search_packages("Green Spaces")

GR_id <- list_package_resources(GR_reference)[2, "id"]
GS_id <- list_package_resources(GS_reference)[7, "id"]

GR_CSV <- get_resource(GR_id)
GS_CSV <- get_resource(GS_id)

#### Save data ####
write_csv(GR_CSV, "data/01-raw_data/GR_raw_data.csv")
write_csv(GS_CSV, "data/01-raw_data/GS_raw_data.csv")
