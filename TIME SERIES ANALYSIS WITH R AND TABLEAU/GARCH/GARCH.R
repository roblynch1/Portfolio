# GARCH MODEL SIMULATION

library(tseries)
library(forecast)

set.seed(1)

# the coefficients for GARCH(1,1) model i.e. 1st order AR and 1st order MA models.
alpha0 <- 0.1
alpha1 <- 0.4
beta1 <- 0.2

# white noise term values
w <- rnorm(2000)

# the actual x(t) time series
x <-rep(0,2000)
# volatility squared values - sigma squared t = the AR term and MA term which will be 
# substituted into the GARCH formula
sigma2 <- rep(0,2000)

# GARCH(1,1) model simulation
for(t in 2:2000){
  sigma2[t] <- alpha0+alpha1*(x[t-1]^2)+beta1*sigma2[t-1] # AR and MA components
  x[t] <- w[t]*sqrt(sigma2[t])  # GARCH formula  
}

# autocorrelation plot it seems to be OK 
acf(x, main="ACF plot")
# very similar to white noise but its very hard to detect volatility clustering
# so we now examine the squared residuals:
acf(x*x, main="Squared residuals")
# the squared residuals shows there is autocorrelations and thus volatility clustering

# lets use the GARCH function to try and explain this volatility
x.garch <- garch(x,trace=FALSE)

# the confidence intervals for the parameters alpha0, alpha1, and beta1
confint(x.garch)
#         2.5 %    97.5 %
# a0 0.08569519 0.1352623       #alpha0 of 0.1 falls within this interval
# a1 0.30547879 0.4686444       #alpha1 of 0.4 falls within this interval
# b1 0.11166485 0.3183845       #beta1 of 0.2 falls within this interval

# print the model
x.garch
# Call:
# garch(x = x, trace = FALSE)
# 
# Coefficient(s):
#   a0      a1      b1  
# 0.1105  0.3871  0.2150 
# again the alpha and beta parameters are spot on meaning this GARCH model
# is working well in explaining volatility clustering


