#' @title Generate URLs for Environment Canada climate data
#' @name getECurls
#' @aliases getECurls
#' @description  getECurls() generates the URLs
#' for the supplied weather station IDs during the
#' given period.
#' @author Braeden Klaver
#' @usage getECurls(id, year_start, year_end,
#'           timeframe = c("hourly", "daily", "monthly"))
#' @param id A station ID
#' @param year_start Starting year for data pull
#' @param year_end End year for data pull
#' @param timeframe Timeframe of the data to pull, select one of c("hourly", "daily", "monthly")
#' @export getECurls
#' @return List
#' @rdname getECurls
#' @references <https://climate.weather.gc.ca/historical_data/search_historic_data_e.html>
#' <https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/>
#' <https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station_Inventory_ID_Disclaimer_Metadata_EN.txt>
#' @seealso  This function is wrapped in the function ECweather::getECdata()
#' @examples
#' #An example of pulling URLs for daily data
#' getECurls(id = 52, year_start = 2022, year_end = 2023, timeframe = "daily")
#'
#' #An example of pulling URLs for monthly data
#' getECurls(id = 200, year_start = 2020, year_end = 2023, timeframe = "monthly")


getECurls <- function(id, year_start, year_end, timeframe = c("hourly", "daily", "monthly")){

  if (length(id) > 1) {
    stop("Please select one weather station ID at a time.")
  }

  timeframe <- tolower(timeframe)

  if (length(timeframe) > 1) {
    stop("Please select one time frame at a time: hourly, daily, or monthly.")
  }

  #create a vector of years to build URLs
  years <- year_start:year_end

  #Generate vectors to supply to URL
  if (timeframe == "hourly") {

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

    stop("That timeframe is not an option, please select one of: hourly, daily, or monthly.")

  }

  #Fill the URLs
  urls <- paste0("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?&format=csv&stationID=", id,
                 "&Year=", years,
                 "&Month=", months,
                 "&Day=14",
                 "&timeframe=", time_index,
                 "&submit= Download+Data")

  #return a list of URLs for each station ID
  out <- list(urls = urls, ids = ids, years = years, months = rep(months, length.out = length(urls)))

  return(out)


}
