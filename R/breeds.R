
#' Get SMARTER Breeds
#'
#' Fetch SMARTER REST API breeds endpoint and returns results in a dataframe.
#' Cached token is used or a new token is generated if not provided when calling
#' this function (see \code{\link{get_smarter_token}} for more information)
#'
#' @param query a \code{list} of query arguments
#'
#' @return Returns a dataframe with selected breeds
#' @export
#'
#' @section Passing additional parameters:
#' Breeds endpoint supports additional parameters when making queries.
#' Additional parameters need to be passed as \code{list} using the \code{query}
#' parameter. For example, to get all the "Sheep" breeds you need to provide
#' \code{list(species="Sheep")} as \code{query} parameter. Endpoint supports
#' query by breed \code{code} and \code{name}. In addition, you can search
#' using a pattern through the \code{search} parameter.
#' See \href{https://webserver.ibba.cnr.it/smarter-api/docs/#/Breeds}{
#' Swagger Breeds endpoint} for more information about the breeds endpoint
#'
#' @examples
#' selected_breed <- get_smarter_breeds(query = list(code = "TEX"))
#'
#' selected_breeds <- get_smarter_breeds(query = list(search = "mer"))
#' \dontrun{
#'
#' all_breeds <- get_smarter_breeds()
#'
#' sheep_breeds <- get_smarter_breeds(query = list(species = "Sheep"))
#' }
get_smarter_breeds <- function(query = list()) {
  logger::log_info("Get data from breeds endpoint")

  # setting the URL endpoint
  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/breeds", smarterapi_globals$base_endpoint)
  )

  # reading our data
  data <- get_smarter_data(url, query)

  logger::log_info("Done!")

  # returning only the results dataframe
  data$results
}
