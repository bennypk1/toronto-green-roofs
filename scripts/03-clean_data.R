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
acceptable_permit_statuses <- c(
  # all observed except "Cancelled"
  "Closed",
  "Inspection",
  "Revision Issued",
  "Examiner's Notice Sent",
  "Permit Issued",
  "Under Review",
  "Refusal Notice",
  "Response Received",
  "Work Not Started",
  "Issuance Pending",
  "Ready for Issuance",
  "Pending Cancellation",
  "Revocation Pending"
)
# Data Filtering and Type-assigning
cleaned_data <- raw_data %>%
  select(all_of(focal_column_names)) %>%
  mutate(
    APPLICATION_DATE = as.POSIXct(APPLICATION_DATE),
    ISSUED_DATE = as.POSIXct(ISSUED_DATE),
    COMPLETED_DATE = as.POSIXct(COMPLETED_DATE),
  ) %>%
  filter(ECO_ROOF == "FALSE", ) %>% # disregarding 41 eco roof permits ; outside of project scope
  filter(PERMIT_NUM != "23 153544") %>% # removes 5 rows corresponding to a problematic set of duplicate permit numbers
  filter(STATUS %in% acceptable_permit_statuses) %>% # removes definitively "Cancelled" permits
  mutate(ID = paste0(PERMIT_NUM, "_", REVISION_NUM)) %>% # checked: # unique IDs = # rows
  select(c(-ECO_ROOF))

# Notes:
#   - All "Closed" entries have completion dates, all non-closed entries do not
#   - All "Closed" entries have "Issue" and "Application" dates (apart from 18 140369 ; missing "Issue date")
#   - All entries have application dates
#.  - TOCHECK: There is a clear divide among non-closed statuses; those with issue dates and those without

# Issues:
# - A single entry is marked as "Closed" but does not have a completion or issue date. It is kept in the dataset for now.
# - 28 closed permits have a recorded green roof area of 0 for no clear reason
# - 28 closed permits are revisions of previously closed permits

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
