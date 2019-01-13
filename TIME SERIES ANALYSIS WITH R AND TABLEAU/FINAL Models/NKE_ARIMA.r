# ARIMA MODEL APPLIED ON NIKE STOCK & ACTUAL V FORECAST OVER 2017
# PLUS FURTHER FORECASTING METHODS: NEURAL NETWORK, EXPO SMOOTHING, & TBATS

library(quantmod)
library(forecast)
library(tseries)

#Pull monthly data from Yahoo Finance

getSymbols("NKE", src = "yahoo", from = '2006-01-01', to = '2017-12-31')
NKE <- to.monthly(NKE)
NKE = na.omit(NKE) # take out any missing values
frequency(NKE) # shows frequency of data is monthly
View(NKE)
stock_prices= NKE$NKE.Adjusted # use the Adjusted stock price
View(stock_prices)

# Validate the assumptions:
plot(stock_prices, main = "NKE Plot of Adjusted Closing Stock prices")

#Create a time series of the stock prices
times_series=ts(as.numeric(stock_prices), start=c(2006,1),end=c(2017,12),frequency = 12)
View(times_series)
#setup training dataset to 2016 year end
times_series_train=ts(as.numeric(stock_prices), start=c(2006,1),end=c(2016,12), frequency = 12)
View(times_series_train)
class(times_series_train) # shows we now have time series data

plot(times_series_train) # plot the time series, its mean is non stationary, it has a increasing trend as the stock price increases with time
abline(reg=lm(times_series_train~time(times_series_train)), col="blue") 
#fits a regression trend line - upward trend clearly visible

# EXPLORATORY ANALYSIS:

