# ARIMA SIMULATION 

set.seed(3)

#simulate an ARIMA process with AR(1),I(1) and MA(1) and the coefficients
x <- arima.sim(n=2000,list(order=c(1,1,1),ar=0.5,ma=0.1))

#plot the generated time series
plot(x)

#let's fit an ARIMA model with order (1,1,1)
x.arima <- arima(x,order=c(1,1,1))
x.arima
# Call:
#   arima(x = x, order = c(1, 1, 1))
# 
# Coefficients:
#         ar1     ma1
#       0.4483  0.1731
# s.e.  0.0341  0.0372
# 
# sigma^2 estimated as 0.9914:  log likelihood = -2829.48,  aic = 5664.96
# As we can see the arima coefficients above
#         ar1     ma1
#       0.4483  0.1731
# approx match ar=0.5 and ma=0.1 from the arima simulation at the top

#check the confidence intervals
0.4483+c(-1.96,1.96)*0.0341
# 0.381464 0.515136
# 0.4483 lies within these confidence intervals
0.1731+c(-1.96,1.96)*0.0372
# 0.100188 0.246012
# 0.1731 lies within these confidence intervals
# This means that this arima model of (1,1,1) is a good model for the time series above.

#basically no autocorrelation
acf(resid(x.arima))

#Ljung-Box test 
Box.test(resid(x.arima),lag=25,type="Ljung-Box")
# Box-Ljung test
# 
# data:  resid(x.arima)
# X-squared = 25.05, df = 25, p-value = 0.4596
# With this p value > 0.05 this means there is no autocorrelation in the residual series.
# This also means the model can explain the autocorrelation - a good model.
