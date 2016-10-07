rm(list = ls())
setwd("/Users/Riddhik/Desktop/Homesite/Final_Scripts")



######################################################################
############################ Importing Data  #########################
######################################################################
train <- read.csv("ready_for_sampling_train.csv", header = T)[, -1]
train$QuoteConversion_Flag <- as.factor(train$QuoteConversion_Flag)
str(train)


# Randomize the dataset
train <- train[sample(1:nrow(train)), ] 



######################################################################
######################### Simple Random Sample  ######################
######################################################################

#### Margin of Error: 0.5%
#### Confidence Level: 99%
#### Population Size Train: 260753
#### Population Size Test: 173836
#### Proportion: 0.50

#### Sample Size Train: 53,000
#### Sample Size Test: 48,100


sample_train = sample(1:260753, 53000)
simple_random_sample_train = train[sample_train, ] 


# Creating 5 testing samples
sample_test = sample(1:260753, 48100)
simple_random_sample_test1 = train[sample_test, ]
sample_test = sample(1:260753, 48100)
simple_random_sample_test2 = train[sample_test, ]
sample_test = sample(1:260753, 48100)
simple_random_sample_test3 = train[sample_test, ]
sample_test = sample(1:260753, 48100)
simple_random_sample_test4 = train[sample_test, ]
sample_test = sample(1:260753, 48100)
simple_random_sample_test5 = train[sample_test, ]

# Check distribution of dependent variable
# If not good than sample again
CrossTable(simple_random_sample_train$QuoteConversion_Flag)


write.csv(simple_random_sample_train, 'simple_sample_train.csv')
write.csv(simple_random_sample_test1, 'simple_sample_test1.csv')
write.csv(simple_random_sample_test2, 'simple_sample_test2.csv')
write.csv(simple_random_sample_test3, 'simple_sample_test3.csv')
write.csv(simple_random_sample_test4, 'simple_sample_test4.csv')
write.csv(simple_random_sample_test5, 'simple_sample_test5.csv')



######################################################################
####################### Strategic Random Sample  #####################
######################################################################

# Arrange training set according to QuoteConversion_Flag
train_arranged <- arrange(train, QuoteConversion_Flag)
head(train_arranged$QuoteConversion_Flag, 100)
tail(train_arranged$QuoteConversion_Flag, 100)


train_arranged$QuoteConversion_Flag <- as.factor(train_arranged$QuoteConversion_Flag)

head(train_arranged$QuoteConversion_Flag, 100)
tail(train_arranged$QuoteConversion_Flag, 100)
table(train_arranged$QuoteConversion_Flag)


#### Margin of Error: 0.5%
#### Confidence Level: 99%
#### Population Size Zero: 211859
#### Proportion: 0.50

#### Sample Size Zero: 51,000

train_0 <- train_arranged[1:211859,]
sample_0 = sample(1:211859, 51000)
strategic_sample_0 <- train_0[sample_0, ]



#### Margin of Error: 0.5%
#### Confidence Level: 99%
#### Population Size One: 48894
#### Proportion: 0.50

#### Sample Size One: 29,000

train_1 <- train_arranged[211860:nrow(train_arranged), ]
sample_1 = sample(1:48894, 29000)
strategic_sample_1 <- train_1[sample_1, ]


#### Merge
strategic_sample <- rbind(strategic_sample_0, strategic_sample_1)
strategic_sample <- strategic_sample[sample(1:nrow(strategic_sample)), ] #randomize
table(strategic_sample$QuoteConversion_Flag)
str(strategic_sample)


write.csv(strategic_sample, 'strategic_sample_train.csv')