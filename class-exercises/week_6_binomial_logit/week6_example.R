## Data from: https://stats.idre.ucla.edu/r/dae/logit-regression/
## Tom demonstrated this example of logistic regression in class.

head(binary)

summary(binary)

mylogit <- glm(admit ~ gre + gpa + rank, data = binary, family = "binomial")

summary(mylogit)

p <- predict(mylogit, binary, type = "response")

yes_or_no <- ifelse(p > 0.5, 1, 0)

p_class <- factor(yes_no, levels = levels(binary[["admit"]]))

library(caret)

str(binary)

binary$admit <- as.factor(binary$admit)

# Checking the accuracy of the logistic model
table(yes_no, binary$admit)

library(gmodels)

confusionMatrix(as.factor(yes_no), binary$admit)

xtabs(~ rank + admit, data = binary)
