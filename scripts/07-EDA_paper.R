#### Preamble ####
# Purpose: Explore the spatial distribution of Green Roofs and Green Spaces in Toronto.
# Author: Benedict Cummins-Mburu
# Last Updated: 13 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
GR_analysis_data <- read_csv("data/02-analysis_data/GR_analysis_data.csv")
GS_analysis_data <- read_csv("data/02-analysis_data/GS_analysis_data.csv")
summary_analysis_data <- readRDS("data/02-analysis_data/analysis_data.rds")

#### In-Text EDA ####

# ERIP fraction
ERIP_roofs <- GR_analysis_data[GR_analysis_data$ECO_ROOF == "TRUE", ]
ERIP_area <- sum(ERIP_roofs$GREEN_ROOF_AREA, na.rm = TRUE)
total_area <- sum(GR_analysis_data$GREEN_ROOF_AREA, na.rm = TRUE)
(ERIP_area / total_area) * 100
