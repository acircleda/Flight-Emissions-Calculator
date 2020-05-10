library(airportr)
library(tidyverse)
library(readxl)
#calculations <- read_excel("aircalculations.xlsx", sheet="calculations")
#save(calculations, file="calculations.RData")
load("calculations.RData")

data("airports")


# calculate emissions for 1 seat per trip ----

# departure = departure city
# arrival = arrival city
# flightClass = 
  # Unknown (default if blank)
  # Economy
  # Economy+
  # First
  # Business
# output = 
  # co2e (default if blank) - CO2 equivalent
  # co2 - carbon dioxide
  # ch4 - methane
  # n20 - nitrous oxide
    # co2e vs co2 https://ecometrica.com/assets/GHGs-CO2-CO2e-and-Carbon-What-Do-These-Mean-v2.1.pdf


tmp <- function(output = "co2e") {
emissions_table <- calculations %>%
  filter(distance == "short") %>%
  filter(flightclass == "Unknown") %>%
  select(output) %>%
  rename(output_col = output)

emissions_vector <- as.vector(emissions_table$output_col)
emissions_vector

}

tmp("ch4")

# function
emissions <- function(departure, arrival, flightClass = "Unknown", output = "co2e") {
  
  #get distance in km
  distance_vector <- airport_distance(departure, arrival)
  
  #get distance type (long, short, domestic/medium)
  distance_type <- ifelse(distance_vector <= 483, "short",
                      ifelse(distance_vector >= 3700, "long", "medium"))
  
  #set flight class
  flightclass_vector <- flightClass
  
  #find correct calculation value
  emissions_table <- calculations %>%
    filter(distance == distance_type) %>%
    filter(flightclass == flightclass_vector) %>%
    select(output) %>%
    rename(output_col = output)
  
  emissions_vector <- as.vector(emissions_table$output_col)
  emissions_vector
  
  
  #calculate
  emissions_calc <- distance_vector*emissions_vector
  
  #return co2 in metric tons
  emissions_calc
  
}

emissions("TYS", "PEK")
