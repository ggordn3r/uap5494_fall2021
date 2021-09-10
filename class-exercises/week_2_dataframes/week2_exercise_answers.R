# importing relevant libraries increases run speed and simplifies commands
library(tidyverse)
library(readr)
library(stats)

# import data from file (first download and add to the "data" folder in your working directory)
olympics <- read_csv("data/2021_medal_standings.csv")

# view the file
View(olympics)

# find the mean and median number of medals won
  # first approach: use the built-in statistical functions and select the column with the '$' operator.
mean(olympics$Total)
median(olympics$Total)

  # second approach: import the 'describe()' function from the readings and pick out the values from the resulting table.
library(psych)
describe(olympics)
# calculate a new "medals per capita" column. Which country is the most "medal efficient"? The least?
olympics$MedalsPerCapita = olympics$Total/olympics$Population

  # note: there are more efficient ways to accomplish this, particularly for larger datasets.
  # I chose this way because it relies exclusively on functions covered in the week's readings.
  # also, notice that `Team/NOC` must be surrounded with backticks because it includes a '/' symbol.
  # Without it, the interpreter thinks it is a division symbol. In actual practice, you would rename a
  # bad column name like this, but you haven't learned how to do that yet. TA fail. :D
subset(olympics, MedalsPerCapita == max(olympics$MedalsPerCapita), select = c(`Team/NOC`, Total, Population, MedalsPerCapita))
subset(olympics, MedalsPerCapita == min(olympics$MedalsPerCapita), select = c(`Team/NOC`, Total, Population, MedalsPerCapita))

# correlate medals won with population, GDP, or life expectancy. Interpret your results.
print("Pearson Correlation")
cor(olympics$Total, olympics$Population)
cor(olympics$Total, olympics$GDP)
  # because Life Expectancy includes NA values, you need to restrict the analysis to complete observations with 'use ='
  # also, because spaces are important in R, we again need to enclose Life Expectancy in `` as in line 25 above.
cor(olympics$Total, olympics$`Life Expectancy at 21`, use = "complete.obs")

print("Spearman Correlation")
cor(olympics$Total, olympics$Population, method = "spearman")
cor(olympics$Total, olympics$GDP, method = "spearman")
cor(olympics$Total, olympics$`Life Expectancy at 21`, use = "complete.obs", method = "spearman")
