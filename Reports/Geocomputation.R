###Geocomputation with R
install.packages("leaflet")
library(leaflet)
map <- leaflet() %>% addTiles() %>% addMarkers(lng=48.691901, lat=6.171207, popup="Terminus")



#Robinlovelace (https://geocompr.robinlovelace.net/spatial-class.html)
install.packages("raster","spData", "sf")
install.packages("devtools")
library(raster)
library(spData)
library(sf)
library(devtools)
vignette(package = "sf")
world                      #Dataset compris dans le package spData
plot(world["pop"])
world_asia = world[world$continent == "Asia", ]
plot(world_asia)
asia=st_union(world_asia)
asia
plot(asia)
