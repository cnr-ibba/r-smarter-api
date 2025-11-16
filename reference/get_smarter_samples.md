# Get SMARTER Samples

Fetch SMARTER REST API samples endpoint and returns results in a
dataframe.

## Usage

``` r
get_smarter_samples(species, query = list())
```

## Arguments

- species:

  a smarter species ("Goat", "Sheep")

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected samples

## Passing additional parameters

Samples endpoint supports additional parameters when making queries.
Additional parameters need to be passed as `list` using the `query`
parameter. For example, to get all the "foreground" samples you need to
provide `list(type="foreground")` as `query` parameter. Endpoint
supports a lot of parameters and some of them can be provided multiple
times See [Swagger Samples
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples) for
more information about the samples endpoint

## Examples

``` r
italian_sheeps <- get_smarter_samples(
  "Sheep",
  query = list(country = "Italy")
)
#> INFO [2025-11-16 16:16:35] Get data from samples endpoint
#> INFO [2025-11-16 16:16:38] Done!

merino_sheeps <- get_smarter_samples("Sheep", query = list(breed = "Merino"))
#> INFO [2025-11-16 16:16:38] Get data from samples endpoint
#> INFO [2025-11-16 16:16:39] Done!

selected_goats <- get_smarter_samples(
  "Goat",
  query = list(country = "Italy", breed_code = "ORO", breed_code = "GAR")
)
#> INFO [2025-11-16 16:16:39] Get data from samples endpoint
#> INFO [2025-11-16 16:16:39] Done!
if (FALSE) { # \dontrun{

foreground_goats <- get_smarter_samples(
  "Goat",
  query = list(type = "foreground")
)

all_sheep_samples <- get_smarter_samples("Sheep")
} # }
```
