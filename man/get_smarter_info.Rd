% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/info.R
\name{get_smarter_info}
\alias{get_smarter_info}
\title{Get SMARTER Info}
\usage{
get_smarter_info()
}
\value{
a list object with SMARTER database information
}
\description{
Collect information about smarter database status and returns values in a list
}
\section{About SMARTER database info endpoint}{

The info endpoint contains information about the status of the database\tabular{ll}{
   Keyword \tab Content \cr
   last_updated \tab when the SMARTER database was last updated \cr
   version \tab SMARTER database version (see the README in ftp site) \cr
   plink_specie \tab track the specie specific parameters to generate genotypes using plink \cr
   working_assemblies \tab the source of variant positions and genotypes \cr
}


Those information are required to understand if your genotypes are updated
or not. For example, if the SMARTER database current \emph{version} and
\emph{last_updated} are more recent than your genotype file, you could retrive
information on samples not included in the genotype file. In such case, you
have to download a more recent copy from SMARTER database from the FTP site.
The \emph{plink_specie} is a nested list which contains the plink species options
used to generate the genotype data. if you want to modify a genotype file
to be compatible to the SMARTER database you may want to use the same specie
options
}

\examples{
smarter_status <- get_smarter_info()
smarter_version <- smarter_status$version
}
