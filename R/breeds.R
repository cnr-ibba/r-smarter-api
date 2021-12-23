
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
get_smarter_breeds <- function(query = list(), token=NULL) {
  if (is.null(token)) {
    token <- get_smarter_token()
  }

  logger::log_info("Get data from breeds endpoint")

  # setting the URL endpoint
  url <- httr::modify_url(smarterapi.globals$base_url, path = sprintf("%s/breeds", smarterapi.globals$base_endpoint))

  # reading our data
  data <- get_smarter_data(url, token, query)

  # returning only the results dataframe
  data$results
}
