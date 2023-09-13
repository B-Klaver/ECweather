#' @title Extract Environment Canada climate data
#' @name getECdata
#' @aliases getECdata
#' @description  Extract the corresponding climate data
#' for the supplied supplied weather station IDs during the
#' given period.
#' @author Braeden Klaver
#' @usage getECdata(stations, year_start, year_end,
#' timeframe = c("hourly", "daily", "monthly"),
#' download = FALSE, folder = NULL, verbose = TRUE, delete = TRUE)
#' @importFrom data.table fread
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
#' @param timeframe Timeframe of the data to pull
#' @param download Do you want to download the data to a folder
#' @param folder Folder path to where you want data saved
#' @param verbose Include progress bar
#' @param delete Delete files that failed to download or were corrupted
#' @export getECdata
#' @return Dataframe
#' @rdname getECdata
#' @references https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
#' https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/
#' @note This function requires the other function available in the package "getECurls"
#' @examples df <- getECdata(stations = c(52), year_start = 2022,
#' year_end = 2023, timeframe = "daily", download = TRUE, folder = getwd())


getECdata <- function(stations, year_start, year_end, timeframe = c("hourly", "daily", "monthly"),
                      download = FALSE, folder = NULL, verbose = TRUE, delete = TRUE) {

  if (download == TRUE & is.null(folder)) {
    stop("Please provide a folder location to write the data to.")
  }

  ## check the folder exists and try to create it if not
  if (download == TRUE & !dir.exists(folder)) {

    message(paste("Creating the following folder: ", folder))

    create_folder <- try(dir.create(folder))

    if (isFALSE(create_folder)) {
      stop("Failed to create folder '", folder,
           "'. Check path and permissions.", sep = "")
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
  years <- unlist(lapply(urls, function(url_list) url_list$years))
  months <- unlist(lapply(urls, function(url_list) url_list$months))
  nfiles <- length(url_paths)

  ## filenames to use to save the data
  if (download == TRUE) {
    fnames <- paste(sites, years, months, "data.csv", sep = "_")
    fnames <- file.path(folder, fnames)
  }




  ## set up a progress bar if being verbose
  if (isTRUE(verbose)) {
    pb <- utils::txtProgressBar(min = 0,
                                max = nfiles,
                                style = 3)

    on.exit(close(pb))
  }

  #setup a list to fill
  #out <- vector(mode = "list", length = nfiles)
  out <- list("data" = NULL, "fails" = NULL)

  #iterate the download over the files
  for (i in seq_len(nfiles)) {

    if (download == TRUE) {
      #get current file
      curfile <- fnames[i]

      #DOWNLOADING FILE
      utils::download.file(url_paths[i], destfile = curfile, quiet = TRUE)

      ## Try reading the file
      ecdata <- try(data.table::fread(curfile, encoding = "Latin-1", stringsAsFactors = FALSE, fill = TRUE), silent = TRUE)


      if (stringr::str_detect(colnames(ecdata)[1], "DOCTYPE")) {

        ecdata <- readLines(curfile, warn = FALSE) # read all lines in file

        encoding <- stringi::stri_enc_detect(ecdata)$Encoding

        if (is.null(encoding)) {

          out$fails <- append(out$fails, url_paths[i])


          if (delete) {

            file.remove(curfile) # remove file if a problem & deleting

          }

          if (isTRUE(verbose)) { # Update the progress bar

            utils::setTxtProgressBar(pb, value = i)

          }


          next

        }

        ecdata <- iconv(ecdata, encoding, to = "UTF-8") #convert to UTF-8
        writeLines(ecdata, curfile)          # write the data back to the file

        ## try to read the file again, if still an error, bail out
        ecdata <- try(data.table::fread(curfile, encoding = "UTF-8", stringsAsFactors = FALSE), silent = TRUE)

        if (inherits(ecdata, "try-error") | str_detect(colnames(ecdata)[1], "DOCTYPE")) { # yes, still!, handle read problem

          out$fails <- append(out$fails, url_paths[i])    # record failed URL...


          if (delete) {

            file.remove(curfile) # remove file if a problem & deleting

          }


          if (isTRUE(verbose)) {

            utils::setTxtProgressBar(pb, value = i) # update progress bar...

          }

          next                  # bail out of current iteration

        }

      }

    }

    if(download == FALSE) {

      ecdata <- try(data.table::fread(url_paths[i], encoding = "Latin-1", stringsAsFactors = FALSE, fill = TRUE), silent = TRUE)

      if (stringr::str_detect(colnames(ecdata)[1], "DOCTYPE")) {

        ecdata <- readLines(url_paths[i], warn = FALSE) # read all lines in file

        encoding <- stringi::stri_enc_detect(ecdata)$Encoding

        if (is.null(encoding)) {

          out$fails <- append(out$fails, url_paths[i])


          if (isTRUE(verbose)) { # Update the progress bar

            utils::setTxtProgressBar(pb, value = i)

          }


          next

        }

        ## try to read the file again, if still an error, bail out
        ecdata <- try(data.table::fread(url_paths[i], encoding = "UTF-8", stringsAsFactors = FALSE, fill = TRUE), silent = TRUE)

        if (inherits(ecdata, "try-error") | str_detect(colnames(ecdata)[1], "DOCTYPE")) { # yes, still!, handle read problem

          out$fails <- append(out$fails, url_paths[i])    # record failed URL...


          if (isTRUE(verbose)) {

            utils::setTxtProgressBar(pb, value = i) # update progress bar...

          }

          next                  # bail out of current iteration

        }

      }

    }

    ## If we read the file successfully, add on the station id
    ecdata <- cbind.data.frame(station_id = rep(sites[i],
                                                nrow(ecdata)),
                               ecdata) %>%
      janitor::clean_names() %>%
      dplyr::mutate_all(as.character)

    #add onto the list
    #out$data[[as.character(sites[i])]] <- ecdata
    out$data[[as.character(sites[i])]] <- dplyr::bind_rows(out$data[[as.character(sites[i])]], ecdata)

    if (isTRUE(verbose)) { # Update the progress bar

      utils::setTxtProgressBar(pb, value = i)

    }

  }

  #return the failed downloads
  message("\nThe following files failed to download:\n", paste(out$fails, collapse = "\n"))

  #return the list of dataframes
  out <- dplyr::bind_rows(out$data)

  return(out)


}

