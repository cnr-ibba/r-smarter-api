# Get SMARTER Countries

Fetch SMARTER REST API countries endpoint and returns results in a
dataframe.

## Usage

``` r
get_smarter_countries(query = list())
```

## Arguments

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected countries

## Passing additional parameters

Contries endpoint supports additional parameters when making queries.
Additional parameters need to be passed as `list` using the `query`
parameter. For example, to get all the countries where there are
"Sheeps" you need to provide `list(species="Sheep")` as `query`
parameter. Endpoint supports searches with *two* or *tree* ISO codes
using `alpha_2` and `alpha3` parameters respectively. In addition, you
can search using a pattern through the `search` parameter. See [Swagger
Countries
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Countries)
for more information about the breeds endpoint

## Examples

``` r
italy <- get_smarter_countries(query = list(name = "Italy"))
#> INFO [2025-11-16 16:16:33] Get data from countries endpoint
#> INFO [2025-11-16 16:16:33] Done!
france <- get_smarter_countries(query = list(alpha_2 = "FR"))
#> INFO [2025-11-16 16:16:33] Get data from countries endpoint
#> INFO [2025-11-16 16:16:33] Done!

if (FALSE) { # \dontrun{
# get countries where there are sheeps
sheep_countries <- get_smarter_countries(query = list(species = "Sheep"))
} # }
```
