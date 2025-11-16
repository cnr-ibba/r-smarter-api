# Get BibTeX Citation from DOI with Caching

This function retrieves a BibTeX citation from a DOI using CrossRef.
Results are cached using memoization to improve performance for repeated
calls with the same DOI.

## Usage

``` r
get_bibtex_citation(doi)
```

## Arguments

- doi:

  The DOI of the publication to cite.

## Value

A character string with the BibTeX citation, or NA if the DOI is invalid
or cannot be retrieved.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get BibTeX citation
citation_bibtex <- get_bibtex_citation(doi = "10.46471/gigabyte.139")
} # }
```
