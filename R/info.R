
# nolint start
#' Get SMARTER Info
#'
#' Collect information about smarter database status and returns values in a list
#'
#' @return a list object with SMARTER database information
#' @export
#'
#' @section About SMARTER database info endpoint:
#' The info endpoint contains information about the status of the database
#'
#' | Keyword | Content |
#' | --- | --- |
#' | last_updated | when the SMARTER database was last updated |
#' | version | SMARTER database version (see the README in ftp site) |
#' | plink_specie | track the specie specific parameters to generate genotypes using plink |
#' | working_assemblies | the source of variant positions and genotypes |
#'
#' Those information are required to understand if your genotypes are updated
#' or not. For example, if the SMARTER database current *version* and
#' *last_updated* are more recent than your genotype file, you could retrive
#' information on samples not included in the genotype file. In such case, you
#' have to download a more recent copy from SMARTER database from the FTP site.
#' The *plink_specie* is a nested list which contains the plink species options
#' used to generate the genotype data. if you want to modify a genotype file
#' to be compatible to the SMARTER database you may want to use the same specie
#' options
#'
#' @examples
#' smarter_status <- get_smarter_info()
#' smarter_version <- smarter_status$version
# nolint end
get_smarter_info <- function() {
  logger::log_info("Get data from info endpoint")

  url <- httr::modify_url(
    smarterapi_globals$base_url,
    path = sprintf("%s/info", smarterapi_globals$base_endpoint)
  )

  data <- get_smarter_data(url)

  logger::log_info("Done!")

  # this is not a dataframe like any other object, so return
  # the content as it is
  data$content
}
