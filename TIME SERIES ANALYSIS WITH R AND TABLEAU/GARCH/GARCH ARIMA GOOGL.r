# ARIMA & GARCH MODEL APPLIED ON GOOGLE STOCK

library(quantmod)
library(forecast)
library(tseries)

#Pull monthly data from Yahoo Finance

getSymbols("GOOGL", src = "yahoo", from = '2006-01-01', to = '2017-12-31')
GOOGL <- to.monthly(GOOGL)
frequency(GOOGL) # shows frequency of data is monthly
stock_prices= GOOGL$GOOGL.Adjusted # use the Adjusted stock price

#Create a time series of the stock prices
times_series=ts(as.numeric(stock_prices), start=c(2006,1),end=c(2017,12),frequency = 12)

# BUILD MODELS

# Fit a model auto.arima
auto.fit<- auto.arima(times_series, seasonal=T)
summary(auto.fit)
# Series: times_series 
# ARIMA(0,2,1) 
# 
# Coefficients:
#         ma1
#       -0.9763
# s.e.   0.0197
# 
# sigma^2 estimated as 914.7:  log likelihood=-686.63
# AIC=1377.27   AICc=1377.35   BIC=1383.18
# 
# Training set error measures:
#                    ME     RMSE      MAE       MPE     MAPE     MASE        ACF1
# Training set 3.220806 29.92663 22.11835 0.4979359 6.099528 0.249038 -0.07304012

Box.test(residuals(auto.fit), lag=45, type='Ljung-Box')
# Box-Ljung test
# 
# data:  residuals(auto.arima)
# X-squared = 46.571, df = 45, p-value = 0.4075
# With pvalue > 0.05 we can determine this is good evidence of
# white noise, thus being a good model fit
# Double check by plotting acf of residuals
acf(residuals(auto.fit), main="GOOGL Residuals of auto.arima") 
# acf plot indicates residuals look like white noise

# ARIMA model of order 0,2,1

# GARCH MODEL IMPLEMENTATION

# we have to check the square of the residuals because there can
# still be some heteroskedastic behaviour meaning the variance is changing
acf(resid(auto.fit)^2)
# yes the variance has some volatility clustering present 

# apply a GARCH model on the ARIMA model residuals 
# to try and explain autocorrelation
result.garch <- garch(resid(auto.fit),trace=F)
summary(result.garch)
# get rid of the first NA invalid value
result.residuals <- result.garch$res[-1]
str(result.garch)
# plot the residuals
acf(result.residuals, main="ACF of GARCH residuals")
# the residuals look OK
# but we have to check the squared residuals 
acf(result.residuals^2, main="ACF of GARCH squared residuals")
# still show 4 correlation spikes present but overall it is a good approximation
# of white noise. We have approx managed to explain heteroskedastic behaviour 
# and volatility clustering with the help of the GARCH model

