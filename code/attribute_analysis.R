rm(list = ls())

library(ggplot2)
library(tidyverse)

# read steak_attributes.csv
steak_attributes<-read.csv("data/steak_attributes.csv", header = TRUE)

# factorize attributes
for (ind in 1:dim(steak_attributes)[1]) {
  # re-code Alcohol: 0-none, 1-beer_and_wine, 2-full_bar
  steak_attributes[ind,6]<-gsub("'", "", steak_attributes[ind,6])
  steak_attributes[ind,6]<-gsub("^u", "", steak_attributes[ind,6])
  if (steak_attributes[ind,6] == "none") {
    steak_attributes[ind,6]<-0
  } else if (steak_attributes[ind,6] == "beer_and_wine") {
    steak_attributes[ind,6]<-1
  } else {
    steak_attributes[ind,6]<-2
  }
  
  # re-code GoodForKids: 0-False, 1-True
  steak_attributes[ind,7]<-as.numeric(ifelse(steak_attributes[ind,7] == "False", 0, 1))
  
  # re-code HasTV: 0-False, 1-True
  steak_attributes[ind,8]<-as.numeric(ifelse(steak_attributes[ind,8] == "False", 0, 1))
  
  # re-code OutdoorSeating: 0-False, 1-True
  steak_attributes[ind,9]<-as.numeric(ifelse(steak_attributes[ind,9] == "False", 0, 1))
  
  # re-code RestaurantsAttire: 0-casual, 1-dressy
  steak_attributes[ind,10]<-gsub("'", "", steak_attributes[ind,10])
  steak_attributes[ind,10]<-gsub("^u", "", steak_attributes[ind,10])
  steak_attributes[ind,10]<-as.numeric(ifelse(steak_attributes[ind,10] == "casual", 0, 1))
  
  # re-code RestaurantsDelivery: 0-None/False, 1-True
  steak_attributes[ind,11]<-as.numeric(ifelse(steak_attributes[ind,11] == "True", 1, 0))
  
  # re-code RestaurantsReservations: 0-None/False, 1-True
  steak_attributes[ind,13]<-as.numeric(ifelse(steak_attributes[ind,13] == "True", 1, 0))
  
  # re-code RestaurantsTakeout: 0-False, 1-True
  steak_attributes[ind,14]<-as.numeric(ifelse(steak_attributes[ind,14] == "False", 0, 1))
}

for (i in 6:ncol(steak_attributes)) {
  steak_attributes[,i]<-factor(steak_attributes[,i])
}

summary(steak_attributes)
## no hipster ambience, nearly no divey/touristy ambience, nearly no validated parking
steak_attributes$Ambience.divey<-NULL
steak_attributes$Ambience.hipster<-NULL
steak_attributes$Ambience.touristy<-NULL
steak_attributes$BusinessParking.validated<-NULL



