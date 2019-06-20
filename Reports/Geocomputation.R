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
asia=st_union(world_asia)  #ne garde que la geometrie prinipale
asia
plot(asia)
plot(st_union(world[world$name_long=="France",]))
plot(world["pop"], reset = FALSE)
plot(asia,add=TRUE,col="red")


######VECTOR DATA######

###Rajouter des cercles proportionnels a une info
world_cents = st_centroid(world,of_largest=TRUE)  #convertit des polygones en cercles
plot(world["continent"], reset=FALSE)             #On imprime le fond de carte, modifiable grace a REset
cex = sqrt(world$pop) / 10000
plot(st_geometry(world_cents), add = TRUE, cex = cex) #On y rajoute un cercle dont l'estetique est defini par cex (qui contient la pop)

###Mettre en valeur une partie de la carte
india = world[world$name_long == "India", ]
plot(st_geometry(india),  expandBB=c(0, 0.2, 0.1, 0.1),col = "gray", lwd = 3)
plot(world_asia[0], add=TRUE)

####CREER DES SIMPLE FEATURES
a<-st_point(c(5, 2))
b<-st_point(c(8,9))
ab<-st_sfc(a,b)           #combine deux objets dans une sfc
ab   
st_geometry_type(ab)      #Donne la geometreie des objets
st_crs(ab)                #Donne le syst coord ref

ab_WGS = st_sfc(a, b, crs = 4326) #Attribue un CRS
st_crs(ab_WGS)

lnd_point = st_point(c(0.1, 51.5))                 # sfg object
lnd_geom = st_sfc(lnd_point, crs = 4326)           # sfc object
lnd_attrib = data.frame(                           # data.frame object
  name = "London",
  temperature = 25,
  date = as.Date("2017-06-21"))
lnd_sf = st_sf(lnd_attrib, geometry = lnd_geom)    # sf object
st_geometry_type(lnd_sf)
lnd_sf


######RASTER DATA######
vignette("functions", package = "raster")
devtools::install_github("Nowosad/spDataLarge")
library(spDataLarge)
?srtm

#on charge le fichier depuis le package puis on le trsfrme en raster
raster_filepath = system.file("raster/srtm.tif", package = "spDataLarge")
new_raster = raster(raster_filepath)  #Raster layer
raster_filepath
plot(new_raster)

multi_raster_file = system.file("raster/landsat.tif", package = "spDataLarge")
r_brick = brick(multi_raster_file)  #RasterBrick
plot(r_brick)
r_brick

install.packages("lwgeom")
library(lwgeom)
st_area(world_asia)


####EXERCICES#####
world
summary(world$geom)   #On a 177 multupolygones en projection 4326

#use plot to create a map of nigeria in context
Nigeria = world[world$name_long=="Nigeria",]
plot(Nigeria)
plot(st_geometry(Nigeria))
plot(st_geometry(Nigeria), expandBB=c(0, 0, 0, 0), lwd=3, col="darkgreen")
Africa= world[world$continent=="Africa",]
plot(Africa[0], add=TRUE)
text

matrice<-matrix(sample(1:10, replace=TRUE), nrow=10,ncol=10)

my_raster = raster(ncol = 10, nrow = 10, vals = runif(n = 100, min = 0, max = 1000))  
plot(my_raster)
