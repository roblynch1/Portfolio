# ARIMA MODEL APPLIED ON GOOGLE STOCK & ACTUAL V FORECAST OVER 2017
# PLUS FURTHER FORECASTING METHODS: NEURAL NETWORK, EXPO SMOOTHING, & TBATS

library(quantmod)
library(forecast)
library(tseries)

#Pull monthly data from Yahoo Finance

getSymbols("GOOGL", src = "yahoo", from = '2006-01-01', to = '2017-12-31')
GOOGL <- to.monthly(GOOGL)
GOOGL = na.omit(GOOGL) # take out any missing values
frequency(GOOGL) # shows frequency of data is monthly
View(GOOGL)
stock_prices= GOOGL$GOOGL.Adjusted # use the Adjusted stock price
View(stock_prices)

# Data visualisation inspection:
plot(stock_prices, main = "GOOGL Plot of Adjusted Closing Stock prices")

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
# X-squared = 2062.6, df = 45, p-value < 2.2e-16
# With this low p value we can determine that there is serial correlation
# and the time series is non-stationary

# Augmented Dickey-Fuller Test
adf.test(times_series)
# Augmented Dickey-Fuller Test
# 
# data:  times_series
# Dickey-Fuller = -0.57887, Lag order = 5, p-value = 0.9771
# alternative hypothesis: stationary
# With a high P value like this we will have to difference the time series

# Check for seasonality and trend by decomposing the training time series
fit<-stl(times_series_train, s.window="periodic")
plot(fit) 

# Seasonal plot
seasonplot(times_series_train, main="GOOGL Seasonal Plot", ylab = "GOOGL stock price", year.labels = TRUE, year.labels.left = TRUE,
           labelgap = 0.8, col = 1:20, pch = 15, lwd = 3)
# difficult to establish regular seasonal patterns over 12 month period, there may be shorter
# seasonal patterns e.g. Jan begins low and theres a rise in Feb

# MODEL ESTIMATION:

# ACF AND PACF PLOTS 
acf(as.data.frame(times_series_train) , lag.max=50, main="GOOGL ACF Plot time_series_train")  # correlation plot, 
# there is major serial correlation and this is a non stationary time series.
pacf(as.data.frame(times_series_train) , lag.max=50, main="GOOGL PACF Plot time_series_train") 
# It is clear this time series needs to be differenced to adjust for non-stationaryity

# Make the ts stationary

# We also need to remove the trend aspect by differencing the time series using diff() 
# which makes the time series stationary
diff_GOOGL <- diff((times_series_train),d=2) 
# d=2 here as had to differnce twice 
plot(diff_GOOGL, main="GOOGL differenced time series") 
mean(diff_GOOGL)
# 0.3971158
# now displays a stationary time series as the mean is approx zero

# Use Dickey FUller test to confirm stationary

adf.test(diff_GOOGL, alternative="stationary", k=0)
# Augmented Dickey-Fuller Test
# 
# data:  diff_GOOGL
# Dickey-Fuller = -20.028, Lag order = 0, p-value = 0.01
# alternative hypothesis: stationary
# With this low p value we can determine that the time series is now stationary
# and we can now perform time series modelling. 

# Diagnose ACF and PACF of transformed time series:

# ACF and PACF plots of the differenced time series:
acf(as.data.frame(diff_GOOGL) , lag.max=50, main="GOOGL acf plot of differened time series")  
pacf(as.data.frame(diff_GOOGL) , lag.max=50, main="GOOGL pacf plot of differened time series") 
# The ACF plot has a spike at lag 1 and then drops off quickly
# The PACF plot looks like it decays slowly
# This indicates an MA model of order 1.
# As we have differenced twice our ARIMA model would be of the order 0,2,1

# BUILD MODEL
# Fit an ARIMA model differenced twice and MA order 1
arimafit <- Arima(times_series_train, order = c(0,2,1), include.drift = TRUE)
summary(arimafit)
# Series: times_series_train 
# ARIMA(0,2,1) 
# 
# Coefficients:
#           ma1
#       -0.9903
# s.e.   0.0350
# 
# sigma^2 estimated as 870.2:  log likelihood=-625.86
# AIC=1255.72   AICc=1255.82   BIC=1261.46
# 
# Training set error measures:
#                    ME     RMSE      MAE       MPE     MAPE      MASE        ACF1
# Training set 2.874344 29.16214 21.66404 0.5036992 6.370402 0.2725742 -0.07194367

