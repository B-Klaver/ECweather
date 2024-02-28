#' @title Extract Environment Canada climate data
#' @name getECdata
#' @aliases getECdata
#' @description  getECdata() returns a data frame with
#'  the corresponding climate data for the supplied supplied
#'  weather station IDs during the given period.
#' @author Braeden Klaver
#' @usage getECdata(stations, year_start, year_end,
#'           timeframe = c("hourly", "daily", "monthly"),
#'           verbose = TRUE)
#' @importFrom janitor clean_names
#' @importFrom stringi stri_enc_detect
#' @param stations Vector of weather station IDs to pull for
#' @param year_start Starting year for data pull
#' @param year_end End year for data pull
#' @param timeframe Timeframe of the data to pull, select one of c("hourly", "daily", "monthly")
#' @param verbose Include progress bar
#' @export getECdata
#' @return Dataframe
#' @rdname getECdata
#' @references <https://climate.weather.gc.ca/historical_data/search_historic_data_e.html>
#' <https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station_Inventory_ID_Disclaimer_Metadata_EN.txt>
#' @seealso  This function wraps the function ECweather::getECurls()
#' @examples
#' #An example that  pulls the data into the environment
#' getECdata(stations = c(52, 55, 200), year_start = 2020, year_end = 2023,
#'           timeframe = "monthly")


getECdata <- function(stations, year_start, year_end,
                      timeframe = c("hourly", "daily", "monthly"),
                      verbose = TRUE) {

  #set in lower case
  timeframe <- tolower(timeframe)

  #quickly check the timeframe parameter
  if (length(timeframe) > 1) {
    stop("Please select one time frame at a time: hourly, daily, or monthly.")
  }

  if (timeframe != "daily" & timeframe != "hourly" & timeframe != "monthly") {
    stop("That timeframe is not an option, please select one of: hourly, daily, or monthly.")
  }


  #GENERATE URLS FOR EACH STATION TO PULL DATA

  urls <- lapply(stations, function(station) {
    getECurls(station,
              year_start,
              year_end,
              timeframe = timeframe)
  })


  ## Extract the data from the URLs generation
  url_paths <- unlist(lapply(urls, function(url_list) url_list$urls))
  sites <- unlist(lapply(urls, function(url_list) url_list$ids))
  n_paths <- length(url_paths)


  ## set up a progress bar if being verbose
  if (isTRUE(verbose)) {
    progress <- utils::txtProgressBar(min = 0,
                                      max = n_paths,
                                      style = 3)

    on.exit(close(progress))
  }

  #setup a list to fill
  out <- list("data" = NULL,
              "fails" = NULL)

  #iterate the download over the files
  for (i in seq_len(n_paths)) {


    #try to read the data
    ecdata <- try(utils::read.csv(url_paths[i],
                                  encoding = "Latin-1",
                                  stringsAsFactors = FALSE,
                                  fill = TRUE),
                  silent = TRUE)

      #If the URL doesn't hold data it will give a strange first column
      if (inherits(ecdata, "try-error") | length(ecdata) < 2) {

        #read the lines
        ecdata <- readLines(url_paths[i], warn = FALSE)

        #check the encoding
        ec_encoding <- stringi::stri_enc_detect(ecdata)$Encoding

        #If encoding is null it tells us the data failed to download
        if (is.null(ec_encoding)) {

          #label as a failed url
          out$fails <- append(out$fails, url_paths[i])

          # Update the progress bar
          if (isTRUE(verbose)) {

            utils::setTxtProgressBar(progress, value = i)

          }


          #next iteration
          next

        }

        ## try to read the file again using the encoding found above
        ecdata <- try(utils::read.csv(url_paths[i],
                                      encoding = ec_encoding,
                                      stringsAsFactors = FALSE,
                                      fill = TRUE),
                      silent = TRUE)

        #If still no luck then throw into the failed pile and continue
        if (inherits(ecdata, "try-error") | length(ecdata) < 2) {

          out$fails <- append(out$fails, url_paths[i])


          if (isTRUE(verbose)) {

            utils::setTxtProgressBar(progress, value = i)

          }

          next

        }

      }


    ## If we read the file successfully, add on the station id and do clean up
    ecdata <- cbind.data.frame(station_id = rep(sites[i], nrow(ecdata)),
                               ecdata)

    ecdata <- janitor::clean_names(ecdata)

    ecdata <- as.data.frame(lapply(ecdata, as.character))

    #add the data onto the list
    out$data[[as.character(sites[i])]] <- rbind(out$data[[as.character(sites[i])]], ecdata)

    # Update the progress bar
    if (isTRUE(verbose)) {

      utils::setTxtProgressBar(progress, value = i)

    }

  }

  #return the failed downloads
  if (length(out$fails) > 0) {
    warning("The following URLs failed to download, please check your parameters:\n", paste(out$fails, collapse = "\n"))
  }

  #return the list of dataframes
  out <- do.call(rbind, out$data)

  return(out)

}

