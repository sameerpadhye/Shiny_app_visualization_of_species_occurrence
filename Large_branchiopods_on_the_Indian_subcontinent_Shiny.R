# Code for Rshiny app
# link for the app: 

# Libraries used

require(tidyverse)
require(leaflet)
require(DT)
require(shiny)
# Data 

sp_combo_data<-read.csv("C:/Research_data/Research data/Large Branchiopoda/All Large Branchiopod data/Shinyapp/species_map_data.csv")        

species_map_data<-subset(sp_combo_data,select=c(species_name,
                                                locality,
                                                latitude,
                                                longitude,
                                                family,
                                                authors))%>%
    drop_na(.)        %>%
    tidyr::separate(species_name,c("Genus","Species"),
                    sep='_',remove=FALSE)

#write.csv(species_map_data,'species_map_data.csv')

library(shiny)
require(tidyverse)
require(leaflet)

species_map_data<-read.csv("data/species_map_data.csv")   

ui<-shinyUI(pageWithSidebar(
    headerPanel('Distribution of large branchiopods on the Indian subcontinent'),
    sidebarPanel(
        selectInput('species', 
                    'Select species', 
                    as.character(unique(species_map_data$species_name))),
        wellPanel(span(h5(strong("Family:")), h5(textOutput("family_name"))),
                  span(h5(strong("Genus:")),h5(textOutput("genus"))),
                  span(h5(strong("Species:")),h5(textOutput("species"))),
                  span(h5(strong("Author/s:")),h5(textOutput("authors"))))
    ),
    mainPanel(
        leafletOutput("plot1",
                      width = '100%',
                      height = 600)
        
    )
))


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
        
        output$family_name <- renderText({ unique(as.character(data()$family))})
        output$genus <- renderText({ unique(as.character(data()$genus))})
        output$species <- renderText({ unique(as.character(data()$species))})
        output$authors<-renderText({ unique(as.character(data()$authors))})
    }
)

shinyApp(ui = ui, server = server)
