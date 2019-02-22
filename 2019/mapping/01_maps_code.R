
# If you haven't installed ggplot2 or sf yet, uncomment and run the lines below
#install.packages("ggplot2")
#install.packages("sf")

library(ggplot2)
library(sf)

# If you're using a Mac, uncomment and run the lines below
#options(device = "X11") 
#X11.options(type = "cairo")

fifty_location <- "data/cb_2017_us_state_20m/cb_2017_us_state_20m.shp"
fifty_states <- st_read(fifty_location)

## Mapping a simple shape file

View(fifty_states)

## Map fifty_states


ggplot(fifty_states) + geom_sf()


## Join it to data 

# If you don't have readr installed yet, uncomment and run the line below
#install.packages("readr")

library(readr)
populations <- read_csv("data/acs2016_1yr_B02001_04000US55.csv")

View(populations)

## Join data to blank shapefile and map

ncol(fifty_states)

library(dplyr)

fifty_states <- left_join(fifty_states, populations,
                          by=c("NAME"="name"))

## Did it work? 

ncol(fifty_states)

colnames(fifty_states)

## What are the variables

forty_eight <- fifty_states %>% 
filter(NAME!="Hawaii" & NAME!="Alaska" & NAME!="Puerto Rico")


ggplot(forty_eight) +
geom_sf(aes(fill=B02001001)) +
scale_fill_distiller(direction=1, name="Population") +
labs(title="Population of 48 states", caption="Source: US Census")

## Downloading shape files directly into R

## Downloading Texas

# If you don't have tigris installed yet, uncomment the line below and run
#install.packages("tigris")

library(tigris)

# set sf option

options(tigris_class = "sf")

tx <- counties("TX", cb=T)

#If cb is set to TRUE, download a generalized (1:500k) counties file. Defaults to FALSE (the most detailed TIGER file).

# tx <- readRDS("backup_data/tx.rds")


View(tx)

  ## When we imported the file locally
  
fifty_location <- "data/cb_2017_us_state_20m/cb_2017_us_state_20m.shp"
fifty_states <- st_read(fifty_location)

View(fifty_states)

## Mapping Texas

ggplot(tx) + 
  geom_sf() +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent')) +
  labs(title="Texas counties")


## Downloading Census data into

## Load the censusapi library

# Add key to .Renviron
Sys.setenv(CENSUS_KEY="YOURKEYHERE")
# Reload .Renviron
readRenviron("~/.Renviron")
# Check to see that the expected key is output in your R console
Sys.getenv("CENSUS_KEY")

# If you don't have censusapi installed yet, uncomment the line below and run
#install.packages("censusapi")

library(censusapi)


## Look up Census tables

apis <- listCensusApis()
View(apis)

## Downloading Census data

## Downloading median income

tx_income <- getCensus(name = "acs/acs5", vintage = 2016, 
vars = c("NAME", "B19013_001E", "B19013_001M"), 
region = "county:*", regionin = "state:48")

# tx_income <- readRDS("backup_data/tx_income.rds")



head(tx_income)

## Join and map

# Can't join by NAME because tx_income data frame has "County, Texas" at the end
# We could gsub out the string but we'll join on where there's already a consistent variable, even though the names don't line up

tx4ever <- left_join(tx, tx_income, by=c("COUNTYFP"="county"))

ggplot(tx4ever) + 
  geom_sf(aes(fill=B19013_001E), color="white") +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent')) +
  scale_fill_distiller(palette="Oranges", direction=1, name="Median income") +
  labs(title="2016 Median income in Texas counties", caption="Source: US Census/ACS5 2016")


## Download Census data and shapefiles together


## Load up tidycensus

# if you don't have tidycensus installed yet, uncomment and run the line below

#install.packages("tidycensus")

library(tidycensus)

# Pass it the census key you set up before

census_api_key("YOUR API KEY GOES HERE")


## Getting unmployment figures

jobs <- c(labor_force = "B23025_005E", 
          unemployed = "B23025_002E")

jersey <- get_acs(geography="tract", year=2016, 
                  variables= jobs, county = "Hudson", 
                  state="NJ", geometry=T)

# jersey <- readRDS("backup_data/jersey.rds")

head(jersey)

## Transforming and mapping the data


library(tidyr)

jersey %>% 
  mutate(variable=case_when(
    variable=="B23025_005" ~ "Unemployed",
    variable=="B23025_002" ~ "Workforce")) %>%
  select(-moe) %>% 
  spread(variable, estimate) %>% 
  mutate(percent_unemployed=round(Unemployed/Workforce*100,2)) %>% 
  ggplot(aes(fill=percent_unemployed)) + 
  geom_sf(color="white") +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent')) +
  scale_fill_distiller(palette="Reds", direction=1, name="Estimate") +
  labs(title="Percent unemployed in Jersey City", caption="Source: US Census/ACS5 2016") +
  NULL

## Faceting maps (Small multiples)

racevars <- c(White = "B02001_002", 
              Black = "B02001_003", 
              Asian = "B02001_005",
              Hispanic = "B03003_003")

harris <- get_acs(geography = "tract", variables = racevars, 
                  state = "TX", county = "Harris County", geometry = TRUE,
                  summary_var = "B02001_001", year=2017) 

# harris <- readRDS("backup_data/harris.rds")


## Faceting maps (Small multiples)

head(harris)


## Transforming and mapping the data

library(viridis)

harris %>%
  mutate(pct = 100 * (estimate / summary_est)) %>%
  ggplot(aes(fill = pct, color = pct)) +
  facet_wrap(~variable) +
  geom_sf() +
  coord_sf(crs = 26915) + 
  scale_fill_viridis(direction=-1) +
  scale_color_viridis(direction=-1) +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent')) +
  labs(title="Racial geography of Harris County, Texas", caption="Source: US Census 2010")


## Welcome back Alaska and Hawaii

county_pov <- get_acs(geography = "county",
                      variables = "B17001_002",
                      summary_var = "B17001_001",
                      geometry = TRUE,
                      shift_geo = TRUE) %>% 
  mutate(pctpov = 100 * (estimate/summary_est))

# county_pov <- readRDS("backup_data/county_pov.rds")


ggplot(county_pov) +
  geom_sf(aes(fill = pctpov), color=NA) +
  coord_sf(datum=NA) +
  labs(title = "Percent of population in poverty by county",
       subtitle = "Alaska and Hawaii are shifted and not to scale",
       caption = "Source: ACS 5-year, 2016",
       fill = "% in poverty") +
  scale_fill_viridis(direction=-1)

## leaflet map

library(leaflet)

tx %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons(popup=~NAME)


# Creating a color palette based on the number range in the B19013_001E column
pal <- colorNumeric("Reds", domain=tx4ever$B19013_001E)

# Setting up the pop up text
popup_sb <- paste0("Median income in ", tx4ever$NAME.x, "\n$", as.character(tx4ever$B19013_001E))

# Mapping it with the new tiles CartoDB.Positron
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(-98.807691, 31.45037, zoom = 6) %>% 
  addPolygons(data = tx4ever , 
              fillColor = ~pal(tx4ever$B19013_001E), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2, 
              popup = ~popup_sb) %>%
  addLegend(pal = pal, 
            values = tx4ever$B19013_001E, 
            position = "bottomright", 
            title = "Median income")