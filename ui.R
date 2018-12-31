# This is the user-interface definition of a Shiny web application.

library(shiny)
library(leaflet)
library(readxl)

# load the dataset
data <- read_xls('whc-sites-2018.xls')
data <- data[c('name_en',
               'short_description_en',
               'longitude',
               'latitude',
               'category',
               'states_name_en')]

# Define UI for application that generates the map
shinyUI(fluidPage(
  
  # Application title
  titlePanel("UNESCO World Heritage Sites"),
  
  # Sidebar with a list input for selecting the country
  sidebarLayout(
    sidebarPanel(
      
      selectInput("country", "Country:", 
                  choices = unique(data$states_name_en))
    ),
    
    # Show a leaflet map
    mainPanel(
      leafletOutput("my_map", width = "100%", height = 600)
    )
  )
))
