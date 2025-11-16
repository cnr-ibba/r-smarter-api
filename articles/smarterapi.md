# Using smarterapi

**smarterapi** is an R package which enable to browse the [SMARTER
backend API](https://webserver.ibba.cnr.it/smarter-api/docs/) and
collect smarter data. In this R package, functions to deal with the
different API endpoints are implemented.

## Getting started

Simply import `smarterapi` like any other R package:

``` r
library(dplyr)
library(smarterapi)
```

## Collect info about versions

The smarter database is continuously updated, for example when receiving
new samples, genotypes, metadata or when something is fixed or updated,
for example when a new assembly is added. In order to ensure
reproducibility and monitoring changes, genotypes and metadata are
provided using *versions*: this means that you have to ensure that the
genotypes dataset and metadata are referring to the same version. You
can check database version using the
[`get_smarter_info()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_info.md)
method:

``` r
info <- get_smarter_info()
info$version
#> [1] "0.4.10"
info$last_updated
#> [1] "2024-10-08 11:55:59 UTC"
```

The same version system is specified in the genotype file dataset you
can download from the smarter FTP site:

``` bash
$ tree -L 2 SHEEP/
SHEEP/
└── OAR3
    ├── archive
    ├── SMARTER-OA-OAR3-top-0.4.10.md5
    └── SMARTER-OA-OAR3-top-0.4.10.zip
```

You have to ensure that you are working with the same version, for both
metadata and genotypes: if not, you may not find samples in the genotype
files or you are referring to an out-dated assembly version. To see the
changelist in each version, please refer to the SMARTER-database
[HISTORY.rst](https://github.com/cnr-ibba/SMARTER-database/blob/master/HISTORY.rst)
file.

## Querying SMARTER API

The `smarterapi` package is structured to handle *requests/responses* to
the SMARTER API backend using R packages like `httr` and `jsonlite`. In
general, each functions accepts a `query=list()` parameter, in which
pass additional parameter to the API endpoint in order to filter results
matching query. Some functions like
[`get_smarter_samples()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_samples.md)
or
[`get_smarter_variants()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_variants.md)
requires additional parameters like the `species` or the `assembly`
version. Each function in general will return results in a `data.frame`:
you could filter out data using `dplyr` or with standard R methods or
you could filter data *directly* by submitting a proper query to the
API. Please refer to the proper documentation to understand which
parameters a function expect. See also the [SMARTER-backend
API](https://webserver.ibba.cnr.it/smarter-api/docs/) web interface to
have an idea on which parameter are allowed for each endpoint.

## Collect samples

Here are some examples on collecting samples. The main function required
to collect sample is
[`get_smarter_samples()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_samples.md),
which is an helper function which allow to query the
[/samples/goat](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples/get_samples_goat)
and
[/samples/sheep](https://webserver.ibba.cnr.it/smarter-api/docs/#/Samples/get_samples_sheep)
endpoints of the SMARTER-backend API. We will use some other functions
to have better idea on which values to use to filter data. Remember that
all the parameters you see in each different example can be merged with
other to restrict your query to have only the samples you are looking
for.

### Select by datasets

Getting samples by dataset is quite easy, you have to provide the proper
`dataset_id` to the
[`get_smarter_samples()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_samples.md)
function. However, you have to determine the proper `dataset_id` using
the `get_smarter_dataset()` function, which model the
[/datasets](https://webserver.ibba.cnr.it/smarter-api/docs/#/Datasets/get_datasets)
endpoint. For example, to extract only *background* genotypes datasets
(data generated before SMARTER project) you have to pass the proper
`type` to the `query` argument. Since the `query` argument is a list,
you can pass multiple parameters at once. For parameters which supports
arrays, you could supply the same parameter name multiple times: each
one will be passed through the API endpoint

``` r
# select all genotypes datasets made before SMARTER project
background_genotypes <- get_smarter_datasets(
  query = list(type = "background", type = "genotypes")
)

# same as before, but limiting to goat species
background_goat_genotypes <- get_smarter_datasets(
  query = list(
    type = "background",
    type = "genotypes",
    species = "Goat"
  )
)
```

Take some time to explore the dataframe columns. There are two
importants fields, the first is the `_id.$oid` column, which is the
`dataset_id` we want to provide to collect samples belonging to this
dataset. The second is the `file` column, which is the archive name
which was uploaded into the smarter database. For example, here is what
the `background_goat_genotypes` table looks like:

|        \_id.\$oid        |   breed    |               file                |
|:------------------------:|:----------:|:---------------------------------:|
| 604f75a61a08c53cebd09b5b | 144 breeds | ADAPTmap_genotypeTOP_20161201.zip |
| 643ec41371506d0c63bc5d63 | 10 breeds  |       burren_et_al_2016.zip       |
| 643ec41571506d0c63bc5d64 | 23 breeds  |     cortellari_et_al_2021.zip     |

So collect the *adaptmap* samples, we can provide the proper
`dataset_id` to the
[`get_smarter_samples()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_samples.md)
method. We can add additional parameters, like country:

``` r
# select the adaptmap id, which is in the first row of the dataframe
adatpmap_id <- background_goat_genotypes["_id.$oid"][1, 1]
adaptmap_goats <- get_smarter_samples(
  species = "Goat", query = list(dataset = adatpmap_id, country = "Italy")
)
```

The previous case is quite easy, we want only one dataset in
`background_goat_genotypes` dataframe, so we can simply paste this value
in the `get_smarter_samples` query. But how we can handle multiple
datasets? we can transform the proper column in a list and then renaming
it:

``` r
# get more datasets
foreground_goat_genotypes <- get_smarter_datasets(
  query = list(type = "genotypes", type = "foreground", species = "Goat")
)

# construct the query arguments
datasets <- as.list(foreground_goat_genotypes$"_id.$oid")
names(datasets) <- rep("dataset", length(datasets))
breeds <- list(breed_code = "LNR", breed_code = "SKO", breed_code = "FSS")
query <- append(datasets, breeds)

# select samples: subset by breed code and datasets
foreground_goat_samples <- get_smarter_samples(species = "Goat", query = query)
```

We can also use the
[`get_smarter_datasets()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_datasets.md)
function to do a reverse selection of our samples, for example to get
all the samples which are not in one or more datasets: suppose, for
example, to collect all samples which are not in the *isheep* datasets:

``` r
# collect all foreground datasets having "isheep" in their name
isheep_datasets <- get_smarter_datasets(
  query = list(
    type = "foreground",
    type = "genotypes",
    search = "isheep"
  )
)

# collect ids for isheep datasets
isheep_ids <- isheep_datasets$"_id.$oid"

# collect all foreground samples
foreground_samples <- get_smarter_samples(
  "Sheep",
  query = list(type = "foreground")
)

# get rid of isheep_samples
filtered_samples <- foreground_samples %>%
  dplyr::filter(!`dataset_id.$oid` %in% isheep_ids)
```

The last selection example relies on dataset file contents: if you
remember the name of the file submitted in the dataset, you can search
by datasets *content*:

``` r
datasets <- get_smarter_datasets(query = list(search = "adaptmap"))
```

|        \_id.\$oid        |   breed    |               file                |
|:------------------------:|:----------:|:---------------------------------:|
| 604f75a61a08c53cebd09b5b | 144 breeds | ADAPTmap_genotypeTOP_20161201.zip |
| 604f82821a08c53cebd0a0bf | 144 breeds |  ADAPTmap_phenotype_20161201.zip  |

This time two results are returned, since one is a *phenotypes* dataset,
while the other is a *genotypes*. To select only *genotypes*, simply add
`type=genotypes` to the `query` parameter.

### Select by breed

You can select samples relying on *breeds names* or *breed codes*. Breed
names are written in the languages they come from, so in order to
retrieve *Île de France* or *Fjällnäs* breed samples, you have to
specify the full breed name or use the search parameter with the
[`get_smarter_breeds()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_breeds.md)
which model the
[/breeds](https://webserver.ibba.cnr.it/smarter-api/docs/#/Breeds/get_breeds)
endpoint:

``` r
breeds <- get_smarter_breeds(
  query = list(
    species = "Sheep",
    search = "de france"
  )
)
```

|     name      | code |
|:-------------:|:----:|
| Île de France | IDF  |

Search for breeds can return multiple values, for example:

``` r
breeds <- get_smarter_breeds(
  query = list(
    species = "Sheep",
    search = "merino"
  )
)
```

|           name           | code |
|:------------------------:|:----:|
|          Merino          | MER  |
| AustralianIndustryMerino | AIM  |
|     AustralianMerino     | AME  |
|   AustralianPollMerino   | APM  |
|      ChineseMerino       | CME  |
|     MacarthurMerino      | MCM  |
|     Merinolandschaf      | MLA  |
|      Merino Horned       | MEH  |
|      Merino Polled       | MEP  |
|    Merino Estremadura    | MEE  |

Name and codes can be used as they are to select samples by passing
multiple arguments to the query:

``` r
selected_samples <- get_smarter_samples(species = "Sheep", query = list(
  breed_code = "MER", breed_code = "AME"
))
```

or to get all the samples with *merino* in breed name:

``` r
# construct the query arguments
query <- as.list(breeds$code)
names(query) <- rep("breed_code", length(query))

# execute query
merino_samples <- get_smarter_samples(species = "Sheep", query = query)
```

### Select by country

You can retrive samples by countries. First get a list of the available
countries relying on country name, then extract samples using the
correct country name:

``` r
italy <- get_smarter_countries(query = list(search = "italy"))

italian_background_sheeps <- get_smarter_samples(
  species = "Sheep",
  query = list(
    country = italy$name[1]
  )
)
```

### Select by chip

You can select samples relying on the chip they are sequenced. If you
search for multiple chip types, you will collect all samples which
belongs to any of the specified chip. First, collect a list of the
available chips for a certain species:

``` r
sheep_chips <- get_smarter_supportedchips(query = list(species = "Sheep"))
```

| manufacturer | n_of_snps |          name           | species |
|:------------:|:---------:|:-----------------------:|:-------:|
|   illumina   |   54241   |   IlluminaOvineSNP50    |  Sheep  |
|   illumina   |  605998   |   IlluminaOvineHDSNP    |  Sheep  |
|  affymetrix  |   56793   |  AffymetrixAxiomOviCan  |  Sheep  |
|  affymetrix  |   49702   | AffymetrixAxiomBGovisNP |  Sheep  |
|  affymetrix  |   60379   | AffymetrixAxiomBGovis2  |  Sheep  |
|      NA      |     0     |  WholeGenomeSequencing  |  Sheep  |

Then collect samples relying on chip name, for example:

``` r
selected_samples <- get_smarter_samples(
  species = "Sheep",
  query = list(
    chip_name = "IlluminaOvineHDSNP",
    chip_name = "AffymetrixAxiomOviCan"
  )
)
```

### Select by metadata

Since metadata aren’t formatted in the same way in each samples, is
difficult to define a single query you can apply to each samples. For
the moment, the only queries you can apply on metadata are restricted to
their presence or absence. For example, we can collect all samples which
have GPS coordinates and phenotypes (any):

``` r
smarter_goats <- get_smarter_samples(
  species = "Goat",
  query = list(
    locations__exists = TRUE,
    phenotype__exists = TRUE
  )
)
```

After that, you have to filter out the `smarter_goats` dataframe in
order to collect only the samples you want.

## Refer samples to their original publication

Suppose you want to refer the samples to the original publication the
come from: in the *dataset* dataframe we have a `doi` column in which
the *publication DOI* is stored. You can use this information to collect
publication information, but you need to merge *samples* and *datasets*
dataframes in order to refer properly the samples to the publication
they come from. Here is an example of how to do:

``` r
# collect all the genotypes datasets
datasets <- get_smarter_datasets(
  query = list(
    species = "Sheep",
    type = "genotypes"
  )
)

# collect all the samples
samples <- get_smarter_samples(
  species = "Sheep",
)

# merge datasets and samples using dplyr
samples_with_doi <- dplyr::inner_join(
  datasets,
  samples,
  by = dplyr::join_by(`_id.$oid` == `dataset_id.$oid`)
) %>%
  dplyr::select(smarter_id, breed_code, breed.y, doi) %>%
  dplyr::filter(!is.na(doi))

# count how many samples come from each publication
samples_with_doi %>%
  group_by(doi) %>%
  summarise(counts = n())
```

For a comprehensive guide on how to cite SMARTER samples, including
additional examples, see the dedicated
[`vignette("citing")`](https://cnr-ibba.github.io/r-smarter-api/articles/citing.md)

## Collect genotypes

The *genotypes* can’t be retrieved using the *smarter-api* because they
are available from the [public
FTP](ftp://webserver.ibba.cnr.it/smarter/). You need to download the
files using an FTP client like
[FileZilla](https://filezilla-project.org/) or
[lftp](https://lftp.yar.ru/) and then extract the genotypes using
[plink](https://www.cog-genomics.org/plink/). In alternative, is it
possible to download the genotypes using the `get_smarter_genotypes`
method of this package. This method will download the genotypes from the
FTP for the current releases of the selected *species* and *assembly*
and will return the destination path of the downloaded archive:

``` r
downloaded_archive <- get_smarter_genotypes(
  "Sheep",
  "OAR3"
)
```

This method will download the genotypes in the current working
directory, or in the directory specified in the `dest_path` argument.
The genotypes will be stored in a compressed `.zip` file, which need to
be de-compressed in order to be used with
[plink](https://www.cog-genomics.org/plink/).

## Subset genotypes relying samples

After you have identified the samples of your interest, you can extract
their genotypes from the proper file using
[plink](https://www.cog-genomics.org/plink/). First, you have to write a
*TSV* file with *breed_code* and *smarter_id* as columns. For example,
using the samples selected above and *dplyr*:

``` r
selected_sheeps_ids <- italian_background_sheeps %>%
  dplyr::select(
    "breed_code", "smarter_id"
  )

write.table(
  selected_sheeps_ids,
  file = "selected_sheeps.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
```

Next, you need to collect the proper *plink options* in order to not
loose information from the plink file. The parameters used to generate
the genotype files are tracked in the info endpoint. In this example,
get parameters from *Sheep* genotypes:

``` r
info <- get_smarter_info()
plink_opts <- paste0(info$plink_specie_opt$Sheep, collapse = " ")
plink_opts
#> [1] "--chr-set 26 no-xy no-mt --allow-no-sex"
```

And finally you can call plink and providing your sample list:

``` bash
plink --chr-set 26 no-xy no-mt --allow-no-sex \
  --bfile SMARTER-OA-OAR3-top-0.4.10 \
  --keep selected_sheeps.txt \
  --out selected_sheeps-OAR3-top-0.4.10 \
  --make-bed
```
