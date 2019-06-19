#ggplot 2 dossier
library(ggplot2)
library(dplyr)
library(lubridate)
install.packages("tidyverse")
library(tidyverse)
data <- mpg #Data incluses dans la librairie ggplot

#Exercice 1-Manip donnees
  #Get informations about the dataset
  str(data)
  summary(data)
  head(data)
  tail(data)
  names(data)
  dim(data)
  #what data set are included with ggplot2
  data(package="ggplot2")
  #Convertir cty et hwy (mpg) en l/100km
    #On a 1 mpg=235.21L/100km
    data %>% mutate(cty=235.21*cty, hwy=235.21*hwy )
  #manufacturer with the most the models
    arrange(data.frame(manuf=unique(data$manufacturer),nombre_modele=tapply(data$model, data$manufacturer, function(x) length(unique(x)))),nombre_modele)  
    #retourne le nombre de modele par manufactureur, toyota a le plus de modeles
  #which model has the most variation?
    count(data,model,sort=T)
    #retourne le nombre de chaque modele, caravan 2wd a le plus de variations (11)
  #If you remove specification
    data$model_base <- str_split(data$model, " ", simplify = TRUE)[,1]
    count(data,model_base,sort=1)
    #Maintenant c'est a4 qui a le plus de variations (15)
    
#Exercice 2-ggplot simples
    #consommation grandes distance en fonction de la cylindree
    ggplot(mpg, aes(x=displ, y=hwy))+
      geom_point()+
      geom_smooth(method = "lm")
    #On peut emettre que la conso baisse lineairement quand la cylindree augmente
    ggplot(mpg, aes(model, manufacturer))+
      geom_point()
    #on peut proposer un graph qui donne le nombre de variations pour chaque 
    #modele de chaque manufatureur
    df <- mpg %>%  mutate(manuModel = paste(manufacturer, model, sep = " "))
    ggplot(df, aes(x = manuModel)) + 
      geom_bar() +                  #On trace le compte 
      coord_flip()                  #on echange absices et ordonnees
    
#Exercice 3-Manip ggplot
    #Ajouter une info pour chaque point avec colour, ici la classe du vehicule
    ggplot(mpg, aes(displ, hwy, colour=class, size=cyl))+
      geom_point()

    ggplot(mpg, aes(displ, hwy))+
      geom_point(colour="blue")
    #lien entre roues motrices et consommation en fuel
    ggplot(mpg, aes(drv, hwy))+
      geom_boxplot()
    
#Exercice 4-Facetting, graphs multiples
    #Obtenir un graph par classe donnant disp en fonction de hwy
    ggplot(mpg, aes(displ, hwy))+
      geom_point(colour="blue")+
      facet_wrap(~class)
    
    #exploration 3-way
    ggplot(mpg, aes(displ, hwy))+
      geom_point()+
      facet_wrap(~cyl) #moyen le plus clair, mieux vaut facetter par une variable qui a peu d'options
    
    ggplot(mpg, aes(cyl, hwy))+
      geom_point()+
      facet_wrap(~displ)
    
    ggplot(mpg, aes(cyl, displ))+
      geom_point()+
      facet_wrap(~hwy)   
    
    #facetting pour comparer des distributions
    ggplot(mpg,aes(displ))+
      geom_freqpoly()+
      facet_wrap(~drv,ncol=1)
    
    ggplot(mpg,aes(drv,weight=TRUE))+
      geom_bar()

    #faire apparaitre deux contenus de colonnes selon deux axes de coordonees
    #Soit illustrer 4 variables!
    ggplot(economics, aes(unemploy/pop, uempmed))+
      geom_path(colour="yellow")+
      geom_line(aes(colour=year(date)))
    
#Exercice 5-Quel graph choisir?
    ggplot(mpg,aes(cty))+ geom_histogram()
    ggplot(mpg,aes(hwy))+ geom_histogram()
    
    #Ordonner des boxplot dans l'ordre croissant
    ggplot(mpg,aes(reorder(class,hwy),hwy))+geom_boxplot()
    
    summary(diamonds)
    #le binwidht pour les prix ([326:18823])peut etre de 500
    ggplot(diamonds,aes(price))+ geom_histogram(binwidth = 500)
    ggplot(diamonds,aes(carat))+ geom_histogram(binwidth = 0.1)
    
    #Modifier les axes
    ggplot(mpg, aes(cty,hwy))+geom_polygon(alpha=1/2)+xlab("city")+ylab("highway")
    ggsave("./Figure/Graphique_city_highway.jpeg")

##Fournir un graphique
    ggplot(economics, aes(date,unemploy))+ geom_line()
    subset(presidential, start>economics$date[1]) #on supprime ce qui est avant 1965
  
    ggplot(economics)+ 
      geom_rect(aes(xmin=start, xmax=end, fill=party),ymin=-Inf,ymax=Inf, data = presidential, alpha=1/10)+
      geom_vline(aes(xintercept=as.numeric(start)),data=presidential, alpha=1/8)+
      geom_text(aes(x=start, y=2500, label=name),data=presidential)+
      geom_line(aes(date, unemploy))+
      ggtitle("evolution du taux de chomage aux EU")

#Exercice 6
    ggplot(mpg,aes(cyl,hwy,group=cyl))+geom_boxplot()

    
    
    