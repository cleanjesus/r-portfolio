# BC Liquor Store Prices (Shiny)

Interactive Shiny app for exploring BC liquor products: filter by price, product type, and country, then view a histogram of alcohol content plus a results table.

## Question
Given price, type, and country filters, what does the alcohol-content distribution look like, and which products match?

## Data
- [`bcl-data.csv`](bcl-data.csv): about 6,100 products with Type, Subtype, Country, Name, Alcohol_Content, Price, and Sweetness.

## Files
- [`app.R`](app.R): single-file Shiny app (UI + server). Keep `bcl-data.csv` in the same folder.

## How to run
```r
install.packages(c("shiny", "ggplot2", "dplyr", "readr"))
# From this folder:
shiny::runApp()
```

## App features
- Price range slider
- Product type radio buttons (Beer, Refreshment, Spirits, Wine)
- Dynamic country dropdown from the data
- Histogram of `Alcohol_Content` for the filtered set
- Result count text and filtered table

## Skills shown
- Reactive filtering with dplyr
- `renderUI` for data-driven inputs
- ggplot2 plots inside Shiny
- Single-file `app.R` structure
