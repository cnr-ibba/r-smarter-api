#' Get SMARTER variants
#'
#' Retrieve information on SMARTER SNPs. Only informations about the supported
#' assemblies are returned (see \code{\link{get_smarter_info}} for more
#' information).
#' Cached token is used or a new token is generated if not provided when calling
#' this function (see \code{\link{get_smarter_token}} for more information)
#'
#' @inheritParams get_smarter_samples
#' @param assembly the smarter working assembly for such species
#'
#' @return Returns a dataframe with selected variants
#' @export
#'
#' @section About SMARTER supported assemblies:
#' Currently SMARTER supports *OAR3* and *OAR4* assemblies for Sheep and *CHI1*
#' and *ARS1* assemblies for goat. For each assembly, only the evidences used
#' to create the smarter database are returned. Retrieving all variant for a
#' certain assembly and species could require time and memory.
#'
#' @examples
#' # get variants by region (chrom:start-end)
#' variants <- get_smarter_variants(
#'   species = "Goat",
#'   assembly = "ARS1",
#'   query = list(region = "1:1-100000")
#' )
#' \dontrun{
#' # get available assemblies from info endpoint
#' names(get_smarter_info()$working_assemblies)
#'
#' # collect variants from goat ARS1 endpoint (takes a lot of time)
#' ars1_variant <- get_smarter_variants(
#'   species = "Goat",
#'   assembly = "ARS1"
#' )
#' }
# nolint start
get_smarter_variants <- function(species, assembly, query = list()) {
  # nolint end
  logger::log_info("Get data from variants endpoint")

  # mind that species is lowercase in endpoint url
  species <- tolower(species)
  assembly <- toupper(assembly)

  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf(
      "%s/variants/%s/%s",
      smarterapi_globals$base_endpoint,
      species,
      assembly
    )
  )

  data <- get_smarter_data(url, query)

  logger::log_info("Done!")

  # try to unnest variants and returns them
  tidyr::unnest(data$results, cols = c("locations"))
}
