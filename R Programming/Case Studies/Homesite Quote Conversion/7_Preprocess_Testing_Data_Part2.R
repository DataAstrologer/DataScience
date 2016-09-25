library(caret)
library(gmodels)
library(ggplot2)
library(grid)
library(gridExtra)
library(xts)
library(Rmisc)
library(zoo)
library(dplyr)

rm(list = ls())
setwd("/Users/Riddhik/Desktop/Homesite")


test <- read.csv("ready_for_advanced_preprocess_test.csv", header = T)[, -1]
str(test)


# Last step of dummy and lc
# extract only numeric columns
num_df = test[sapply(test, is.numeric)]
dim(num_df)

exclude = c()
for (i in 1:ncol(num_df)) {
    if(length(table(num_df[,i])) == 2){
        exclude = c(exclude, i)
    }
}
num_df = num_df[, -exclude]


nums = c(14, 15, 16, 17, 37, 38, 43, 88, 89, 90, 110, 127, 128)

to_factors <- names(num_df[, nums])
for (n in to_factors) {
    test[, n] <- as.factor(test[, n])
    num_df[, n] <- as.factor(num_df[, n])
}

levels(num_df$PersonalField66)[levels(num_df$PersonalField66) == "3"] <- "0"
levels(num_df$PropertyField29)[levels(num_df$PropertyField29) == "10"] <- "-1"

# generate dummy variables
fac_df <- num_df[sapply(num_df, 
                        is.factor)]

dumVar <- dummyVars("~.", data = fac_df)
trsf3 <- data.frame(predict(dumVar,
                            newdata = fac_df))

trsf3 <- rename(trsf3, PropertyField29.Neg.1 = PropertyField29..1)
names(trsf3)

test = cbind(test, trsf3)
test = test[, !(names(test) %in% to_factors)]

# drop linear combinations
drops <- c("CoverageField5A.25", "CoverageField5B.2",  "CoverageField5B.22",
           "CoverageField5B.25","CoverageField6A.25", "CoverageField6B.1",
           "CoverageField6B.6", "CoverageField6B.23", "CoverageField6B.25",
           "PersonalField8.3","PersonalField9.3","PersonalField13.4",
           "PersonalField64.2","PersonalField66.2","PersonalField68.1",
           "PersonalField68.2",  "PersonalField68.3",  "PersonalField68.4",
           "PropertyField13.3",  "PropertyField29.1",  "PropertyField35.2")

test = test[, !(names(test) %in% drops)]

write.csv(test, 'ready_for_sampling_test.csv')
