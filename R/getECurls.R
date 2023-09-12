

getECurls <- function(id, year_start, year_end, timeframe){

  #create a vector of years to build URLs
  years <- year_start:year_end

  #Generate vectors to supply to URL
  if(timeframe == "hourly") {

    years <-  rep(years, each = 12)
    months <- rep(1:12, times = length(years))
    ids <- rep(id, length(years) * 12)
    time_index <- 1

  } else if (timeframe == "daily") {

    months <- 1
    ids <- rep(id, length(years))
    time_index <- 2

  } else if (timeframe == "monthly") {

    years <- year_start
    months <- 1
    ids <- id
    time_index <- 3

  } else {
    stop ("That timeframe is not an option, please select: hourly, daily, or monthly")
  }

  #Fill the URLs
  urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?&format=csv&stationID=", id,
                 "&Year=", years,
                 "&Month=", months,
                 "&Day=14",
                 "&timeframe=", time_index,
                 "&submit= Download+Data")

  #return a list of URLs for each station ID
  list(urls = urls, ids = ids, years = years, months = rep(months, length.out = length(urls)))


}
