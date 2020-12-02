# ------ Set-up
rm(list=ls())
#setwd("/Users/hrl/Desktop/628 M3/dataset")

# install.packages("dplyr")
# install.packages("tm")  # for text mining
# install.packages("SnowballC") # for text stemming
# install.packages("wordcloud") # word-cloud generator 
# install.packages("RColorBrewer") # color palettes

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(dplyr)

# ------
tip <- read.csv("steakhouse_tip.csv")

head(tip)
text <- tip$text
alltext <- paste(text,sep = "", collapse = " ")

alltext <- gsub('[.]', '', alltext)
alltext <- gsub('[,]', '', alltext)
alltext <- gsub('[!]', '', alltext)
alltext <- tolower(alltext)
septext <- strsplit(alltext,split=' ')

freq_0 <- table(septext)
freq <- sort(freq_0, decreasing = TRUE)[1:100]

docs <- Corpus(VectorSource(septext))
toSpace <- content_transformer(function (x , pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

docs <- tm_map(docs, content_transformer(tolower)) # Remove numbers

docs <- tm_map(docs, removeNumbers) # Remove english common stopwords

docs <- tm_map(docs, removeWords, stopwords("english")) # Remove your own stop word


docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))  # specify your stopwords as a character vector

docs <- tm_map(docs, removePunctuation) # Remove punctuations

docs <- tm_map(docs, stripWhitespace) # Eliminate extra white spaces


dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(15, "Dark2"))

# colors <- c('red','blue','green','maroon','brown','navy','purple')
list_things <- list()
list_other <- list()

list_food$word<-c("steak","bar","sushi","cheese",
              "drinks","salad","meat","chicken","beer","wine","burger","hibachi","fresh",
              "specials","crab","soup","fries","shrimp","bread","cocktails","rib","onion","lobster",
              "sandwich","appetizer","fish","dessert","pork","lamb","tuna","salmon",
              "chips","pizza","cinnamon","oysters","calamari","bisque","gluten","pepper","pie",
              "italian","cheesecake","chocolate","mushrooms","nachos")
list_food$freq <- (length(list_food$word):1)^1.5

wordcloud(words = list_food$word, freq = list_food$freq, 
          random.order=F,random.color=T, colors=brewer.pal(12, "Dark2"))

list_other$word<-c("service","atmosphere",
                  "lunch","dinner","night","wait","order","price","friendly","brunch",
                  "reservation", "deliver","bartender","patio","music","breakfast","overpriced",
                  "martini","clean","plates","wifi")
list_other$freq <- (length(list_other$word):1)^1.2

wordcloud(words = list_other$word, freq = list_other$freq, 
          random.order=F,random.color=T, colors=brewer.pal(12, "Set1"))


# list_food$word<-c("steak","bar","sushi","cheese",
#                   "drinks","salad","meat","chicken","beer","wine","burger","hibachi","fresh",
#                   "specials","crab","soup","fries","shrimp","bread","cocktails","rib","onion","lobster",
#                   "sandwich","appetizer","fish","dessert","pork","lamb","tuna","salmon",
#                   "chips","pizza","cinnamon","oysters","calamari","bisque","gluten","pepper","pie",
#                   "italian","cheesecake","chocolate","mushrooms","nachos")
# list_food$freq <- (length(list_food$word):1) * 5 

