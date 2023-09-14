
<!-- README.md is generated from README.Rmd. Please edit that file -->
# ECweather

<!-- badges: start -->
<!-- badges: end -->
The goal of ECweather is to conveniently and efficiently extract weather data from the Environment Canada website.

## Installation

You can install the development version of ECweather like so:

``` r
devtools::install_github("B-Klaver/ECweather")
```

## Examples

This is a basic example that extracts daily data for the stations 55 and 100 from 2020 to 2023:

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

This is a basic example that generates URLs for station 55 from 2020 to 2023:

``` r
library(ECweather)

df <- getECurls(id = 55,
                year_start = 2020,
                year_end = 2023,
                timeframe = "daily")
```
