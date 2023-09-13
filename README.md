
<!-- README.md is generated from README.Rmd. Please edit that file -->
# ECweather
<<<<<<< HEAD

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
                timeframe = "daily",
                download = TRUE,
                folder = getwd())
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
=======
An R package that will extract weather station climate data from the Environment Canada website.
>>>>>>> 9bbfda5906e00e7dd74a0480a71bf9dca1a4e1ff