# Check for correlations and stationarity of full data set
# Ljung Box test
Box.test(times_series, lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  times_series
# X-squared = 2588.9, df = 45, p-value < 2.2e-16
# With this low p value we can determine that there is serial correlation
# and the time series is non-stationary

# Augmented Dickey-Fuller Test
adf.test(times_series)
# Augmented Dickey-Fuller Test
# 
# data:  times_series
# Dickey-Fuller = -2.1166, Lag order = 5, p-value = 0.5279
# alternative hypothesis: stationary
# With a high P value like this we will have to difference the time series

# Check for seasonality and trend by decomposing the training time series
fit<-stl(times_series_train, s.window="periodic")
plot(fit) # 

# Seasonal plot
seasonplot(times_series_train, main="NKE Seasonal Plot", ylab = "NKE stock price", year.labels = TRUE, year.labels.left = TRUE,
           labelgap = 0.8, col = 1:20, pch = 15, lwd = 3)
# no clear seasonal patterns, although '13,'14, and '15 have a similar trend upwards

# MODEL ESTIMATION:

# ACF AND PACF PLOTS 
acf(as.data.frame(times_series_train) , lag.max=50, main="NKE ACF Plot time_series_train")  # correlation plot, 
# there is major serial correlation and this is a non stationary time series.
pacf(as.data.frame(times_series_train) , lag.max=50, main="NKE PACF Plot time_series_train") 
# It is clear this time series needs to be differenced to adjust for non-stationarity

# Make the ts stationary and constant variance

# We also need to remove the trend aspect by differencing the time series using diff() which makes
# the time series stationary
diff_NKE <- diff(times_series_train) 
plot(diff_NKE, main="NKE differenced time series") 
# now displays a stationary time series as the mean is approx zero

adf.test(diff_NKE, alternative="stationary", k=0)
# Augmented Dickey-Fuller Test
# 
# data:  diff_NKE
# Dickey-Fuller = -10.246, Lag order = 0, p-value = 0.01
# alternative hypothesis: stationary
# With this low p value we can determine that the time series is now stationary
# and we can now perform time series modelling. 

# Diagnose ACF and PACF of transformed time series:

# ACF and PACF plots of the differenced time series:
acf(as.data.frame(diff_NKE) , lag.max=50, main="NKE acf plot of differened time series")  
pacf(as.data.frame(diff_NKE) , lag.max=50, main="NKE pacf plot of differened time series") 
# ACF similar to white noise although there is correlation at lag 20 and lag 48...
# PACF plot is similar to white noise so overall suggests the time series is random, i.e. random walk.
# Therefore as we have differenced once our ARIMA model would be of the order
# 0,1,0

# BUILD MODEL
# Fit an ARIMA model differenced twice and MA order 1
arimafit <- Arima(times_series_train, order = c(0,1,0), include.drift = TRUE)
summary(arimafit)
# Series: times_series_train 
# ARIMA(0,1,0) with drift 
# 
# Coefficients:
#       drift
#       0.3392
# s.e.  0.1356
# 
# sigma^2 estimated as 2.427:  log likelihood=-243.46
# AIC=490.92   AICc=491.01   BIC=496.67
# 
# Training set error measures:
#                        ME     RMSE      MAE        MPE     MAPE      MASE       ACF1
# Training set 3.855748e-05 1.546069 1.074318 -0.7970566 5.022793 0.1826082 0.09775239

# examine residuals of arima model using Ljung box test to check for goodness of fit
Box.test(residuals(arimafit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(arimafit)
# X-squared = 37.148, df = 45, p-value = 0.791
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(arimafit), main="NKE Residuals of arimafit") 
# acf plot indicates residuals look like white noise

# Try auto.arima
auto.fit<- auto.arima(times_series_train, seasonal=T)
summary(auto.fit)
# Series: times_series_train 
# ARIMA(0,1,0) with drift 
# 
# Coefficients:
#        drift
#       0.3392
# s.e.  0.1356
# 
# sigma^2 estimated as 2.427:  log likelihood=-243.46
# AIC=490.92   AICc=491.01   BIC=496.67
# 
# Training set error measures:
#                        ME     RMSE      MAE        MPE     MAPE      MASE       ACF1
# Training set 3.855748e-05 1.546069 1.074318 -0.7970566 5.022793 0.1826082 0.09775239

Box.test(residuals(auto.fit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(auto.arima)
# X-squared = 37.148, df = 45, p-value = 0.791
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(auto.fit), main="NKE Residuals of auto.arima") 
# acf plot indicates residuals look like white noise

# MODEL DECISION
# Both models return exactly the same results, AIC and error measures.
# This ARIMA model or order 0,1,0 is essentially a random walk.
# I will chose the auto.fit model for the predictions stage

# Proceed to forecasting as we believe we’ve found a good model

# forecast 1 full year stock prices, h=12 i.e. 12 months ahead
for_train <- forecast(auto.fit, h = 12)
autoplot(for_train)
for_train
# grab the actual stock prices for 2017
NKE_test <- (window(times_series, 2017, c(2017, 12)))
NKE_test

# Get the forecasted figures only
fcast_Data <- as.data.frame(for_train)
predicted_stocks <- fcast_Data[,1]
predicted_stocks

# actual stock prices
actual_stocks <- as.numeric(NKE_test)
actual_stocks

# plot Actual vs Predicted forecasts
predicted_stocks_ts=ts(predicted_stocks, start=c(2017,1),frequency = 12)
predicted_stocks_ts
actual_stock_ts=ts(actual_stocks, start=c(2017,1),frequency = 12)
actual_stock_ts
ts.plot(predicted_stocks_ts, actual_stock_ts, main = "NKE ARIMA actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(predicted_stocks, actual_stocks)
#               ME     RMSE      MAE     MPE    MAPE
# Test set 3.45405 4.554767 3.753655 5.945422 6.527056

#############################################################################
# OTHER FORECAST METHODS:

# NEURAL NETWORK FORECAST

nn_fit <- forecast(nnetar(times_series_train, lambda=0), h = 12)
autoplot(nn_fit, 
         holdout=NKE,
         forc_name = 'Neural Network',
         ts_object_name = 'NKE')

# Get the forecasted figures only
nn_predicted_stocks <- as.numeric(nn_fit$mean)
View(nn_predicted_stocks)

# plot Actual vs Predicted forecasts
nn_predicted_stocks_ts=ts(nn_predicted_stocks, start=c(2017,1),frequency = 12)
nn_predicted_stocks_ts

ts.plot(nn_predicted_stocks_ts, actual_stock_ts, main = "NKE NN actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(nn_predicted_stocks, actual_stocks)
#                ME    RMSE      MAE      MPE     MAPE
# Test set 3.539793 4.610833 3.78805 6.100947 6.583585

##############################################################################
# EXPONENTIAL SMOOTHING FORECAST

exposmooth_fit <- forecast(ets(times_series_train), h = 12)
autoplot(exposmooth_fit, 
         holdout=NKE,
         forc_name = 'Exponential Smoothing',
         ts_object_name = 'NKE')

# Get the forecasted figures only
expo_fcast_Data <- as.data.frame(exposmooth_fit)
expo_predicted_stocks <- expo_fcast_Data[,1]
expo_predicted_stocks

# plot Actual vs Predicted forecasts
expo_predicted_stocks_ts=ts(expo_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(expo_predicted_stocks_ts, actual_stock_ts, main = "NKE EXPO actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(expo_predicted_stocks, actual_stocks)
#               ME     RMSE      MAE     MPE    MAPE
# Test set 4.14554 5.138482 4.244956 7.178449 7.371944

###############################################################
# TBATS forecast

tbats_test = tbats(times_series_train)
tbats_forecast = forecast(tbats_test, h=12)
autoplot(tbats_forecast, 
         holdout=NKE,
         forc_name = 'TBATS',
         ts_object_name = 'NKE')

# Get the forecasted figures only
tbats_fcast_Data <- as.data.frame(tbats_forecast)
tbats_predicted_stocks <- tbats_fcast_Data[,1]
View(tbats_predicted_stocks)

# plot Actual vs Predicted forecasts
tbats_predicted_stocks_ts=ts(tbats_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(tbats_predicted_stocks_ts, actual_stock_ts, main = "NKE TBATS actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(tbats_predicted_stocks, actual_stocks)
#                ME     RMSE      MAE     MPE     MAPE
# Test set 2.064153 3.608438 3.203401 3.47079 5.656869
