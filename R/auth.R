
#' Get a SMARTER authentication token
#'
#' Authenticate through SMARTER API and returns a valid token. Token is also
#' cached in package in order to be used by other functions. Calling this
#' function another time will return the cached token if is still valid
#'
#' @param username the SMARTER username (or 'SMARTER_API_USERNAME' environment
#'   variable)
#' @param password the SMARTER password (or 'SMARTER_API_PASSWORD' environment
#'   variable)
#'
#' @return Returns a valid token as a string
#' @export
#'
#' @section Configure environment variables:
#' In order to not provide your SMARTER credentials within your code, you could
#' set those values in your environment. You can call
#' \code{usethis::edit_r_environ()} in order to track credentials in your
#' \emph{.Renviron} file using the \code{Key=value} syntax, for example:
#' \preformatted{
#' SMARTER_API_USERNAME=<smarter username>
#' SMARTER_API_PASSWORD=<smarter password>
#' }
#' See \href{"https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf"}{
#' Managing R with .Rprofile, .Renviron, Rprofile.site, Renviron.site,
#' rsession.conf, and repos.conf}
#' for more information
#' @section Warning:
#' SMARTER credentials \strong{MUST NOT be tracked} in your code
#' @examples
#' token <- get_smarter_token()
#' \dontrun{
#'
#' token <- get_smarter_token(username, password)
#' }
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
    encode = "json",
    smarterapi_globals$user_agent
  )

  # this will read a JSON by default
  data <- httr::content(resp)

  # test for error in responses
  check_smarter_errors(resp, data)

  # track data in my environment
  smarterapi_globals$token <- data$token
  smarterapi_globals$expires <- lubridate::ymd_hms(data$expires)

  # returning only the token as a string
  return(data$token)
}
