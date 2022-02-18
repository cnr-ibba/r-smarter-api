
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smarterapi

<!-- badges: start -->
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

## Example

This is a basic example which shows you how to collect data from SMARTER
REST API for the *Italian* goats belonging to the *Adaptmap* dataset:

``` r
library(smarterapi)
datasets <- get_smarter_datasets(
  query = list(species = "Goat", search = "adaptmap", type = "genotypes"))
adatpmap_id <- datasets["_id.$oid"][1]
adaptmap_goats <- get_smarter_samples(
  species = "Goat", query = list(dataset=adatpmap_id, country="Italy"))
```