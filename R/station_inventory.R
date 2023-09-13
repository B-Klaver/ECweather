#' @title Generate URLs for Environment Canada climate data
#' @name station_inventory
#' @description  station_inventory is a dataframe that includes
#' a detailed inventory of the weather stations available from
#' Environment Canada.
#' \itemize{
#'   \item Name: Official Climate Station Name
#'   \item Climate ID: Official ID for the Climate Station, and it appears on the Climate
#'   Data Online webpage. The climate ID is a 7 digit number assigned by the Meteorological
#'   Service of Canada to a site where official weather observations are taken, and serves
#'   as a permanent, unique identifier. The first digit assigned identifies the province
#'   where the second and third digits identify the climatological district within the province.
#'   When observations are discontinued at a site, the number is not used for subsequent
#'   stations (which may, or may not, differ in name) unless it is judged that the records
#'   from the earlier and subsequent stations may be combined for most climatological purposes.
#'   \item Station ID: Internal numbering with no meaning and for database use only. Does not
#'   appear on the Climate Data Online webpage
#'   \item WMO ID: A 5-digit number permanently assigned to Canadian stations by the World
#'   Meteorological Organization to identify the station internationally. The WMO ID is an
#'   international identifier assigned by the Meteorological Service of Canada to standards
#'   of the World Meteorological Organization for stations that transmit observations in
#'   international meteorological formats in real time.
#'   \item TC ID: The TC ID is the identifier assigned by Transport Canada to identify
#'   meteorological reports from airport observing sites transmitted in real time in
#'   aviation formats.
#'   \item Latitude: Latitude co-ordinates for climate stations are generally for the
#'   instrument site; however prior to April 1, 1986 at principal stations (airports) the
#'   locations given were normally that of the official airport locations. The accuracy of
#'   these locations depended on the quality of the reference maps available at the time.
#'   The latitude of each site is given to the nearest second or to the nearest 0.003 of a
#'   degree. All locations in Canada are north of the equator.
#'   \item Longitude: Longitude co-ordinates for climate stations are generally for the
#'   instrument site; however prior to April 1, 1986 at principal stations (airports) the
#'   locations given were normally that of the official airport locations. The longitude
#'   of each site is given to the nearest second or to the nearest 0.003 of a degree. The
#'   accuracy of these locations depends on the quality of the reference maps available at
#'   the time. Negative values of longitude denote degrees west of the Greenwich Meridian.
#'   All locations in Canada have negative values of longitude.
#'   \item Elevation (m): The elevation in metres (m) refers to the elevation of the observing
#'   location above mean sea level. The elevation of each site is given to the nearest metre
#'   and is generally the height of ground on which the instruments are exposed. Prior to
#'   April 1, 1986, the elevation at principal stations located at airports was generally
#'   the established by the elevation of the aerodrome. For principal stations not located
#'   at airports the elevation was established by the elevation of the barometer cistern.
#'   \item First Year: The year observation began.
#'   \item Last Year: The year of latest observation.
#'   \item HLY First Year: The year hourly observation began.
#'   \item HLY Last Year: The year of latest hourly observation.
#'   \item DLY First Year: The year daily observation began.
#'   \item DLY Last Year: The year of latest daily observation.
#'   \item MLY First Year: The year monthly observation began.
#'   \item MLY Last Year: The year of latest monthly observation.
#' }
#' @author Braeden Klaver
#' @docType data
#' @usage data(station_inventory)
#' @format A data frame with 8797 rows and 19 variables
#' @rdname station_inventory
#' @references
#' https://collaboration.cmc.ec.gc.ca/cmc/climate/Get_More_Data_Plus_de_donnees/Station_Inventory_ID_Disclaimer_Metadata_EN.txt
#' @note This list was extracted on 09/13/2023 and may be out of date.
NULL
