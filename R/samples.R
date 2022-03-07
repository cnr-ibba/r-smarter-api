
#' Get SMARTER Samples
#'
#' Fetch SMARTER REST API samples endpoint and returns results in a dataframe.
#' Cached token is used or a new token is generated if not provided when calling
#' this function (see \code{\link{get_smarter_token}} for more information)
#'
#' @param species a smarter species ("Goat", "Sheep")
#' @inheritParams get_smarter_breeds
#'
#' @return Returns a dataframe with selected samples
#' @export
#'
#' @section Passing additional parameters:
#' Samples endpoint supports additional parameters when making queries.
#' Additional parameters need to be passed as \code{list} using the \code{query}
#' parameter. For example, to get all the "foreground" samples you need to
#' provide \code{list(type="foreground")} as \code{query} parameter.
#' Endpoint supports a lot of parameters and some of them can be provided
#' multiple times
#' See \href{https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples}{
#' Swagger Samples endpoint} for more information about the samples endpoint
#'
#' @examples
#' italian_sheeps <- get_smarter_samples(
#'   "Sheep",
#'   query = list(country = "Italy")
#' )
#'
#' merino_sheeps <- get_smarter_samples("Sheep", query = list(breed = "Merino"))
#'
#' selected_goats <- get_smarter_samples(
#'   "Goat",
#'   query = list(country = "Italy", breed_code = "ORO", breed_code = "GAR")
#' )
#' \dontrun{
#'
#' foreground_goats <- get_smarter_samples(
#'   "Goat",
#'   query = list(type = "foreground")
#' )
#'
#' all_sheep_samples <- get_smarter_samples("Sheep")
#' }
get_smarter_samples <- function(species, query = list(), token = NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from samples endpoint")

  # mind that species is lowercase in endpoint url
  species <- tolower(species)

  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/samples/%s", smarterapi_globals$base_endpoint, species)
  )

  data <- get_smarter_data(url, token, query)

  logger::log_info("Done!")

  # returning only the results dataframe
  data$results
}
