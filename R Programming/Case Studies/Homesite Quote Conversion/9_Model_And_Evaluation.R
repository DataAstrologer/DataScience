library(caret)
library(rpart)
library(party)
library(e1071)
library(xgboost)
library(doMC)
library(gmodels)
library(gbm)
library(dplyr)
library(pROC)
library(xgboost)



rm(list = ls())
setwd("/Users/Riddhik/Desktop/Homesite/Final_Scripts")
registerDoMC(cores = 3)



######################################################################
############################ Importing Data  #########################
######################################################################
train <- read.csv("simple_sample_train.csv", header = T)[,-1]
train$QuoteConversion_Flag = as.factor(train$QuoteConversion_Flag)

test1 <- read.csv("simple_sample_test1.csv", header = T)[,-1]
test1$QuoteConversion_Flag = as.factor(test1$QuoteConversion_Flag)

test2 <- read.csv("simple_sample_test2.csv", header = T)[,-1]
test2$QuoteConversion_Flag = as.factor(test2$QuoteConversion_Flag)

test3 <- read.csv("simple_sample_test3.csv", header = T)[,-1]
test3$QuoteConversion_Flag = as.factor(test3$QuoteConversion_Flag)

test4 <- read.csv("simple_sample_test4.csv", header = T)[,-1]
test4$QuoteConversion_Flag = as.factor(test4$QuoteConversion_Flag)

test5 <- read.csv("simple_sample_test5.csv", header = T)[,-1]
test5$QuoteConversion_Flag = as.factor(test5$QuoteConversion_Flag)




######################################################################
############################# XGBoost - 1  ###########################
######################################################################
set.seed(100)

myControl <- trainControl(method = 'repeatedcv', 
                          number = 3, 
                          repeats = 3, 
                          returnResamp = 'none',
                          verboseIter = T)

t1 = Sys.time()


xgb1 <- train(QuoteConversion_Flag ~ . ,
              data = train,
              method = "xgbTree",
              trControl = myControl)
xgb1


preds_xgb1_test1 <- predict(object = xgb1, test1[,-2])
preds_xgb1_test2 <- predict(object = xgb1, test2[,-2])
preds_xgb1_test3 <- predict(object = xgb1, test3[,-2])
preds_xgb1_test4 <- predict(object = xgb1, test4[,-2])
preds_xgb1_test5 <- predict(object = xgb1, test5[,-2])


t2 = Sys.time()
t2 - t1


confusionMatrix(test1$QuoteConversion_Flag, preds_xgb1_test1)
confusionMatrix(test2$QuoteConversion_Flag, preds_xgb1_test2)
confusionMatrix(test3$QuoteConversion_Flag, preds_xgb1_test3)
confusionMatrix(test4$QuoteConversion_Flag, preds_xgb1_test4)
confusionMatrix(test5$QuoteConversion_Flag, preds_xgb1_test5)

# imp <- varImp(xgb1, scale = F)
# plot(imp)


gbmImp1 <- varImp(xgb1, scale = TRUE)
category_1 <- rownames(gbmImp1$importance) 
importance_1 <- gbmImp1$importance$Overall 
importance_df_1 <- data.frame(category_1, importance_1)
importance_df_1 <- arrange(importance_df_1, -importance_1)
importance_df_1 <- importance_df_1[1:20,]

ggplot(data = importance_df_1, 
       aes(x = reorder(category_1, importance_1),
           y = (importance_df_1$importance),
           fill = importance_df_1$importance)) + 
    geom_bar(stat = "identity", 
             width = 0.8, 
             alpha = 0.8) +
    theme(legend.position = "none") + 
    coord_flip() + 
    xlab(NULL) + 
    ylab("% Reduction in Predicitve Performance") + 
    ggtitle("XGBoost Variable Importance (Top 20)")



######################################################################
############################# XGBoost - 2  ###########################
######################################################################
set.seed(100)

train <- read.csv("strategic_sample_train.csv", header = T)[,-1]
train$QuoteConversion_Flag = as.factor(train$QuoteConversion_Flag)


t1 = Sys.time()


xgb2 <- train(QuoteConversion_Flag ~ . ,
              data = train,
              method = "xgbTree",
              trControl = myControl)

save(xgb2, file = "model_strategic.RData")

