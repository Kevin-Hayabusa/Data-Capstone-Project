Data Science Capstone Project
========================================================
author: Kevin Jiang
date: April 7, 2018
autosize: true

Text Prediction 

Introduction
========================================================

The objective of this project is to develop a Shiny Wed Application for text prediction by leveraging data provided by swiftkey. 

This presentation will breifly discuss the 3 part of the application design

- Getting and cleaning the data
- Prediction Model

Getting and cleaning the data
========================================================
70% of the original data was sampled from the 3 sources (blogs, twitter, news) and combined into one file
- Text is preprocess by convert to lower case, remove numbers, symbols, urls, emails,stop words, punctuation etc
- NGrams are generated (Unigram,BiGram,Trigram,Quadgram)
- NGrams are sorted by frequency in descending order
- Results dictionary are saved in csv files 

Prediction Model
========================================================
Preprocess user inputs (using same as cleaning text) and we use a simple backoff algorithem for word prediction

- If the input phrase is 2 words, choose the most frequent phrase from among 3-word phrases that start with the input phrase. The predicted word is the last word of the chosen 3-word phrase.
- If the input phrase is 3 words, choose the most frequent phrase from among 4-word phrases that start with the input phrase. The predicted word is the last word of the chosen 4-word phrase.
- If the input phrase is longer than 3 words, use only the last 3 input words and follow the procedure for a 3-word phrase.
- If there is no prediction for a 3-word input phrase, use only the last 2 input words and follow the procedure for a 2-word phrase.
- If there is no prediction for a 2-word input phrase, select the most frequent word in the text sample.

Apps
========================================================
     
- The shiny app can be access [app]
- Detail report [report]
- Source Code [Github]

[app]: https://kevin1212.shinyapps.io/predictNext/
[report]: http://rpubs.com/kevin123/milestone_report
[Github]: https://github.com/KevinJiang1112/Data-Capstone-Project
