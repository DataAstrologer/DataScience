library(caret)
library(dplyr)



#################################################################
################### Dummy Variable Generation  ##################
#################################################################
factor_df = homesite.data[sapply(homesite.data, is.factor)]
drops <- names(factor_df)

dmy1 <- dummyVars("~Field12+
                 PersonalField7+
                 PropertyField3+
                 PropertyField4+
                 PropertyField5+
                 PropertyField14+
                 PropertyField28+
                 PropertyField30+
                 PropertyField31+
                 PropertyField32+
                 PropertyField33+
                 PropertyField34+
                 PropertyField36+
                 PropertyField37+
                 PropertyField38+
                 GeographicField63+
                 GeographicField64+
                 Original_Quote_Year", 
                 data = factor_df)
              

trsf1 <- data.frame(predict(dmy1, 
                            newdata = factor_df))


trsf1 <- rename(trsf1, PersonalField7Neg1 = PersonalField7..1)
trsf1 <- rename(trsf1, 
                PropertyField3Neg1 = PropertyField3..1,
                PropertyField4Neg1 = PropertyField4..1,
                PropertyField32Neg1 = PropertyField32..1,
                PropertyField34Neg1 = PropertyField34..1,
                PropertyField36Neg1 = PropertyField36..1,
                PropertyField38Neg1 = PropertyField38..1)

#names(trsf1)

homesite.data = cbind(homesite.data, 
                      trsf1)


dmy2 <- dummyVars("~Field6+
                  Field10+
                  CoverageField8+
                  CoverageField9+
                  SalesField7+
                  PersonalField16+
                  PersonalField17+
                  PersonalField18+
                  PersonalField19+
                  PropertyField7+
                  Original_Quote_Month+
                  Original_Quote_Day+
                  Original_Quote_Quarter+
                  Original_Quote_Week", 
                  data = factor_df)

trsf2 <- data.frame(predict(dmy2, 
                            newdata = factor_df))

#names(trsf2)

homesite.data = cbind(homesite.data, 
                      trsf2)

homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]
homesite.data$QuoteConversion_Flag <- as.factor(homesite.data$QuoteConversion_Flag)


write.csv(homesite.data, 'homesite_dummy_generated.csv')



#################################################################
####################### Linear Combinations #####################
#################################################################
dim(homesite.data)
str(homesite.data, 
    vec.len = 2, 
    give.attr = T) # only QuoteConversionFlag must be factor


# extract only numeric columns
num_df = homesite.data[sapply(homesite.data, 
                              is.numeric)]


# 1. Fields
linear_columns_field <- num_df[, c(2:5,262,263,316:330)]
linear.matrix.fields <- as.matrix(linear_columns_field)
comboInfo.fields <- findLinearCombos(linear.matrix.fields)
comboInfo.fields
drops <- names(linear_columns_field[comboInfo.fields$remove])

# 2. Coverage Fields
linear_columns_coverage <- num_df[, c(6:19,331:342)]
linear.matrix.coverage <- as.matrix(linear_columns_coverage)
comboInfo.coverage <- findLinearCombos(linear.matrix.coverage)
comboInfo.coverage
drops <- c(drops, names(linear_columns_coverage[comboInfo.coverage$remove]))

# 3. Sales Fields
linear_columns_sales <- num_df[, c(20:35, 344:348)]
linear.matrix.sales <- as.matrix(linear_columns_sales)
comboInfo.sales <- findLinearCombos(linear.matrix.sales)
comboInfo.sales


# 4. Personal Fields
linear_columns_personal <- num_df[, c(36:108, 264, 265, 266, 349:442)]
linear.matrix.personal <- as.matrix(linear_columns_personal)
comboInfo.personal <- findLinearCombos(linear.matrix.personal)
comboInfo.personal
drops <- c(drops, names(linear_columns_personal[comboInfo.personal$remove]))


# 5. Property Feilds 
linear_columns_property <- num_df[, c(109:138, 267:306, 443:456)]
linear.matrix.property <- as.matrix(linear_columns_property)
comboInfo.property <- findLinearCombos(linear.matrix.property)
comboInfo.property
drops <- c(drops, names(linear_columns_property[comboInfo.property$remove]))


# 6. Geographic Fields
linear_columns_geo <- num_df[, c(139:260, 307:312)] 
linear.matrix.geo <- as.matrix(linear_columns_geo)
comboInfo.geo <- findLinearCombos(linear.matrix.geo)
comboInfo.geo
drops <- c(drops, names(linear_columns_geo[comboInfo.geo$remove]))


# Drop some first
homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]


#7. All
# extract only numeric columns
num_df = homesite.data[sapply(homesite.data, 
                              is.numeric)]


linear.fields <- as.matrix(num_df)


comboInfo <- findLinearCombos(linear.fields)
comboInfo


drops <- names(num_df[, comboInfo$remove])
homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]


write.csv(homesite.data, 'ready_for_advanced_preprocessing.csv')