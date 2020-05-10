Air Travel Carbon Emissions Calculator
================

## Introduction

This calculator is a crude attempt at designing a function that can
quickly take several travel-based inputs (departure airport code,
arrival airport code, and flight class) and output how many metric tons
of CO2 are emitted.

The calculator uses CO2 factors based on the [Greenhouse Gas Protocol’s
methodology](https://ghgprotocol.org/calculation-tools#cross_sector_tools_id).

This blog post details the reasoning and methodology behind the tool.

## Dependencies

The function relies on two dependencies:

### Airportr

First, you should install the `airportr` package.

`install.packages("airportr")`

This will allow you to do things such as look-up airport codes, if
needed:

``` r
library(airportr)
airport_lookup(input = "Los Angeles", input_type = "name", output_type = "IATA")
```

    ## Warning in airport_lookup(input = "Los Angeles", input_type = "name",
    ## output_type = "IATA"): No exact matches but some similar names in the database
    ## include:

    ## Los Angeles International Airport

If you know the airport name, you can get the exact IATA airport
code:

``` r
airport_lookup(input = "Los Angeles International Airport", input_type = "name", output_type = "IATA")
```

    ## [1] "LAX"

If you are not sure about the full name, you can also look it up by
city:

``` r
data(airports)
airports %>%
  filter(City == "Lhasa") %>%
  select(Name, IATA)
```

    ## # A tibble: 1 x 2
    ##   Name                  IATA 
    ##   <chr>                 <chr>
    ## 1 Lhasa Gonggar Airport LXA

### Calculations.RData

There are a series of lookup tables that must be loaded for the function
to work. This table is based on the [Greenhouse Gas Protocol’s
methodology](https://ghgprotocol.org/calculation-tools#cross_sector_tools_id).

``` r
load("calculations.RData")
```

## Inputs

Currently, the function takes three required inputs:

1.  3-digit IATA airport code for the departure city
2.  3-digit IATA airport code for the arrival city
3.  Flight class, defined as (case sensitive):
      - Unknown (default if blank)
      - Economy
      - Economy+
      - First
      - Business
4.  Greenhouse gas metric
      - co2e - CO2 Equivalent (default if blank)
          - \[Click here to read about this\]
            metric(<https://ecometrica.com/assets/GHGs-CO2-CO2e-and-Carbon-What-Do-These-Mean-v2.1.pdf>)
      - co2 - carbon dioxide
      - ch4 - methan
      - n20 - nitrous oxide

## Example

I want to calculate the emissions from Denver to Shanghai.

### Get the airport codes

``` r
data(airports)
airports %>%
  filter(City == "Denver" | City == "Shanghai") %>%
  select(Name, IATA)
```

    ## # A tibble: 5 x 2
    ##   Name                                    IATA 
    ##   <chr>                                   <chr>
    ## 1 Shanghai Hongqiao International Airport "SHA"
    ## 2 Shanghai Pudong International Airport   "PVG"
    ## 3 Denver International Airport            "DEN"
    ## 4 Centennial Airport                      "APA"
    ## 5 Front Range Airport                     "\\N"

### Calculate Emissions from DEN to PVG

This will be for Economy class.

``` r
source("flight emissions calculator.R")

emissions("DEN", "NRT", "Economy")
```

    ## [1] 1392.587

The output tells me 891 metric tons of CO2 are emitted on this trip.

## Multiple legs

If your trip has multiple legs, you can simple calculate both and add
them together

``` r
source("flight emissions calculator.R")

emissions("DEN", "NRT", "Economy") +
  emissions("NRT", "PVG", "Economy")
```

    ## [1] 1672.292

## Not a Package

This is an R script and .RData file, not a package because:

  - The carbon calculations are based on data from 2010 and need to be
    updated
  - These are rough estimates and I would like to have more accurate
    ones
  - I have never made a package and not ready for this one to be\!
