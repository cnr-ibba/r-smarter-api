# Get SMARTER GeoJSON Samples

Fetch SMARTER REST API samples with GPS coordinates and return them into
as simple features.

## Usage

``` r
get_smarter_geojson(species, query = list(), polygons = NULL)
```

## Arguments

- species:

  a smarter species ("Goat", "Sheep")

- query:

  a `list` of query arguments

- polygons:

  a sf object with polygons to filter the samples

## Value

a sf data object

## Examples

``` r
if (FALSE) { # \dontrun{
# required to execute pipe operations and draw examples
library(dplyr)
library(leaflet)

# get goat samples with GPS coordinates as sf object
goat_data <- get_smarter_geojson(
  species = "Goat",
  query = list(
    type = "background",
    country = "Italy"
  )
)

# leaflet doesn't handle MULTIPOINT data (https://github.com/rstudio/leaflet/issues/352)
# Cast them into point considering only the first objects
# (https://r-spatial.github.io/sf/reference/st_cast.html)
goat_data <- goat_data %>% sf::st_cast("POINT", do_split = FALSE)

# draw samples in a leaflet map using markerCluser
leaflet(data = goat_data) %>%
  leaflet::addTiles() %>%
  leaflet::addMarkers(
    clusterOptions = leaflet::markerClusterOptions(), label = ~smarter_id
  )
} # }
```
