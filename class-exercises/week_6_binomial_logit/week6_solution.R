# This week, we will try to predict whether a wine is white or red based on other chemical and perceptual characteristics.
# Download the datasets here: https://archive.ics.uci.edu/ml/datasets/wine+quality
library(tidyverse)

# Hint: you should create a new variable before merging the two datasets.
reds <- read_delim("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", delim = ";", col_types = "n")
reds$color = "Red"

whites <- read_delim("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv", delim = ";", col_types = "n")
whites$color = "White"

wines <- rbind(reds, whites)
wines$color <- factor(wines$color)

rm(reds)
rm(whites)

# Create a logit model using the rest of the variables to predict whether a wine is white or red.
model <- glm(color ~ ., data = wines, family = "binomial")
summary(model)

print(paste("McFadden's Pseudo-R2: ", round(1-model$deviance/model$null.deviance, 3)))

# Create a confusion matrix of your predictions vs. actual values.
library(corrplot)
corrplot(cor(subset(wines, select = -color)), method = 'number', order = 'FPC', type = 'upper', diag = FALSE)

library(caret)
pred <- predict(model, wines, type = "response")
pdata <- ifelse(pred > 0.5, 1, 0)
pclass <- factor(pdata, labels = c("Red", "White"))
confusionMatrix(data = pclass, reference = wines$color)

# Plot the log-likelihood as illustrated in the Statsquest video part 3.
library(ggplot2)
library(cowplot)

comparison <- data.frame(predicted = model$fitted.values, color = wines$color)
comparison <- comparison[order(comparison$predicted, decreasing = FALSE),]
comparison$rank <- 1:nrow(comparison)

ggplot(comparison, aes(x=rank, y=predicted)) + geom_point(aes(color=color), alpha = 1, shape = 4, stroke = 2) + xlab("Index") + ylab("Predicted probability of white wine")

# Bonus: split wines into training and test and perform cross-validation