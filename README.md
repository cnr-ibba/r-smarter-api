
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smarterapi

<!-- badges: start -->

[![R-CMD-check](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/R-CMD-check.yaml)
[![lint](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/lint.yaml/badge.svg)](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/lint.yaml)
[![pkgdown](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/cnr-ibba/r-smarter-api/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

The goal of `smarterapi` is to collect SMARTER data from [SMARTER REST
API](https://webserver.ibba.cnr.it/smarter-api/docs/) and provide them
to the user as a dataframe. Get more information with the [online
vignette](https://cnr-ibba.github.io/r-smarter-api/articles/smarterapi.html).

## Installation

The `smarterapi` package is only available from
[GitHub](https://github.com/) and can be installed as a *source package*
or alternatively using the
[devtools](https://CRAN.R-project.org/package=devtools) package, for
example:

``` r
# install devtools if needed
# install.packages("devtools")
devtools::install_github("cnr-ibba/r-smarter-api")

# Alternatively, you can use remotes (lighter dependency):
# install.packages("remotes")
remotes::install_github("cnr-ibba/r-smarter-api")
```

After the installation, you can load the package in your R session:

``` r
# import this library to deal with the SMARTER API
library(smarterapi)
```

> NOTE: The `smarterapi` package is managed using
> [renv](https://rstudio.github.io/renv/): you don’t need to clone the
> entire repository to install the package. Managing the package
> installation with `devtools` lets you install the minimal set of
> dependencies needed to use the package. Cloning the repository is only
> needed if you want to contribute to the package development: in this
> case, please follow the instructions in the
> [CONTRIBUTING.md](./.github/CONTRIBUTING.md) guide to set up your
> development environment with all the required dependencies to build
> and test the package with vignettes.

## SMARTER credentials

After the public release of SMARTER data, there is no need to provide
credentials to access the data. If you previously had credentials to
access the data, you need to upgrade your installation of the
`smarterapi` package.

## Querying the SMARTER backend

`smarterapi` provides a set of functions to fetch data from
*SMARTER-backend* endpoints described in the [API
documentation](https://webserver.ibba.cnr.it/smarter-api/docs/) and
return them as `data.frame` objects. For example,
`get_smarter_datasets()` queries the [Datasets
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Datasets/get_datasets),
while `get_smarter_samples()` queries and parses the [Samples
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples)
response. Each `smarterapi` function is documented in R and you can get
help on each function like any other R function. There are two types of
parameters that can be used to fetch data from the *SMARTER-backend*:
the `species` parameter, which can be `Goat` or `Sheep` for the
[Samples](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples) or
[Variants](https://webserver.ibba.cnr.it/smarter-api/docs/#/Variants)
endpoints, and the `query` parameter which can be provided to any
`get_smarter_*()` function. The `species` parameter is *mandatory* to
query species-specific endpoints, while the `query` parameter is
optional and needs to be specified as a `list()` object to filter your
query to specific data. For example, if you need all foreground genotype
datasets, you can collect data like this:

``` r
datasets <- get_smarter_datasets(
  query = list(type = "genotypes", type = "foreground")
)
```

If you require only background goat samples, you can do this:

``` r
goat_samples <- get_smarter_samples(
  species = "Goat", query = list(type = "background")
)
```

The full list of available options for each endpoint is documented in
the SMARTER-backend [Swagger
documentation](https://webserver.ibba.cnr.it/smarter-api/docs/). The
option names to use are the same as those described in the *parameters*
section, and the descriptions and parameter types can give you hints on
how to use the endpoints properly. For instance, parameters described as
*array of objects* can be specified multiple times:

``` r
> goat_breeds <- get_smarter_breeds(query = list(species="Goat", search="land"))
> goat_breeds[c("name","code")]
            name code
1      Rangeland  RAN
2       Landrace  LNR
3         Landin  LND
4 Icelandic goat  ICL

> goat_samples <- get_smarter_samples(
    species = "Goat",
    query = list(
      breed_code="RAN",
      breed_code="LNR",
      breed_code="LND",
      breed_code="ICL"
    )
  )
```

## Examples

This is a basic example showing how to collect data from the SMARTER
REST API for *Italian* goats belonging to the *Adaptmap* dataset:

``` r
# Collect the dataset by providing part of the name with the search option.
# Since we are filtering for background genotypes only, only one dataset
# will be returned
datasets <- get_smarter_datasets(
  query = list(
    species = "Goat",
    search = "adaptmap",
    type = "genotypes",
    type = "background"
  )
)

# Get the dataset ID
adaptmap_id <- datasets["_id.$oid"][1]

# Collect all Italian goats from the Adaptmap dataset. Use the dataset ID
# to filter samples belonging to this dataset and the country option
# to filter for Italian samples only
adaptmap_goats <- get_smarter_samples(
  species = "Goat",
  query = list(
    dataset = adaptmap_id,
    country = "Italy"
  )
)
```

While this information can be retrieved through the
[SMARTER-backend](https://webserver.ibba.cnr.it/smarter-api/docs/),
genotype data are available from the [FTP
site](ftp://webserver.ibba.cnr.it/smarter/). The `smarterapi` package
provides functions to easily download and manage these data:

``` r
get_smarter_genotypes(species = "Goat", assembly = "ARS1")
```

See the [Collect
genotypes](https://cnr-ibba.github.io/r-smarter-api/articles/smarterapi.html#collect-genotypes)
vignette for more details and examples on how to extract genotype data
from the samples of interest.

More examples are available in the
[vignettes](https://cnr-ibba.github.io/r-smarter-api/articles/), such as
[get
started](https://cnr-ibba.github.io/r-smarter-api/articles/smarterapi.html)
with `smarterapi`, how to collect data from the
[Variants](https://cnr-ibba.github.io/r-smarter-api/articles/variants.html)
endpoint or how to work with [geographic
coordinates](https://cnr-ibba.github.io/r-smarter-api/articles/geojson.html).

## Citation

To cite SMARTER data in publications, please use:

> Cozzi P, Manunza A, Ramirez-Diaz J, Tsartsianidou V, Gkagkavouzis K,
> Peraza P, Johansson A, Arranz J, Freire F, Kusza S, Biscarini F,
> Peters L, Tosser-Klopp G, Ciappesoni G, Triantafyllidis A, Rupp R,
> Servin B, Stella A (2024). “SMARTER-database: a tool to integrate SNP
> array datasets for sheep and goat breeds.” *GigaByte*.
> <doi:10.46471/gigabyte.139> <https://doi.org/10.46471/gigabyte.139>,
> <https://github.com/cnr-ibba/SMARTER-database>.

Or simply copy `citation("smarterapi")` output from your R console.

## License

This package is licensed under GPL-3.0 License. See the
[LICENSE](LICENSE.md) file for details.
