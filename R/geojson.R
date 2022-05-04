
# nolint start
#' Get SMARTER GeoJSON Samples
#'
#' Fetch SMARTER REST API samples with GPS coordinates and return them into as
#' simple features.
#' Cached token is used or a new token is generated if not provided when calling
#' this function (see \code{\link{get_smarter_token}} for more information)
#'
#' @param species a smarter species ("Goat", "Sheep")
#' @param token a string with a valid token
#'
#' @return a sf data object
#' @export
#'
#' @examples
#' \dontrun{
#' # required to execute pipe operations and draw examples
#' library(dplyr)
#' library(leaflet)
#'
#' # get goat samples with GPS coordinates as sf object
#' goat_data <- get_smarter_geojson("Goat")
#'
#' # leaflet doesn't handle MULTIPOINT data (https://github.com/rstudio/leaflet/issues/352)
#' # Cast them into point considering only the first objects
#' # (https://r-spatial.github.io/sf/reference/st_cast.html)
#' goat_data <- goat_data %>% sf::st_cast("POINT", do_split=FALSE)
#'
#' # draw samples in a leaflet map using markerCluser
#' leaflet(data = goat_data) %>%
#'   leaflet::addTiles() %>%
#'   leaflet::addMarkers(
#'     clusterOptions = leaflet::markerClusterOptions(), label = ~smarter_id
#'   )
#' }
# nolint end
get_smarter_geojson <- function(species, token = NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from geojson endpoint")

  # mind that species is lowercase in endpoint url
  species <- tolower(species)

  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf(
      "%s/samples.geojson/%s", smarterapi_globals$base_endpoint, species
    )
  )

  # in this request, we add the token to the request header section
  resp <- httr::GET(
    url,
    httr::add_headers(Authorization = paste("Bearer", token)),
    smarterapi_globals$user_agent
  )

  # check errors: SMARTER-backend is supposed to return JSON objects
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  logger::log_info("Done!")

  data <- sf::read_sf(
    httr::content(resp, "text", encoding = "utf-8")
  )
}
