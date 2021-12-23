library(httr)

#' Title
#'
#' @param username
#' @param password
#'
#' @return
#' @export
#'
#' @examples
get_smarter_token <-
  function(username=Sys.getenv("SMARTER_API_USERNAME"), password=Sys.getenv("SMARTER_API_PASSWORD")) {
    auth_url <-
      httr::modify_url(smarterapi.globals$base_url, path = sprintf("%s/auth/login", smarterapi.globals$base_endpoint))

    resp <-
      httr::POST(
        auth_url,
        body = list(username = username, password = password),
        encode = "json"
      )

    # this will read a JSON by default
    data <- httr::content(resp)

    # returning only the token as a string
    return(data$token)
  }
