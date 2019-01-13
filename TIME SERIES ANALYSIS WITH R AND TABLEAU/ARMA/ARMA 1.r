# ARMA MODEL SIMULATION 

set.seed(3)

#we can construct an ARMA(p,q) simulation with the AR and MA components
x <- arima.sim(n=2000,model=list(ar=c(0.4,-0.2,0.6),ma=c(0.6,-0.4)))
plot(x)

#calculate the optimal q and p values with AIC
solution.aic <- Inf
solution.order <- c(0,0,0)

#we don't know the q and p parameters so lets generate several ARMA(p,q) models
#and choose the best according to the AIC
for(i in 1:4) for(j in 1:4) { 
  
  actual.aic <- AIC(arima(x,order=c(i,0,j),optim.control=list(maxit = 1000)))
  
  if( actual.aic < solution.aic){
    solution.aic <- actual.aic
    solution.order <- c(i,0,j)
    solution.arma <- arima(x,order=solution.order,optim.control=list(maxit = 1000))
  }
}

solution.aic
# 5711.891
solution.order
# 3 0 2
# ARMA model of AR(3) and MA(2)

solution.arma
# Call:
# arima(x = x, order = solution.order, optim.control = list(maxit = 1000))
# 
# Coefficients:
#         ar1      ar2     ar3     ma1      ma2  intercept
#       0.3948  -0.2361  0.5962  0.6233  -0.3767    -0.0363
# s.e.  0.0289   0.0193  0.0179  0.0354   0.0354     0.1137
# 
# sigma^2 estimated as 1.006:  log likelihood = -2848.95,  aic = 5711.89
# As you can see our ARMA model has been able to calculate the coefficients/parameters
# of our ARIMA simulation using the arima function and AIC diagnostic test as follows:
#         ar1      ar2     ar3     ma1      ma2  
#       0.3948  -0.2361  0.5962  0.6233  -0.3767    
# and the arima simulation coefficents: (ar=c(0.4,-0.2,0.6),ma=c(0.6,-0.4)).
# Note: make sure to set the seed first.

#no serial correlation in the residual y(t) series
acf(resid(solution.arma))

#let's apply Ljung-Box test
#if the p-value>0.05 it means that the residuals are independent
#at the 95% level so ARMA model is a good model
Box.test(resid(solution.arma),lag=20,type="Ljung-Box")
# Box-Ljung test
# 
# data:  resid(solution.arma)
# X-squared = 18.043, df = 20, p-value = 0.5846
# With a p value > 0.05 we can accept H0 the null hypothesis and determine
# that there is no autocorrelation in the residuals. Therefore this ARMA model of order 3,0,2
# can explain the autocorrelation and is working well.


