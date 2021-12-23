
require(logger)

#' Title
#'
#' @param species
#' @param query
#' @param token
#'
#' @return
#' @export
#'
#' @examples
get_smarter_samples <- function(species, query = list(), token=NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from samples endpoint")

  # mind that species is lowercase in endpoint url
  species <- tolower(species)

  url <-
    modify_url(smarterapi.globals$base_url, path = sprintf("%s/samples/%s", smarterapi.globals$base_endpoint, species))

  data <- get_smarter_data(url, token, query)

  # returning only the results dataframe
  data$results
}
