# Get Short Citation from DOI with Caching

This function retrieves a short citation (Author et al. Year) from a DOI
using CrossRef. Results are cached using memoization to improve
performance for repeated calls with the same DOI.

## Usage

``` r
get_short_citation(doi)
```

## Arguments

- doi:

  The DOI of the publication to cite.

## Value

A character string with the short citation in "Author et al. Year"
format, or NA if the DOI is invalid or cannot be retrieved.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get short citation
citation <- get_short_citation(doi = "10.46471/gigabyte.139")
} # }
```
