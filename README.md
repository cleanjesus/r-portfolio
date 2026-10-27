# R Portfolio

Data visualization and interactive app projects in R for my data visualization course (CECS 450). Each project folder contains the R script, any data sources, and a short write-up.

| Project | Focus | Data |
|---|---|---|
| [walking-dead](walking-dead) | Reshape wide data to long and visualize with ggplot2 | Character kill counts by season (in script) |
| [bcl-shiny](bcl-shiny) | Interactive Shiny app: filter BC liquor products and plot alcohol content | `bcl-data.csv` (~6,100 products) |

## How to run

1. Install [R](https://cran.r-project.org/) and (recommended) [RStudio](https://posit.co/download/rstudio-desktop/).
2. Open a project folder and install packages listed in that project's README.
3. For the Shiny app, open `app.R` and click **Run App**, or run `shiny::runApp()` from that folder.

## Tools

R · ggplot2 · reshape2 · Shiny · dplyr · readr

## Author

Jesus Santiago · [GitHub](https://github.com/cleanjesus)
