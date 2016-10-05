# city_and_metro_data
Respository contains R script for downloading US city and metropolitain populations from wikipedia.  
It also contains the data from these downloads in csv files.  

# R scripts  
get_city_pop_table_2015.R
- reads data from [wikipedia](https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population), cleans and stores the data as a csv file `city_pop_table_2015.csv`.

get_metro_pop_table_2015.R
- reads data from [wikipedia](https://en.wikipedia.org/wiki/List_of_Metropolitan_Statistical_Areas), cleans, and stores the data as a csv file `metro_pop_table.csv`.   

# data files and variables 
city_pop_table_2015.csv
- rank  (rank in 2015 population)   
- city  
- state  
- pop_2015 (population in 2015)   
- pop_2010 (population in 2010)   
- land_area	(in km^2^)   
- latitude (in decimal degrees)   
- longitude (in decimal degrees)   

metro_pop_table.csv
- rank (rank in 2015 population)  
- metro (name of major city associated with the metropolitain area)
- pop_2015 (population in 2015)  
- pop_2010 (population in 2010)  