preds_xgb2_test1 <- predict(object = xgb2, test1[,-2])
preds_xgb2_test2 <- predict(object = xgb2, test2[,-2])
preds_xgb2_test3 <- predict(object = xgb2, test3[,-2])
preds_xgb2_test4 <- predict(object = xgb2, test4[,-2])
preds_xgb2_test5 <- predict(object = xgb2, test5[,-2])


t2 = Sys.time()
t2 - t1


confusionMatrix(test1$QuoteConversion_Flag, preds_xgb2_test1)
confusionMatrix(test2$QuoteConversion_Flag, preds_xgb2_test2)
confusionMatrix(test3$QuoteConversion_Flag, preds_xgb2_test3)
confusionMatrix(test4$QuoteConversion_Flag, preds_xgb2_test4)
confusionMatrix(test5$QuoteConversion_Flag, preds_xgb2_test5)


varImp(xgb2)


######################################################################
############################# XGBoost - 3  ###########################
######################################################################
train <- read.csv("simple_sample_train.csv", header = T)[,-1]
train$QuoteConversion_Flag = as.factor(train$QuoteConversion_Flag)

test1 <- read.csv("simple_sample_test1.csv", header = T)[,-1]
test1$QuoteConversion_Flag = as.factor(test1$QuoteConversion_Flag)

test2 <- read.csv("simple_sample_test2.csv", header = T)[,-1]
test2$QuoteConversion_Flag = as.factor(test2$QuoteConversion_Flag)

test3 <- read.csv("simple_sample_test3.csv", header = T)[,-1]
test3$QuoteConversion_Flag = as.factor(test3$QuoteConversion_Flag)

test4 <- read.csv("simple_sample_test4.csv", header = T)[,-1]
test4$QuoteConversion_Flag = as.factor(test4$QuoteConversion_Flag)

test5 <- read.csv("simple_sample_test5.csv", header = T)[,-1]
test5$QuoteConversion_Flag = as.factor(test5$QuoteConversion_Flag)



# Pairwise Sum of top 3 features - both test and train (mutate)
train <- mutate(train, aplusb = PropertyField37.N+SalesField5)
test1 <- mutate(test1, aplusb = PropertyField37.N+SalesField5)
test2 <- mutate(test2, aplusb = PropertyField37.N+SalesField5)
test3 <- mutate(test3, aplusb = PropertyField37.N+SalesField5)
test4 <- mutate(test4, aplusb = PropertyField37.N+SalesField5)
test5 <- mutate(test5, aplusb = PropertyField37.N+SalesField5)

train <- mutate(train, aplusc = PropertyField37.N+PersonalField10A)
test1 <- mutate(test1, aplusc = PropertyField37.N+PersonalField10A)
test2 <- mutate(test2, aplusc = PropertyField37.N+PersonalField10A)
test3 <- mutate(test3, aplusc = PropertyField37.N+PersonalField10A)
test4 <- mutate(test4, aplusc = PropertyField37.N+PersonalField10A)
test5 <- mutate(test5, aplusc = PropertyField37.N+PersonalField10A)

train <- mutate(train, bplusc = SalesField5+PersonalField10A)
test1 <- mutate(test1, bplusc = SalesField5+PersonalField10A)
test2 <- mutate(test2, bplusc = SalesField5+PersonalField10A)
test3 <- mutate(test3, bplusc = SalesField5+PersonalField10A)
test4 <- mutate(test4, bplusc = SalesField5+PersonalField10A)
test5 <- mutate(test5, bplusc = SalesField5+PersonalField10A)



# Pairwise Difference of top 3 features - both test and train
train <- mutate(train, aminusb = PropertyField37.N-SalesField5)
test1 <- mutate(test1, aminusb = PropertyField37.N-SalesField5)
test2 <- mutate(test2, aminusb = PropertyField37.N-SalesField5)
test3 <- mutate(test3, aminusb = PropertyField37.N-SalesField5)
test4 <- mutate(test4, aminusb = PropertyField37.N-SalesField5)
test5 <- mutate(test5, aminusb = PropertyField37.N-SalesField5)

train <- mutate(train, aminusc = PropertyField37.N-PersonalField10A)
test1 <- mutate(test1, aminusc = PropertyField37.N-PersonalField10A)
test2 <- mutate(test2, aminusc = PropertyField37.N-PersonalField10A)
test3 <- mutate(test3, aminusc = PropertyField37.N-PersonalField10A)
test4 <- mutate(test4, aminusc = PropertyField37.N-PersonalField10A)
test5 <- mutate(test5, aminusc = PropertyField37.N-PersonalField10A)

