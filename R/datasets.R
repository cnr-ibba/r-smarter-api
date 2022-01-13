
#' Get SMARTER Datasets
#'
#' Fetch SMARTER REST API datasets endpoint and returns results in a dataframe.
#' Cached token is used or a new token is generated if not provided when calling
#' this function (see \code{\link{get_smarter_token}} for more information)
#'
#' @inheritParams get_smarter_breeds
#'
#' @return Returns a dataframe with selected datasets
#' @export
#'
#' @section Passing additional parameters:
#' Datasets endpoint supports additional parameters when making queries.
#' Additional parameters need to be passed as \code{list} using the \code{query}
#' parameter. For example, to get all the "Sheep" datasets you need to provide
#' \code{list(species="Sheep")} as \code{query} parameter. Endpoint supports
#' query by \code{type} and \code{chip_name}. In addition, you can search
#' using a pattern in file contents through the \code{search} parameter.
#' See \href{https://webserver.ibba.cnr.it/smarter-api/docs/#/Datasets}{
#' Swagger Datasets endpoint} for more information about the datasets endpoint
#'
#' @examples
#' genotypes_foreground <- get_smarter_datasets(
#'   query = list(type = "foreground", type = "genotypes")
#' )
#'
#' adaptmap_genotypes <- get_smarter_datasets(
#'   query = list(species = "Goat", search = "adaptmap", type = "genotypes")
#' )
#' \dontrun{
#'
#' all_datasets <- get_smarter_datasets()
#' }
get_smarter_datasets <- function(query = list(), token = NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from datasets endpoint")

  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/datasets", smarterapi_globals$base_endpoint)
  )

  data <- get_smarter_data(url, token, query)

  logger::log_info("Done!")

  # returning only the results dataframe
  data$results
}
