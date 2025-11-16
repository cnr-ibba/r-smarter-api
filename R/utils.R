#' @importFrom utils packageVersion
#' @importFrom httr user_agent http_error http_type status_code GET content
#' @importFrom jsonlite fromJSON
#' @importFrom logger log_debug
#' @importFrom urltools param_get
#' @importFrom dplyr bind_rows
#' @importFrom stringr str_to_title
version <- utils::packageVersion("smarterapi")

# define a global environment for the package
smarterapi_globals <- new.env()
smarterapi_globals$base_url <- "https://webserver.ibba.cnr.it"
smarterapi_globals$base_endpoint <- "/smarter-api"
smarterapi_globals$size <- 25
smarterapi_globals$ftp_url <- "ftp://webserver.ibba.cnr.it"
smarterapi_globals$ftp_path <- "/smarter"
smarterapi_globals$user_agent <- httr::user_agent(
  paste0("r-smarterapi v", version)
)

# define supported species and assemblies
smarterapi_species_assemblies <- list(
  Sheep = c("OAR3", "OAR4"),
  Goat  = c("ARS1", "CHI1")
)

# some helpers functions to deal with species and assemblies
is_valid_species <- function(species) {
  species %in% names(smarterapi_species_assemblies)
}

is_valid_assembly <- function(species, assembly) {
  is_valid_species(species) && assembly %in% smarterapi_species_assemblies[[species]]
}

check_species <- function(species) {
  # check species
  species_clean <- stringr::str_to_title(tolower(species))

  if (!is_valid_species(species_clean)) {
    stop(sprintf("Species '%s' is not supported", species))
  }
}

check_species_and_assemblies <- function(species, assembly) {
  # check species and assembly
  species_clean <- stringr::str_to_title(tolower(species))
  assembly <- toupper(assembly)

  if (!is_valid_species(species_clean)) {
    stop(sprintf("Species '%s' is not supported", species))
  }

  if (!is_valid_assembly(species_clean, assembly)) {
    stop(
      sprintf(
        "Assembly '%s' is not supported for species '%s'",
        toupper(assembly),
        species
      )
    )
  }
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

read_url <- function(url, query = list()) {
  logger::log_debug(sprintf("Get data from %s", url))

  # in this request, we add the token to the request header section
  resp <- httr::GET(
    url,
    query = query,
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

get_smarter_data <- function(url, query = list()) {
  # test for page size. Add a default size if necessary
  if (!"size" %in% names(query) || is.null(query[["size"]])) {
    # add global result size to query
    query$size <- smarterapi_globals$size
  }

  # do the request and parse data with our function
  parsed <- read_url(url, query)

  # track results in df
  results <- parsed$"items"

  # check for pagination
  while (!is.null(parsed$`next`)) {
    # get next page
    query$page <- urltools::param_get(parsed$`next`, "page")

    logger::log_debug(sprintf("Next page %s", query$page))

    # get next page
    parsed <- read_url(url, query)

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
