
version <- utils::packageVersion("smarterapi")

# define a global environment for the package
smarterapi_globals <- new.env()
smarterapi_globals$base_url <- "https://webserver.ibba.cnr.it"
smarterapi_globals$base_endpoint <- "/smarter-api"
smarterapi_globals$token <- NULL
smarterapi_globals$expires <- NULL
smarterapi_globals$size <- 25
smarterapi_globals$user_agent <- httr::user_agent(
  paste0("r-smarterapi v", version)
)


# returns true if token doesn't exist or is expired (or expires within 1 day)
is_token_expired <- function() {
  if (is.null(smarterapi_globals$token) | is.null(smarterapi_globals$token)) {
    return(TRUE)
  }

  # consider a token expired if it least less than one day
  return(smarterapi_globals$expires < as.Date(lubridate::now() + 1))
}


check_smarter_errors <- function(resp, parsed) {
  # deal with API errors: not "200 Ok" status
  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "SMARTER API returned an error [%s]: '%s'",
        httr::status_code(resp),
        parsed$message
      ),
      call. = FALSE
    )
  }
}


read_url <- function(url, token, query = list()) {
  logger::log_debug(sprintf("Get data from %s", url))

  # in this request, we add the token to the request header section
  resp <- httr::GET(
    url,
    query = query,
    httr::add_headers(Authorization = paste("Bearer", token)),
    smarterapi_globals$user_agent
  )

  # check errors: SMARTER-backend is supposed to return JSON objects
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # parse a JSON response. fromJSON to flatten results
  parsed <- jsonlite::fromJSON(
    httr::content(resp, "text", encoding = "utf-8"),
    flatten = TRUE
  )

  # test for error in responses
  check_smarter_errors(resp, parsed)

  return(parsed)
}


get_smarter_data <- function(url, token, query = list()) {
  # test for page size. Add a default size if necessary
  if (!"size" %in% names(query) | is.null(query[["size"]])) {
    # add global result size to query
    query$size <- smarterapi_globals$size
  }

  # do the request and parse data with our function
  parsed <- read_url(url, token, query)

  # track results in df
  results <- parsed$"items"

  # check for pagination
  while (!is.null(parsed$`next`)) {
    # append next value to base url
    next_url <- httr::modify_url(
      smarterapi_globals$base_url,
      path = parsed$`next`
    )

    # query arguments are already in url: get next page
    parsed <- read_url(next_url, token)

    # append new results to df. Deal with different columns
    results <- dplyr::bind_rows(results, parsed$"items")
  }

  # return an S3 obj with the data we got
  structure(
    list(
      content = parsed,
      url = url,
      results = results
    ),
    class = "smarter_api"
  )
}
