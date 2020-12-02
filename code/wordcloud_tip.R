# ------ Set-up ------

rm(list=ls())

#setwd("../data")

# install.packages("dplyr")
# install.packages("tm") 
# install.packages("SnowballC")
# install.packages("wordcloud")
# install.packages("RColorBrewer") 

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(dplyr)

# ------------ Cleaning data ------------

tip <- read.csv("steakhouse_tip.csv")

#head(tip)
text <- tip$text
alltext <- paste(text,sep = "", collapse = " ") # combine all texts

alltext <- gsub('[.]', '', alltext) # remove marks
alltext <- gsub('[,]', '', alltext)
alltext <- gsub('[!]', '', alltext)
alltext <- tolower(alltext)

septext <- strsplit(alltext,split=' ') # split words 

# freq_0 <- table(septext)
# freq <- sort(freq_0, decreasing = TRUE)[1:100]
# head(septext)

docs <- Corpus(VectorSource(septext))

docs <- tm_map(docs, removeWords, stopwords("english")) # remove stop words

docs <- tm_map(docs, removePunctuation) # remove punctuations

docs <- tm_map(docs, stripWhitespace) # remove extra spaces


# ------------ Wordcloud ------------

set.seed(100)

freqs <- sort(rowSums(as.matrix(TermDocumentMatrix(docs))),
              decreasing=TRUE) 
word_result <- data.frame(word = names(freqs),freq = freqs )

wordcloud(words = word_result$word, 
          freq = word_result$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

head(word_result)
write.csv(word_result,"word_result.csv")

# ----------- Output -----------
# Following groups are selected by our eyes from "word_result.csv"

# === Food-realted ===

list_food <- list()

list_food$word<-c("steak","bar","sushi",
              "drinks","salad","meat","chicken","beer","cheese",
              "wine","burger","hibachi","fresh",
              "specials","crab","soup","fries","bartender",
              "shrimp","bread","cocktails","rib","onion","lobster",
              "sandwich","appetizer","fish","dessert","pork",
              "lamb","tuna","salmon","martini",
              "chips","pizza","cinnamon","oysters","calamari",
              "bisque","gluten","pepper","pie",
              "italian","cheesecake","chocolate",
              "mushrooms","nachos")
list_food$freq <- length(list_food$word):1

wordcloud(words = list_food$word, freq = list_food$freq, 
          random.order=F,random.color=T, 
          colors=brewer.pal(8, "Dark2"))

# === Service-realted ===

list_other <- list()

list_other$word<-c("service","atmosphere",
                  "lunch","dinner","night","wait","order",
                  "price","friendly","brunch",
                  "reservation", "deliver","patio",
                  "music","breakfast","overpriced",
                  "clean","plates","wifi")
list_other$freq <- length(list_other$word):1

wordcloud(words = list_other$word, freq = list_other$freq, 
          random.order=F,random.color=T, 
          colors=brewer.pal(8, "Dark2"))




