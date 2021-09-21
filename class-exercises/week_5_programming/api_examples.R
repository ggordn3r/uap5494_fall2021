# install these packages if you haven't already:
# install.packages(c("tidycensus", "httr", "jsonlite"))
library(tidyverse)
library(tidycensus)
library(httr)
library(jsonlite)

# This script gives you a brief overview of using APIs in R.

# Example 1: Github
# This requests information about a user (me!) from the Github API.
# try opening this URL in your browser and compare it to the variable created.
response <- GET("https://api.github.com/users/ggordn3r")

# running this line gives you a summary of what's inside the API response
response

# Working with APIs in R can be tricky because the response is in Unicode.
# This line just translates Unicode to a structure that is more readable
# Fuller explanation here: https://www.dataquest.io/blog/r-api-tutorial/
github_data = fromJSON(rawToChar(response$content))

# Now we can explore the data that we received and it's nicely organized like a dataframe
names(github_data)
github_data$login
github_data$name
github_data$public_repos
# Imagine running a script that pulled data for 100 Github users, combining that into a dataframe,
# and then comparing some of the metrics the Github API provides. You already have the skills to do this!


# Example 2: Census Data
# As above, we can request data from the US Census API. Notice, however, the "?" marker--
# a "?" in a URL is an indication that parameters are being passed to an API
# The creator of the API determines the parameters and then describes them in documentation.
# Here is the documentation for the Census APIs: https://www.census.gov/data/developers/guidance/api-user-guide.Overview.html
# This is one of their example queries, which returns the Hispanic population of each state.
response <- GET("https://api.census.gov/data/2019/pep/charagegroups?get=NAME,POP&HISP=2&for=state:*")
census_hisp = fromJSON(rawToChar(response$content))
# Notice the relationship between the columns you see in this table and the GET call made to the URL above.
census_hisp

# Example 3: Tidycensus
# Constructing a URL for a complex API request can be complicated. Some programmers write programs
# to make the process easier and integrate it better with a certain language. These programs
# are called "wrappers". There is a nice wrapper for the US Census API in R called tidycensus.
# documentation for tidycensus here: https://walker-data.com/tidycensus/articles/basic-usage.html

# For most requests, the Census API requires a "key", kind of like a password. 
# You can register for one for free following the instructions in the handbook:
# https://www.census.gov/content/dam/Census/library/publications/2020/acs/acs_api_handbook_2020_ch02.pdf

# add your own census key directly here--mine is obscured for security.
# follow the instructions at the link above if you are unsure how to authenticate.
census_api_key(readChar("~/census_key.txt", 40), install = TRUE)

# Instead of typing a long URL after GET(), tidycensus lets you use functions and arguments
# to retrieve data. This also makes it easier to reuse variables in multiple data downloads.
age10 <- get_decennial(geography = "state", 
                       variables = "P013001", 
                       year = 2010)

head(age10)

age10 %>%
  ggplot(aes(x = value, y = reorder(NAME, value))) + 
  geom_point()

# here are some other interesting APIs to explore!
# World Bank: https://medium.com/pew-research-center-decoded/using-apis-to-collect-website-data-b7fc340d59e3
# FBI: https://crime-data-explorer.fr.cloud.gov/#
# Zillow: https://data.nasdaq.com/databases/ZILLOW/documentation?anchor=zillow-data-zillow-data-