# Code for Rshiny app


# link for the app: 

library(shiny)
require(tidyverse)
require(leaflet)
require(shinythemes)

species_map_data<-read.csv("data/species_map_data.csv")   


ui<-shinyUI(fluidPage(theme = shinytheme("darkly"),
                      headerPanel('Distribution of large branchiopods on the Indian subcontinent'),
                      
                      br(),
                      br(),
                      
                      sidebarPanel(
                          selectInput(selected = NULL,
                                      'species', 
                                      h3(strong("Select species")), 
                                      as.character(unique(sort(species_map_data$species_name)))),
                          br(),
                          br(),
                          wellPanel(span(h4(strong("Family:")), h4(textOutput("family_name"))),
                                    br(),
                                    span(h4(strong("Genus:")),h4(em(textOutput("genus")))),
                                    br(),
                                    span(h4(strong("Species:")),h4(em(textOutput("species")))),
                                    br(),
                                    span(h4(strong("Author/s:")),h4(textOutput("authors")))),
                          
                      ),
                      
                      mainPanel(
                          leafletOutput("plot1",
                                        width = '100%',
                                        height = 600)
                          
                      )
))

## server

server<-shinyServer(
    function(input,output){
        
        data<- reactive({species_map_data[species_map_data$species_name == input$species,]})
        
        india_map<-readOGR("C:/Research_data/GIS_data/GIS_layers/India_DataLayers/IND_adm/INDSTATE_region.shp")        
        
        output$plot1 <- renderLeaflet({data()%>%
                leaflet() %>%
                addPolygons(data=india_map,color = 'black',weight = 2, smoothFactor = 0.5,
                            opacity = 0.5, fillOpacity = 0)%>%
                addProviderTiles("Stamen.Terrain") %>%
                addCircleMarkers(
                    stroke = TRUE,
                    color = "black",
                    fillOpacity = 1,
                    fillColor = "orange",
                    lng = ~longitude, 
                    lat = ~latitude,
                    label = ~as.character(locality),
                    labelOptions = labelOptions(noHide = FALSE, direction = "bottom",
                                                style = list(
                                                    "color" = "grey50",
                                                    "font-family" = "serif",
                                                    "font-style" = "bold",
                                                    "font-size" = "13px")),
                    
                    radius = 5)%>%
                setView(lng = mean(data()$longitude), lat = mean(data()$latitude), zoom = 05) %>%
                addScaleBar(.,
                            position = 'topright')
            
        })
        
        output$family_name <- renderText({ unique(as.character(data()$family))})
        
        output$genus <- renderText({ unique(as.character(data()$genus))})
        
        output$species <- renderText({ unique(as.character(data()$species))})
        
        output$authors<-renderText({ unique(as.character(data()$authors))})
        
    }
)

shinyApp(ui = ui, server = server)
