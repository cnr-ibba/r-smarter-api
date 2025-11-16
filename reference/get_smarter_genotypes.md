# Get SMARTER Genotypes

Retrieve genotypes data from SMARTER database. Only information about
the supported assemblies are returned (see
[`get_smarter_info`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_info.md)
for more information).

## Usage

``` r
get_smarter_genotypes(species, assembly, dest_path = NULL)
```

## Arguments

- species:

  a smarter species ("Goat", "Sheep")

- assembly:

  the smarter working assembly for such species

- dest_path:

  the path where the file will be downloaded. If NULL, the file will be
  downloaded in the current working directory

## Value

a character string with the path to the downloaded file is returned

## About SMARTER supported assemblies

Currently SMARTER supports *OAR3* and *OAR4* assemblies for Sheep and
*CHI1* and *ARS1* assemblies for goat. Genotypes are provided in PLINK
binary format, and compressed in a zip file.

## Examples

``` r
if (FALSE) { # \dontrun{
# get genotypes for sheep OAR3 in current directory
get_smarter_genotypes(species = "Sheep", assembly = "OAR3")
} # }
```
