
require(lubridate)

smarterapi.globals <- new.env()
smarterapi.globals$base_url <- "https://webserver.ibba.cnr.it"
smarterapi.globals$base_endpoint <- "/smarter-api"
smarterapi.globals$token <- NULL
smarterapi.globals$expires <- NULL

is_token_expired <- function() {
  if (is.null(smarterapi.globals$token) | is.null(smarterapi.globals$token)) {
    return(TRUE)
  }

  # consider a token expired if it least less than one day
  return(smarterapi.globals$expires < as.Date(lubridate::now() + 1))

}
