
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smarterapi

<!-- badges: start -->

[![R-CMD-check](https://github.com/cnr-ibba/r-smarter-api/workflows/R-CMD-check/badge.svg)](https://github.com/cnr-ibba/r-smarter-api/actions)
<!-- badges: end -->

The goal of `smarterapi` is to collect data from *SMARTER REST API*

## Installation

You can install the development version of smarterapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cnr-ibba/r-smarter-api")
```

## SMARTER credentials

The *SMARTER REST API* is not yet public and can be accessed providing a
valid *token* in every *HTTP* request. `smarterapi` can deal with token
generation and management and implement functions in order to
automatically manage tokens in every user requests. The function
`get_smarter_token` can be used to manage tokens and cache them inside
`smarterapi` package. You could provide manually your SMARTER
credentials by calling `get_smarter_token` with the proper parameters in
order to generate a token, however the recommended way is to store your
credentials using environment variables, and let `smarterapi` deal with
your token management. Please remember that SMARTER credentials **MUST
NOT be tracked** in your code nor provided to un-authorized people. To
manage your environment properly, you should define such environment
variables in your `$HOME` directory, outside any other *R projects*. If
you use *rstudio*, you can call an utility function which open such
environment file:

``` r
usethis::edit_r_environ()
```

Variables in environment file should be defined with `key=value` syntax.
In order to configure properly `smarterapi`, you have to define
`SMARTER_API_USERNAME` and `SMARTER_API_PASSWORD` with your SMARTER
credentials, like this:

``` text
SMARTER_API_USERNAME=<smarter username>
SMARTER_API_PASSWORD=<smarter password>
```

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
get help on each function like any other R functions. If you manage
tokens using `smarterapi` and environment variables, you don’t need to
provide a token as a parameter while fetching data, those function will
handle the token generation and authentication for you. There are two
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
datasets <- get_smarter_datasets(query = list(type="genotypes", type="foreground"))
```

while if you require only background goat samples, you can do like this:

``` r
goat_samples <- get_smarter_samples(species = "Goat", query=list(type="background"))
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
>
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

## Example

This is a basic example which shows you how to collect data from SMARTER
REST API for the *Italian* goats belonging to the *Adaptmap* dataset:

``` r
library(smarterapi)
datasets <- get_smarter_datasets(
  query = list(species = "Goat", search = "adaptmap", type = "genotypes", type="background"))
adatpmap_id <- datasets["_id.$oid"][1]
adaptmap_goats <- get_smarter_samples(
  species = "Goat", query = list(dataset=adatpmap_id, country="Italy"))
```
