# Working with SNPs

This vignette describe how to use the [variant
endpoints](https://webserver.ibba.cnr.it/smarter-api/docs/#/Variants)
which store information about SNPs used in the *smarter genotype
datasets*.

``` r
library(smarterapi)
```

## Assembly versions

One of the aim of this project is to manage genotypes in different
assembly version. This means collect data from different assemblies (due
to when data is generated), from different sources (*Affymetrix*,
*Illumina*, *WGS*) and different file formats. Genotypes are normalized
in order to be consistent accross data sources and stored in one
genotype file for each specie.

Currently four assembly versions are managed, two for the sheep dataset
and two for the goat dataset. Information about assemblies data sources
can be retrieved from the backend [info
endpoint](https://webserver.ibba.cnr.it/smarter-api/docs/#/Info) through
the
[`get_smarter_info()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_info.md)
function:

``` r
info <- get_smarter_info()
assemblies <- as.data.frame(t(as.data.frame(info$working_assemblies)))
names(assemblies) <- c("name", "source")
```

|          |   name   |    source    |
|:--------:|:--------:|:------------:|
| **ARS1** |   ARS1   |   manifest   |
| **CHI1** |  CHI1.0  | SNPchiMp v.3 |
| **OAR3** | Oar_v3.1 | SNPchiMp v.3 |
| **OAR4** | Oar_v4.0 | SNPchiMp v.3 |

## Collect data from an assembly

[`get_smarter_variants()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_variants.md)
have two mandatory parameters, `species` and `assembly`, then it could
accept additional parameters (see one of the [variant
endpoints](https://webserver.ibba.cnr.it/smarter-api/docs/#/Variants) to
have more information). For example you can search variants for *snp
name* or *rs id* (if the latter exists):

``` r
snp <- get_smarter_variants(
  species = "Goat",
  assembly = "ARS1",
  query = list(
    name = "snp12965-scaffold1499-3295573"
  )
)
```

|  affy_snp_id   | chrom |    date    | illumina | illumina_strand |
|:--------------:|:-----:|:----------:|:--------:|:---------------:|
| Affx-122936132 |   8   | 2021-01-08 |   T/C    |       BOT       |

Table continues below

| illumina_top | imported_from | position | strand | version |
|:------------:|:-------------:|:--------:|:------:|:-------:|
|     A/G      |   manifest    | 66621364 |  BOT   |  ARS1   |

Table continues below

|             name              |       probesets       |    rs_id    |
|:-----------------------------:|:---------------------:|:-----------:|
| snp12965-scaffold1499-3295573 | AffymetrixAxiomGoatv2 | rs119103301 |

Please, refer to the
[`get_smarter_info()`](https://cnr-ibba.github.io/r-smarter-api/reference/get_smarter_info.md)
`working_assemblies` to have an idea of the assemblies supported by the
[SMARTER-database](https://github.com/cnr-ibba/SMARTER-database). Data
which come from [SNPchiMp v.3](https://webserver.ibba.cnr.it/SNPchimp/)
like the *Sheep* `OAR3` assembly, support the *illumina forward*
attribute. For example the following SNP:

``` r
snp <- get_smarter_variants(
  species = "Sheep",
  assembly = "OAR3",
  query = list(
    rs_id = "rs10721092"
  )
)
```

|     chip_name      | alleles | chrom | illumina | illumina_forward |
|:------------------:|:-------:|:-----:|:--------:|:----------------:|
| IlluminaOvineHDSNP |   C/T   |  18   |   T/C    |       T/C        |

Table continues below

| illumina_strand | illumina_top | imported_from | position |    ss_id    |
|:---------------:|:------------:|:-------------:|:--------:|:-----------:|
|     bottom      |     A/G      | SNPchiMp v.3  | 64249211 | ss896246690 |

Table continues below

| strand  | version  |        name         |   rs_id    |
|:-------:|:--------:|:-------------------:|:----------:|
| forward | Oar_v3.1 | oar3_OAR18_64249211 | rs10721092 |

Is `T/C` on the *forward* strand of *OAR3*: this means that the reversed
probe is aligned to the genome (as you could infer from the `bottom`
*illumina strand* attribute of this SNP). Genotypes in the
SMARTER-database are converted using the **illumina top** coding
convention, so you will find this SNP as `A/G` in the SMARTER-database
while on the reference sequence it’s `T/C`.

## Fetch Variants by region

Variants endpoint support query by regions, using
`<chromosome>:<start>-<end>` as format, for example:

``` r
variants <- get_smarter_variants(
  species = "Goat",
  assembly = "ARS1",
  query = list(
    region = "1:1-100000"
  )
)
```

|   affy_snp_id   |                chip_name                | chrom |    date    |
|:---------------:|:---------------------------------------:|:-----:|:----------:|
| Affx-1111832849 | IlluminaGoatSNP50,AffymetrixAxiomGoatv2 |   1   | 2021-01-08 |
| Affx-122941307  | IlluminaGoatSNP50,AffymetrixAxiomGoatv2 |   1   | 2021-01-08 |
|       NA        |            IlluminaGoatSNP50            |   1   | 2021-01-08 |

Table continues below

| illumina | illumina_strand | illumina_top | imported_from | position | strand |
|:--------:|:---------------:|:------------:|:-------------:|:--------:|:------:|
|   T/C    |       BOT       |     A/G      |   manifest    |  18960   |  TOP   |
|   T/C    |       BOT       |     A/G      |   manifest    |  47271   |  BOT   |
|   T/C    |       BOT       |     A/G      |   manifest    |  63095   |  BOT   |

Table continues below

| version |             name             |    rs_id    |
|:-------:|:----------------------------:|:-----------:|
|  ARS1   |       1_18960_AF-PAKI        |    NULL     |
|  ARS1   | snp14099-scaffold1560-920888 | rs268246860 |
|  ARS1   |        GoatD01.029677        |    NULL     |

## Fetch Variants by chip name

You can download *all variants* for a certain chip: please consider that
it will require a lot of time and memory, since we store more than 600K
SNPs in the smarter database. First, collect the available chips from
the SMARTER-database, for example for the Sheep species:

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

Then collect all the SNPs for a certain chip by providing the SMARTER
chip *name*. Please, consider that you will download more than 50K SNP
for this chip and this will take a lot of time

``` r
variants <- get_smarter_variants(
  species = "Sheep",
  assembly = "OAR3",
  query = list(
    chip_name = "IlluminaOvineSNP50"
  )
)
```
