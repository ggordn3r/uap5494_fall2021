library(tidyverse)
library(gapminder)

head(gapminder)

summary(gapminder)

aggregate(lifeExp ~ continent, gapminder, median)

# what is the difference between these code blocks?
filter(gapminder, country==c("Afghanistan", "Albania"), `year`== c(1952, 1957))
gapminder %>% filter(country==c("Afghanistan", "Albania"), `year`== c(1952, 1957))  


gapminder %>% filter((country == "Afghanistan" | country == "Albania") & (year == 1952 | year == 1957))

gapminder %>% filter(country %in% c("Afghanistan", "Albania") & year %in% c(1952, 1957))
