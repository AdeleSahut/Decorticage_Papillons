###SPATIAL DATA SCIENCE###
  #Coordonnees basees sur l'article
  #"Interactive Effects of Large- and Small-Scale Sources of Feral Honey-Bees for Sunflower in the Argentine Pampas
      # datT1 <- raster('./SpatialData/Argentine/LC08_L1TP_225086_20190405_20190422_01_T1.tif')
      # datQB <- raster('./SpatialData/Argentine/LC08_L1TP_225086_20190405_20190422_01_T1_QB.tif')
      # datTIR <- raster('./SpatialData/Argentine/LC08_L1TP_225086_20190405_20190422_01_T1_TIR.tif') 
      # plot(datT1)  #orange
      # plot(datQB)  #noir
      # plot(datTIR) #vert
      # datT1
      # compareRaster(datT1,datQB,datTIR) #Meme format, proj et tout?
      # Arg <- stack(datT1, datQB, datTIR) #Colle les bandes
      # plot(Arg)
      # Arg
      # plot(datT1, main = "green", col = gray(0:100 / 100))

library(raster)

###Test avec Bordeaux###

  BordT1 <- raster('./SpatialData/Bordeaux/LC08_L1TP_200029_20190321_20190326_01_T1.tif')
  BordQB <- raster('./SpatialData/Bordeaux/LC08_L1TP_200029_20190321_20190326_01_T1_QB.tif')
  BordTIR <- raster('./SpatialData/Bordeaux/LC08_L1TP_200029_20190321_20190326_01_T1_TIR.tif')
  Bordtest <- stack(BordQB, BordT1, BordTIR)
  plot(Bord)
  plot(BordT1, main = "Carte_T1", col = gray(0:100 / 100))
  plotRGB(Bord, main = "carte")
  
#Ouverture de toutes les couleurs
  Bandes<-paste0("./SpatialData/Bordeaux/bandes/LC08_L1TP_200029_20190321_20190326_01_T1_B", 1:7,".tif")
  Bandes
  Bordeaux <- stack(Bandes)
  RGB(Bordeaux)

#Ouverture de certaines
  # Blue
  b2 <- raster('./SpatialData/Bordeaux/bandes/LC08_L1TP_200029_20190321_20190326_01_T1_B2.tif')
  # Green
  b3 <- raster('./SpatialData/Bordeaux/bandes/LC08_L1TP_200029_20190321_20190326_01_T1_B3.tif')
  # Red
  b4 <- raster('./SpatialData/Bordeaux/bandes/LC08_L1TP_200029_20190321_20190326_01_T1_B4.tif')
  # Near Infrared (NIR)
  b5 <- raster('./SpatialData/Bordeaux/bandes/LC08_L1TP_200029_20190321_20190326_01_T1_B5.tif')

  s<-stack(b5,b4,b3)  
  par(mfrow = c(2,2))
  plot(b2, main = "Blue", col = gray(0:100 / 100))
  plot(b3, main = "Green", col = gray(0:100 / 100))
  plot(b4, main = "Red", col = gray(0:100 / 100))
  plot(b5, main = "NIR", col = gray(0:100 / 100))
  
  #True color image
  BordRGBtrue <- stack(b4,b3,b2)  #Red, Green, Blue
  plotRGB(BordRGBtrue,  axes = TRUE, stretch = "lin", main = "Bordeaux True Color Composite")

  
  #False color image
  par(mfrow=c(1,2))
  BordRGBfalse <- stack(b5,b4,b3)
  plotRGB(BordRGBfalse, axes=TRUE, stretch= "lin", main= "Bordeaux False color Composite")  
  
Bordeaux1 <-subset(Bordeaux, 1:7)  
names(Bordeaux1) <- c("ultra-blue", "blue", "Green", "Red","NIR","SIR","ThermalI")  
Bordeaux1

  #Retrecir zone d'etude
    #En selectionnant nos limites
  extent(Bordeaux1)
  BordeauxNord <- crop(Bordeaux1, extent(558000, 788000,4941000,5058000))
  plot(BordeauxNord)
    #En zoomant direct sur la carte
  drawExtent()  #puis on clique sur l'endroit pour connaitre les limites
  
  
  ###VEGETATION INDICE###
  #BordRGBtrue/BordRGBfalse
  vi <- function(Objet_raster, k, i) {
    bk<- Objet_raster[[k]]
    bi<- Objet_raster[[i]]
    vi<- (bk-bi)/(bk+bi)
    return (vi)
    }
Bordvi <- vi(Bordeaux, 5, 4)  
plot(Bordvi, col = rev(terrain.colors(10)), main = "Landsat-NDVI")
hist(Bordvi,
     main = "Distribution of NDVI values",
     xlab = "NDVI",
     ylab= "Frequency",
     col = "wheat",
     xlim = c(-0.5, 1),
     breaks = 30,
     xaxt = 'n')
axis(side=1, at = seq(-0.5,1, 0.05), labels = seq(-0.5,1, 0.05))
plot(histvi)

  #Modifier des couleurs selon des echelles
Bordviclass1<-reclassify(Bordvi, c(-Inf,0.2,NA, 0.2, 0.3, 1, 0.3, Inf, NA))
plot(Bordviveg, add=TRUE)

Bordviclass2 <- reclassify(Bordvi, c(-Inf, 0.1, 1, 0.1, 0.2, 2, 0.2, 0.3, 3, 0.3,0.4, 4, 0.4,0.5,5,0.5,Inf,6))
plot(Bordviclass2, col = rev(terrain.colors(5)))
