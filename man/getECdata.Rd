\name{getECdata}
\alias{getECdata}
\title{
%%  ~~ Extract Environment Canada climate data ~~
}
\description{
%%  ~~ The function will extract the corresponding climate data
%%    for the supplied supplied weather station IDs during the
%%    given period.
}
\usage{
getECdata(stations,
          year_start,
          year_end,
          folder,
          time_frame = c("hourly", "daily", "monthly"),
          verbose = TRUE,
          delete = TRUE)
}
\arguments{
  \item{stations}{
%%     A vector of weather station IDs
}
  \item{year_start}{
%%     The starting year of data to pull
}
  \item{year_end}{
%%     The final year of data to pull
}
  \item{folder}{
%%     The folder path to save the data
}
  \item{time_frame}{
%%     The time frame of data to pull: monthly, daily, or hourly
}
  \item{verbose}{
%%     Whether you want a progress bar
}
  \item{delete}{
%%     Whether you want to delete the saved files that failed
%%     to properly download
}
}
\value{
%%  A dataframe of the successfully downloaded climate data
}
\references{
%% https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
%% https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/
}
\author{
%%  Braeden Klaver
}
\note{
%%  This function requires the other function available in the package "getECurls"
}
\examples{

test <- getECdata(stations = c(52),
                  year_start = 2022,
                  year_end = year(Sys.Date()),
                  folder = "C:/Users/User/Documents/Projects",
                  timeframe = "daily")

}
