
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smarterapi

<!-- badges: start -->
<!-- badges: end -->

The goal of smarterapi is to collect data from SMARTER REST API

## Installation

You can install the development version of smarterapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cnr-ibba/r-smarter-api")
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
