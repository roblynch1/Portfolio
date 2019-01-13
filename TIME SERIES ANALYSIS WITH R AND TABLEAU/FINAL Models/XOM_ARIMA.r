# ARIMA MODEL APPLIED ON EXXON MOBIL STOCK & ACTUAL V FORECAST OVER 2017
# PLUS FURTHER FORECASTING METHODS: NEURAL NETWORK, EXPO SMOOTHING, & TBATS

library(quantmod)
library(forecast)
library(tseries)

#Pull monthly data from Yahoo Finance

getSymbols("XOM", src = "yahoo", from = '2006-01-01', to = '2017-12-31')
XOM <- to.monthly(XOM)
XOM = na.omit(XOM) # take out any missing values
frequency(XOM) # shows frequency of data is monthly
View(XOM)
stock_prices= XOM$XOM.Adjusted # use the Adjusted stock price
View(stock_prices)

# Validate the assumptions:
plot(stock_prices, main = "XOM Plot of Adjusted Closing Stock prices")

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
# X-squared = 1614.7, df = 45, p-value < 2.2e-16
# With this low p value we can determine that there is serial correlation
# and the time series is non-stationary

# Augmented Dickey-Fuller Test
adf.test(times_series)
# Augmented Dickey-Fuller Test
# 
# data:  times_series
# Dickey-Fuller = -2.6377, Lag order = 5, p-value = 0.3109
# alternative hypothesis: stationary
# With a high P value like this we will have to difference the time series

# Check for seasonality and trend by decomposing the training time series
fit<-stl(times_series_train, s.window="periodic")
plot(fit) # 

# Seasonal plot
seasonplot(times_series_train, main="XOM Seasonal Plot", ylab = "XOM stock price", year.labels = TRUE, year.labels.left = TRUE,
           labelgap = 0.8, col = 1:20, pch = 15, lwd = 3)
# no clear seasonal patterns, to the naked eye

# MODEL ESTIMATION:

# ACF AND PACF PLOTS 
acf(as.data.frame(times_series_train) , lag.max=50, main="XOM ACF Plot time_series_train")  # correlation plot, 
# there is major serial correlation and this is a non stationary time series.
pacf(as.data.frame(times_series_train) , lag.max=50, main="XOM PACF Plot time_series_train") 
# It is clear this time series needs to be differenced to adjust for non-stationarity

# Make the ts stationary

# We also need to remove the trend aspect by differencing the time series using diff() which makes
# the time series stationary
diff_XOM <- diff(times_series_train)
plot(diff_XOM, main="XOM differenced time series") 
mean(diff_XOM)
# 0.3043867
# now displays a stationary time series as the mean is approx zero

adf.test(diff_XOM, alternative="stationary", k=0)
# Augmented Dickey-Fuller Test
# 
# data:  diff_XOM
# Dickey-Fuller = -11.929, Lag order = 0, p-value = 0.01
# alternative hypothesis: stationary
# With this low p value we can determine that the time series is now stationary
# and we can now perform time series modelling. 

# Diagnose ACF and PACF of transformed time series:

# ACF and PACF plots of the differenced time series:
acf(as.data.frame(diff_XOM) , lag.max=50, main="XOM acf plot of differened time series")  
pacf(as.data.frame(diff_XOM) , lag.max=50, main="XOM pacf plot of differened time series") 
# Both plots have no spiked correlations over any lags. 
# This suggests the time series is random, i.e. random walk.
# Therefore as we have differenced once our ARIMA model would be of the order
# 0,1,0

# BUILD MODEL
# Fit an ARIMA model differenced once
arimafit <- Arima(times_series_train, order = c(0,1,0), include.drift = TRUE)
summary(arimafit)

# Series: times_series_train 
# ARIMA(0,1,0) with drift 
# 
# Coefficients:
#        drift
#       0.3044
# s.e.  0.2627
# 
# sigma^2 estimated as 9.108:  log likelihood=-330.08
# AIC=664.15   AICc=664.25   BIC=669.9
# 
# Training set error measures:
#                        ME     RMSE      MAE       MPE     MAPE      MASE        ACF1
# Training set 0.0003345256 2.994932 2.391055 -0.098953 3.691813 0.2717324 -0.05617978

