# install.packages("tigris")
# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("mapproj")
# install.packages("magick")

library(tigris)
library(tidyverse)
library(lubridate)
usmap <- states(cb=T)

# This is a big file. Uncomment and run at your own risk

# plot(usmap)
usfort <- fortify(usmap, region="STUSPS")

library(rgdal)
# For readOGR to work, we'll need to know the folder where the shape file is
# And we also need to know the name of the shapefiles

droughtmap <- readOGR(dsn="shapes/USDM_20160105_M", layer="USDM_20160105")

# Transform the shapefile into a dataframe so we can work with it in R
droughtfort <- fortify(droughtmap, region="DM")

gg <- ggplot() 

# This line will bring in the drought shapefile
gg <- gg +  geom_polygon(data = droughtfort, aes(x=long, y=lat, group=group, fill=id), color = "black", size=0) 
gg

# Mapping the shapefile II

gg <- ggplot() 

# This line will bring in the drought shapefile
gg <- gg +  geom_polygon(data = droughtfort, aes(x=long, y=lat, group=group, fill=id), color = "black", size=0) 

# This line brings in the US borders as a layer
gg <- gg +  geom_polygon(data = usfort, aes(x=long, y=lat, group=group, fill=total), color = "gray73", fill=NA, size=0.2) 

# This sets the boundaries of the view so it excludes Alaska and Hawaii
gg <- gg +  coord_map("polyconic", xlim=c(-125, -70), ylim=c(25.5, 48.5)) 

# This line sets the colors and text for the legend items
gg <- gg +  scale_fill_manual(name="", values = c("#FFFF00", "#FCD37F", "#FFAA00", "#E60000", "#730000"),
labels = c("Abnormal", "Moderate", "Severe", "Extreme", "Exceptional"))

# The rest of the code in this chunk is for blurbs and style.
gg <- gg + labs(x=NULL, y=NULL, 
title="Drought in the U.S.",
# The date is from the file name itself
subtitle="January 5, 2016",
caption="National Drought Mitigation Center (NDMC), \nthe U.S. Department of Agriculture (USDA), \n and the National Oceanic and Atmospheric Association (NOAA)")
gg <- gg + theme(plot.title=element_text(face="bold", family="Lato Regular", size=13))
gg <- gg + theme(plot.caption=element_text(face="bold", family="Lato Regular", size=7, color="gray", margin=margin(t=10, r=80)))
gg <- gg + theme(legend.position="top")
gg <- gg + theme(axis.line =  element_blank(),
axis.text =  element_blank(),
axis.ticks =  element_blank(),
panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank()) 
print(gg)

  
# Loop to create all the maps
  
### What this loop does

# 1. Goes through every single folder in the 'shapes' folder
# 2. Imports the shapefile for that week
# 3. Places the U.S. drought shapefile
# 4. Then places the U.S. borders on top of it
# 5. Saves the image into the us_maps folder

# This will create a folder called "us_maps" to store the png files created

the_path <- getwd()
ifelse(!dir.exists(file.path(the_path, "us_maps")), dir.create(file.path(the_path, "us_maps")), FALSE)

# Compiling a list of the folders in the 'shapes' folder
shape_list <- list.files("shapes")

for (i in 1:length(shape_list)) {

file_name <- shape_list[i]
dsn_name <- paste0("shapes/", file_name)
layer_name <- gsub("_M", "", file_name)
the_date <- gsub("USDM_", "", layer_name)
the_date <- ymd(the_date)
ap_date <- paste0(month(the_date, label=T, abbr=F), " ", day(the_date), ", ", year(the_date))
droughtmap <- readOGR(dsn=dsn_name, layer=layer_name)
droughtfort <- fortify(droughtmap, region="DM")

gg <- ggplot() 
gg <- gg +  geom_polygon(data = droughtfort, aes(x=long, y=lat, group=group, fill=id), color = "black", size=0) 
gg <- gg +  geom_polygon(data = usfort, aes(x=long, y=lat, group=group, fill=total), color = "gray73", fill=NA, size=0.2) 
gg <- gg +  coord_map("polyconic", xlim=c(-125, -70), ylim=c(25.5, 48.5)) 
gg <- gg +  scale_fill_manual(name="", values = c("#FFFF00", "#FCD37F", "#FFAA00", "#E60000", "#730000"),
labels = c("Abnormal", "Moderate", "Severe", "Extreme", "Exceptional"))
gg <- gg + labs(x=NULL, y=NULL, 
title="Drought in the U.S.",
subtitle=ap_date,
caption="National Drought Mitigation Center (NDMC), \nthe U.S. Department of Agriculture (USDA), \n and the National Oceanic and Atmospheric Association (NOAA)")
gg <- gg + theme(plot.title=element_text(face="bold", family="Lato Regular", size=13))
gg <- gg + theme(plot.caption=element_text(face="bold", family="Lato Regular", size=7, color="gray", margin=margin(t=10, r=80)))
gg <- gg + theme(legend.position="top")
gg <- gg + theme(axis.line =  element_blank(),
axis.text =  element_blank(),
axis.ticks =  element_blank(),
panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank()) 
gg
file_path <- paste0("us_maps/", layer_name, ".png")
ggsave(gg, file=file_path, width=5, height=4, type="cairo-png")


}

