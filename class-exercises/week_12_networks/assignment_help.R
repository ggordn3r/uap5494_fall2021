# Here is a quick helper to make better plots and tables in your assignments

library(tidyverse)
library(ggplot2)

# check for NAs
any(is.na(data))
# data <- na.omit(data)

# plot the data
# https://ggplot2.tidyverse.org/reference/economics.html
data <- economics
head(data)

# plot() without labels
plot(
  x = data$date,
  y = data$pop
)

# plot() with labels
plot(
  x = data$date,
  y = data$pop,
  main = "Figure 1: U.S. Population, 07/1967-04-2015",
  ylab = "Pop. in thousands",
  xlab = "Time (Monthly)",
  type = "l"
)

# ggplot() without labels
ggplot(data = economics, aes(x = date, y = pop)) +
  geom_line()

# ggplot() with labels
ggplot(data = economics, aes(x = date, y = pop)) +
  geom_line() +
  xlab("Time (Monthly)") +
  ylab("Pop. in thousands") +
  ggtitle("Figure 1: U.S. Population, 07/1967-04/2015")

# Multiple plots in same graphic
library(corrplot)
nodate <- data %>% subset(select = -c(date))

par(mfrow = c(2,2))
boxplot(data, main = "Boxplot of All Variables", ylab = "Values", xlab = "Variables")
hist(data$uempmed, main = "Histogram of Median Unemployment", ylab = "Frequency",xlab = "Duration in Weeks",)
corrplot(cor(nodate), diag = FALSE, title = "Correlation Plot of Numeric Variables", type = "lower", mar = c(1, 1, 1, 1))
plot(
  x = data$date,
  y = data$pop,
  main = "U.S. Population, 1967-2015",
  ylab = "Pop. in thousands",
  xlab = "Time (Monthly)",
  type = "l"
)

# using ts() correctly
tsdata <- data %>%
  mutate(rate = unemploy / pop) %>%
  subset(select = rate) %>%
  ts(., start = c(1967, 7), end = c(2015, 4), frequency = 12)
# decomp <- decompose(tsdata)
# plot(decomp)

library(forecast)
model <- auto.arima(tsdata)

# Make a nice table
# https://bookdown.org/yihui/rmarkdown-cookbook/kable.html
labels <- c("Log-Likelihood", "AIC", "BIC")
values <- c(model$loglik, model$aic, model$bic)

tabdata <- as.data.frame(values, labels)

knitr::kable(tabdata)

knitr::kable(tabdata, col.names = "Values", caption = "Model Metrics")
