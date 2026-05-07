#### Preamble ####
# Purpose: Simulate a simplified version of the "Building Permits - Green Roofs" dataset from Open Data Toronto
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
set.seed(416)

#### Simulate data ####

# Define Possible Entries
CFSAs <- c("M8", "M5", "M9", "M2", "M6", "M4", "M3", "M1")
statuses <- c("Inspection", "Closed")
permit_types <- c(
  "Small Residential Projects",
  "New Building",
  "Building Additions/Alterations",
  "New Houses"
)
structure_types <- c(
  "Mixed Use/Res w Non Res",
  "Apartment Building",
  "Multiple Use/Non Residential",
  "SFD - Detached",
  "Industrial",
  "Elementary School",
  "Office",
  "Other",
  "Retail Store",
  "SFD - Semi-Detached",
  "University",
  "Car Dealership",
  "SFD - Townhouse",
  "Hospital",
  "Laneway / Rear Yard Suite",
  "Secondary School",
  "College/Trade/Tech School/Training Cent.",
  "Multiple Unit Building",
  "Parking Garage",
  "Community Hall",
  "Self-Service Storage Building",
  "Student Residence",
  "2 Unit - Detached",
  "Library",
  "Motel/Hotel",
  "Recreational",
  "Place of Worship",
  "Transit Station,Subway, Bus Terminal",
  "Warehouse",
  "Long Term Care Facility",
  "Retail Mall/Plaza",
  "Crematorium/Cemetary Structure",
  "Home for the Aged",
  "Medical/Dental Office",
  "Nursing Home Facility",
  "Performing Arts Centre",
  "Restaurant Greater Than 30 Seats",
  "Stacked Townhouses",
  "Television Studio(no audience)",
  "2 Unit - Semi-detached",
  "2 Unit - Townhouse",
  "3+ Unit - Detached",
  "Club",
  "Gas Station/Car Wash/Repair Garage",
  "Indoor Swimming Pool",
  "Industrial Manufacturing Plant",
  "Industrial Warehouse/Hazardous Building",
  "Live/Work Unit",
  "Stadium",
  "Water and Sewage Pumping Stations"
)

# Helper Function
simulate_POSIXct_dates <- function(n) {
  start_date <- as.POSIXct("2010-02-18")
  end_date <- as.POSIXct("2022-04-06")
  return(as.POSIXct(
    runif(n, min = as.numeric(start_date), max = as.numeric(end_date)),
    origin = "1970-01-01"
  ))
}

# Initialize dataframe with base data
n_sim_perm <- 100

simulated_data <- data.frame(
  REVISION_NUM = rpois(n_sim_perm, 0.04),
  PERMIT_TYPE = sample(permit_types, n_sim_perm, replace = TRUE),
  STRUCTURE_TYPE = sample(structure_types, n_sim_perm, replace = TRUE),
  APPLICATION_DATE = simulate_POSIXct_dates(n_sim_perm),
  ISSUED_DATE = simulate_POSIXct_dates(n_sim_perm),
  COMPLETED_DATE = simulate_POSIXct_dates(n_sim_perm), # real data will have NAs here
  STATUS = sample(statuses, n_sim_perm, replace = TRUE),
  POSTAL_AREA = sample(CFSAs, n_sim_perm, replace = TRUE),
  GREEN_ROOF_AREA = runif(n_sim_perm, min = 0.5, max = 3000)
)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
