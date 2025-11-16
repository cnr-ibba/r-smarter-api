# Get SMARTER Supported Chips

Collect information on chip data currently managed in SMARTER database.

## Usage

``` r
get_smarter_supportedchips(query = list())
```

## Arguments

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected chips

## Examples

``` r
chips <- get_smarter_supportedchips()
#> INFO [2025-11-16 16:16:40] Get data from supported chip endpoint
#> INFO [2025-11-16 16:16:40] Done!
if (FALSE) { # \dontrun{
# collect data on chips
get_smarter_supportedchips()

# retrieve samples relying on chip used
samples <- get_smarter_samples(
  species = "Sheep",
  query = list(chip_name = "AffymetrixAxiomOviCan")
)
} # }
```
