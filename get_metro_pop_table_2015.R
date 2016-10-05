## get_metro_pop_table
##
## Get wikipedia page of metro populations
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

theurl = "https://en.wikipedia.org/wiki/List_of_Metropolitan_Statistical_Areas"


wikipage <- getURL(theurl)
wikipage <- readLines(connect <- textConnection(wikipage))
close(connect)

pagetree <- htmlTreeParse(wikipage, error=function(...){}, useInternalNodes = TRUE)

# Extract table header and contents
tablehead <- xpathSApply(pagetree, "//*/table[@class='wikitable sortable']/tr/th", xmlValue)
results <- xpathSApply(pagetree, "//*/table[@class='wikitable sortable']/tr/td", xmlValue)

# Convert to data_frame
raw_content <- as_data_frame(matrix(results, ncol = 6, byrow = TRUE))

# assign raw data to content variable
content <- raw_content

# assign meaningful column names
colnames(content) <- c("rank", "metro_stat_area", "pop_2015", "pop_2010", "change", "encompassing_stat_area")

# fix rank
content$rank <- 1:nrow(content)

# get rid of commas in numbers
content <- content %>% mutate (pop_2015 = gsub("," , "", pop_2015),
                               pop_2010 = gsub("," , "", pop_2010))

# clean specific metro names
content <- content %>% mutate(metro = gsub('(/|–|-|,).*', "",metro_stat_area),
                              metro = gsub('Boise City', 'Boise', metro),
                              metro = gsub('Urban ', '', metro),
                              metro = gsub('^York', 'Harrisburg', metro),
                              metro = gsub('Winston$', 'Winston-Salem', metro))


# convert population to numeric data
content <- content %>% mutate(pop_2015 = as.numeric(pop_2015))
content <- content %>% mutate(pop_2010 = as.numeric(pop_2010))

# select desired content
metro_data_clean <- content %>% as_data_frame %>% select(rank, metro, pop_2015, pop_2010)

# save data
write.csv(metro_data_clean, "metro_pop_table_2015.csv", row.names = FALSE)

## End (not run)
