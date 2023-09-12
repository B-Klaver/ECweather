\name{getECurls}
\alias{getECurls}
\title{
%%  ~~ Generate URLs for Environment Canada climate data ~~
}
\description{
%%  ~~ The function will generate the needed URLs
%%    for the supplied supplied weather station IDs during the
%%    given period.
}
\usage{
getECurls(id,
          year_start,
          year_end,
          timeframe = c("hourly", "daily", "monthly"))
}
\arguments{
  \item{id}{
%%     A station ID
}
  \item{year_start}{
%%     The starting year of data to pull
}
  \item{year_end}{
%%     The final year of data to pull
}
  \item{time_frame}{
%%     The time frame of data to pull: monthly, daily, or hourly
}
}
\value{
%%  A list that contains the URLs, id, years, and months
}
\references{
%% https://climate.weather.gc.ca/historical_data/search_historic_data_e.html
%% https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/
}
\author{
%%  Braeden Klaver
}
\note{
%%  This function is used in the other function available in the package "getECdata"
}
\examples{

getECurls(id = 52,
          year_start = 2022,
          year_end 2023,
          timeframe = "daily")

}
