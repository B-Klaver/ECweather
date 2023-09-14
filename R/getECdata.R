#' @title Extract Environment Canada climate data
#' @name getECdata
#' @aliases getECdata
#' @description  getECdata() returns a data frame with
#'  the corresponding climate data for the supplied supplied
#'  weather station IDs during the given period. It will also
#'  save the data to a local folder if download is TRUE.
#' @author Braeden Klaver
#' @usage getECdata(stations, year_start, year_end,
#'           timeframe = c("hourly", "daily", "monthly"),
#'           download = FALSE, folder = NULL, verbose = TRUE, delete = TRUE)
#' @importFrom data.table fread
#' @importFrom data.table fwrite
#' @importFrom dplyr bind_rows
#' @importFrom janitor clean_names
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom utils txtProgressBar
#' @importFrom stringi stri_enc_detect
#' @importFrom stringr str_detect
#' @importFrom utils download.file
#' @importFrom utils setTxtProgressBar
#' @param stations Vector of weather station IDs to pull for
#' @param year_start Starting year for data pull
#' @param year_end End year for data pull
#' @param timeframe Timeframe of the data to pull, select one of c("hourly", "daily", "monthly")
#' @param download Do you want to download the data to a folder
#' @param folder Folder path to where you want data saved
#' @param verbose Include progress bar
#' @param delete Delete files that failed to download or were corrupted
#' @export getECdata
#' @return Dataframe
#' @rdname getECdata
#' @references https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
#' https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/
#' https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station_Inventory_ID_Disclaimer_Metadata_EN.txt
#' @seealso  This function wraps the function ECweather::getECurls()
#' @examples
#' #An example that includes saving the data to the local working directory
#' getECdata(stations = c(52), year_start = 2022, year_end = 2023,
#'           timeframe = "daily", download = TRUE, folder = getwd())
#'
#' #An example that does not include saving the data, instead just pulls the data into the environment
#' getECdata(stations = c(52, 55, 200), year_start = 2020, year_end = 2023,
#'           timeframe = "monthly", download = FALSE)


getECdata <- function(stations, year_start, year_end, timeframe = c("hourly", "daily", "monthly"),
                      download = FALSE, folder = NULL, verbose = TRUE, delete = TRUE) {

  #set in lower case
  timeframe <- tolower(timeframe)

  #quickly check the timeframe parameter
  if (length(timeframe) > 1) {
    stop("Please select one time frame at a time: hourly, daily, or monthly.")
  }

  if (timeframe != "daily" & timeframe != "hourly" & timeframe != "monthly") {
    stop("That timeframe is not an option, please select one of: hourly, daily, or monthly.")
  }

  ## check the folder exists and try to create it if not
  if (download == TRUE) {

    if (is.null(folder)) {
      stop("Please provide a folder location to write the data to.")
    }

    if (!dir.exists(folder)) {
      stop("Folder path doesn't exist.")
    }
  }


  #GENERATE URLS FOR EACH STATION TO PULL DATA

  urls <- stations %>%
    purrr::map(~ {
      getECurls(.,
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
    ecdata <- try(data.table::fread(url_paths[i],
                                    encoding = "Latin-1",
                                    stringsAsFactors = FALSE,
                                    fill = TRUE,
                                    showProgress = FALSE),
                  silent = TRUE)

      #If the URL doesn't hold data it will give a strange first column
      if (stringr::str_detect(colnames(ecdata)[1], "DOCTYPE")) {

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
        ecdata <- try(data.table::fread(url_paths[i],
                                        encoding = ec_encoding,
                                        stringsAsFactors = FALSE,
                                        fill = TRUE,
                                        showProgress = FALSE),
                      silent = TRUE)

        #If still no luck then throw into the failed pile and continue
        if (inherits(ecdata, "try-error") | str_detect(colnames(ecdata)[1], "DOCTYPE")) {

          out$fails <- append(out$fails, url_paths[i])


          if (isTRUE(verbose)) {

            utils::setTxtProgressBar(progress, value = i)

          }

          next

        }

      }


    ## If we read the file successfully, add on the station id and do clean up
    ecdata <- cbind.data.frame(station_id = rep(sites[i], nrow(ecdata)),
                               ecdata) %>%
      janitor::clean_names() %>%
      dplyr::mutate_all(as.character)

    #add the data onto the list
    out$data[[as.character(sites[i])]] <- dplyr::bind_rows(out$data[[as.character(sites[i])]], ecdata)

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
  out <- dplyr::bind_rows(out$data)

  return(out)

  #download data if selected
  if(download == TRUE){
    fwrite(out, file.path(folder, paste0("ECdata_", timeframe, "_", year_start, "_", year_end, ".csv")))
  }

}

