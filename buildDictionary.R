#options("java.parameters" = "-Xmx8g")
library(stringi)
library(tm)
library(downloader)
library(RWeka)
library(ggplot2)
library(gridExtra)
library(wordcloud)
library(SnowballC)
library(dplyr)
library(quanteda)
library(magrittr) 
source('~/Dropbox/Data Science/Data Capstone/functions.R')

setwd("~/Dropbox/Data Science/Data Capstone")
if(!file.exists("dataset.zip")){
    url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    download(url, dest="dataset.zip", mode="wb") 
    unzip ("dataset.zip", exdir = "./")
    list.files("./final/en_US")
}

conTwitter <- file("./final/en_US/en_US.twitter.txt", "r")
conBlog <- file("./final/en_US/en_US.blogs.txt", "r")
conNews <- file("./final/en_US/en_US.news.txt", "r")

twitter <- readLines(conTwitter, encoding="UTF-8")
blogs <- readLines(conBlog, encoding="UTF-8")
news <- readLines(conNews, encoding="UTF-8")

blogs <- iconv(blogs, to="ASCII", sub="")
news <- iconv(news, to="ASCII", sub="")
twitter <- iconv(twitter, to="ASCII", sub="")

set.seed(1212) # For reproducibility
sampleSize <- 0.7
blogs_sample <- sample(blogs,as.integer(length(blogs)*sampleSize),replace = FALSE)
twitter_sample <- sample(twitter,as.integer(length(twitter)*sampleSize),replace = FALSE)
news_sample <- sample(news,as.integer(length(news)*sampleSize),replace = FALSE)
sample_us_text <- c(blogs_sample,twitter_sample,news_sample)

if(!file.exists("badwords.txt")) {
    fileUrl2 <- "http://www.bannedwordlist.com/lists/swearWords.txt"
    download.file(fileUrl2, destfile="badwords.txt")
}
badwords <- readLines("badwords.txt")
sample_us_text <- sample_us_text %>%
    remove_online_junk() %>%
    remove_symbols()

tokens <- quanteda::tokens(char_tolower(sample_us_text),what="word",
                           remove_symbols=TRUE,remove_numbers = TRUE,
                           remove_punct = TRUE, remove_separators = TRUE, 
                           remove_twitter = TRUE, remove_hyphens = TRUE,
                           remove_url = TRUE,verbose=FALSE)
tokens <- tokens_remove(tokens,stopwords("english"))
tokens <- tokens_remove(tokens,badwords)
rm(sample_us_text,blogs_sample,twitter_sample,news_sample,twitter,blogs,news,words_blogs,words_news,words_twitter,profanity)

quadGrams <- as.data.frame(table(unlist(quanteda::tokens_ngrams(tokens, n=4))))
quadGrams <- quadGrams[order(quadGrams$Freq,decreasing=TRUE),]
colnames(quadGrams) <- c("Word", "Frequency")
DictionaryQuad <- buildDictionary(quadGrams,4,90)
rm(quadGrams)

triGrams <- as.data.frame(table(unlist(quanteda::tokens_ngrams(tokens, n=3))))
triGrams <- triGrams[order(triGrams$Freq,decreasing=TRUE),]
colnames(triGrams) <- c("Word", "Frequency")
DictionaryTri <- buildDictionary(triGrams,3,90)
rm(triGrams)

biGrams <- as.data.frame(table(unlist(quanteda::tokens_ngrams(tokens, n=2))))
biGrams <- biGrams[order(biGrams$Freq,decreasing=TRUE),]
colnames(biGrams) <- c("Word", "Frequency")
DictionaryBi <- buildDictionary(biGrams,2,90)
rm(biGrams)

uniGrams <- as.data.frame(table(unlist(quanteda::tokens_ngrams(tokens, n=1))))
uniGrams <- uniGrams[order(uniGrams$Freq,decreasing=TRUE),]
colnames(uniGrams) <- c("Word", "Frequency")
default <- head(uniGrams,20)
rm(uniGrams)

write.csv(DictionaryQuad,"DictionaryQuad.csv")
write.csv(DictionaryTri,"DictionaryTri.csv")
write.csv(DictionaryBi,"DictionaryBi.csv")
write.csv(default,"default.csv")

predict("what was the",DictionaryQuad,DictionaryTri,DictionaryBi,default)
predict("do you",DictionaryQuad,DictionaryTri,DictionaryBi,default)
predict("i",DictionaryQuad,DictionaryTri,DictionaryBi,default)


