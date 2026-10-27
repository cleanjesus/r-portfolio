###############################################################
#  In-Class Exercise: Build a Shiny App (BC Liquor)
# Instructions:
#   - DO NOT copy/paste from the internet.
#   - Write code where you see: TODO:
#   - Keep this file as a single app.R.
#   - Run the app frequently after each checkpoint.
###############################################################

########################
# Part 0 — Setup (5 min)
########################

# TODO: Load required libraries:
#   - shiny
#   - ggplot2
#   - dplyr
#   - readr
#
# HINT: Use library(packageName)
library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# TODO: Read the CSV into an object called bcl
# HINTS:
#   - Use readr::read_csv()
#   - Put bcl-data.csv in the same folder as this app.R
#   - If you have a path issue, use getwd() to check your working directory
bcl <- read_csv("bcl-data.csv")

# TODO: Inspect the dataset so you know column names
# HINTS:
#   - Use names(bcl) or glimpse(bcl)
#   - Make sure you see at least: Price, Type, Country, Alcohol_Content
names(bcl)
glimpse(bcl)
View(bcl)

#############################################
# Part 1 — Shiny skeleton (Checkpoint A) 10 m
#############################################

# TODO: Create the UI object named ui
# HINTS:
#   - Use fluidPage()
#   - Add a titlePanel() with title "BC Liquor Store Prices"
#   - Later you will add window = "CS614 Lecture 7"
ui <- fluidPage(
  titlePanel("BC Liquor Store Prices", window = "bcl_app"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min = 0, max = 100, value = c(10,20), pre = "$"),
      radioButtons("typeInput", "Product Type", choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"), selected = "WINE"),
      uiOutput("countryOutput")
    ),
    mainPanel(

      plotOutput("coolplot"),
      textOutput("nrow"),
      tableOutput("results")
    )
  )
)

# TODO: Create the server function
# HINTS:
#   - server <- function(input, output) { ... }
#   - Leave it empty for now
server <- function(input, output) {
  output$countryOutput <- renderUI({
    selectInput(
      inputId = "countryInput",
      label = "Country",
      choices = sort(unique(bcl$Country)),
      selected = "CANADA"
    )
  })
  output$coolplot <- renderPlot({
    data <- filtered()
    
    if (is.null(data)) {
      return()
    }
    
    ggplot(data, aes(x = Alcohol_Content)) +
      geom_histogram()
  })
  output$nrow <- renderText({
    data <- filtered()
    
    if (is.null(data)) {
      return("Based on your criteria, there were 0 results found.")
    }
    
    paste(
      "Based on your criteria, there were",
      nrow(data),
      "results found."
    )
  })
  
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    bcl %>%
      filter(
        Price >= input$priceInput[1],
        Price <= input$priceInput[2],
        Type == input$typeInput,
        Country == input$countryInput
      )
  })
  output$results <- renderTable({
    filtered()
  })
}

# TODO: Call shinyApp(ui = ui, server = server)
# CHECKPOINT A:
#   - App runs and shows a title
shinyApp(ui = ui, server = server)


##################################################
# Part 2 — Layout + Inputs (Checkpoint B) 15–20 m
##################################################

# TODO: Update ui to use sidebarLayout:
#   - sidebarPanel() for inputs
#   - mainPanel() for outputs
#
# HINT: Put these inside fluidPage()

# --- Input 1: price slider ---
# TODO: Add a sliderInput() to sidebarPanel
# Requirements:
#   - inputId: "priceInput"
#   - label: "Price"
#   - min: 0, max: 100
#   - value is a RANGE: c(10, 20)
#   - prefix "$"
#
# CHECKPOINT B1:
#   - Slider appears and you can drag both ends (range)

# --- Input 2: product type radio buttons ---
# TODO: Add radioButtons() under the sliderInput
# Requirements:
#   - inputId: "typeInput"
#   - label: "Product type"
#   - choices: BEER, REFRESHMENT, SPIRITS, WINE
#   - default selected: WINE
#
# CHECKPOINT B2:
#   - Radio buttons appear and switch correctly


####################################################
# Part 3 — First Output: a table (Checkpoint C) 15 m
####################################################

