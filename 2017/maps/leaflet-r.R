# Getting started with R Leaflet

# Uncomment and run "install.packages" functions below if you have not yet installed these packages

#install.packages("leaflet")
library(leaflet)

#install.packages("tidyverse")
library(tidyverse)


# Putting a marker on a map

# Initialize and assign m as the leaflet object
m <- leaflet()
# Now add tiles to it
m <- addTiles(m)
# Now, add a marker with a popup
m <- addMarkers(m, lng=-81.655210, lat=30.324303, popup="<b>Hello</b><br><a href='http://ire.org/conferences/nicar2017/'>-NICAR 2017</a>")

# Print out the map
m

# It’s easier to wrap your head around it if you think of coding grammatically. 

# Normal coding in R is rigid declarative sentences: “Bob is 32. Nancy is 4 years younger than Bob.” 

# Coding with the pipe operator: “Nancy is 4 years younger than Bob, who is 32.” 

# Pipes are a comma (or a semi-colon, if you want) that lets you create one long, run-on sentence.

### This is the same code as above but using pipes

m <- leaflet() %>%
addTiles() %>%  
setView(-81.655210, 30.324303, zoom = 16) %>%
addMarkers(lng=-81.655210, lat=30.324303, popup="<b>Hello</b><br><a href='http://ire.org/conferences/nicar2017/'>-NICAR 2017</a>")

# See how the m object is no longer needed to be included in every line except the first? It's just assumed now.

m 

# Multiple locations from a csv

dunkin <- read.csv("data/dunkin.csv", stringsAsFactors=F)

# Bringing in the DataTables package to display the data in a nice format
# install.packages("DT")
library(DT)

# Using the datatable function from the DT package to see the first 6 rows of data
datatable(head(dunkin))

m <- leaflet(dunkin) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                                  attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
  setView(-81.655210, 30.324303, zoom = 8) %>% 
  addCircles(~lon, ~lat, popup=dunkin$type, weight = 3, radius=40, 
             color="#ffa500", stroke = TRUE, fillOpacity = 0.8) 

m

# Let's bring in some competition.

starbucks <- read.csv("data/starbucks.csv", stringsAsFactors=F)

datatable(head(starbucks))

# isolating just the 3 columns we're interested in-- type, lat, and lon
sb_loc <- select(starbucks, type, lat, lon)
dd_loc <- select(dunkin, type, lat, lon)

# joining the two data frames together
ddsb <- rbind(sb_loc, dd_loc)

# creating a coffee color palette
cof <- colorFactor(c("#ffa500", "#13ED3F"), domain=c("Dunkin Donuts", "Starbucks"))

# mapping based on type
m <- leaflet(ddsb) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                                attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
  setView(-81.655210, 30.324303, zoom = 8) %>% 
  addCircleMarkers(~lon, ~lat, popup=ddsb$type, weight = 3, radius=4, 
                   color=~cof(type), stroke = F, fillOpacity = 0.5) 

m

# Add a legend

m <- leaflet(ddsb) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
setView(-81.655210, 30.324303, zoom = 8) %>% 
addCircleMarkers(~lon, ~lat, popup=ddsb$type, weight = 3, radius=4, 
color=~cof(type), stroke = F, fillOpacity = 0.5)  %>%
addLegend("bottomright", colors= c("#ffa500", "#13ED3F"), labels=c("Dunkin'", "Starbucks"), title="Coffee places")

m

## Mapping the end of the universe

# https://www.youtube.com/embed/Mb7qDfIzQRk

# Here's a loop determining the distance between SB locations.

# The code to do so is below, but you can skip ahead to the next chunk 
# Because it will take an hour and 45 minutes to complete 

# Creating a loop to go through the Starbucks dataframe and compare it itself
# Going through each row of SB lat and lon and finding/keeping the SB lat/lon with the shortest distance to it

# First, set up some temp columns
sb_loc$sb_lat <- 0
sb_loc$sb_lon <- 0
sb_loc$feet <- 0
sb_loc$string_check <- paste(sb_loc$lat, sb_loc$lon)

