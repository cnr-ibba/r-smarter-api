# Get Full Citation from DOI with Caching

This function retrieves a full formatted citation from a DOI using
CrossRef. Results are cached using memoization to improve performance
for repeated calls with the same DOI.

## Usage

``` r
get_full_citation(doi, style = "apa")
```

## Arguments

- doi:

  The DOI of the publication to cite.

- style:

  The citation style to use (default is "apa"). Other options include
  "bibtex", "ris", "vancouver", etc. See CrossRef documentation for
  available styles.

## Value

A character string with the full formatted citation, or NA if the DOI is
invalid or cannot be retrieved.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get full citation in APA style
citation <- get_full_citation(doi = "10.46471/gigabyte.139")

# Get citation in Vancouver style
citation_vancouver <- get_full_citation(doi = "10.46471/gigabyte.139", style = "vancouver")
} # }
```