# TODO: In mainPanel, add a tableOutput() placeholder
# Requirements:
#   - outputId: "results"
#
# HINT: mainPanel(tableOutput("results"))

# TODO: In server, create a reactive() called filtered
# filtered should filter bcl based on:
#   - Price range: between input$priceInput[1] and input$priceInput[2]
#   - Type equals input$typeInput
#
# HINTS:
#   - filtered <- reactive({ ... })
#   - Use dplyr::filter()
#   - Remember: input$priceInput is a length-2 vector (min, max)

# TODO: In server, create output$results using renderTable()
# It should display the filtered dataset
#
# CHECKPOINT C:
#   - Table updates when you move slider or change type


#############################################################
# Part 4 — Dynamic Country Input with uiOutput (Checkpoint D)
# 15–20 m
#############################################################

# GOAL:
#   - Country dropdown appears based on the data
#   - User chooses a country, and filtering includes it
#
# Why dynamic?
#   - The UI choices come from bcl$Country, which is data-driven.

# TODO: Add uiOutput("countryOutput") inside sidebarPanel
# Place it UNDER the radioButtons

# TODO: In server, create output$countryOutput using renderUI()
# It must generate a selectInput with:
#   - inputId: "countryInput"
#   - label: "Country"
#   - choices: all unique countries from bcl$Country, sorted
#   - selected: "CANADA"
#
# HINTS:
#   - unique(bcl$Country)
#   - sort(...)
#   - renderUI({ selectInput(...) })

# TODO: Update filtered() to also filter by:
#   - Country equals input$countryInput
#
# IMPORTANT NULL GUARD:
#   - If input$countryInput is NULL, return NULL
#   - This prevents errors at app startup
#
# CHECKPOINT D:
#   - Country dropdown appears
#   - Table updates when country changes


#########################################################
# Part 5 — Plot + Result Count Text (Checkpoint E) 15–20 m
#########################################################

# TODO: In mainPanel, add:
#   - plotOutput("coolplot")
#   - textOutput("nrow")
#   - (keep the tableOutput("results") below them)
#
# HINT:
#   - Use br() to add spacing if you want

# TODO: In server, create output$coolplot using renderPlot()
# The plot should be a histogram of Alcohol_Content using ggplot2
#
# REQUIREMENTS:
#   - Use filtered() as the dataset
#   - Map x aesthetic to Alcohol_Content
#   - Use geom_histogram()
#
# IMPORTANT:
#   - If filtered() is NULL, return early (no plot)
#
# HINTS:
#   - if (is.null(filtered())) return()
#   - ggplot(data, aes(...)) + geom_histogram()

# TODO: In server, create output$nrow using renderText()
# It should show:
#   "Based on your criteria, there were <N> results found."
# where N is the number of rows in filtered()
#
# IMPORTANT:
#   - If filtered() is NULL, decide what to do:
#       Option A: show 0 results
#       Option B: return() until available
#
# CHECKPOINT E (FINAL):
#   - Slider + radio + country all work
#   - Histogram updates
#   - Text count updates
#   - Table updates


########################################
# Part 6 — Finish-early challenges (opt)
########################################

# Pick ONE (or more) if you finish early.

# Challenge 1 (easy): Sort results by Price (descending)
# TODO: In filtered(), after filtering, arrange by Price descending

# Challenge 2 (easy): Show only top 10 rows in the table
# TODO: In renderTable(), show only first 10 rows

# Challenge 3 (medium): Add checkbox to keep only Alcohol_Content > 0
# TODO:
#   - Add checkboxInput("onlyAlcohol", "Only alcoholic products", value = TRUE)
#   - In filtered(), if checked, filter Alcohol_Content > 0

# Challenge 4 (medium): Add bins slider for histogram
# TODO:
#   - Add sliderInput("bins", "Histogram bins", min=5, max=50, value=15)
#   - Use geom_histogram(bins = input$bins)


###############################################################
# Submission checklist:
#   1) app.R runs
#   2) Screenshot of the running app
#   3) 1–2 sentences: What does reactive() do in this app? After google searches and AI tutoring, reactive() wraps the filtering logic so it only reruns when priceInput, typeInput, or countryInput change, and caches the result so all three outputs (coolplot, nrow, results) can reuse it without re-filtering the data separately.
#.    
###############################################################