# Now the loop
for (i in 1:nrow(sb_loc)) {
print(paste0(i, " of ", nrow(sb_loc)))
# Looping through the SB dataframe

# slicing out each row
sb_loc_row <- subset(sb_loc[i,])

# Filtering out the sliced out row so it doesn't measure against itself
sb_loc_compare <- subset(sb_loc, string_check!=sb_loc_row$string_check[1])

# Looping through the new SB dataframe
for (x in 1:nrow(sb_loc_compare)) {

# Using the spDistsN1 function which is a little weird because it
#  only works if the lat lon pairs being measured are in a matrix
to_measure_sb <- matrix(c(sb_loc_row$lon[1], sb_loc_compare$lon[x], sb_loc_row$lat[1], sb_loc_compare$lat[x]), ncol=2)
# Comparing the entire matrix to a single row in the matrix
km <- spDistsN1(to_measure_sb, to_measure_sb[1,], longlat=TRUE)
# We only care about the second result sine the first result is always zero
km <- km[2]

# Converting kilometers to feet
feet <- round(km*1000/.3048,2)

# These if statements replace the current SB lat and lon and feet variables 
#  with the first results but replaces that if
#  the feet value is smaller than what's currently in it
if (x==1) {
sb_loc_row$sb_lat <- sb_loc_compare$lat[x]
sb_loc_row$sb_lon <- sb_loc_compare$lon[x]
sb_loc_row$feet <- feet
sb_loc_row$sb_name <- sb_loc_compare$string_check[x]
} else {
if (feet < sb_loc_row$feet) {
sb_loc_row$sb_lat <- sb_loc_compare$lat[x]
sb_loc_row$sb_lon <- sb_loc_compare$lon[x]
sb_loc_row$feet <- feet
sb_loc_row$sb_name <- sb_loc_compare$string_check[x]
}
}
}

# This is rebuilding the dataframe row by row with the new SB dataframe values
if (i==1) {
sb_distances <- sb_loc_row
} else {
sb_distances <- rbind(sb_distances, sb_loc_row)
}
}

# sb_distances <- unique...
write.csv(sb_distances, "data/sb_distances.csv")

### SKIP TO HERE

# Mapping

# Bringing in the dataframe because I don't want to make you wait through a loop
sb_distances <- read.csv("data/sb_distances.csv")

# Arranging and filtering just the 10 locations with the shortest distances
sb_10 <- sb_distances %>%
arrange(feet) %>%
filter(feet > 60) %>%
head(40)

sb_solo <- select(sb_10, lat, lon, feet)
sb_solo2 <- select(sb_10, sb_lat, sb_lon, feet)
colnames(sb_solo2) <- c("lat", "lon", "feet")

sb_again <- rbind(sb_solo, sb_solo2)

# Mapping it
m <- leaflet(sb_again) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
setView(-98.483330, 38.712046, zoom = 4) %>% 
addCircleMarkers(~lon, ~lat, popup=sb_again$feet, weight = 3, radius=4, 
color="#13ED3F", stroke = F, fillOpacity = 0.5)  %>%
addLegend("bottomright", colors= "#13ED3F", labels="Starbucks", title="End of the Universe")


m

# Making choropleths

# To make a choropleth map, you firdst need a shapefile or geojson of the polygons that you're filling in. 

# Polygon stuff from shape file
# install.packages("tigris")
library(tigris)

states <- states(cb=T)

# Let's quickly map that out
states %>% leaflet() %>% addTiles() %>% addPolygons(popup=~NAME)

# Joining data to a shapefile

### Let's make a choropleth map based on number of Starbucks per state

# First, we'll use dplyr to summarize the data
# count by state
sb_state <- starbucks %>%
  group_by(Province) %>%
  summarize(total=n())

# Some quick adjustments to the the dataframe to clean up names
sb_state$type <- "Starbucks"
colnames(sb_state) <- c("state", "total", "type")

# Now we use the Tigris function geo_join to bring together 
# the states shapefile and the sb_states dataframe -- STUSPS and state 
# are the two columns they'll be joined by
states_merged_sb <- geo_join(states, sb_state, "STUSPS", "state")

