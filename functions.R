remove_online_junk <- function(x){
    # replace emails and such but space
    x <- gsub("[^ ]{1,}@[^ ]{1,}"," ",x)
    x <- gsub(" @[^ ]{1,}"," ",x)
    # hashtags
    x <- gsub("#[^ ]{1,}"," ",x) 
    # websites and file systems
    x <- gsub("[^ ]{1,}://[^ ]{1,}"," ",x) 
    x
}

remove_symbols <- function(x){
    # Edit out most non-alphabetical character
    # text must be lower case first
    x <- gsub("[`??????]","'",x)
    x <- gsub("[^a-z']"," ",x)
    x <- gsub("'{2,}"," '",x)
    x <- gsub("' "," ",x)
    x <- gsub(" '"," ",x)
    x <- gsub("^'","",x)
    x <- gsub("'$","",x)
    x
}

getCoverage <- function(nGram,percentage){
    total <- sum(nGram$Frequency)
    i <- 1
    sum <- 0
    coverage <- 0
    while (i < nrow(nGram) && coverage < percentage) 
    {
        sum <- sum + nGram[i, 2]
        coverage <- (sum / total)*100
        i <- i + 1
    }
    i
}

buildDictionary <- function(nGrams,n,coveragePercent){
    totalWord = sum(nGrams$Frequency)
    coverageWord = getCoverage(nGrams,coveragePercent)
    nGrams <- nGrams[1:coverageWord,]
    nGrams$Word <- as.character(nGrams$Word)
    #split n-grams into n-1 grams and last word
    nGrams[,"prediction"] <- NA
    tmp = strsplit(nGrams$Word,"_")
    index = sapply(tmp,function(x){paste(x[1:n-1],collapse = " ")})
    prediction = sapply(tmp,function(x){x[n]})
    dictionary = data.frame(index,prediction,Frequency=nGrams$Frequency)
    dictionary <- filter(dictionary,Frequency > 2)
    dictionary
}
checkDictionary <- function(input,dictionary){
    if(input %in% dictionary$index){
        result = dictionary[which(input == dictionary$index),c(2:3)]
        if(nrow(result)>5){
            result = head(result,5)
        }else{
            result
        }
    }else{
        result =NA
    }
}
predict <- function(input,DictionaryQuad,DictionaryTri,DictionaryBi,default){
    if(stri_count_words(input)>=3){
        input = paste(tail(unlist(strsplit(input,' ')),3), collapse=" ")
        result = checkDictionary(input,DictionaryQuad)
        if(is.na(result)){
            input = paste(tail(unlist(strsplit(input,' ')),2), collapse=" ")
            result = checkDictionary(input,DictionaryTri)
            if(is.na(result)){
                input = paste(tail(unlist(strsplit(input,' ')),1), collapse=" ")
                result = checkDictionary(input,DictionaryBi)
                if(is.na(result)){
                    default
                }else{
                    result
                }
            }else{
                result
            }
        }else{
            result
        }
    }else if(stri_count_words(input)==2){
        result = checkDictionary(input,DictionaryTri)
        if(is.na(result)){
            input = paste(tail(unlist(strsplit(input,' ')),1), collapse=" ")
            result = checkDictionary(input,DictionaryBi)
            if(is.na(result)){
                default
            }else{
                result
            }
        }else{
            result
        }
    }else{
        result = checkDictionary(input,DictionaryBi)
        if(is.na(result)){
            default
        }else{
            result
        }
    }
}