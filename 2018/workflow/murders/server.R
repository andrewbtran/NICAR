#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(tidyverse)
library(rgdal)
library(leaflet)
library(readr)
library(tigris)
library(stringr)
library(DT)
#data <- read_csv("data/data.csv")
#counties_agg <- read_csv("data/counties_agg_2006.csv")


files = list.files("data_partition", pattern="*.csv")

for (i in 1:length(files)) {
  file_x <- read_csv(paste0("data_partition", "/", files[i]))
  if (i ==1) {
    data <- file_x
  } else {
    data <- rbind(data, file_x)
  }

}

counties_map <- readOGR("maps", "counties")
states_map <- readOGR("maps", "states")

#counties_merged_map <- geo_join(counties_map, counties_agg, "GEOID", "CNTYFIPS")

#counties_merged_map <- subset(counties_merged_map, !is.na(serial))

#pal_sb <- colorNumeric("PuRd", domain=counties_merged_map$serial)




library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$murdermap <- renderLeaflet({
    
    spots_counties <- data %>%
      group_by(murdgrp_cnty, agegroup_label, VicSex_label, county_name, Weapon_label, CNTYFIPS) %>%
      filter(Year>=input$years[1] & Year <=input$years[2]) %>% 
      summarize(total=n(), solved=sum(Solved_value)) %>%
      mutate(percent=round(solved/total*100,2)) %>%
      filter(VicSex_label=="Female", murdgrp_cnty>0, percent <=input$threshold) %>% 
      mutate(unsolved=total-solved) %>% 
      filter(unsolved!=1) %>% 
      arrange(desc(unsolved))
    
    
    uniques <- unique(spots_counties$CNTYFIPS)
    
    for (i in 1:length(uniques)) {
      filtered <- filter(spots_counties, CNTYFIPS==uniques[i])
      
      for (x in 1:nrow(filtered)) {
        if (x==1) {
          popuptxt <- paste0("<strong>", filtered$county_name[x], "</strong><br />", filtered$agegroup_label[x]," | ", filtered$Weapon_label[x], ": ", filtered$unsolved[x])
        } else {
          popuptxt <- paste0(popuptxt, "<br />",  filtered$agegroup_label[x]," | ", filtered$Weapon_label[x], ": ", filtered$unsolved[x])
        }
      }
      the_join <- data.frame(id=uniques[i], popuptxt)
      if (i == 1) {
        for_join <- the_join
      } else {
        for_join <- rbind(for_join, the_join)
      }
    }
    
    for_join$id <- as.character(for_join$id)
    for_join <- arrange(for_join, desc(id))
    
    
    counties_agg <- data %>%
      group_by(murdgrp_cnty, agegroup_label, VicSex_label, county_name, Weapon_label, CNTYFIPS) %>%
      filter(Year>=input$years[1] & Year <=input$years[2]) %>% 
      summarize(total=n(), solved=sum(Solved_value)) %>%
      mutate(percent=round(solved/total*100,2)) %>%
      filter(VicSex_label=="Female", murdgrp_cnty>0, percent <=input$threshold) %>% 
      mutate(unsolved=total-solved) %>% 
      filter(unsolved!=1) %>% 
      arrange(desc(unsolved)) %>% 
      group_by(county_name, CNTYFIPS) %>% 
      summarize(serial=n()) %>%
      arrange(desc(as.character(CNTYFIPS)))
    
    counties_agg <- data.frame(counties_agg)
    counties_agg <- left_join(counties_agg, for_join, by=c("CNTYFIPS"="id"))
    
    counties_agg$CNTYFIPS <- str_trim(counties_agg$CNTYFIPS)
    
    
    counties_merged_map <- geo_join(counties_map, counties_agg, "GEOID", "CNTYFIPS")
    
    counties_merged_map <- subset(counties_merged_map, !is.na(serial))
    
    pal_sb <- colorNumeric("PuRd", domain=counties_merged_map$serial)
    
    
    
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(-98.483330, 38.712046, zoom = 4) %>% 
      # addPolygons(data = counties_map,
      #             color ="#444444",
      #             fillColor = "transparent", 
      #             fillOpacity = 0.9, 
      #             weight = 0.2, 
      #             smoothFactor = 0.5) %>% 
      addPolygons(data = states_map,
                  color ="#444444",
                  fillColor = "transparent", 
                  fillOpacity = 0.9, 
                  weight = 0.5, 
                  smoothFactor = 0.5) %>% 
      addPolygons(data = counties_merged_map, 
                  fillColor = ~pal_sb(counties_merged_map$serial), 
                  fillOpacity = 0.9, 
                  weight = 1, 
                  smoothFactor = 0.2,
                  popup=~popuptxt,
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
      addLegend(pal = pal_sb, 
                values = counties_merged_map$serial, 
                position = "bottomright", 
                title = "Unsolved clusters")
    
  })

  
  output$table <- renderDataTable({
    
    the_end <- data %>%
      group_by(murdgrp_cnty, agegroup_label, VicSex_label, county_name, Weapon_label, CNTYFIPS) %>%
      filter(Year>=input$years[1] & Year <=input$years[2]) %>% 
      summarize(total=n(), solved=sum(Solved_value)) %>%
      mutate(percent=round(solved/total*100,2)) %>%
      filter(VicSex_label=="Female", murdgrp_cnty>0, percent <=input$threshold) %>% 
      mutate(unsolved=total-solved) %>% 
      filter(unsolved!=1) %>% 
      arrange(desc(unsolved)) %>%
      ungroup() %>%
      mutate(State=gsub(".*, ", "", county_name), County=gsub(",.*", "", county_name)) %>%
      mutate(agegroup_label=as.factor(agegroup_label), State=as.factor(State), Weapon_label=as.factor(Weapon_label)) %>% 
      select(`Age Group`=agegroup_label, County, State, Weapon=Weapon_label, Total=total, Solved=solved, `%` = percent, Unsolved=unsolved)
      datatable(the_end, filter = list(position = 'top', clear = FALSE))
  })
  
})
