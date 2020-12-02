library(leaflet)
library(ggplot2)
library(Rmisc)
library(plyr)

bus <- read.csv('steakhouse_business.csv')
bus$business_id<- as.character(bus$business_id)
bus$name <- as.character(bus$name)
suggestions <- read.csv('suggestionsnew.csv')
suggestions$suggestion <- as.character(suggestions$suggestion)