# examine residuals of arima model using Ljung box test to check for goodness of fit
Box.test(residuals(arimafit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(arimafit)
# X-squared = 34.257, df = 45, p-value = 0.8782
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(arimafit), main="XOM Residuals of arimafit") 
# acf plot indicates residuals look like white noise

# Try auto.arima
auto.fit<- auto.arima(times_series_train, seasonal=T)
summary(auto.fit)

# Series: times_series_train 
# ARIMA(0,1,0) 
# 
# sigma^2 estimated as 9.131:  log likelihood=-330.74
# AIC=663.49   AICc=663.52   BIC=666.36
# 
# Training set error measures:
#                     ME     RMSE      MAE       MPE     MAPE     MASE        ACF1
# Training set 0.3024175 3.010244 2.397713 0.3776508 3.697671 0.272489 -0.05554567

# examine residuals of arima model using Ljung box test to check for goodness of fit
Box.test(residuals(auto.fit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(auto.arima)
# X-squared = 34.266, df = 45, p-value = 0.8779
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(auto.fit), main="XOM Residuals of auto.arima") 
# acf plot indicates residuals look like white noise

# MODEL DECISION
# I would have expected the same AIC and error measure results for both
# models as they both had the same order of 0,1,0. However the manual model
# has a drift coefficent while the auto.arima does not. Both models are
# essentially a random walk model 0,1,0.
# Again based on the AIC result I will use the auto.arima model for
# my predictions

# Proceed to forecasting as we believe we’ve found a good model

# forecast 1 full year stock prices, h=12 i.e. 12 months ahead
for_train <- forecast(auto.fit, h = 12)
autoplot(for_train)
for_train
# grab the actual stock prices for 2017
XOM_test <- (window(times_series, 2017, c(2017, 12)))
XOM_test

# Get the forecasted figures only
fcast_Data <- as.data.frame(for_train)
predicted_stocks <- fcast_Data[,1]
predicted_stocks

# actual stock prices
actual_stocks <- as.numeric(XOM_test)
actual_stocks

# plot Actual vs Predicted forecasts
predicted_stocks_ts=ts(predicted_stocks, start=c(2017,1),frequency = 12)
predicted_stocks_ts
actual_stock_ts=ts(actual_stocks, start=c(2017,1),frequency = 12)
actual_stock_ts
ts.plot(predicted_stocks_ts, actual_stock_ts, main = "XOM ARIMA actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(predicted_stocks, actual_stocks)
#                ME     RMSE      MAE     MPE    MAPE
# Test set -6.571059 6.901295 6.571059 -8.530068 8.530068

#############################################################################
# OTHER FORECAST METHODS:

# NEURAL NETWORK FORECAST

nn_fit <- forecast(nnetar(times_series_train, lambda=0), h = 12)
autoplot(nn_fit, 
         holdout=XOM,
         forc_name = 'Neural Network',
         ts_object_name = 'XOM')

# Get the forecasted figures only
nn_predicted_stocks <- as.numeric(nn_fit$mean)
View(nn_predicted_stocks)

# plot Actual vs Predicted forecasts
nn_predicted_stocks_ts=ts(nn_predicted_stocks, start=c(2017,1),frequency = 12)
nn_predicted_stocks_ts

ts.plot(nn_predicted_stocks_ts, actual_stock_ts, main = "XOM NN actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(nn_predicted_stocks, actual_stocks)
#                ME    RMSE      MAE      MPE     MAPE
# Test set -4.631801 5.097959 4.631801 -6.034784 6.034784

##############################################################################
# EXPONENTIAL SMOOTHING FORECAST

exposmooth_fit <- forecast(ets(times_series_train), h = 12)
autoplot(exposmooth_fit, 
         holdout=XOM,
         forc_name = 'Exponential Smoothing',
         ts_object_name = 'XOM')

# Get the forecasted figures only
expo_fcast_Data <- as.data.frame(exposmooth_fit)
expo_predicted_stocks <- expo_fcast_Data[,1]
expo_predicted_stocks

# plot Actual vs Predicted forecasts
expo_predicted_stocks_ts=ts(expo_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(expo_predicted_stocks_ts, actual_stock_ts, main = "XOM EXPO actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(expo_predicted_stocks, actual_stocks)
#                ME     RMSE      MAE     MPE    MAPE
# Test set -6.570775 6.901024 6.570775 -8.529703 8.529703

###############################################################
# TBATS forecast

tbats_test = tbats(times_series_train)
tbats_forecast = forecast(tbats_test, h=12)
autoplot(tbats_forecast, 
         holdout=XOM,
         forc_name = 'TBATS',
         ts_object_name = 'XOM')

# Get the forecasted figures only
tbats_fcast_Data <- as.data.frame(tbats_forecast)
tbats_predicted_stocks <- tbats_fcast_Data[,1]
View(tbats_predicted_stocks)

# plot Actual vs Predicted forecasts
tbats_predicted_stocks_ts=ts(tbats_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(tbats_predicted_stocks_ts, actual_stock_ts, main = "XOM TBATS actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(tbats_predicted_stocks, actual_stocks)
#                ME     RMSE      MAE      MPE     MAPE
# Test set -6.484252 6.818694 6.484252 -8.418359 8.418359
