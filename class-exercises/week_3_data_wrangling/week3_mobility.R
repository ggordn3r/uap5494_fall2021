library(dplyr)
library(tidyr)

# SICSS uses gather(), I use pivot_longer() -- both give the same answer!
long_data <- pivot_longer(apple_data, starts_with("2020"), "day", "case")

# my analysis is country-level comparison, so I'm dropping rows with sub-regions
# make sure you use backticks (``) when naming columns in functions
long_data <- filter(long_data, `geo_type` == "country/region")

# dropping columns I don't need to save on memory and simplify usage
# notice that I don't use backticks because I am referencing a variable, not a column
col_to_keep <- c("region", "transportation_type", "day", "value")
long_data <- select(long_data, col_to_keep)

# using table() and prop.table() to see the different transportation types
table(long_data$transportation_type)
prop.table(table(long_data$transportation_type))

# subsetting to see results for two different countries. I chose UK & CAN because
# they have lots of observations across all 3 transportation modalities
# notice that subset() and filter() produce the same results in this case.
can_data <- subset(long_data, `region` == "Canada")
uk_data <- filter(long_data, `region` == "United Kingdom")

# arrange UK in ascending order of values
arrange(uk_data, value)
# now descending
arrange(uk_data, -value)

# Compare descriptive statistics for the two countries
summary(can_data$value)
summary(uk_data$value)

# dropping the 6 NA values
can_data <- na.omit(can_data)
uk_data <- na.omit(uk_data)

# We can use correlation to see how much Canada's mobility data track with the UK's.
cor(can_data$value, uk_data$value)

# how do the descriptive stats vary by transportation_type?
# I use mean here, but you can swap in summary, max, min, IQR, etc. and rerun
by(can_data$value, can_data$transportation_type, mean)
by(uk_data$value, uk_data$transportation_type, mean)

# a more advanced approach will use the pipe (%>%) to create a workflow combining
# many instructions and apply them all at once. Notice that summarize() creates
# a new dataframe where you can specify many columns, each with a different
# function, unlike by(), where you only pick one.
long_data %>%
  na.omit() %>%
  mutate(month = as.numeric(substr(day, 6, 7))) %>%
  group_by(month) %>%
  summarize(median = median(value), n = n())

## Above, I use mutate() on "day" to create a new "month" variable. In this data, 
## "day" is text, so I lop off characters and change the remainder to numeric.
## Basically, this line takes in "2020-01-13" and turns it into 1.
## Another approach would be to change "day" to as.Date() and use the special
## R functions to work with dates, but we haven't learned those yet.
## Using group_by() month illustrates the severity of global lockdown each month
