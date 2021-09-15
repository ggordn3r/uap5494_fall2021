# import the apple mobility data
library(tidyverse)
data <- read.csv("apple_mobility_data.csv")
# if you see an error like "cannot open file 'apple_mobility_data.csv': No such file or directory",
# make sure your working directory is set correctly.

# reshape to long form
long_data <- pivot_longer(data, cols = starts_with("X2020"), names_to = "day", values_to = "mobility")
## You can also use colon notation to select the columns: cols = X2020.01.13:X2020.08.20
## I use starts_with() to introduce you to the (very helpful) concept of regular expressions.

# filter or subset to transit data for US cities
us_transit_data <- long_data %>% filter(geo_type == "city" 
                                        & transportation_type == "transit" 
                                        & country == "United States" 
                                        & !is.na(mobility))
## I used ftable(long_data$geo_type) and ftable(long_data$transportation_type)
## to find the right command without scrolling through the data.
## I noticed that there were 186 NA mobility values with summary(us_transit_data$mobility)
## and I get rid of NAs in this same  with the final condition: !is.na(mobility)

# create a bar graph showing the median value for each city in the US
city_medians <- us_transit_data %>%
  group_by(region) %>%
  summarise(median_mobility = median(mobility) - 100)
## The first step creates a new summary table of the median value per city.
## 100 is the normal/baseline value. I find the resulting chart easier to
## interpret when I subtract that, leaving the % loss/gain in mobility.

ggplot(city_medians, aes(y = reorder(region, median_mobility), weight = median_mobility)) +
  geom_bar(fill = "dark red") +
  xlab("% change in transit mobility") +
  ylab("US City") +
  theme_minimal()
## This is almost identical to the SICSS video example, so I won't annotate in detail.
## A fun thing to do at this point is enter ?geom in the console, giving you a list of
## all of the different types of charts you can create with ggplot.

# choose any city and create a line chart of its transit data
# NOTE: this will require you to coerce the "day" variable to Date type
chicago_transit_data <- long_data %>% filter(geo_type == "city" 
                                        & transportation_type == "transit" 
                                        & region == "Chicago" 
                                        & !is.na(mobility))

library(lubridate)
chicago_transit_data$day <-substr(chicago_transit_data$day, 2, 11)
chicago_transit_data$day <- as_date(chicago_transit_data$day)
## This part is tricky because of data messiness. Each date started with "X"
## in the CSV file. I first use substr() to cut that off of the front of each date.
## Then, in a second step, I coerce the corrected text to date format.

ggplot(chicago_transit_data, aes(day, mobility - 100)) +
  geom_line() +
  xlab("Time") +
  ylab("Transit mobility in Chicago") +
  theme_minimal()
## Again, I subtract 100 so that 0 is the baseline.

# choose any two cities and plot them as 2 series in the same line chart for comparison.
chi_vs_cin <- long_data %>% filter(geo_type == "city" 
                                             & transportation_type == "transit" 
                                             & region %in% c("Chicago", "Cincinnati")
                                             & !is.na(mobility)) %>% 
  group_by(region, day)
## Unlike the SICSS example, I use the %in% operator because it strikes me as more intuitive.
## Don't miss the very important step group_by(region, day)! 

chi_vs_cin$day <-substr(chi_vs_cin$day, 2, 11)
chi_vs_cin$day <- as_date(chi_vs_cin$day)
## Once again we should correct dates. Otherwise, there is the possibility that
## some days end up out of order. In a real deployment, we would clean long_data
## at the very beginning of the project to avoid repeat work like this.

ggplot(chi_vs_cin, aes(day, mobility - 100, group = region, color = region)) +
  geom_line() +
  xlab("Time") +
  ylab("Transit Mobility Compared") +
  theme_minimal()
## Take a moment to interpret this chart. What trends do you notice? Dates of interest?

# choose any city and filter to get data for all 3 transportation types in that city only.
chicago_data <- long_data %>% filter(geo_type == "city" 
                                     & region == "Chicago" 
                                     & !is.na(mobility)) %>% 
  group_by(transportation_type)
## note the difference in filter conditions and group.

chicago_data$day <-substr(chicago_data$day, 2, 11)
chicago_data$day <- as_date(chicago_data$day)
## Yeah, really should have cleaned at the beginning. Teachable moment?

# create a line chart of that city's mobility data using transportation type as a facet
ggplot(chicago_data, aes(day, mobility - 100)) +
  geom_line() +
  xlab("Time") +
  ylab("Transit mobility in Chicago by modality") +
  facet_wrap(~transportation_type) +
  theme_minimal()
