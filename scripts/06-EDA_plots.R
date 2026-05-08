#### Preamble ####
# Purpose: Explore the "Building Permits - Green Roofs" with figures and tables
# Author: Benedict Cummins-Mburu
# Last Updated: 7 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
library(forcats)
library(canadianmaps)
library(scales)
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

### Distribution of Structure Types ###

educational_structures <- c(
  "Elementary School",
  "University",
  "College/Trade/Tech School/Training Cent.",
  "Secondary School"
)
mixed_use_structures <- c(
  "Mixed Use/Res w Non Res",
  "Multiple Use/Non Residential",
  "Multiple Unit Building"
)

residential_structures <- c(
  "Apartment Building",
  "Student Residence",
  "SFD - Detached",
  "SFD - Semi-Detached",
  "2 Unit - Detached",
  "SFD - Townhouse",
  "Home for the Aged",
  "Nursing Home Facility",
  "Stacked Townhouses",
  "2 Unit - Semi-detached",
  "2 Unit - Townhouse",
  "3+ Unit - Detached",
  "Long Term Care Facility",
  "Laneway / Rear Yard Suite"
)
industrial_structures <- c(
  "Industrial",
  "Industrial Manufacturing Plant",
  "Industrial Processing Plant",
  "Industrial Warehouse/Hazardous Building",
  "Water and Sewage Pumping Stations",
  "Warehouse"
)
business_related_structures <- c(
  "Retail Store",
  "Car Dealership",
  "Motel/Hotel",
  "Retail Mall/Plaza",
  "Medical/Dental Office",
  "Restaurant Greater Than 30 Seats",
  "Television Studio(no audience)",
  "Gas Station/Car Wash/Repair Garage"
)
transportation_structures <- c(
  "Parking Garage",
  "Transit Station,Subway, Bus Terminal"
)

structure_distribution <- analysis_data %>%
  mutate(
    STRUCTURE_TYPE_GROUP = case_when(
      STRUCTURE_TYPE %in% educational_structures ~ "Education",
      STRUCTURE_TYPE %in% mixed_use_structures ~ "Mixed Use",
      STRUCTURE_TYPE %in% residential_structures ~ "Residential",
      STRUCTURE_TYPE %in% industrial_structures ~ "Industrial",
      STRUCTURE_TYPE %in% business_related_structures ~ "Private Business",
      STRUCTURE_TYPE %in% transportation_structures ~ "Transportation",

      TRUE ~ "Other"
    )
  )
structure_distribution %>%
  ggplot() +
  geom_bar(aes(x = fct_infreq(STRUCTURE_TYPE_GROUP))) +
  theme_classic() +
  xlab("Structure Type") +
  ylab("Count") +
  theme(
    axis.title.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold")
  )

### TIME: Cummulative Distribution of Green-Roof Permit Application Dates ###

analysis_data %>%
  arrange(APPLICATION_DATE) %>%
  ggplot(aes(x = APPLICATION_DATE)) +
  stat_ecdf(
    aes(y = after_stat(y) * nrow(analysis_data)),
    geom = "step",
    color = "cornflowerblue",
    linewidth = 1
  ) +
  scale_x_datetime(
    date_breaks = "5 years",
    date_labels = "%Y",
    expand = c(0, 0)
  ) +
  theme_classic() +
  theme(
    panel.grid.major.y = element_line(color = "grey90"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.x = element_text(face = "bold", size = 16),
    axis.title.y = element_text(face = "bold", size = 16)
  ) +
  labs(y = "Cumulative Number of Permits Applications", x = "Time (Years)")

### TIME: Cummulative Distribution of Completed Green-Roof Projects ###

analysis_data %>%
  filter(STATUS == "Closed") %>%
  pivot_longer(
    cols = c(APPLICATION_DATE, ISSUED_DATE, COMPLETED_DATE),
    names_to = "Date_Type",
    values_to = "Date_Value"
  ) %>%
  filter(!is.na(Date_Value)) %>%
  ggplot(aes(x = Date_Value, color = Date_Type)) +
  stat_ecdf(
    aes(y = after_stat(y) * (nrow(analysis_data))),
    geom = "step",
    linewidth = 1
  ) +
  scale_x_datetime(
    date_breaks = "5 years",
    date_labels = "%Y",
    expand = c(0, 0)
  ) +
  scale_color_manual(
    values = c(
      "APPLICATION_DATE" = "cornflowerblue",
      "ISSUE_DATE" = "orange",
      "COMPLETION_DATE" = "forestgreen"
    ),
    labels = c("Application", "Completion", "Issuance")
  ) +
  theme_classic() +
  theme(
    panel.grid.major.y = element_line(color = "grey95"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  ) +
  labs(
    title = "Green-Roof Permit Lifecycle: Cumulative Growth",
    x = "Year",
    y = "Cumulative Count of Permits",
    color = "Permit Stage"
  )

### TIME: Distribution of Application -> Completion Lifecycles ###

analysis_data %>%
  mutate(
    LIFECYCLE = (1 / 365) *
      as.numeric(difftime(
        COMPLETED_DATE,
        APPLICATION_DATE,
        units = "days"
      ))
  ) %>%
  mutate(
    LIFECYCLE2 = (1 / 365) *
      as.numeric(difftime(
        ISSUED_DATE,
        APPLICATION_DATE,
        units = "days"
      ))
  ) %>%
  mutate(
    LIFECYCLE3 = (1 / 365) *
      as.numeric(difftime(
        COMPLETED_DATE,
        ISSUED_DATE,
        units = "days"
      ))
  ) %>%
  ggplot() +
  geom_histogram(aes(x = LIFECYCLE3))

### SPACE: Distribution of Green Roofs in Toronto ###

# Setup plotting data
green_roof_distribution <- analysis_data %>%
  mutate(CFSAUID = POSTAL) %>%
  filter(!is.na(CFSAUID)) %>%
  group_by(CFSAUID) %>%
  summarize(COUNT = n(), TOTAL_AREA = sum(GREEN_ROOF_AREA))
MFSA_data_raw <- FSA[str_detect(FSA$CFSAUID, "^M"), c("geometry", "CFSAUID")]
MFSA_data_augmented <- left_join(
  MFSA_data_raw,
  green_roof_distribution,
  by = "CFSAUID"
)
MFSA_data_augmented <- MFSA_data_augmented %>%
  mutate(COUNT = ifelse(is.na(COUNT), 0, COUNT))
# Plot
ggplot() +
  geom_fsa(data = MFSA_data_augmented, fill = "COUNT") +
  theme_classic() +
  labs(
    title = "Toronto FSA Data Distribution",
    subtitle = "Filtered for 'M' Postal Regions"
  )
# Get additional point stats for the largest (identified manually)
most <- c("M5A", 28, 29933.35)
runner_up_total <- c("M2N", 11, 18776.32)
runner_up_count <- c("M5V", 24, 14509.44)


this <- analysis_data[
  analysis_data$APPLICATION_DATE > as.POSIXct("2025-11-01"),
]
