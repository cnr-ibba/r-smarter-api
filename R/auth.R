require(httr)
require(lubridate)
require(logger)

#' Title
#'
#' @param username
#' @param password
#'
#' @return
#' @export
#'
#' @examples
get_smarter_token <- function(username = Sys.getenv("SMARTER_API_USERNAME"),
                              password = Sys.getenv("SMARTER_API_PASSWORD")) {
  if (!is_token_expired()) {
    logger::log_debug("Get a token from local environment")
    return(smarterapi_globals$token)
  }

  auth_url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/auth/login", smarterapi_globals$base_endpoint)
  )

  logger::log_info(sprintf("Get a new token from %s", auth_url))

  resp <- httr::POST(
    auth_url,
    body = list(username = username, password = password),
    encode = "json"
  )

  # this will read a JSON by default
  data <- httr::content(resp)

  # track data in my environment
  smarterapi_globals$token <- data$token
  smarterapi_globals$expires <- lubridate::ymd_hms(data$expires)

  # returning only the token as a string
  return(data$token)
}
