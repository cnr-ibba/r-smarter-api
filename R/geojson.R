
# nolint start
#' Get SMARTER GeoJSON Samples
#'
#' Fetch SMARTER REST API samples with GPS coordinates and return them into as
#' simple features.
#'
#' @inheritParams get_smarter_samples
#' @param polygons a sf object with polygons to filter the samples
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
#' goat_data <- get_smarter_geojson(
#'   species = "Goat",
#'   query = list(
#'     type = "background",
#'     country = "Italy"
#'   )
#' )
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
get_smarter_geojson <- function(species, query = list(), polygons = NULL) {
  logger::log_info("Get data from geojson endpoint")

  # mind that species is lowercase in endpoint url
  species <- tolower(species)

  # construct the url
  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf(
      "%s/samples.geojson/%s", smarterapi_globals$base_endpoint, species
    )
  )

  # check if polygons are provided, if yes call another function and exit
  if (!is.null(polygons)) {
    if (!inherits(polygons, "sf")) {
      stop("polygons must be a sf object", call. = FALSE)
    } else {
      # call an helper function with a post method
      return(get_within_polygon(url, polygons, query))
    }
  }

  # in this request, we add the token to the request header section
  resp <- httr::GET(
    url,
    query = query,
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

  return(data)
}


get_within_polygon <- function(url, polygons, query = list()) {
  # transform the polygons into a geojson object
  feature_list <- geojsonsf::sf_geojson(polygons, atomise = TRUE)

  # for the results
  data <- list()

  for (i in seq_along(feature_list)) {
    resp = httr::POST(
      url = url,
      query = query,
      body = jsonlite::toJSON(
        list(geo_within_polygon = jsonlite::fromJSON(feature_list[i])),
        pretty = TRUE,
        auto_unbox = TRUE
      ),
      httr::content_type_json(),
      smarterapi_globals$user_agent
    )

    # check errors: SMARTER-backend is supposed to return JSON objects
    if (httr::http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }

    data[[i]] <- sf::read_sf(
      httr::content(resp, "text", encoding = "utf-8")
    )
  }

  logger::log_info("Done!")

  # Get a list of all unique column names
  all_columns <- unique(unlist(lapply(data, colnames)))

  # Standardize the columns across all data frames
  standardized_data <- lapply(data, function(df) {
    # Add missing columns with NA
    missing_cols <- setdiff(all_columns, colnames(df))
    df[missing_cols] <- NA
    return(df)
  })

  # Combine all standardized sf objects into a single sf object
  data <- do.call(rbind, standardized_data)

  return(data)
}
