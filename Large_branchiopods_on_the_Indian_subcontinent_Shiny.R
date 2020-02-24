# Code for Rshiny app
# link for the app: 

# Libraries used

require(tidyverse)
require(leaflet)

# Data 

sp_combo_data<-read.csv("C:/Research_data/Research data/Large Branchiopoda/All Large Branchiopod data/Shinyapp/sp_combined_data.csv")        

species_map_data<-subset(sp_combo_data,select=c(species_name,
                                                   locality,
                                                   latitude,
                                                   longitude,
                                                   family))%>%
    drop_na(.)        

## ui

ui<-shinyUI(pageWithSidebar(
    headerPanel('Distribution of large branchiopods on the Indian subcontinent'),
    sidebarPanel(
        selectInput('species', 
                    'Select species', 
                    as.character(unique(species_map_data$species_name))),
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
             addScaleBar(.,
                         position = 'topright')
     
     })
    }
)
    

# app
    
shinyApp(ui = ui, server = server)


