
<!-- README.md is generated from README.Rmd. Please edit that file -->
# ECweather

<!-- badges: start -->
<!-- badges: end -->
The goal of ECweather is to conveniently and efficiently download and extract weather data from the Environment Canada website.

## Installation

You can install the development version of ECweather like so:

``` r
devtools::install_github("B-Klaver/ECweather")
```

## Example

This is a basic example downloads the data to a specified folder, while also creating a dataframe in the local environment of all of the weather data:

``` r
library(ECweather)

df <- getECdata(stations = c(55, 100),
                year_start = 2020,
                year_end = 2023,
                timeframe = "daily")
#> 
  |                                                                            
  |                                                                      |   0%
  |                                                                            
  |=========                                                             |  12%
  |                                                                            
  |==================                                                    |  25%
  |                                                                            
  |==========================                                            |  38%
  |                                                                            
  |===================================                                   |  50%
  |                                                                            
  |============================================                          |  62%
  |                                                                            
  |====================================================                  |  75%
  |                                                                            
  |=============================================================         |  88%
  |                                                                            
  |======================================================================| 100%
```
