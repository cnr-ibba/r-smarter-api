
#' Get SMARTER Countries
#'
#' Fetch SMARTER REST API countries endpoint and returns results in a dataframe.
#'
#' @inheritParams get_smarter_breeds
#'
#' @return Returns a dataframe with selected countries
#' @export
#'
#' @section Passing additional parameters:
#' Contries endpoint supports additional parameters when making queries.
#' Additional parameters need to be passed as \code{list} using the \code{query}
#' parameter. For example, to get all the countries where there are "Sheeps"
#' you need to provide \code{list(species="Sheep")} as \code{query} parameter.
#' Endpoint supports searches with *two* or *tree* ISO codes using
#' \code{alpha_2} and \code{alpha3} parameters respectively. In addition,
#' you can search using a pattern through the \code{search} parameter.
#' See \href{https://webserver.ibba.cnr.it/smarter-api/docs/#/Countries}{
#' Swagger Countries endpoint} for more information about the breeds endpoint
#'
#' @examples
#' italy <- get_smarter_countries(query = list(name = "Italy"))
#' france <- get_smarter_countries(query = list(alpha_2 = "FR"))
#'
#' \dontrun{
#' # get countries where there are sheeps
#' sheep_countries <- get_smarter_countries(query = list(species = "Sheep"))
#' }
#'
get_smarter_countries <- function(query = list()) {
  logger::log_info("Get data from countries endpoint")

  # setting the URL endpoint
  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/countries", smarterapi_globals$base_endpoint)
  )

  # reading our data
  data <- get_smarter_data(url, query)

  logger::log_info("Done!")

  # returning only the results dataframe
  data$results
}
