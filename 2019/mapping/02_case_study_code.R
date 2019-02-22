#install.packages("tidyverse")
#install.packages("jsonlite")
#install.packages("stringr")

library(tidyverse)
library(stringr)
library(jsonlite)

json_url <-"http://sbgi.net/resources/assets/sbgi/MetaverseStationData.json"

## If the url above doesn't exist anymore uncomment the line below and run it
# json_url <- "MetaverseStationData.json"

stations <- fromJSON(json_url)

primary_stations <- stations %>% 
filter(Channel=="Primary") %>% 
mutate(
Location=str_replace(Location, "Point \\(", ""),
lon=str_replace(Location, " .*", ""),
lat=str_replace(Location, ".* ", ""),
lat=str_replace(lat, "\\)", ""))

## What have we got

glimpse(primary_stations)

## What can we do with this data?


## Single out the stations

station_latlon <- 
select(primary_stations, DMA_Short, Location, lon, lat) %>%
unique() %>% 
mutate(lon=as.numeric(lon)) %>% 
mutate(lat=as.numeric(lat)) %>% 
filter(!is.na(lon))

glimpse(station_latlon)

## Download map of state boundaries

# if you don't have sf or tigris installled yet, uncomment and run the lines below
# install.packages("sf")
# install.packages("tigris")

library(sf)
library(tigris)

options(tigris_class = "sf")

states <- states(cb=T)

# states <- readRDS("backup_data/stats.rds")


glimpse(states)

## Refining the data


# Filter out some territories and states

states <- filter(states, !STUSPS %in% c("AK", "AS", "MP", "PR", "VI", "HI", "GU"))

# Converting the projection to Albers
states <- st_transform(states, 5070)

# Changing the projection of station_latlon so it matches the states sf dataframe map

station_latlon_projected <- station_latlon %>% 
  filter(!is.na(lon)) %>% 
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(states)) %>% 
  st_coordinates(geometry)

station_latlon <- cbind(station_latlon, station_latlon_projected)

ggplot(states) +
geom_sf() +
geom_point(data=station_latlon, aes(x=X, y=Y), color="blue") +
theme_void() +
theme(panel.grid.major=element_line(colour="transparent")) +
labs(title="Station locations")


## Next, figure out the scope


# Fixing a bad data point
primary_stations$DMA_Code <- ifelse(primary_stations$DMA_Short=="Lincoln_NE", 722, primary_stations$DMA_Code)

## Summarizing by DMA
dma_totals <- primary_stations %>% 
group_by(DMA, DMA_Code) %>% 
count() %>% 
arrange(desc(n)) %>% 
ungroup() %>% 
rename(dma_code=DMA_Code) %>% 
mutate(dma_code=as.numeric(dma_code))

head(dma_totals)

## What's the DMA footprint for each station?
  
geo <- st_read("data/dma_2008/DMAs.shp")

# It doesn't have a CRS so we'll assign it one
st_crs(geo) <- 4326

# Converting the projection so it's Albers
geo <- st_transform(geo, 5070)

ggplot(geo) +
  geom_sf(color="red") +
  coord_sf()

## Mapping Sinclair DMAs


# Prepping a column name to join on
geo <- geo %>% 
  mutate(dma_code=as.numeric(as.character(DMA)))

geo <- left_join(geo, dma_totals, by="dma_code") %>% 
  filter(!is.na(n)) 

ggplot() +
  geom_sf(data=states, color="red", fill=NA) +
  geom_sf(data=geo, aes(fill=n)) +
  coord_sf()

## Mapping Sinclair DMAs

# Prepping a column name to join on
geo <- geo %>% 
  mutate(dma_code=as.numeric(as.character(DMA)))


geo <- left_join(geo, dma_totals, by="dma_code") %>% 
  filter(!is.na(n)) 

ggplot() +
  geom_sf(data=states, color="red", fill=NA) +
  geom_sf(data=geo, aes(fill=n)) +
  coord_sf()

# Filtering out locations based on map
cities <- c("Portland", "Seattle", "Butte", "Boise", "Reno", "Fresno", "Bakersfield", 
            "Reno", "Salt Lake City", "Las Vegas", "El Paso", "Austin", "San Antonio",
            "Corpus Christi", "Oklahoma City", "Wichita", "Lincoln", "Sioux City", 
            "Minneapolis", "Green Bay", "Milwaukee", "Des Moines", "Springfield", 
            "St. Louis", "Little Rock", "Flint", "Columbus", "Lexington", "Birmingham",
            "Mobile", "Macon", "Asheville", "Charleston", "Buffalo", "Johnstown", "Baltimore",
            "Norfolk", "Conway", "Savannah", "Gainesville", "West Palm Beach", "Albany",
            "Providence", "Portland")

station_latlon_filtered <- station_latlon %>% 
  mutate(DMA_Short= gsub("_.*", "", DMA_Short)) %>% 
  mutate(DMA_Short= gsub("Bozeman", "Butte", DMA_Short)) %>% 
  mutate(DMA_Short= gsub("Champaign", "Springfield", DMA_Short)) %>% 
  mutate(DMA_Short= gsub("Myrtle Beach", "Conway", DMA_Short)) %>% 
  mutate(DMA_Short= gsub("West Palm", "West Palm Beach", DMA_Short)) %>% 
  filter(DMA_Short %in% cities) %>% 
  group_by(DMA_Short) %>% 
  filter(row_number()==1)

glimpse(station_latlon_filtered)

## Style prep

# Need to create bins for the numbers

geo <- geo %>% 
  mutate(bin=case_when(
    n == 1 ~ "1",
    n == 2 ~ "2",
    n == 3 ~ "3",
    n == 4 ~ "4",
    n >= 5 ~ "5+"
  ))

# install.packages("ggrepel")
library(ggrepel)

# install.packages("shadowtext")
library(shadowtext)



## Final map


ggplot() +
  geom_sf(data=states, color="gray", fill=NA, size=.3) +
  geom_sf(data=geo, aes(fill=bin), color="light gray", size=.2) +
  scale_fill_brewer(palette = "Oranges", name="Number of Sinclair-owned TV stations") +
  geom_point(data=station_latlon_filtered, aes(x=X, y=Y), 
             color="dark gray", fill="white", shape=21) +
  geom_shadowtext(data=station_latlon_filtered, aes(x=X, y=Y, label=DMA_Short), 
 color="black", bg.color="white", vjust=-1, size=2.5) +
  geom_text_repel() +
  coord_sf() +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent'),
        legend.position="top", legend.direction="horizontal") +
  labs(title="Sinclair's nationwide reach",
       subtitle="This map only highlights stations owned outright by Sinclair. 
       It does not include the many stations licensed to other operators but managed by Sinclair.",
       caption="Sources: U.S. Securities and Exchange Commission, Nielsen, Television Bureau of Advertising, GeoCommons")

ggsave("images/sinclair_ggplot.png", width=10, height=6, units="in")
