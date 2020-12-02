library(leaflet)
library(Rmisc)
library(ggplot2)
library(plyr)

bus <- read.csv('steakhouse_business.csv')
bus$name<- as.character(bus$name)
bus$business_id <- as.character(bus$business_id)
suggestions <- read.csv('suggestionsnew.csv')
suggestions$suggestion <- as.character(suggestions$suggestion)

