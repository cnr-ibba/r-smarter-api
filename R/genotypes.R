
#' Get SMARTER Genotypes
#'
#' Retrieve genotypes data from SMARTER database. Only information about the
#' supported assemblies are returned (see \code{\link{get_smarter_info}} for
#' more information).
#'
#' @inheritParams get_smarter_variants
#' @param dest_path the path where the file will be downloaded. If NULL, the
#' file will be downloaded in the current working directory
#'
#' @return a character string with the path to the downloaded file is returned
#' @export
#'
#' @section About SMARTER supported assemblies:
#' Currently SMARTER supports *OAR3* and *OAR4* assemblies for Sheep and *CHI1*
#' and *ARS1* assemblies for goat. Genotypes are provided in PLINK binary
#' format, and compressed in a zip file.
#'
#' @examples
#' \dontrun{
#' # get genotypes for sheep OAR3 in current directory
#' get_smarter_genotypes(species = "Sheep", assembly = "OAR3")
#' }
get_smarter_genotypes <- function(species, assembly, dest_path = NULL) {
  # mind that species is lowercase in endpoint url
  species <- toupper(species)
  assembly <- toupper(assembly)

  url <- httr::modify_url(
    smarterapi_globals$ftp_url,
    path = sprintf("%s/%s/%s/", smarterapi_globals$ftp_path, species, assembly)
  )

  tmp <- RCurl::getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
  file_list <- strsplit(tmp, "\n")[[1]]

  info <- get_smarter_info()

  # Use grep to find the file name that version and have zip extension
  pattern <- sprintf("%s.*\\.zip$", info$version)
  matching_file <- grep(pattern, file_list, value = TRUE)

  # check that matching_file is one length
  # if not, return an error
  if (length(matching_file) != 1) {
    stop("No matching file found")
    return(NULL)
  }

  # now get the full path of the genotype file
  url <- httr::modify_url(
    smarterapi_globals$ftp_url,
    path = sprintf(
      "%s/%s/%s/%s",
      smarterapi_globals$ftp_path,
      species,
      assembly,
      matching_file
    )
  )

  if (is.null(dest_path)) {
    dest_file <- fs::path(getwd(), matching_file)
  } else {
    dest_file <- fs::path(dest_path, matching_file)
  }

  # Use tryCatch to handle potential errors
  tryCatch({
    utils::download.file(url, destfile = dest_file, mode = "wb")
    if (file.exists(dest_file)) {
      print(sprintf("File downloaded successfully in %s.", dest_file))
    } else {
      print("File download failed.")
    }
  }, error = function(e) {
    print(paste("An error occurred:", e$message))
  })

  return(dest_file)
}
