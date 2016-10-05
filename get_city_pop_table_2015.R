## get_city_pop_table
##
## Get wikipedia page of city populations
## Winston Saunders Oct 5 2016
##
## reads wikipedia page 
## gets table
## converts from html to data_frame
## cleans
## stores data as csv


library(XML)
library(RCurl)
library(dplyr)
library(stringr)

theurl = "https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population"


wikipage <- getURL(theurl)
wikipage <- readLines(connect <- textConnection(wikipage))
close(connect)

pagetree <- htmlTreeParse(wikipage, error=function(...){}, useInternalNodes = TRUE)

# Extract table header and contents
tablehead <- xpathSApply(pagetree, "//*/table[@class='wikitable sortable']/tr/th", xmlValue)
results <- xpathSApply(pagetree, "//*/table[@class='wikitable sortable']/tr/td", xmlValue)

# keep first 304 results 
results <- results[1:2736]

# Convert to data_frame
raw_content <- as_data_frame(matrix(results, ncol = 9, byrow = TRUE))

# assign raw data to content variable
content <- raw_content

# assign meaningful column names
colnames(content) <- c("rank", "city", "state", "pop_2015", "pop_2010", "change", "land_area", "pop_density", "location")

# fix rank
content$rank <- 1:nrow(content)

# get rid of change and pop_density (these are easily computed, if needed)
content <- content %>% select(-change, - pop_density)

# get rid of commas in numbers
content <- content %>% mutate (pop_2015 = gsub("," , "", pop_2015),
                               pop_2010 = gsub("," , "", pop_2010))

# clean city

content <- content %>% mutate(city = gsub("\\[[0-9]+\\]", "", city),
                              city = gsub('–', '-', city))


content <- content %>% mutate(land_area = gsub("km2", "" , land_area)) %>% 
    mutate(land_area = gsub(".*(\n)" , "" , land_area)) %>%
    mutate(land_area = gsub("," , "" , land_area )) %>% 
    mutate(land_area = as.numeric(land_area))
           
## extract latitude and longitude
content <- content %>% mutate(latitude = location %>% str_extract("[0-9]+.[0-9]+(?=;)"))
content <- content %>% mutate(longitude = location %>% str_extract("-[0-9]+.[0-9]+"))
    
# convert population to numeric data
content <- content %>% mutate(pop_2015 = as.numeric(pop_2015))
content <- content %>% mutate(pop_2010 = as.numeric(pop_2010))

# select desired content
city_data_clean <- content %>% select(rank, city, state, pop_2015, pop_2010, land_area, latitude, longitude)

# save data
write.csv(city_data_clean, "city_pop_table_2015.csv", row.names = FALSE)

## End (not run)
