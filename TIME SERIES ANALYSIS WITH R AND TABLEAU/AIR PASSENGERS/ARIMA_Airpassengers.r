# ARIMA MODEL APPLIED TO SEASONAL AIRLINE PASSENGER LEVELS RECORDED OVER TIME

library(tseries)
library(forecast)

# LOAD DATA
data(AirPassengers)
AP= AirPassengers
class(AP) 
# AP is a time series

AP
# Monthly data captured each month

# Visualise the time series
plot(AP)
# Show trend line (mean) of the data
abline(reg=lm(AP~time(AP)), col="blue")

# Check for correlations and stationarity of full data set
# Ljung Box test
Box.test(AP, lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  times_series
# X-squared = 1923.7, df = 45, p-value < 2.2e-16
# With this low p value we can determine that there is serial correlation
# and the time series is non-stationary

# ACF AND PACF PLOTS OF TIME SERIES
acf(as.data.frame(AP), main="Air Passengers ACF plot") # High serial correlations, data is non-stationary
pacf(as.data.frame(AP), main="Air Passengers PACF plot") #spike at lag 1 and 13....may indicate a
# seasonality aspect?

# Check for seasonality and trend by decomposing the time series
fit<-stl(AP, s.window="periodic")
plot(fit, main="Air Passengers decomposition") # 

# Seasonal plot
seasonplot(AP, main="Air Passengers Seasonal Plot", ylab = "Passengers", year.labels = TRUE, year.labels.left = TRUE,
           labelgap = 0.8, col = 1:20, pch = 15, lwd = 3)
# Seasonal patterns evident across the months each year 

# Further sesaonal check using boxplots
boxplot(AP~cycle(AP)) 
# months follows similar pattern and variances are similar also

# Make the ts stationary before applying any time series models

# Remove the trend  by differencing the time series using diff() which makes
# the time series stationary
diff_AP <- diff(AP) 
plot(diff_AP, main="Air Passengers differenced time series") 
# now displays a stationary time series as the mean is approx zero

adf.test(diff_AP, alternative="stationary", k=0)
# Augmented Dickey-Fuller Test
# 
# data:  diff_NKE
# Dickey-Fuller = -8.5472, Lag order = 0, p-value = 0.01
# alternative hypothesis: stationary
# With this low p value we can determine that the time series is now stationary
# and we can now perform time series modelling. 

# Diagnose ACF and PACF of transformed time series:

# ACF and PACF plots of the differenced time series:
acf(as.data.frame(diff_AP) , lag.max=50, main="Air Passengers acf plot of differened time series")  
pacf(as.data.frame(diff_AP) , lag.max=50, main="Air Passengers pacf plot of differened time series") 
# ACF displays a clear positive and negative trends across lags
# PACF plot - correlation at 1 and then drops off, however other correlations present
# Looks to me like an MA model o


# automatically fitting model to the seasonal data
auto.fit<-auto.arima(AP, seasonal=T)  # automatic way to find the optimized model
summary(auto.fit)
# Series: AP 
# ARIMA(2,1,1)(0,1,0)[12] 
# 
# Coefficients:
#         ar1     ar2      ma1
#       0.5960  0.2143  -0.9819
# s.e.  0.0888  0.0880   0.0292
# 
# sigma^2 estimated as 132.3:  log likelihood=-504.92
# AIC=1017.85   AICc=1018.17   BIC=1029.35
# 
# Training set error measures:
#                  ME     RMSE     MAE      MPE     MAPE     MASE        ACF1
# Training set 1.3423 10.84619 7.86754 0.420698 2.800458 0.245628 -0.00124847

# ARIMA model (2,1,1)(0,1,0)[12] indicating AR(2), integrated once, MA (2).
# Plus the seasonal element is captured (0,1,0) and [12] indicating the monthly
# time series

Box.test(residuals(auto.fit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(auto.arima)
# X-squared = 56.054, df = 45, p-value = 0.125
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(auto.fit), main="Air Passengers Residuals of auto.arima") 
# acf plot indicates residuals look like white noise - again good model fit

# Forecast 2 years ahead
auto.fcast <- forecast(auto.fit, h=24)
plot(auto.fcast)
# ARIMA model is excellent at capturing the seasonal trend into the future
# The lighter coloured confidence bands levels are in really good shape too 
# and align very closely with the predictions.




