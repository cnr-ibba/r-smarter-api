# Get SMARTER Breeds

Fetch SMARTER REST API breeds endpoint and returns results in a
dataframe.

## Usage

``` r
get_smarter_breeds(query = list())
```

## Arguments

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected breeds

## Passing additional parameters

Breeds endpoint supports additional parameters when making queries.
Additional parameters need to be passed as `list` using the `query`
parameter. For example, to get all the "Sheep" breeds you need to
provide `list(species="Sheep")` as `query` parameter. Endpoint supports
query by breed `code` and `name`. In addition, you can search using a
pattern through the `search` parameter. See [Swagger Breeds
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Breeds) for
more information about the breeds endpoint

## Examples

``` r
selected_breed <- get_smarter_breeds(query = list(code = "TEX"))
#> INFO [2025-11-16 16:25:06] Get data from breeds endpoint
#> INFO [2025-11-16 16:25:07] Done!

selected_breeds <- get_smarter_breeds(query = list(search = "mer"))
#> INFO [2025-11-16 16:25:07] Get data from breeds endpoint
#> INFO [2025-11-16 16:25:07] Done!
if (FALSE) { # \dontrun{
all_breeds <- get_smarter_breeds()
sheep_breeds <- get_smarter_breeds(query = list(species = "Sheep"))
} # }
```
