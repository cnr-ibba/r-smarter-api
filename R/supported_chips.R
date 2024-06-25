
#' Get SMARTER supported chips
#'
#' Collect information on chip data currently managed in SMARTER database.
#'
#' @inheritParams get_smarter_breeds
#'
#' @return Returns a dataframe with selected chips
#' @export
#'
#' @examples
#' chips <- get_smarter_supportedchips()
#' \dontrun{
#' # collect data on chips
#' get_smarter_supportedchips()
#'
#' # retrieve samples relying on chip used
#' samples <- get_smarter_samples(
#'   species = "Sheep",
#'   query = list(chip_name = "AffymetrixAxiomOviCan")
#' )
#' }
get_smarter_supportedchips <- function(query = list()) {
  logger::log_info("Get data from supported chip endpoint")

  # setting the URL endpoint
  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/supported-chips", smarterapi_globals$base_endpoint)
  )

  # reading our data
  data <- get_smarter_data(url, query)

  logger::log_info("Done!")

  # returning only the results dataframe
  data$results
}
