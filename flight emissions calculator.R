library(airportr)
library(tidyverse)
library(readxl)
load("calculations.RData")
data("airports")


#airportr functions ----

airport_lookup(input = "Raleigh Durham International Airport", input_type = "name", output_type = "IATA")

airport_lookup(input = "TYS")

airport_distance("TYS", "LAX")


# calculate emissions for 1 seat per trip ----

# departure = departure city
# arrival = arrival city
# flightClass = Unknown, Economy, Economy+, First, or Business
emissions <- function(departure, arrival, flightClass) {
  
  #get departure origin
  country <- airports %>%
    filter(IATA == departure) %>%
    select(Country) %>%
    mutate(Country = ifelse(Country != "United States" | 
                              Country != "United Kingdom", 
                            "Other", Country))
  
  country_vector <- as.vector(country$Country)
  
  #get distance in km
  distance_vector <- airport_distance(departure, arrival)
  
  #get distance type (long, short, domestic/medium)
  distance_type <- ifelse(distance_vector < 1000, "Short",
                      ifelse(distance_vector > 2000, "Long", "Domestic"))
  
  #set flight class
  flightclass_vector <- flightClass
  
  #find correct calculation value
  co2 <-calculations %>%
    filter(location == country_vector) %>%
    filter(distance == distance_type) %>%
    filter(flightclass == flightclass_vector) %>%
    select(co2)
  
  co2_vector <- as.vector(co2$co2)
  
  #calculate
  emissions_calc <- distance_vector*co2_vector
  
  #return co2 in metric tons
  emissions_calc
  
}

emissions("TYS", "PEK", "First")
