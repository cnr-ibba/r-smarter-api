
require(logger)

#' Title
#'
#' @param query
#' @param token
#'
#' @return
#' @export
#'
#' @examples
get_smarter_datasets <- function(query = list(), token = NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from datasets endpoint")

  url <- modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/datasets", smarterapi_globals$base_endpoint)
  )

  data <- get_smarter_data(url, token, query)

  # returning only the results dataframe
  data$results
}
