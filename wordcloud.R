# ------ Set-up

rm(list=ls())
setwd("/Users/hrl/Desktop/628 M3/dataset")

install.packages("dplyr")

install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

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
# ----- word cloud ------

wordcloud2(freq, color = "random-light", backgroundColor = "grey")

docs <- Corpus(VectorSource(septext))
inspect(docs)

#___


toSpace <- content_transformer(function (x , pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)


dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(15, "Dark2"))