library(magick)

# Create a list of the png file names in the us_maps folder
the_list <- paste0("us_maps/", list.files("us_maps/"))

# apply the image_read function to each of the files and store it as a list in frames
frames <- lapply(the_list, image_read)

# use the image_animate function, which creates a GIF out of the list of images
animation <- image_animate(image_join(frames), fps=4)

# Print the animation
print(animation)

# Save the image as us_map.gif
image_write(animation,"us_map.gif")

# Mapping state drought

# NOTE: YOU CAN CREATE STATE-SPECIFIC MAPS FOR YOUR STATE IF YOU SUB OUT "TX" 
# AND THEN CHANGE THE BOUNDING BOX LATITUDES AND LONGITUDES (XLIM AND YLIM IN COORD_MAP)

state_abbrev <- "TX"

# Creating a shapefile specifically for Connecticut
state_fort <- filter(usfort, id==state_abbrev)

# Creating a shapefile of all state shapes minus Connecticut
not_state_fort <- filter(usfort, id!=state_abbrev)

# Compiling a list of the folders in the 'shapes' folder
shape_list <- list.files("shapes")

### Now the loop


ifelse(!dir.exists(file.path(the_path, paste0(state_abbrev, "_maps"))), dir.create(file.path(the_path, paste0(state_abbrev, "_maps"))), FALSE)

for (i in 1:length(shape_list)) {

file_name <- shape_list[i]
dsn_name <- paste0("shapes/", file_name)
layer_name <- gsub("_M", "", file_name)
the_date <- gsub("USDM_", "", layer_name)
the_date <- ymd(the_date)
ap_date <- paste0(month(the_date, label=T, abbr=F), " ", day(the_date), ", ", year(the_date))
droughtmap <- readOGR(dsn=dsn_name, layer=layer_name)
droughtfort <- fortify(droughtmap, region="DM")


gg <- ggplot() 
gg <- gg +  geom_polygon(data = droughtfort, aes(x=long, y=lat, group=group, fill=id), color = NA, size=0.5) 
gg <- gg +  geom_polygon(data = not_state_fort, aes(x=long, y=lat, group=group, fill=total), color = "white", fill="white", size=.5) 
gg <- gg +  geom_polygon(data = state_fort, aes(x=long, y=lat, group=group, fill=total), color = "gray73", fill=NA, size=0.5) 

# OK, replace the line below with the bounding box
# For example, the northeast lat and lon around Texas is 36.942330, -108.602890
# And the southeast lat and lon for Texas is 24.911878, -89.930472
# Therefore, xlim=c(-108.602890, -89.930472), ylim=c(24.911878, 36.942330)
gg <- gg +  coord_map("polyconic", xlim=c(-108.602890, -89.930472), ylim=c(24.911878, 36.942330)) 
gg <- gg +  scale_fill_manual(name="", values = c("#FFFF00", "#FCD37F", "#FFAA00", "#E60000", "#730000"),
labels = c("Abnormal", "Moderate", "Severe", "Extreme", "Exceptional"))
gg <- gg + labs(x=NULL, y=NULL, 
title=paste0("Drought in ", state_abbrev),
subtitle=ap_date,
caption="National Drought Mitigation Center (NDMC), \nthe U.S. Department of Agriculture (USDA), \n and the National Oceanic and Atmospheric Association (NOAA)")
gg <- gg + theme(plot.title=element_text(face="bold", family="Lato Regular", size=13))
gg <- gg + theme(plot.caption=element_text(face="bold", family="Lato Regular", size=7, color="gray", margin=margin(t=10, r=80)))
gg <- gg + theme(legend.position="top")
gg <- gg + theme(axis.line =  element_blank(),
axis.text =  element_blank(),
axis.ticks =  element_blank(),
panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
panel.border = element_blank(),
panel.background = element_blank()) 
gg

file_path <- paste0(state_abbrev, "_maps/", layer_name, ".png")
ggsave(gg, file=file_path, width=5, height=4, type="cairo-png")


# Final state GIF

the_list <- paste0(paste0(state_abbrev,"_maps/"), list.files(paste0(state_abbrev,"_maps/")))

frames <- lapply(the_list, image_read)
animation <- image_animate(image_join(frames), fps=4)
image_write(animation, paste0(state_abbrev, "_map.gif"))