# examine residuals of arima model using Ljung box test to check for goodness of fit
Box.test(residuals(arimafit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(arimafit)
# X-squared = 31.686, df = 45, p-value = 0.9332
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(arimafit), main="GOOGL Residuals of arimafit") 
# acf plot indicates residuals look like white noise

# Try the automatic way of finding the ARIMA order using auto.arima
auto.fit<- auto.arima(times_series_train, seasonal=T)
summary(auto.fit)
# Series: times_series_train 
# ARIMA(0,1,0) with drift 
# 
# Coefficients:
#        drift
#       4.3962
# s.e.  2.5480
# 
# sigma^2 estimated as 857:  log likelihood=-627.73
# AIC=1259.46   AICc=1259.55   BIC=1265.21
# 
# Training set error measures:
#                       ME     RMSE      MAE        MPE     MAPE      MASE        ACF1
# Training set 0.001607199 29.05203 21.42977 -0.7596913 6.337574 0.2696266 -0.07067459

# examine residuals of arima model using Ljung box test to check for goodness of fit
Box.test(residuals(auto.fit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(auto.fit)
# X-squared = 31.686, df = 45, p-value = 0.9332
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(arimafit), main="GOOGL Residuals of auto.fit") 
# acf plot indicates residuals look like white noise

# MODEL DECISION
# Interestingly auto.arima has calculated the best model to be of order 0,1,0
# i.e. no AR or MA order which is effectively a random walk model. 
# However looking at the AIC and BIC results the manual arima fit produces slightly 
# better results. On the other hand the error measures are slightly lower for 
# the auto.arima model. Based on the AIC result I will use the manual arima fit 
# of order 0,2,1.

# Proceed to forecasting as we believe we’ve found a good model

# forecast 1 full year stock prices, h=12 i.e. 12 months ahead
for_train <- forecast(arimafit, h = 12)
autoplot(for_train)
for_train
# grab the actual stock prices for 2017
GOOGL_test <- (window(times_series, 2017, c(2017, 12)))
GOOGL_test

# Get the forecasted figures only
fcast_Data <- as.data.frame(for_train)
predicted_stocks <- fcast_Data[,1]
predicted_stocks

# actual stock prices
actual_stocks <- as.numeric(GOOGL_test)
actual_stocks

# plot Actual vs Predicted forecasts
predicted_stocks_ts=ts(predicted_stocks, start=c(2017,1),frequency = 12)
predicted_stocks_ts
actual_stock_ts=ts(actual_stocks, start=c(2017,1),frequency = 12)
actual_stock_ts
ts.plot(predicted_stocks_ts, actual_stock_ts, main = "GOOGL ARIMA actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(predicted_stocks, actual_stocks)
#                ME     RMSE      MAE     MPE    MAPE
# Test set 120.6854 134.0408 120.6854 12.3418 12.3418

#############################################################################
# OTHER FORECAST METHODS:

# NEURAL NETWORK FORECAST

nn_fit <- forecast(nnetar(times_series_train, lambda=0), h = 12)
autoplot(nn_fit, 
         holdout=GOOGL,
         forc_name = 'Neural Network',
         ts_object_name = 'GOOGL')

# Get the forecasted figures only
nn_predicted_stocks <- as.numeric(nn_fit$mean)
View(nn_predicted_stocks)

# plot Actual vs Predicted forecasts
nn_predicted_stocks_ts=ts(nn_predicted_stocks, start=c(2017,1),frequency = 12)
nn_predicted_stocks_ts

ts.plot(nn_predicted_stocks_ts, actual_stock_ts, main = "GOOGL NN actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(nn_predicted_stocks, actual_stocks)
#                ME    RMSE      MAE      MPE     MAPE
# Test set 164.9068 181.3654 164.9068 16.89588 16.89588

##############################################################################
# EXPONENTIAL SMOOTHING FORECAST

exposmooth_fit <- forecast(ets(times_series_train), h = 12)
autoplot(exposmooth_fit, 
         holdout=GOOGL,
         forc_name = 'Exponential Smoothing',
         ts_object_name = 'GOOGL')

# Get the forecasted figures only
expo_fcast_Data <- as.data.frame(exposmooth_fit)
expo_predicted_stocks <- expo_fcast_Data[,1]
expo_predicted_stocks

# plot Actual vs Predicted forecasts
expo_predicted_stocks_ts=ts(expo_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(expo_predicted_stocks_ts, actual_stock_ts, main = "GOOGL EXPO actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(expo_predicted_stocks, actual_stocks)
#                ME     RMSE      MAE     MPE    MAPE
# Test set 153.4918 170.5175 153.4918 15.6931 15.6931

###############################################################
# TBATS forecast

tbats_test = tbats(times_series_train)
tbats_forecast = forecast(tbats_test, h=12)
autoplot(tbats_forecast, 
         holdout=GOOGL,
         forc_name = 'TBATS',
         ts_object_name = 'GOOGL')

# Get the forecasted figures only
tbats_fcast_Data <- as.data.frame(tbats_forecast)
tbats_predicted_stocks <- tbats_fcast_Data[,1]
View(tbats_predicted_stocks)

# plot Actual vs Predicted forecasts
tbats_predicted_stocks_ts=ts(tbats_predicted_stocks, start=c(2017,1),frequency = 12)
ts.plot(tbats_predicted_stocks_ts, actual_stock_ts, main = "GOOGL TBATS actual vs forecast", gpars = list(col = c("purple", "green")))
legend('topleft',c("Forecasted","Actual"),lty=c(1,1),lwd=c(0.2,0.2),col=c('purple','green'))

# Accuracy measurements of predictions
accuracy(tbats_predicted_stocks, actual_stocks)
#                ME     RMSE      MAE      MPE     MAPE
# Test set 153.2536 170.3032 153.2536 15.66776 15.66776