train <- mutate(train, bminusc = SalesField5-PersonalField10A)
test1 <- mutate(test1, bminusc = SalesField5-PersonalField10A)
test2 <- mutate(test2, bminusc = SalesField5-PersonalField10A)
test3 <- mutate(test3, bminusc = SalesField5-PersonalField10A)
test4 <- mutate(test4, bminusc = SalesField5-PersonalField10A)
test5 <- mutate(test5, bminusc = SalesField5-PersonalField10A)



# 2-Way interactions of top 3 features - both test and train
train <- mutate(train, ab = PropertyField37.N*SalesField5)
test1 <- mutate(test1, ab = PropertyField37.N*SalesField5)
test2 <- mutate(test2, ab = PropertyField37.N*SalesField5)
test3 <- mutate(test3, ab = PropertyField37.N*SalesField5)
test4 <- mutate(test4, ab = PropertyField37.N*SalesField5)
test5 <- mutate(test5, ab = PropertyField37.N*SalesField5)

train <- mutate(train, ac = PropertyField37.N*PersonalField10A)
test1 <- mutate(test1, ac = PropertyField37.N*PersonalField10A)
test2 <- mutate(test2, ac = PropertyField37.N*PersonalField10A)
test3 <- mutate(test3, ac = PropertyField37.N*PersonalField10A)
test4 <- mutate(test4, ac = PropertyField37.N*PersonalField10A)
test5 <- mutate(test5, ac = PropertyField37.N*PersonalField10A)

train <- mutate(train, bc = SalesField5*PersonalField10A)
test1 <- mutate(test1, bc = SalesField5*PersonalField10A)
test2 <- mutate(test2, bc = SalesField5*PersonalField10A)
test3 <- mutate(test3, bc = SalesField5*PersonalField10A)
test4 <- mutate(test4, bc = SalesField5*PersonalField10A)
test5 <- mutate(test5, bc = SalesField5*PersonalField10A)



# 3-Way interaction of top 3 features - both test and train
train <- mutate(train, abc = PropertyField37.N*SalesField5*PersonalField10A)
test1 <- mutate(test1, abc = PropertyField37.N*SalesField5*PersonalField10A)
test2 <- mutate(test2, abc = PropertyField37.N*SalesField5*PersonalField10A)
test3 <- mutate(test3, abc = PropertyField37.N*SalesField5*PersonalField10A)
test4 <- mutate(test4, abc = PropertyField37.N*SalesField5*PersonalField10A)
test5 <- mutate(test5, abc = PropertyField37.N*SalesField5*PersonalField10A)



