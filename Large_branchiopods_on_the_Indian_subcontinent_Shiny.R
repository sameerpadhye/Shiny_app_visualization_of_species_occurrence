# Code for Rshiny app


# link for the app: 

library(shiny)
require(tidyverse)
require(leaflet)

species_map_data<-read.csv("data/species_map_data.csv")   


ui<-shinyUI(fluidPage(
    headerPanel('Distribution of large branchiopods on the Indian subcontinent'),
    
    br(),
    br(),
    
    sidebarPanel(
        selectInput(selected = NULL,
                    'species', 
                    h4(strong("Select species")), 
                    as.character(unique(sort(species_map_data$species_name)))),
        br(),
        br(),
        wellPanel(span(h4(strong("Family:")), h5(textOutput("family_name"))),
                  br(),
                  span(h4(strong("Genus:")),h5(em(textOutput("genus")))),
                  br(),
                  span(h4(strong("Species:")),h5(em(textOutput("species")))),
                  br(),
                  span(h4(strong("Author/s:")),h5(textOutput("authors")))),
        
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
        
        
        output$plot1 <- renderLeaflet({data()%>%
                leaflet() %>%
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


