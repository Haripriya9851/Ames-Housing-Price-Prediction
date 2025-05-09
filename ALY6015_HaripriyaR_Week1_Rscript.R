### ALY6015 - Week 1 - Regression Ananlysis
## Created By: Hari Priya Ramamoorthy
## Dataset Details:Ames Housing
## Aim of Analysis - Perform EDA and Regression Analysis on Housing data to find the numeric variables that are influencing sales price.


####################################################################### Load Packages ###################################################################
install.packages('GGally','tibble','knitr','tidyr','janitor','moments','car','leaps')
library(GGally)
library(dplyr)
library(ggplot2)
library(tidyr)
library(tibble)
library(knitr)
library(corrplot)
library(janitor)
library(car)
library(moments)
library(leaps)
####################################################################### Load Packages ###################################################################

####################################################################### Data cleaning - Step-1,2 ###################################################################

##Load Ameshousing Dataset
housing <- read.table(file.choose(), sep=",",header=TRUE, stringsAsFactors = FALSE)

##Standardize column names with janitor package
housing<-janitor::clean_names(housing)
names(housing)

create_glimpse_table <- function(df) {
  tibble(
    Column_Name = names(df),
    Data_Type = sapply(df, class),
    Example_Value = sapply(df, function(x) if (length(x) > 0) x[1] else NA)
  )
}
raw_data_glimpse<-create_glimpse_table(housing)
summary(housing)
str(housing)


### check missing values  Check
missing_values <- sapply(housing, function(x) sum(is.na(x)))
print(missing_values[missing_values > 0])

#Based on data dictionary, replace values for Columns where NA means not present.
not_present_columns <- c('alley', 'garage_finish', 'garage_type', 'garage_qual', 'garage_cond',
                         'bsmt_fin_type_1','bsmt_fin_type_2','bsmt_exposure','bsmt_cond','bsmt_qual',
                         'fireplace_qu',  'pool_qc','fence', 'misc_feature')
# Replace NA values with 'Not Present' in the specified columns
housing[not_present_columns] <- lapply(housing[not_present_columns], function(x) ifelse(is.na(x), 'Not Present', x))

# for numerical columns let's replace NA values with Median
num_missing_cols <- sapply(housing, function(x) is.numeric(x) && any(is.na(x)))
num_missing_cols <- names(num_missing_cols[num_missing_cols == TRUE])

# Replace NA with the median in these numerical columns
housing[num_missing_cols] <- lapply(housing[num_missing_cols], function(x) {
  x[is.na(x)] <- median(x, na.rm = TRUE)
  return(x)
})
### check missing values Again
missing_values <- sapply(housing, function(x) sum(is.na(x)))
# Print the result
print(missing_values[missing_values > 0])
####################################################################### Data cleaning - Step-1,2 ###################################################################

####################################################################### EDA Visualizations - Step3 ############################################################################


##  Histogram on Sales Price Distribution - Right Skewed
ggplot(housing, aes(x = sale_price/1000)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  labs(title = "Distribution of SalePrice", x = "SalePrice (In Thousand $ ) ", y = "Count")+
  theme_minimal()+
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  ) +
  scale_x_continuous(limits = c(0,1000, 100))

##  Histogram on Sales Price Distribution - Right Skewed
ggplot(housing, aes(x = lot_area)) +
  geom_histogram( fill = "green", color = "black") +
  labs(title = "Distribution of Lot Area", x = "Lot Area (In Sq Ft ) ", y = "Count")+
  
  theme_minimal()+
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  ) 


# Histogram of Living Area
ggplot(housing, aes(x = gr_liv_area)) +
  geom_histogram(bins = 30, fill = "orange", color = "black") +
  labs(title = "Distribution of Ground Living Area", x = "Ground Living Area (in Sq. Feet)", y = "Count")+
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  ) 

# Boxplot comparing Saleprice variation by Overall Quality of the house
ggplot(housing, aes(x = reorder(factor(overall_qual),desc(sale_price/1000)), y = sale_price/1000)) +
  geom_boxplot(fill = "lightcoral", color = "black") +
  labs(title = "SalePrice by Overall Quality", x = "Overall Quality", y = "SalePrice (In Thousand $ )") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  ) 

# Box plot for SalePrice vs. Neighborhood
ggplot(housing, aes(x = reorder(neighborhood,desc(sale_price/1000)), y = sale_price/1000)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "SalePrice by Neighborhood", x = "Neighborhood", y = "SalePrice  (In Thousand $)")+
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.title.x = element_text(size = 12),
      axis.title.y = element_text(size = 12),
      axis.text.x = element_text(size = 10, hjust = 1),
      axis.text.y = element_text(size = 10)
    ) 
####################################################################### EDA - Step-3 ############################################################################

####################################################################### Correlarion And Scatter Plot Analysis For Numeric Variables -Step-4,5,6 ####################################
numeric_vars <- sapply(housing, is.numeric)
corr_matrix <- cor(housing[, numeric_vars], use = "complete.obs")

# Plot correlation matrix showing only the upper half
#### Insights from Plot
# High Correlation : gr_liv_area,overallquality; Low/No Correlation:pool_area,year ; Medium correlation-tot_rmsabv_grd,full_bath
corrplot(corr_matrix, method = "color", order = "hclust", tl.cex = 1.1, type = "upper")
title(main = "Correlation Heat Map")