# plot
## distribution of star ratings
steak_attributes %>% group_by(stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = stars, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Set2") + 
  geom_col(width = 0.4)

ggsave("figure/stars_dist.png", width = 4, height = 3)

## Stars vs. Alcohol
steak_attributes %>% group_by(Alcohol, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = Alcohol, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.7) + 
  ylab("Frequency") + ggtitle("Stars vs. Alcohol") + 
  scale_x_discrete(labels = c("0" = "None", "1" = "Beer & Wine", "2" = "Full Bar"))

ggsave("figure/stack_alcohol.png", width = 4, height = 3)


## Stars vs. GoodForKids
steak_attributes %>% group_by(GoodForKids, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = GoodForKids, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequency") + ggtitle("Stars vs. GoodForKids") + 
  scale_x_discrete(labels = c("0" = "Not Good for Kids", "1" = "Good for Kids"))

ggsave("figure/stack_goodforkids.png", width = 4, height = 3)


## Stars vs. RestaurantsAttire
steak_attributes %>% group_by(RestaurantsAttire, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = RestaurantsAttire, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. RestaurantsAttire") + 
  scale_x_discrete(labels = c("0" = "Casual", "1" = "Dressy"))

ggsave("figure/stack_attire.png", width = 4, height = 3)


## Stars vs. RestaurantsDelivery
steak_attributes %>% group_by(RestaurantsDelivery, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = RestaurantsDelivery, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. RestaurantsDelivery") + 
  scale_x_discrete(labels = c("0" = "No Delivery", "1" = "Delivery Available"))

ggsave("figure/stack_delivery.png", width = 4, height = 3)


## Stars vs. RestaurantsReservations
steak_attributes %>% group_by(RestaurantsReservations, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = RestaurantsReservations, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. RestaurantsReservations") + 
  scale_x_discrete(labels = c("0" = "No Reserve", "1" = "Reserve"))

ggsave("figure/stack_reserve.png", width = 4, height = 3)


## Stars vs. Ambience
star<-seq(1.5, 4.5, by = 0.5)
ambience<-c("casual", "classy", "intimate", "romantic", "trendy", "upscale")
amb_star<-data.frame("Ambience" = rep(ambience, each = 7), "stars" = rep(star, length(ambience)))
star_count<-c()
for (i in 15:20) {
  for (j in 1:7) {
    c<-sum(steak_attributes[steak_attributes$stars == star[j],i] == 1)
    star_count<-c(star_count, c)
  }
}
amb_star$count<-star_count

amb_star %>% ggplot(aes(x = Ambience, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.7) + 
  ylab("Frequency") + ggtitle("Stars vs. Ambience")

ggsave("figure/stack_ambience.png", width = 4, height = 3)



# anova
steak_attributes_aov<-aov(stars ~ ., data = steak_attributes[,-seq(1,4)])
summary(steak_attributes_aov)
## Alcohol, GoodForKids, RestaurantsAttire, RestaurantsDelivery, RestaurantsReservations, 
## Ambience.casual, Ambience.classy

reg<-lm(stars ~ Alcohol + GoodForKids + RestaurantsAttire + RestaurantsDelivery + 
          RestaurantsReservations + Ambience.casual + Ambience.classy, 
        data = steak_attributes)
summary(reg)
anova(reg)



# plot (attributes not included in final suggestions)
## Stars vs. HasTV
steak_attributes %>% group_by(HasTV, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = HasTV, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. HasTV") + 
  scale_x_discrete(labels = c("0" = "No TV", "1" = "Has TV"))

ggsave("figure/stack_hastv.png", width = 4, height = 3)

## Stars vs. OutdoorSeating
steak_attributes %>% group_by(OutdoorSeating, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = OutdoorSeating, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. OutdoorSeating") + 
  scale_x_discrete(labels = c("0" = "No Outdoor Seating", "1" = "Outdoor Seating Available"))

ggsave("figure/stack_outdoorseating.png", width = 4, height = 3)

## Stars vs. RestaurantsPriceRange2
steak_attributes %>% group_by(RestaurantsPriceRange2, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = RestaurantsPriceRange2, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.7) + 
  ylab("Frequence") + ggtitle("Stars vs. RestaurantsPriceRange2")

ggsave("figure/stack_price.png", width = 4, height = 3)


## Stars vs. RestaurantsTakeout
steak_attributes %>% group_by(RestaurantsTakeOut, stars) %>% summarise(count = n()) %>% 
  ggplot(aes(x = RestaurantsTakeOut, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.4) + 
  ylab("Frequence") + ggtitle("Stars vs. RestaurantsTakeout") + 
  scale_x_discrete(labels = c("0" = "No Takeout", "1" = "Takeout Allowed"))

ggsave("figure/stack_takeout.png", width = 4, height = 3)


## Stars vs. BusinessParking
park<-c("garage", "lot", "street", "valet")
park_star<-data.frame("BusinessParking" = rep(park, each = 7), "stars" = rep(star, 4))
star_count<-c()
for (i in 21:24) {
  for (j in 1:7) {
    c<-sum(steak_attributes[steak_attributes$stars == star[j],i] == 1)
    star_count<-c(star_count, c)
  }
}
park_star$count<-star_count

park_star %>% ggplot(aes(x = BusinessParking, y = count, fill = factor(stars, levels = seq(4.5, 1.5, by = -0.5)))) + 
  scale_fill_brewer(name = "stars", palette = "Pastel1") + 
  geom_bar(position = "fill", stat = "identity", width = 0.7) + 
  ylab("Frequency") + ggtitle("Stars vs. BusinessParking")

ggsave("figure/stack_parking.png", width = 4, height = 3)



# write seleted attributes .csv file
write.csv(steak_attributes[, c(1:7, 10, 11, 13, 15, 16)], "data/attributes.csv", row.names = FALSE)
