###Geocomputation with R
install.packages("ggmap")
library(ggmap)

#Robinlovelace (https://geocompr.robinlovelace.net/spatial-class.html)
install.packages("raster","spData", "sf") #packages partie 1
install.packages("devtools")
library(raster)
library(spData)
library(sf)
library(devtools)
install.packages("dplyr")                 #Packages partie 2
install.packages("stringr")
library(dplyr)
library(stringr)
vignette(package = "sf")
world                      #Dataset compris dans le package spData
plot(world["pop"])
world_asia = world[world$continent == "Asia", ]
plot(world_asia)
asia=st_union(world_asia)  #ne garde que la geometrie prinipale
asia
plot(asia)
plot(st_union(world[world$name_long=="France",]))1
plot(world["pop"], reset = FALSE)
plot(asia,add=TRUE,col="red")

###~~1-GEOGRAPHIC DATA IN R~~###

  #####VECTOR DATA######

    ##Rajouter des cercles proportionnels a une info
    world_cents = st_centroid(world,of_largest=TRUE)  #convertit des polygones en cercles
    plot(world["continent"], reset=FALSE)             #On imprime le fond de carte, modifiable grace a REset
    cex = sqrt(world$pop) / 10000
    plot(st_geometry(world_cents), add = TRUE, cex = cex) #On y rajoute un cercle dont l'estetique est defini par cex (qui contient la pop)
  
    ##Mettre en valeur une partie de la carte
    india = world[world$name_long == "India", ]
    plot(st_geometry(india),  expandBB=c(0, 0.2, 0.1, 0.1),col = "gray", lwd = 3)
    plot(world_asia[0], add=TRUE)
    
    ##CREER DES SIMPLE FEATURES
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
    
###~~ATTRIBUTE DATA OPERATIONS~~###
install.packages()
datcount <- read.csv("./Data/UKBMS_100/ukbms_count.csv")    
setwd("C:/Users/retoschm/Documents/R Adele/Decorticage_Papillons") 
aggregate(datcount, by=list(datcount$site_ID,datcount$year,datcount$species_name),function(x)length(x))    

  #Obtenir les trois continents les plus peuples, et le nombre de pays qu'ils contiennent  
  world %>% 
    dplyr::select(pop, continent, area_km2) %>% 
    group_by(continent) %>% 
    summarize(pop = sum(pop, na.rm = TRUE), area=sum(area_km2, na.rm=TRUE), n_countries = n()) %>% 
    top_n(n = 3, wt = pop) %>%
    arrange(desc(pop)) %>% 
    mutate(pop_moy_surf=pop/area) %>%
    st_drop_geometry()
names(world)

#####MEGA DEFI: PLACER LES POINTS Papillons SUR UNE CARTE UK#####
datcoord <- read.csv("./Data/UKBMS_100/ukbms_coord.csv")
datgeom<- st_as_sf(datcoord, dcoords=c("section_lon", "section_lat", crs=3035))
#creer liste de points coordonnees
datcoordsol <- dplyr::select(datcoord,"section_lon","section_lat") #On eclairci en ne gardant que les coordonnees du dataframe
datcoordsolmat <- as.matrix(datcoordsol)                           #On les met sous forme matrice parce que sinon sf aime pas
col_coord <- (st_multipoint(datcoordsolmat,dim = "XY"))            #On trsfrme en objets geometriques, multipoints ici
sfc_coord <- st_sfc(sfc_coord)                                     #On transforme cet ensemble en une sfc
sf_coord <- st_sf(sfc_coord, crs = 3035)                           #Et le tout en un simple feature


Roy_U=st_transform(world[world$name_long=="United Kingdom",],3035) 

plot(st_geometry(Roy_U), Reset=FALSE ,col="#CDC673")               #Extraire les UK depuis World
plot(sf_coord,add=TRUE, col="red")                                 #Melanger le tout
                                                                   #Victoire!

###Defi numero 2: faire apparaitre infos de count sur carte coord####
#Joindre les tables
data <- right_join()

UK<-st_as_sf(getData("GADM", country= 'GBR', level=0))  #Avoir un fond de carte plus joli (c'est en projection 4326)

