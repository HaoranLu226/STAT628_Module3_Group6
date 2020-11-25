# ------ Set-up
setwd("/Users/hrl/Desktop/628 M3/Dataset")

install.packages("wordcloud")
install.packages("dplyr")
library(wordcloud)
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
