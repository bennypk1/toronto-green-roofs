#### Preamble ####
# Purpose: Explore the spatial distribution of Green Roofs and Green Spaces in Toronto.
# Author: Benedict Cummins-Mburu
# Last Updated: 12 May 2026
# Contact: b.cumminsmburu@utoronto.ca
# License: MIT

#### Setup ####
library(tidyverse)
GR_analysis_data <- read_csv("data/02-analysis_data/GR_analysis_data.csv")
GS_analysis_data <- read_csv("data/02-analysis_data/GS_analysis_data.csv")
summary_analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

##### FSA MAPPING FUNCTION #####

plot_fsa <- function(the_data, fill_var, legend_title = fill_var) {
  is_count_var <- grepl("COUNT$", fill_var)
  target_trans <- if (is_count_var) "identity" else "pseudo_log"
  target_high <- if (is_count_var) "#2f2f2f" else "#006d2c"
  p <- ggplot(data = the_data) +
    geom_fsa(data = the_data, fill = fill_var) +
    # Professional Green Scale
    scale_fill_gradient(
      low = "#e5f5e0",
      high = target_high,
      trans = target_trans,
      na.value = "grey90",
      labels = label_comma()
    ) +
    theme_void() +
    labs(fill = legend_title) +
    theme(
      legend.position = "right",
      legend.title = element_text(size = 7),
      legend.text = element_text(size = 6),
      legend.key.size = unit(0.4, "cm")
    )

  return(p)
}

#### FOCAL SCATTERPLOT ####

plotting_data <- data.frame(
  logGRCoverage = log(summary_analysis_data$GREEN_ROOF_COVERAGE),
  logGSCoverage = log(summary_analysis_data$GREEN_SPACE_COVERAGE)
)
Figure_3 <- plotting_data %>%
  ggplot(aes(x = logGSCoverage, y = logGRCoverage)) +
  geom_point(
    shape = 21,
    fill = "#327534",
    size = 3.5,
    alpha = 0.75,
    stroke = 0.4
  ) +
  scale_x_continuous(expand = expansion(mult = 0.03)) +
  scale_y_continuous(expand = expansion(mult = 0.03)) +
  labs(
    x = "log(Green Space Coverage)",
    y = "log(Green Roof Coverage)",
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.caption = element_text(color = "grey60", size = 9, hjust = 0),
    axis.title = element_text(color = "grey30", size = 11),
    axis.text = element_text(color = "grey50"),
    plot.margin = margin(16, 16, 12, 16)
  )

### SAVE PLOTS ###

saveRDS(plot_fsa, "plots/figures/plot_fsa.rds")
saveRDS(Figure_3, "plots/figures/Figure_3.rds")
