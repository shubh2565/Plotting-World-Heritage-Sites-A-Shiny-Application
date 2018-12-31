# This is the server logic of a Shiny web application.

library(shiny)
library(leaflet)

data <- read_xls('whc-sites-2018.xls')
data <- data[c('name_en',
               'short_description_en',
               'longitude',
               'latitude',
               'category',
               'states_name_en')]

# Define server logic required to generate the map
shinyServer(function(input, output) {
   
  output$my_map <- renderLeaflet({
    
    data <- subset(data, states_name_en == input$country) 
    content <- paste(sep = "<br/>",
                     paste('<b style="color:grey;">',data$name_en,'</b>'),
                     data$short_description_en,
                     paste('Category: ', '<i style="color:blue;">', data$category, '</i>'))
    
    data["information"] <- content
    
    # making groups
    natural <- subset(data, category == 'Natural')
    cultural <- subset(data, category == 'Cultural')
    mixed <- subset(data, category == 'Mixed')
    
    
    my_map <- leaflet() %>%
      addTiles() %>%
    
      # Add two tiles
      addProviderTiles("Esri.WorldImagery", group="background 1") %>%
      addTiles(options = providerTileOptions(noWrap = TRUE), group="background 2") %>%
      
      # Add 3 marker groups
      addCircleMarkers(data = natural,
                       lng = ~longitude,
                       lat = ~latitude,
                       radius = 8,
                       color = "black",
                       fillColor = "green",
                       stroke = TRUE,
                       fillOpacity = 0.9,
                       group = "Natural",
                       popup = ~information) %>%
      addCircleMarkers(data = cultural,
                       lng = ~longitude,
                       lat = ~latitude,
                       radius = 8,
                       color = "black",
                       fillColor = "red",
                       stroke = TRUE,
                       fillOpacity = 0.9,
                       group = "Cultural",
                       popup = ~information) %>%
      addCircleMarkers(data = mixed,
                       lng = ~longitude,
                       lat = ~latitude,
                       radius = 8,
                       color = "black",
                       fillColor = "orange",
                       stroke = TRUE,
                       fillOpacity = 0.9,
                       group = "Mixed",
                       popup = ~information) %>%
      
      # Add the control widget
      addLayersControl(overlayGroups = c("Natural", "Cultural", "Mixed"),
                       baseGroups = c("background 1","background 2"),
                       options = layersControlOptions(collapsed = FALSE))
    my_map
    
  })
  
})
