# Get SMARTER Variants

Retrieve information on SMARTER SNPs. Only information about the
supported assemblies are returned (see
[`get_smarter_info`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_info.md)
for more information).

## Usage

``` r
get_smarter_variants(species, assembly, query = list())
```

## Arguments

- species:

  a smarter species ("Goat", "Sheep")

- assembly:

  the smarter working assembly for such species

- query:

  a `list` of query arguments

## Value

Returns a dataframe with selected variants

## About SMARTER supported assemblies

Currently SMARTER supports *OAR3* and *OAR4* assemblies for Sheep and
*CHI1* and *ARS1* assemblies for goat. For each assembly, only the
evidences used to create the smarter database are returned. Retrieving
all variant for a certain assembly and species could require time and
memory.

## Examples

``` r
# get variants by region (chrom:start-end)
variants <- get_smarter_variants(
  species = "Goat",
  assembly = "ARS1",
  query = list(region = "1:1-100000")
)
#> INFO [2025-11-16 16:16:40] Get data from variants endpoint
#> INFO [2025-11-16 16:16:40] Done!
if (FALSE) { # \dontrun{
# get available assemblies from info endpoint
names(get_smarter_info()$working_assemblies)

# collect variants from goat ARS1 endpoint (takes a lot of time)
ars1_variant <- get_smarter_variants(
  species = "Goat",
  assembly = "ARS1"
)
} # }
```
