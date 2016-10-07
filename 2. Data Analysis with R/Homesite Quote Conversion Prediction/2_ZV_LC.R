library(caret)




#################################################################
###################### Zero-Variance Columns ####################
#################################################################
dim(homesite.data)


# Zero Variance, first 100 features
homesite.100 <- homesite.data[, 1:100]
zero.values = nearZeroVar(homesite.100, 
                          saveMetrics = TRUE)
zero.values[zero.values[, "zeroVar"] == TRUE, ]


# Near-zero variance, first 100 features
zv <- zero.values[zero.values[, "zeroVar"] +
                        zero.values[, "nzv"] == TRUE, ]
zv_df <- as.data.frame(zv)


# save
ratio_names <- rownames(zv_df)
freqratio <- zv_df$freqRatio


# Zero Variance, next 100 features
homesite.200 <- homesite.data[, 101:200]
zero.values.2 = nearZeroVar(homesite.200, 
                            saveMetrics = TRUE)
zero.values.2[zero.values.2[, "zeroVar"] == TRUE, ]



# Near-zero variance, next 100 features
zv2 <- zero.values.2[zero.values.2[, "zeroVar"] +
                           zero.values.2[, "nzv"] == TRUE, ]
zv_df2 <- as.data.frame(zv2)


# save
ratio_names <- c(ratio_names, 
                 rownames(zv_df2))
freqratio <- c(freqratio, 
               zv_df2$freqRatio)


# Zero Variance, next 102 features
homesite.300 <- homesite.data[, 201:302]
zero.values.3 = nearZeroVar(homesite.300, 
                            saveMetrics = TRUE)
zero.values.3[zero.values.3[, "zeroVar"] == TRUE, ]


# Near-zero variance, next 102 features
zv3 <- zero.values.3[zero.values.3[, "zeroVar"] +
                           zero.values.3[, "nzv"] == TRUE, ]
zv_df3 <- as.data.frame(zv3)


# save
ratio_names <- c(ratio_names, rownames(zv_df3))
freqratio <- c(freqratio, zv_df3$freqRatio)


# Plot near-zv data
zv_ratio <- round(freqratio)
zv_features <- ratio_names


new_zv_df <- data.frame(zv_features, zv_ratio)
new_zv_df <- arrange(new_zv_df, -zv_ratio)


gg_zv <- head(new_zv_df, 25)
gg_zv$zv_features <- factor(gg_zv$zv_features, 
                            levels = gg_zv$zv_features[order(-gg_zv$zv_ratio)])


ggplot(data = gg_zv, aes(x = zv_features, 
                         y = zv_ratio, 
                         fill = zv_features)) + 
      geom_bar(stat = "identity") + 
      theme(legend.position = "none") + 
      theme(axis.text.x = element_text(angle = 90, 
                                       hjust = 1),
            axis.text=element_text(size=10,face="bold")) + 
      xlab(NULL) + 
      ylab(NULL) + 
      ggtitle("Near Zero-Variance") + 
      geom_hline(yintercept=10000, 
                 color = "red", 
                 linetype="dashed") + 
      scale_y_continuous(breaks=seq(0, 130500, 10000))


# CrossTable(homesite.data$GeographicField10B)
# CrossTable(homesite.data$PropertyField20)
# CrossTable(homesite.data$PropertyField9)


#Drop zv and near-zv columns
drops <- c("PropertyField6", 
           "GeographicField10A", 
           "GeographicField10B",
           "PropertyField20",
           "PropertyField9")

homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]




#################################################################
####################### Linear Combinations #####################
#################################################################

# extract only numeric columns
num_df = homesite.data[sapply(homesite.data, 
                              is.numeric)]
dim(num_df)
#colnames(num_df)


# 1. Fields
linear_columns_field <- num_df[, 3:6]
linear.matrix.fields <- as.matrix(linear_columns_field)
comboInfo.fields <- findLinearCombos(linear.matrix.fields)
comboInfo.fields


# 2. Coverage Fields
linear_columns_coverage <- num_df[, 7:20]
linear.matrix.coverage <- as.matrix(linear_columns_coverage)
comboInfo.coverage <- findLinearCombos(linear.matrix.coverage)
comboInfo.coverage


# 3. Sales Fields
linear_columns_sales <- num_df[, 21:36]
linear.matrix.sales <- as.matrix(linear_columns_sales)
comboInfo.sales <- findLinearCombos(linear.matrix.sales)
comboInfo.sales


# 4.a. Personal Fields
linear_columns_personal <- num_df[, 37:114]
linear.matrix.personal <- as.matrix(linear_columns_personal)
comboInfo.personal <- findLinearCombos(linear.matrix.personal)
comboInfo.personal
drops <- names(linear_columns_personal[,comboInfo.personal$remove])
homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]

# Example:
# (X)*PersonalField27 + (Y)*Personal Field77 = PersonalField82 
# Drop Z

# [1] "PersonalField65" "PersonalField67"
# [3] "PersonalField80" "PersonalField81"
# [5] "PersonalField82"


# 5. Property Feilds
linear_columns_property <- num_df[, 115:144]
linear.matrix.property <- as.matrix(linear_columns_property)
comboInfo.property <- findLinearCombos(linear.matrix.property)
comboInfo.property
drops <- names(linear_columns_property[,comboInfo.property$remove])
homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]


# 6. Geographic Fields
linear_columns_geo <- num_df[, 145:266]
linear.matrix.geo <- as.matrix(linear_columns_geo)
comboInfo.geo <- findLinearCombos(linear.matrix.geo)
comboInfo.geo


#7. All
num_df = homesite.data[sapply(homesite.data, is.numeric)]
linear.matrix <- as.matrix(num_df)
comboInfo <- findLinearCombos(linear.matrix)
comboInfo

drops <- c("PersonalField65",
           "PersonalField67",
           "PersonalField80",
           "PersonalField81",
           "PersonalField82")

homesite.data = homesite.data[, !(names(homesite.data) %in% drops)]