# 4-Way interaction of top 4 features - both test and train
train <- mutate(train, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test1 <- mutate(test1, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test2 <- mutate(test2, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test3 <- mutate(test3, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test4 <- mutate(test4, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test5 <- mutate(test5, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)


str(test)
str(train)

t1 = Sys.time()


myControl <- trainControl(method = 'repeatedcv', 
                          number = 5, 
                          repeats = 5, 
                          returnResamp = 'none',
                          verboseIter = T)

# xgb3 <- train(QuoteConversion_Flag ~ . ,
#               data = train,
#               method = "xgbTree",
#               trControl = myControl)

load("/Users/Riddhik/Desktop/Homesite/Final_Scripts/model.RData")

preds_xgb3_test1 <- predict(object = xgb3, test1[,-2])
preds_xgb3_test2 <- predict(object = xgb3, test2[,-2])
preds_xgb3_test3 <- predict(object = xgb3, test3[,-2])
preds_xgb3_test4 <- predict(object = xgb3, test4[,-2])
preds_xgb3_test5 <- predict(object = xgb3, test5[,-2])

xgb3

t2 = Sys.time()
t2 - t1

#save(xgb3, file = "model.RData")
#load("model.RData")


confusionMatrix(test1$QuoteConversion_Flag, preds_xgb3_test1)
confusionMatrix(test2$QuoteConversion_Flag, preds_xgb3_test2)
confusionMatrix(test3$QuoteConversion_Flag, preds_xgb3_test3)
confusionMatrix(test4$QuoteConversion_Flag, preds_xgb3_test4)
confusionMatrix(test5$QuoteConversion_Flag, preds_xgb3_test5)

varImp(xgb3)


result.predicted.prob <- predict(object = xgb3, test4[,-2], type = "prob")
result.roc <- roc(test4$QuoteConversion_Flag, result.predicted.prob$`0`) 
plot(result.roc, print.thres="best", print.thres.best.method="closest.topleft")

result.coords <- coords(result.roc, "best", best.method="closest.topleft", ret=c("threshold", "accuracy"))
print(result.coords)#to get threshold and accuracy

x <- coords(result.roc, x = "all",
       input=c("threshold", "specificity","sensitivity"),
       ret=c("threshold", "specificity", "sensitivity"))
x <- as.data.frame(x)
x <- t(x)
x<- as.data.frame(x)

ggplot(data = x, aes(x = specificity, 
                     y = sensitivity)) + 
    geom_line() + 
    scale_x_reverse()  + 
    geom_point(aes(x = 0.887, 
                   y = 0.884), 
               color = "blue") + 
    theme_bw() + 
    geom_abline(intercept = 1, 
                slope = 1, 
                color = "red", 
                linetype = "dashed") +
    geom_text(aes(x = 0.75 , 
                  y = 0.85), 
              label = "(0.887, 0.884), threshold = 0.794, AUC = 0.9625") + 
    ggtitle("ROC: Single Best Model")



######################################################################
############################# XGBoost - 4 ############################
######################################################################
train <- read.csv("simple_sample_train.csv", header = T)[,-1]
train$QuoteConversion_Flag = as.factor(train$QuoteConversion_Flag)

test1 <- read.csv("simple_sample_test1.csv", header = T)[,-1]
test1$QuoteConversion_Flag = as.factor(test1$QuoteConversion_Flag)

test2 <- read.csv("simple_sample_test2.csv", header = T)[,-1]
test2$QuoteConversion_Flag = as.factor(test2$QuoteConversion_Flag)

test3 <- read.csv("simple_sample_test3.csv", header = T)[,-1]
test3$QuoteConversion_Flag = as.factor(test3$QuoteConversion_Flag)

test4 <- read.csv("simple_sample_test4.csv", header = T)[,-1]
test4$QuoteConversion_Flag = as.factor(test4$QuoteConversion_Flag)

test5 <- read.csv("simple_sample_test5.csv", header = T)[,-1]
test5$QuoteConversion_Flag = as.factor(test5$QuoteConversion_Flag)



# Pairwise Sum of top 3 features - both test and train (mutate)
train <- mutate(train, aplusb = PropertyField37.N+SalesField5)
test1 <- mutate(test1, aplusb = PropertyField37.N+SalesField5)
test2 <- mutate(test2, aplusb = PropertyField37.N+SalesField5)
test3 <- mutate(test3, aplusb = PropertyField37.N+SalesField5)
test4 <- mutate(test4, aplusb = PropertyField37.N+SalesField5)
test5 <- mutate(test5, aplusb = PropertyField37.N+SalesField5)

train <- mutate(train, aplusc = PropertyField37.N+PersonalField10A)
test1 <- mutate(test1, aplusc = PropertyField37.N+PersonalField10A)
test2 <- mutate(test2, aplusc = PropertyField37.N+PersonalField10A)
test3 <- mutate(test3, aplusc = PropertyField37.N+PersonalField10A)
test4 <- mutate(test4, aplusc = PropertyField37.N+PersonalField10A)
test5 <- mutate(test5, aplusc = PropertyField37.N+PersonalField10A)

train <- mutate(train, bplusc = SalesField5+PersonalField10A)
test1 <- mutate(test1, bplusc = SalesField5+PersonalField10A)
test2 <- mutate(test2, bplusc = SalesField5+PersonalField10A)
test3 <- mutate(test3, bplusc = SalesField5+PersonalField10A)
test4 <- mutate(test4, bplusc = SalesField5+PersonalField10A)
test5 <- mutate(test5, bplusc = SalesField5+PersonalField10A)



# Pairwise Difference of top 3 features - both test and train
train <- mutate(train, aminusb = PropertyField37.N-SalesField5)
test1 <- mutate(test1, aminusb = PropertyField37.N-SalesField5)
test2 <- mutate(test2, aminusb = PropertyField37.N-SalesField5)
test3 <- mutate(test3, aminusb = PropertyField37.N-SalesField5)
test4 <- mutate(test4, aminusb = PropertyField37.N-SalesField5)
test5 <- mutate(test5, aminusb = PropertyField37.N-SalesField5)

train <- mutate(train, aminusc = PropertyField37.N-PersonalField10A)
test1 <- mutate(test1, aminusc = PropertyField37.N-PersonalField10A)
test2 <- mutate(test2, aminusc = PropertyField37.N-PersonalField10A)
test3 <- mutate(test3, aminusc = PropertyField37.N-PersonalField10A)
test4 <- mutate(test4, aminusc = PropertyField37.N-PersonalField10A)
test5 <- mutate(test5, aminusc = PropertyField37.N-PersonalField10A)

train <- mutate(train, bminusc = SalesField5-PersonalField10A)
test1 <- mutate(test1, bminusc = SalesField5-PersonalField10A)
test2 <- mutate(test2, bminusc = SalesField5-PersonalField10A)
test3 <- mutate(test3, bminusc = SalesField5-PersonalField10A)
test4 <- mutate(test4, bminusc = SalesField5-PersonalField10A)
test5 <- mutate(test5, bminusc = SalesField5-PersonalField10A)



# 2-Way interactions of top 3 features - both test and train
train <- mutate(train, ab = PropertyField37.N*SalesField5)
test1 <- mutate(test1, ab = PropertyField37.N*SalesField5)
test2 <- mutate(test2, ab = PropertyField37.N*SalesField5)
test3 <- mutate(test3, ab = PropertyField37.N*SalesField5)
test4 <- mutate(test4, ab = PropertyField37.N*SalesField5)
test5 <- mutate(test5, ab = PropertyField37.N*SalesField5)

train <- mutate(train, ac = PropertyField37.N*PersonalField10A)
test1 <- mutate(test1, ac = PropertyField37.N*PersonalField10A)
test2 <- mutate(test2, ac = PropertyField37.N*PersonalField10A)
test3 <- mutate(test3, ac = PropertyField37.N*PersonalField10A)
test4 <- mutate(test4, ac = PropertyField37.N*PersonalField10A)
test5 <- mutate(test5, ac = PropertyField37.N*PersonalField10A)

train <- mutate(train, bc = SalesField5*PersonalField10A)
test1 <- mutate(test1, bc = SalesField5*PersonalField10A)
test2 <- mutate(test2, bc = SalesField5*PersonalField10A)
test3 <- mutate(test3, bc = SalesField5*PersonalField10A)
test4 <- mutate(test4, bc = SalesField5*PersonalField10A)
test5 <- mutate(test5, bc = SalesField5*PersonalField10A)



# 3-Way interaction of top 3 features - both test and train
train <- mutate(train, abc = PropertyField37.N*SalesField5*PersonalField10A)
test1 <- mutate(test1, abc = PropertyField37.N*SalesField5*PersonalField10A)
test2 <- mutate(test2, abc = PropertyField37.N*SalesField5*PersonalField10A)
test3 <- mutate(test3, abc = PropertyField37.N*SalesField5*PersonalField10A)
test4 <- mutate(test4, abc = PropertyField37.N*SalesField5*PersonalField10A)
test5 <- mutate(test5, abc = PropertyField37.N*SalesField5*PersonalField10A)



# 4-Way interaction of top 4 features - both test and train
train <- mutate(train, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test1 <- mutate(test1, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test2 <- mutate(test2, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test3 <- mutate(test3, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test4 <- mutate(test4, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)
test5 <- mutate(test5, abcd = PropertyField37.N*SalesField5*PersonalField10A*PersonalField10B)



# Hyperparameter tuning
myControl <- trainControl(method = 'cv', 
                          number = 5, 
                          repeats = 5, 
                          returnResamp = 'none',
                          verboseIter = T)


t1 = Sys.time()


xgb4 <- train(QuoteConversion_Flag ~ . ,
              data = train,
              method = "xgbTree",
              trControl = myControl)


preds_xgb4 <- predict(object = xgb4, test[,-2])


t2 = Sys.time()
t2 - t1


confusionMatrix(test1$QuoteConversion_Flag, preds_xgb4_test1)
confusionMatrix(test2$QuoteConversion_Flag, preds_xgb4_test2)
confusionMatrix(test3$QuoteConversion_Flag, preds_xgb4_test3)
confusionMatrix(test4$QuoteConversion_Flag, preds_xgb4_test4)
confusionMatrix(test5$QuoteConversion_Flag, preds_xgb4_test5)
