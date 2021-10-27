library(tidyverse)
data <- austres

# Plot the data. Does it make sense to log transform your variable? Why or why not?
plot(austres)
# It does not make sense to transform this variable because the values do not differ by orders of magnitude.

# Test for autocorrelation, partial autocorrelation, and non-stationarity.
acf(austres)
pacf(austres)

library(tseries)
adf.test(austres)

# Interpret the results in a comment.
# The data is auto-correlated and non-stationary. It exceeds the significance bounds in the ACF test and the p value of the Augmented Dickey-Fuller Test is >0.05,

# calculate and plot first differences.
diff1 <- diff(austres, 1) 
plot(diff1)

# Compare this to the raw data in a comment. When does it make sense to use differences instead of raw data?
# The differences are 

# decompose the data and plot the figures
decomp <- decompose(data)
plot(decomp)

# create an ARIMA model from the data
library(forecast)
model <- auto.arima(data)

# forecast the next 2 years of your variable
f <- forecast(model, h = 24)

# plot the forecast
library(ggplot2)
autoplot(f)

# Interpret the results in a comment.
paste("-----------", "80% Conf", "95% Conf", sep = "    ")
paste("Upper Bound", round(f$upper[24,1]), round(f$upper[24,2]), sep = "      ")
paste("Lower Bound", round(f$lower[24,1]), round(f$lower[24,2]), sep = "      ")

# The model predicts with 80% confidence that the population in 24 months will
# lie between 19165 and 18239. The 95% confidence bounds are 19410, 17994.

# Validate your forecast with a Box test.
Box.test(f$residuals, lag = 24, type = "Ljung-Box")

# Interpret the test output in a comment.
# For lags up to 24 periods, there is little evidence of non-zero auto-correlations
# in the forecast errors.


# Datasets for further practice (optional)
# NYC shootings: 
# https://www.kaggle.com/thaddeussegura/new-york-city-shooting-dataset
# French trains:
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-02-26
