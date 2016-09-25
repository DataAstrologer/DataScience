library(caret)
library(doMC)
registerDoMC(cores = 4) 

rm(list = ls())
setwd("/Users/Riddhik/Desktop/Homesite")


# Import
pca.ready.data <- read.csv("ready_for_advanced_preprocessing.csv")
pca.ready.data <- pca.ready.data[, -1]
pca.ready.data$QuoteConversion_Flag <- as.factor(pca.ready.data$QuoteConversion_Flag)


# extract only numeric columns
num_df = pca.ready.data[sapply(pca.ready.data,
                              is.numeric)]
dim(num_df)

exclude = c()
for (i in 1:ncol(num_df)) {
    if(length(table(num_df[,i])) == 2){
        exclude = c(exclude, i)
    }
}
num_df = num_df[, -exclude]


nums = c()
for (i in 1:ncol(num_df)){
    if(length(table(num_df[,i])) < 5 ){
        nums <- c(nums, i)
    }
}


# convert numerics to factor
to_factors <- names(num_df[, nums])
for (n in to_factors) {
    pca.ready.data[, n] <- as.factor(pca.ready.data[, n])
    num_df[, n] <- as.factor(num_df[, n])
}


# generate dummy variables
fac_df <- num_df[sapply(num_df, 
                        is.factor)]

dumVar <- dummyVars("~.", data = fac_df)
trsf3 <- data.frame(predict(dumVar,
                            newdata = fac_df))
trsf3 <- rename(trsf3, PropertyField29.Neg.1 = PropertyField29..1)

#names(trsf3)

pca.ready.data = cbind(pca.ready.data,
                      trsf3)

pca.ready.data = pca.ready.data[, !(names(pca.ready.data) %in% to_factors)]


# check full linear combination again
num_df = pca.ready.data[sapply(pca.ready.data, 
                              is.numeric)]


linear.fields <- as.matrix(num_df)


comboInfo <- findLinearCombos(linear.fields)
comboInfo


drops <- names(num_df[, comboInfo$remove])
pca.ready.data = pca.ready.data[, !(names(pca.ready.data) %in% drops)]

names(pca.ready.data)

write.csv(pca.ready.data, 'ready_for_sampling_train.csv')