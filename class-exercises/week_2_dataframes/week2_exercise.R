# importing relevant libraries increases run speed and simplifies commands
library(tidyverse)
library(readr)
library(stats)

# import data from file (first download and add to the "data" folder in your working directory)
olympics <- read_csv("data/2021_medal_standings.csv")

# view the file
View(olympics)

# find the mean and median number of medals won

# calculate a new "medals per capita" column. Which country is the most "medal efficient"? The least?

# correlate medals won with population, GDP, or life expectancy. Interpret your results.
