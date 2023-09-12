#' @title Generate URLs for Environment Canada climate data
#' @name getECurls
#' @aliases getECurls
#' @description  Generate the needed URLs
#' for the supplied supplied weather station IDs during the
#' given period.
#' @author Braeden Klaver
#' @usage getECurls(id, year_start, year_end, timeframe = c("hourly", "daily", "monthly"))
#' @param id A station ID
#' @param year_start Starting year for data pull
#' @param year_end End year for data pull
#' @param timeframe Timeframe of the data to pull
#' @return List
#' @rdname getECurls
#' @references https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
#' https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/
#' @note This function is used in the other function available in the package "getECdata"
#' @examples test <- getECurls(id = 52, year_start = 2022, year_end 2023, timeframe = "daily")


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