# Creating a color palette based on the number range in the total column
pal <- colorNumeric("Greens", domain=states_merged_sb$total)

# Getting rid of rows with NA values
states_merged_sb <- subset(states_merged_sb, !is.na(total))

# Setting up the pop up text
popup_sb <- paste0("Total: ", as.character(states_merged_sb$total))

# Mapping it with the new tiles CartoDB.Positron
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(-98.483330, 38.712046, zoom = 4) %>% 
  addPolygons(data = states_merged_sb , 
              fillColor = ~pal(states_merged_sb$total), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2, 
              popup = ~popup_sb) %>%
  addLegend(pal = pal, 
            values = states_merged_sb$total, 
            position = "bottomright", 
            title = "Starbucks")


# What's the problem here. You know what's wrong.

# This is essentially a population map.

# So we need to adjust for population.

# And that's easy to do using the Census API.

# Bringing in Census data via API

# install.packages("devtools")
# devtools::install_github("hrecht/censusapi")

library(censusapi)

# Pulling in the key.R script that has my census api key. 
# It will be disabled after this weekend so get your own
# http://api.census.gov/data/key_signup.html

source("key.R") 

# We won't go over all the functions, but uncomment the lines below to see 
# the available variables 
# vars2015 <- listCensusMetadata(name="acs5", vintage=2015, "v")
# View(vars2015)

# Alright, getting total population by state from the API
state_pop <-  getCensus(name="acs5", 
                        vintage=2015,
                        key=census_key, 
                        vars=c("NAME", "B01003_001E"), 
                        region="state:*")

datatable(head(state_pop))

# Cleaning up the column names
colnames(state_pop) <- c("NAME", "state_id", "population")
state_pop$state_id <- as.numeric(state_pop$state_id)
# Hm, data comes in numbers of fully spelled out, not abbreviations

# Did you know R has its own built in list of State names and State abbreviations?
# Just pull it in this way to create a dataframe for reference

state_off <- data.frame(state.abb, state.name)

# So I needed to create the dataframe above because the Census API data 
# gave me states with full names while the Starbucks data came with abbreviated state names
# So I needed a relationship dataframe so I could join the two

# Cleaning up the names for easier joining
colnames(state_off) <- c("state", "NAME")

# Joining state population dataframe to relationship file
state_pop <- left_join(state_pop, state_off)

# The relationship dataframe didnt have DC or Puerto Rico, so I'm manually putting those in
state_pop$state <- ifelse(state_pop$NAME=="District of Columbia", "DC", as.character(state_pop$state))
state_pop$state <- ifelse(state_pop$NAME=="Puerto Rico", "PR", as.character(state_pop$state))

# Joining Starbucks dataframe to adjusted state population dataframe
sb_state_pop <- left_join(sb_state, state_pop)

# Calculating per Starbucks stores 100,000 residents and rounding to 2 digits
sb_state_pop$per_capita <- round(sb_state_pop$total/sb_state_pop$population*100000,2)

# Eliminating rows with NA
sb_state_pop <- subset(sb_state_pop, !is.na(per_capita))
datatable(head(sb_state_pop))

# Final map


states_merged_sb_pc <- geo_join(states, sb_state_pop, "STUSPS", "state")

pal_sb <- colorNumeric("Greens", domain=states_merged_sb_pc$per_capita)
states_merged_sb_pc <- subset(states_merged_sb_pc, !is.na(per_capita))

popup_sb <- paste0("Per capita: ", as.character(states_merged_sb_pc$per_capita))

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(-98.483330, 38.712046, zoom = 4) %>% 
  addPolygons(data = states_merged_sb_pc , 
              fillColor = ~pal_sb(states_merged_sb_pc$per_capita), 
              fillOpacity = 0.9, 
              weight = 0.2, 
              smoothFactor = 0.2, 
              popup = ~popup_sb) %>%
  addLegend(pal = pal_sb, 
            values = states_merged_sb_pc$per_capita, 
            position = "bottomright", 
            title = "Starbucks<br />per 100,000<br/>residents")

