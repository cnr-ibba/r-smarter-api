
# Function to strip the URL prefix if it exists
strip_doi_url <- function(doi) {
  # Use sub() to remove the https://doi.org/ part if it exists
  stripped_doi <- sub("^https?://(dx\\.)?doi\\.org/", "", doi)
  return(stripped_doi)
}

get_first_non_na_author <- function(authors) {
  # Loop through each row of authors (assuming authors is a data frame)
  for (i in seq_len(nrow(authors))) {
    # Access each author as a row (a list or named vector)
    author <- authors[i, ]

    # Check if family name exists and is not NA
    if (!is.null(author[["family"]]) && !is.na(author[["family"]])) {
      return(author[["family"]])  # Return the first valid family name
    }
  }

  # If no valid family name found, return "Unknown Author"
  return("Unknown Author")
}

#' Get citation from DOI
#'
#' This function retrieves the citation information for a given DOI.
#'
#' @param doi The DOI of the publication to cite.
#'
#' @return A formatted citation string.
#'
#' @importFrom rcrossref cr_cn
#' @keywords internal
get_short_citation_internal <- function(doi) {
  # First strip any URL prefix from the DOI
  doi <- strip_doi_url(doi)

  # Silently return NA for NA input
  if (is.na(doi)) {
    return(NA)
  }

  # If not cached, retrieve metadata and cache the result
  tryCatch({
    # Retrieve metadata from CrossRef
    metadata <- rcrossref::cr_cn(doi, format = "citeproc-json")

    # Check if author information exists and use the helper function to get the first valid author
    if (!is.null(metadata$author) && length(metadata$author) > 0) {
      first_author <- get_first_non_na_author(metadata$author)
    } else {
      first_author <- "Unknown Author"
    }

    # Extract the year
    if (!is.null(metadata$issued$`date-parts`[[1]][1])) {
      year <- metadata$issued$`date-parts`[[1]][1]
    } else {
      year <- "Unknown Year"
    }

    # Create citation in "Author et al. Year" format
    citation <- paste(first_author, "et al.", year)

    # Return the citation
    return(citation)
  }, error = function(e) {
    # Handle errors (e.g., invalid DOI)
    return(NA)
  })
}

#' Get Short Citation from DOI with Caching
#'
#' This function retrieves a short citation (Author et al. Year) from a DOI
#' using CrossRef. Results are cached using memoization to improve performance
#' for repeated calls with the same DOI.
#'
#' @param doi The DOI of the publication to cite.
#'
#' @return A character string with the short citation in "Author et al. Year" format,
#'   or NA if the DOI is invalid or cannot be retrieved.
#'
#' @export
#' @importFrom memoise memoise
#'
#' @examples
#' \dontrun{
#' # Get short citation
#' citation <- get_short_citation(doi = "10.46471/gigabyte.139")
#' }
# Memoizing the function to use cache
get_short_citation <- memoise::memoise(get_short_citation_internal)

#' Get Full Citation in Provided Style from DOI
#'
#' This function retrieves the full citation in provided style for a given DOI using
#' the rcrossref package.
#'
#' @importFrom rcrossref cr_cn
#' @keywords internal
get_full_citation_internal <- function(doi, style = "apa") {
  tryCatch({
    # Fetch the full citation in provided style using rcrossref
    full_citation <- rcrossref::cr_cn(doi, format = "text", style = style)
    return(full_citation)
  }, error = function(e) {
    # If there's an error (e.g., invalid DOI), return NA
    return(NA)
  })
}

#' Get Full Citation from DOI with Caching
#'
#' This function retrieves a full formatted citation from a DOI using CrossRef.
#' Results are cached using memoization to improve performance for repeated calls
#' with the same DOI.
#'
#' @param doi The DOI of the publication to cite.
#' @param style The citation style to use (default is "apa"). Other options include
#'   "bibtex", "ris", "vancouver", etc. See CrossRef documentation for available styles.
#'
#' @return A character string with the full formatted citation, or NA if the DOI
#'   is invalid or cannot be retrieved.
#'
#' @export
#' @importFrom memoise memoise
#'
#' @examples
#' \dontrun{
#' # Get full citation in APA style
#' citation <- get_full_citation(doi = "10.46471/gigabyte.139")
#'
#' # Get citation in Vancouver style
#' citation_vancouver <- get_full_citation(doi = "10.46471/gigabyte.139", style = "vancouver")
#' }
# Memoizing the function to use cache
get_full_citation <- memoise::memoise(get_full_citation_internal)


#' Get Citation in bibtext format from DOI
#'
#' This function retrieves the bibtex citation for a given DOI using
#' the rcrossref package.
#'
#' @importFrom rcrossref cr_cn
#' @keywords internal
get_bibtex_internal <- function(doi) {
  tryCatch({
    # Fetch BibTeX format from CrossRef API
    bibtex_entry <- rcrossref::cr_cn(doi, format = "bibtex")
    return(bibtex_entry)
  }, error = function(e) {
    # Handle cases where the DOI might be invalid or unreachable
    return(NA)
  })
}

#' Get BibTeX Citation from DOI with Caching
#'
#' This function retrieves a BibTeX citation from a DOI using CrossRef.
#' Results are cached using memoization to improve performance for repeated calls
#' with the same DOI.
#'
#' @param doi The DOI of the publication to cite.
#'
#' @return A character string with the BibTeX citation, or NA if the DOI
#'   is invalid or cannot be retrieved.
#' @export
#' @importFrom memoise memoise
#' @examples
#' \dontrun{
#' # Get BibTeX citation
#' citation_bibtex <- get_bibtex_citation(doi = "10.46471/gigabyte.139")
#' }
get_bibtex_citation <- memoise::memoise(get_bibtex_internal)
