
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
or in alternative using
[devtools](https://CRAN.R-project.org/package=devtools) package, for
example:

``` r
# install devtools if needed
# install.packages("devtools")
devtools::install_github("cnr-ibba/r-smarter-api")
```

After the installation, you can load the package in your R session:

``` r
# import this library to deal with the SMARTER API
library(smarterapi)
```

## SMARTER credentials

After the public release of SMARTER data, there’s no need to provide
credentials to access the data. If you used to have credentials to
access the data, you need to upgrade your installation of `smarterapi`
package.

## Querying the SMARTER backend

`smarterapi` provides a set of functions used to fetch data from
*SMARTER-backend* endpoints described in [api
documentation](https://webserver.ibba.cnr.it/smarter-api/docs/) and
returning them into a `data.frame` object. For example, the
`get_smarter_datasets` lets to query the [Datasets
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Datasets/get_datasets),
while `get_smarter_samples` is able to query and parse the [Sample
endpoints](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples)
response. Each `smarterapi` function is documented in `R` and you can
get help on each function like any other R functions. There are two
types of parameters that are required to fetch data through the
*SMARTER-backend*: the `species` parameter, which can be `Goat` or
`Sheep` respectively for goat and sheep
[Samples](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples) or
[Variants](https://webserver.ibba.cnr.it/smarter-api/docs/#/Variants)
endpoints, and the `query` parameter which can be provided to any
*get_smarter\_* function. The `species` parameter is *mandatory* in
order to query an endpoint specific for *Goat* or *Sheep*, while the
`query` parameter is optional and need to be specified as a `list()`
object in order to limit your query to some data in particular. For
example, if you need all the foreground genotypes datasets, you can
collect data like this:

``` r
datasets <- get_smarter_datasets(
  query = list(type = "genotypes", type = "foreground"))
```

while if you require only background goat samples, you can do like this:

``` r
goat_samples <- get_smarter_samples(
  species = "Goat", query = list(type = "background"))
```

The full option list available to each endpoint is available on the
SMARTER-backend [swagger
documentation](https://webserver.ibba.cnr.it/smarter-api/docs/): the
option name to use is the same name described in *parameters*, and
description and parameter types can give you hints on how to exploit
endpoint properly. For instance, parameters described as *array of
objects* can be specified multiple times:

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

This is a basic example which shows you how to collect data from SMARTER
REST API for the *Italian* goats belonging to the *Adaptmap* dataset:

``` r
# collect the dataset by providing part of the name with the search option:
# since we are forcing to collect only background genotypes, only one dataset
# will be returned
datasets <- get_smarter_datasets(
  query = list(
    species = "Goat",
    search = "adaptmap",
    type = "genotypes",
    type = "background"
    )
)

# get the dataset id
adatpmap_id <- datasets["_id.$oid"][1]

# collect all the italian goats from the adaptmap dataset. Using the dataset id
# to filter out all the samples belonging to this dataset and the country option
# to filter out only the italian samples for this dataset
adaptmap_goats <- get_smarter_samples(
  species = "Goat",
  query = list(
    dataset = adatpmap_id,
    country = "Italy"
  )
)
```

We have other examples in the
[vignettes](https://cnr-ibba.github.io/r-smarter-api/articles/), for
example how to collect data from the
[Variants](https://cnr-ibba.github.io/r-smarter-api/articles/variants.html)
endpoints or how to work with [geographic
coordinates](https://cnr-ibba.github.io/r-smarter-api/articles/geojson.html).

# Citation

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
