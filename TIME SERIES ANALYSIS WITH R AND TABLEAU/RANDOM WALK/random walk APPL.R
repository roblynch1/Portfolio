# required package
library(quantmod)

# download AAPL stock prices from Yahoo Finance
getSymbols("GOOGL",src="yahoo")

# there are several columns: high (Hi), low (Lo), closing price (Cl), adjusted closing price(Ad)
Ad(GOOGL)
# we want to plot the adjusted closing prices
plot(Ad(GOOGL))

# plot the acf of the time series
acf(Ad(GOOGL))
# as you can see the time series is non-stationary, the ACF values slowly declines to zero

# Tranform the time series now using diff() function.
# if the process is indeed a random walk: the diff series will have no serial correlations
acf(diff(Ad(GOOGL)),na.action=na.omit)
# there are some serial correlations but in the main the residuals are like 
# white noise and the series is stationary.

# Our goal is to try and find a more complex model that can explain 
# these high and low correlations – explain why autocorrelation or serial 
# correlation is happening.