# scatter plot-1 Between Highly Correlated Ground living Area vs SalePrice
ggplot(housing, aes(x = gr_liv_area, y = sale_price/1000)) +
  geom_point(color = "blue", alpha = 0.5) +
  labs(title = "Ground Living Area vs Sale Price - High Correlation of 0.714",
       x = "Ground Living Area (sq ft)",
       y = "Sale Price (In Thousand $)") +
  geom_smooth(method = "lm", col = "red", size = 1) +  # Linear regression line
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  ) 

# scatter plot-2 Between Least Correlated pool_area vs SalePrice
ggplot(housing, aes(x = pool_area, y = sale_price/1000)) +
  geom_point(color = "blue", alpha = 0.5) +
  labs(title = "Pool Area vs Sale Price - Low Correlation of 0.067",
       x = "Pool Area (sq ft)",
       y = "Sale Price (In Thousand $)") +
  theme_minimal() +
  geom_smooth(method = "lm", col = "red", size = 1) +  # Linear regression line
  
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  )

ggplot(housing, aes(x = tot_rms_abv_grd, y = sale_price/1000)) +
  geom_point(color = "blue", alpha = 0.5) +
  labs(title = "Total Rooms vs Sale Price - Medium Correlation of 0.523",
       x = "Total Rooms ",
       y = "Sale Price (In Thousand $)") +
  theme_minimal() +
  geom_smooth(method = "lm", col = "red", size = 1) +  # Linear regression line
  
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10)
  )

# Scatter plot matrix for numeric variables with high,low, medium correlation
# Reference: https://stackoverflow.com/questions/68638725/how-to-address-overplotting-in-ggallyggpairs
ggpairs(housing[, c("sale_price", "gr_liv_area", "overall_qual","tot_rms_abv_grd", "pool_area",'x1st_flr_sf')])
####################################################################### Correlarion And Scatter Plot Analysis For Numeric Variables -Step-4,5,6 ####################################


####################################################################### LR model 1 - No Feature Engineering #######################################################################
########## Select Highly correlated variables to model the sales price 
model_columns <- c("gr_liv_area", "overall_qual", "garage_area", 'lot_area','tot_rms_abv_grd','total_bsmt_sf','x1st_flr_sf')
model1 <- lm(sale_price ~ gr_liv_area + overall_qual + garage_area + lot_area + tot_rms_abv_grd + total_bsmt_sf+ x1st_flr_sf, data=housing)
summary(model1)
### Residual Plot
par(mfrow=c(2,2))
plot(model1)

## Normalize continuous variables sale_price lot_area to remove skewness, 
housing$sale_price_normalized <- log(housing$sale_price)
housing$lot_area_normalized =log(housing$lot_area)


######### Multi-collinearity Check: correlation Matrix and VIF Test , Outlier Check : car package #########
##### Insights from correlation Matrix and VIF Test
## 1. Remove gr_liv_area - correlated with Overall_quality,1st floor square feet
#corr_matrix_model_data <- cor(housing[, model_columns], use = "complete.obs")
#corrplot(corr_matrix_model_data, method = "color", order = "hclust", tl.cex = 1.1, title = "Correlation Heatmap")
######### Identify Multi Collinearity with VIF Test
vif1<-data.frame("Variance_Inflation_Factor"=vif(model1))

########## Outlier Test on Model 2 #################

outlier_result <- outlierTest(model1)
print(outlier_result)
# Let's get the indices of the outlier observations based on the row numbers from the outlierTest result
outlier_indices <- c(182, 1554, 1499, 2181, 2182, 1183, 1556, 373, 727)
# Extract the outliers from the dataset
outlier_data <- housing[outlier_indices, ]
# Show the outlier rows with their values
print(outlier_data[model_columns])
#### Insights 1. Outlier Present - Because of the room size and garage, which has meaningful data, so no action taken
########## Outlier Test #################

####################################################################### LR model 1 - No Feature Engineering #######################################################################


####################################################################### LR model 2 - After Feature Engineering #######################################################################

new_model_columns = c("overall_qual", "tot_rms_abv_grd", "garage_area", "lot_area_normalized")
model2 <- lm(sale_price_normalized ~ overall_qual + tot_rms_abv_grd + garage_area + lot_area_normalized , data=housing)
summary(model2)



### Residual Plot
par(mfrow=c(2,2))
plot(model2)

## Component +Residual Plot for each predictor
### Residual Plot
par(mfrow=c(1,1))
crPlots(model2)
####################################################################### LR model 2 - After Feature Engineering #######################################################################

################################ subset Regression ################################################################

nullModel <- lm(sale_price_normalized ~ 1,data=housing )
fullModel <- lm(sale_price_normalized ~ overall_qual + tot_rms_abv_grd + garage_area + lot_area_normalized  ,data=housing )

# step-wise regression in both directions
step_model <- step(nullModel,scope=list(lower=nullModel,upper=fullModel),direction = "both")

# Extract the anova table from the stepwise model, which contains the step information.
step_info <- step_model$anova

# Create a data frame to store step information for plotting
stepwise_df <- data.frame(
  Step = 1:nrow(step_info),
  AIC = step_info$AIC,
  Variable = step_info$Step
)

# Use kable to display the table in a report-friendly format
kable(stepwise_df, 
      caption = "Stepwise Regression: Steps, AIC, and Variables Added/Removed",
      col.names = c("Step", "AIC", "Variable Added/Removed"),
      format = "markdown") 

# Print the table for reporting
print(stepwise_df)
summary(step_model)
################################################################ stepwise Regression ################################################################
