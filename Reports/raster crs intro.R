#Spatial data Science - Case Studies
library(raster)
library(sf)
devtools::install_github("rspatial/rspatial")

#Obtenir un fond de carte precis
  uk <- raster::getData("GADM", country="GBR",level=0)
  par(mai=c(0,0,0,0))
  plot(uk)

#Transformer le CRS de notre carte
  #Definir une projection
  prj <- "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m"
  guk <- spTransform(uk,CRS(prj))
  
#Ne garder qu'une sous partie de la carte
  duk<-disaggregate(guk)
  head(duk)  
  a<- area(duk)
  b <- duk[which.max(a),]
  plot(b)
  
#Tentative papillon
  
  #Creation d'un unique data frame plus pratique
  library(lubridate)
  library(dplyr)
  
  datcount$Date<- dmy(paste(datcount$day,datcount$month,datcount$year))
  datcoord1<-dplyr::select(datcoord,"site_id","section_lon","section_lat")
  datcount1<-dplyr::select(datcount, "site_id","species_name","butterfly_count","Date")
  #dataframe eclaircie
  datpap<- right_join(datcount1,datcoord1, by="site_id")
  plot(datpap)
   #dataframe spatiale
   library(tidyverse)
   library(sf)   
   sapply(datpap, class)  
     #on cree une colone geometry
   datpapspat<-st_as_sf(datpap, coords = c("section_lon","section_lat"), crs="+init=EPSG:3035") 
   uk<- spTransform(uk,CRS("+init=EPSG:3035"))
   plot(uk)
   plot(datpapspat[3], add=TRUE, cex=2, pch=16, col="red")

   
   
  
