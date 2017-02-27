


# Measuring distance

# Let's figure out the 10 closest rival stores and map it.

# Loops are slow, so skip the code below and run it later when you have a lot of time (It took my computer an hour and 45 minutes).

# Using the sp package
# install.packages("sp")
library(sp)

# Creating a loop to go through the Starbucks dataframe and compare it to the Dunkin dataframe
# Going through each row of SB lat and lon and finding/keeping the Dunkin lat/lon with the shortest distance to it

# First, set up some temp columns
sb_loc$dd_lat <- 0
sb_loc$dd_lon <- 0
sb_loc$feet <- 0

# Now the loop
for (i in 1:nrow(sb_loc)) {
  print(paste0(i, " of ", nrow(sb_loc)))
  # Looping through the SB dataframe
  
  # slicing out each row
  sb_loc_row <- subset(sb_loc[i,])
  
  # Looping through the DD dataframe
  for (x in 1:nrow(dd_loc)) {
    
    # Using the spDistsN1 function which is a little weird because it
    #  only works if the lat lon pairs being measured are in a matrix
    to_measure_dd <- matrix(c(sb_loc$lon[i], dd_loc$lon[x], sb_loc$lat[i], dd_loc$lat[x]), ncol=2)
    # Comparing the entire matrix to a single row in the matrix
    km <- spDistsN1(to_measure_dd, to_measure_dd[1,], longlat=TRUE)
    # We only care about the second result sine the first result is always zero
    km <- km[2]
    
    # Converting kilometers to feet
    feet <- round(km*1000/.3048,2)
    
    # These if statements replace the current DD lat and lon and feet variables 
    #  with the first results but replaces that if
    #  the feet value is smaller than what's currently in it
    if (x==1) {
      sb_loc_row$dd_lat <- dd_loc$lat[x]
      sb_loc_row$dd_lon <- dd_loc$lon[x]
      sb_loc_row$feet <- feet
    } else {
      if (feet < sb_loc_row$feet) {
        sb_loc_row$dd_lat <- dd_loc$lat[x]
        sb_loc_row$dd_lon <- dd_loc$lon[x]
        sb_loc_row$feet <- feet
      }
    }
  }
  
  # This is rebuilding the dataframe row by row with the new SB dataframe values
  if (i==1) {
    sb_dd_distances <- sb_loc_row
  } else {
    sb_dd_distances <- rbind(sb_dd_distances, sb_loc_row)
  }
}

write.csv(sb_dd_distances, "data/sb_dd_distances.csv")


#![Alright, let's map the rivals.](http://p.o0bc.com/rf/image_360w/Boston/2011-2020/2013/05/31/Boston.com/Regional/Advance/Images/streetrivals-7267-7268.jpg)

# Bringing in the dataframe because I don't want to make you wait through a loop
sb_dd_distances <- read.csv("data/sb_dd_distances.csv")

# Arranging and filtering just the 10 locations with the shortest distances
sb_dd_10 <- sb_dd_distances %>%
  arrange(feet) %>%
  head(10)

sb_solo <- select(sb_dd_10, type, lat, lon, feet)
dd_solo <- select(sb_dd_10, dd_lat, dd_lon, feet)
dd_solo$type <- "Dunkin Donuts"
dd_solo <- select(dd_solo, type, lat=dd_lat, lon=dd_lon, feet)

sb_dd_again <- rbind(sb_solo, dd_solo)

# Mapping it
m <- leaflet(sb_dd_again) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                                       attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
  setView(-98.483330, 38.712046, zoom = 4) %>% 
  addCircleMarkers(~lon, ~lat, popup=sb_dd_again$feet, weight = 3, radius=4, 
                   color=~cof(type), stroke = F, fillOpacity = 0.5)  %>%
  addLegend("bottomright", colors= c("#ffa500", "#13ED3F"), labels=c("Dunkin'", "Starbucks"), title="Closest rivals")


m
