# Ames Housing Price Prediction model optimization with R

Please read whole report : 

This report performs exploratory data analysis (EDA) and regression analysis on the Ames Housing dataset to identify variables influencing sale price using ML optimization and feature engineering techniques. The dataset contains 2,930 observations and 82 variables, sourced from the Ames Assessor’s Office, which provides detailed housing attributes, including both structural and locational characteristics that impact residential property prices.

# Exploratory Data Analysis
![image](https://github.com/user-attachments/assets/1a2d291e-7226-47e9-b4b6-47613023a951)

# Linear Model - Residual Plot  of Model  without Feature Engineering
<img width="350" alt="image" src="https://github.com/user-attachments/assets/24d2e407-0f86-40bd-8275-1657cea40141" />
<img width="469" height="400" alt="image" src="https://github.com/user-attachments/assets/c5607d67-0ec4-4a37-bfd3-52d9d660c89f" />

The adjusted R-squared of 0.7841 suggests that the model explains 78.41% of the variance in the sale price with 7 dependent variables. (Figure-LHS)

Figure-RHS presents the residual plot for the model without feature engineering, revealing several key insights:
1.	The linear assumption is violated, as indicated by the non-flat residual vs. fitted plot.
2.	The residuals appear to be normally distributed, as the Q-Q plot shows the residuals aligning with a straight line.
3.	The homoscedasticity test fails, with the scale-location plot indicating non-constant variance.
4.	Multicollinearity exists, as shown by outliers in the residuals vs. leverage plot.

Hence, the next step is to do scale, handle Multi Collinearity, Outliers to refine the model.

# Apply Feature Engineering
- Handle Homoscedasticity with Normalizing the variables
- Handle Outliers


# Optimized Linear Model - Residual Plot of After Feature Engineering
<img width="350" alt="image" src="https://github.com/user-attachments/assets/06be8b2d-8544-40c3-a917-c53913090a12" />
<img width="469" height="400" alt="image" src="https://github.com/user-attachments/assets/741865d4-bba1-4cdb-872c-6291ee31ccd8" />

After scaling, removing multicollinearity and examining outlier checks, new linear model was fitted to understand the variables influencing the normalized salesprice. 
The adjusted R-squared of 0.7811 indicates that the model explains 78.11% of the variance in sale price, which is nearly identical to the previous model, but with only four significant predictors after feature engineering.

Subset Regression with StepWise Regression

The stepwise regression model was used to identify the best set of predictor variables for sale_price_normalized. The results, displayed in Figure, indicate that each variable included in the final model contributes to reducing the Akaike Information Criterion (AIC), which suggests that all variables have predictive value for the normalized sale price. 

<img width="340" alt="image" src="https://github.com/user-attachments/assets/a78af412-951c-4c26-9f65-aa6ab53fc65c" />

# Insights
1.	**Significant Predictors:** The model indicates that overall quality, lot area, garage area, and total rooms above grade are all significant predictors of the sale price.
2.	**Model Fit:** With an R-squared value of 0.7811, the model explains approximately 78% of the variance in sale price, providing a good fit for predicting the normalized sale price.
3.	**AIC Reduction:** The stepwise approach, which selects predictors based on their contribution to minimizing AIC, has resulted in a set of variables that collectively contribute to the best model identified in Step-9 of this analysis.
4.	**Model Comparison:** The model with 7 variables and the model with 4 variables predict similarly, emphasizing the importance of identifying the most effective predictors.

# Conclusion
The Stepwise Regression Model identifies key predictors—overall_qual, lot_area_normalized, garage_area, and tot_rms_abv_grd—with an adjusted R-squared of 0.7811, indicating a strong fit for predicting normalized sale prices as identified by model in Step-9. After performing feature engineering and addressing issues like multicollinearity and homoscedasticity, the revised model showed only slight improvement in fit, with fewer predictors but similar R-squared values. The stepwise model, being simpler and more interpretable, provides a clearer understanding of the most influential factors in determining sale prices, while both models underscore the importance of property quality, size, and functionality.








