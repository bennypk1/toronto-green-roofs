#### Preamble ####
# Purpose: Explore the "Building Permits - Green Roofs" to compliment a written description of the dataset.
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")


#### EDA Tasks ####

# get first application date and last completion date
study_range <- c(
  min(analysis_data$APPLICATION_DATE),
  max(analysis_data$COMPLETED_DATE, na.rm = TRUE)
)
