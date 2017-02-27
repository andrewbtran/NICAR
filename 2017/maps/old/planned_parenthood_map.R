

# Bringing the data in
addresses_now_all <- read.csv("addresses2017.csv", stringsAsFactors=F)

# Alright, need to concatenate (join) a couple columns together to get addresses
addresses_now_all$address <- paste0(addresses_now_all$address_now1, ", ", addresses_now_all$address_now2)

# We need to geolocate the addresses. We can use the ggmap package

library(ggmap)

geo <- geocode(location = addresses_now_all$address, output="latlon", source="google")

# geo <- read.csv("geo.csv")

addresses_now_all$lon <- geo$lon
addresses_now_all$lat <- geo$lat

# Let's put the locations on a map using Leaflet

library(leaflet)

m <- leaflet(data = addresses_now_all) %>% 
  addTiles() %>%
  setView(lng =-72.70190, lat=41.75798, zoom = 5) %>% 
  addCircleMarkers(~lon, ~lat)

m

# it's missing some. leaflet needs all the NAs to be gone

addresses_now_all_no_na <- subset(addresses_now_all, !is.na(lon))

m <- leaflet(data = addresses_now_all_no_na) %>% 
  addTiles() %>%
  setView(lng =-72.70190, lat=41.75798, zoom = 5) %>% 
  addCircleMarkers(~lon, ~lat)

m
library(albersusa)
library(ggplot2)
library(sf)
library(sp)
library(rgeos)
library(maptools)
library(ggplot2)
library(ggalt)
library(ggthemes)
library(viridis)
library(scales)

us <- usa_composite()
us_map <- fortify(us, region="name")


gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill="white")
gg <- gg +  geom_point(data=addresses_now_all, aes(x=lon, y=lat), color="red")
gg <- gg + coord_proj(us_laea_proj) 
gg <- gg + theme_map(base_family="Arial Narrow")

gg
