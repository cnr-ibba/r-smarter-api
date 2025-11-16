# Get SMARTER Datasets

Fetch SMARTER REST API datasets endpoint and returns results in a
dataframe.

## Usage

``` r
get_smarter_datasets(query = list())
```

## Arguments

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected datasets

## Passing additional parameters

Datasets endpoint supports additional parameters when making queries.
Additional parameters need to be passed as `list` using the `query`
parameter. For example, to get all the "Sheep" datasets you need to
provide `list(species="Sheep")` as `query` parameter. Endpoint supports
query by `type` and `chip_name`. In addition, you can search using a
pattern in file contents through the `search` parameter. See [Swagger
Datasets
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Datasets) for
more information about the datasets endpoint

## Examples

``` r
genotypes_foreground <- get_smarter_datasets(
  query = list(type = "foreground", type = "genotypes")
)
#> INFO [2025-11-16 16:05:46] Get data from datasets endpoint
#> INFO [2025-11-16 16:05:46] Done!

adaptmap_genotypes <- get_smarter_datasets(
  query = list(species = "Goat", search = "adaptmap", type = "genotypes")
)
#> INFO [2025-11-16 16:05:46] Get data from datasets endpoint
#> INFO [2025-11-16 16:05:46] Done!
if (FALSE) { # \dontrun{

all_datasets <- get_smarter_datasets()
} # }
```
