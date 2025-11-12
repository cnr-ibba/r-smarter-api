.onAttach <- function(libname, pkgname) {
  version <- utils::packageVersion(pkgname)
  packageStartupMessage(
    "\nWelcome to smarterapi v", version, "!\n\n",
    "If you use SMARTER data in your research, please cite:\n",
    "  [Cozzi et al. (2024). SMARTER-database: a tool to integrate SNP ",
    "array datasets for sheep and goat breeds. GigaByte. DOI: 10.46471/gigabyte.139]\n",
    "\nUse citation('smarterapi') for BibTeX entry.\n"
  )
}
