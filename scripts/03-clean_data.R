#### Preamble ####
# Purpose: Cleans and saves the raw "Building Permits - Green Roofs" dataset downloaded from Open Data Toronto
# Author: Benedict Cummins-Mburu
# Last Updated: 11 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
library(sf)
library(geojsonsf)
library(canadianmaps) # contains the "FSA" object used in this file
GR_raw_data <- read_csv("data/01-raw_data/GR_raw_data.csv")
GS_raw_data <- read_csv("data/01-raw_data/GS_raw_data.csv")

#### Clean Green Roof Data ####

GR_focal_column_names <- c(
  "PERMIT_NUM",
  "REVISION_NUM",
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
GR_cleaned_data <- GR_raw_data %>%
  select(all_of(GR_focal_column_names)) %>%
  mutate(
    APPLICATION_DATE = as.POSIXct(APPLICATION_DATE),
    ISSUED_DATE = as.POSIXct(ISSUED_DATE),
    COMPLETED_DATE = as.POSIXct(COMPLETED_DATE)
  ) %>%
  filter(STATUS %in% acceptable_permit_statuses) %>% # removes definitively "Cancelled" permits
  mutate(ID = paste0(PERMIT_NUM, "_", REVISION_NUM)) %>% # checked: # unique IDs = # rows
  mutate(CFSAUID = POSTAL, G_AREA = GREEN_ROOF_AREA) # standard naming for map plots
# Addressing Specific Anomalies
for_imputation <- mean(GR_cleaned_data$ISSUED_DATE, na.rm = TRUE)
GR_cleaned_data <- GR_cleaned_data %>%
  filter(PERMIT_NUM != "23 153544") # removes 5 rows corresponding to a problematic set of duplicate permit numbers
GR_cleaned_data[
  GR_cleaned_data$PERMIT_NUM == "18 140369",
  "ISSUED_DATE"
] <- for_imputation # imput an issued date ; likely missing by accident.

#### Clean Green Roof Data ####

# Geometry Parsing Helper
FSA_2952_version <- st_transform(FSA, 2952) # Convert `canadianmaps` FSA reference to 2952 standards
extract_spatial_info <- function(geom_string) {
  # Get centroid and area of polygon
  poly_sf <- geojson_sf(geom_string) %>% # Warning here is fine
    st_set_crs(2952)
  centroid_pt <- st_centroid(poly_sf)
  centroid_google <- st_transform(centroid_pt, 4326)

  coords_2952_version <- st_coordinates(centroid_pt)
  coords_google <- st_coordinates(point_google) # Save the coordinates in Lat, Lon format so they can be easily visualized in Google Maps (for data validation)

  poly_area <- as.numeric(st_area(poly_sf)) # unit: m^2

  # Assignm polygon to an FSA
  intersections <- st_intersection(poly_sf, FSA_2952_version)
  if (nrow(intersections) == 0) {
    main_fsa <- NA
  } else {
    intersections$overlap_area <- st_area(intersections) # Calculate area of each overlap piece and pick the largest
    main_fsa <- intersections %>%
      slice_max(overlap_area, n = 1, with_ties = FALSE) %>%
      pull(CFSAUID)
  }
  # Return a named list of relevant variables
  return(list(
    GREEN_SPACE_AREA = poly_area,
    CFSAUID = main_fsa,
    CENTROID_DEG_LAT = as.numeric(coords_google[1, "Y"]),
    CENTROID_DEG_LON = as.numeric(coords_google[1, "X"])
  ))
}
# Data Filtering and Selection
GS_cleaned_data <- GS_raw_data %>%
  mutate(ID = X_id) %>% # just to keep naming consistent in cleaned datasets
  select(c("ID", "geometry"))
# Parsing Geometry (takes ~ 5 minutes to run)
GS_cleaned_data <- GS_cleaned_data %>%
  mutate(spatial_results = map(geometry, ~ extract_spatial_info(.x))) %>%
  unnest_wider(spatial_results)
# TODO: rerun and place this line in the correct sub-section
GS_cleaned_data <- GS_cleaned_data %>% mutate(G_AREA = GREEN_SPACE_AREA)

# Notes:
#   - checked by manual seaerching that names or descriptions do not contain "Roof", so we havd confidence that green roofs are not present in the dataset (this is good)
#   - confirmed manually that all IDs are, in fact, unique.
#.  - TODO: green spaces data LAT and LON columns are currently bugged (doesn't matter for analysis though)

# - A single entry is marked as "Closed" but does not have a completion or issue date. It is kept in the dataset for now.
# - 28 closed permits have a recorded green roof area of 0 for no clear reason
# - 28 closed permits are revisions of previously closed permits

#### Save data ####
write_csv(GR_cleaned_data, "data/02-analysis_data/GR_analysis_data.csv")
write_csv(GS_cleaned_data, "data/02-analysis_data/GS_analysis_data.csv")
