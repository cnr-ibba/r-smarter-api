# Contributing to r-smarter-api

Thank you for considering contributing to the r-smarter-api project!

## How to contribute

-   **Bug reports**: Open an issue describing the problem and steps to reproduce.
-   **Feature requests**: Open an issue with a clear description of the feature and its motivation.
-   **Pull requests**: Fork the repository, create a feature branch, commit your changes, and open a pull request.

## Manage dependencies

Package dependencies are managed with `renv`. You need to clone the repository
and restore the environment before working on the code:

```r
renv::restore()
```

> NOTE: first time opening the project with *RStudio* or *Positron* may take a while
> as it needs to download and install the `renv` dependency in the project folder.
> After that, your terminal will be able to use the `renv::restore()`.

If you need to add or update a package dependency, use:

```r
renv::install("package_name")
renv::snapshot()
```

To download and install packages in the current `renv` lockfile: remember that
a package will be snapshotted only if it is used in the code (i.e., loaded with
`library()` or `require()`).

### Tracking dependencies in DESCRIPTION

To ensure that all package dependencies are properly tracked, you should:

1. Add the package to the `Imports` field in the `DESCRIPTION` file.
2. Run `renv::snapshot()` to update the lockfile.

This can be done automatically by using the `usethis` package:

```r
usethis::use_package("package_name")
```

You can also specify the type of dependency (e.g., `Suggests`, `Depends`):

```r
usethis::use_package("package_name", type = "Suggests")
```

After adding the package, don't forget to run:

```r
renv::snapshot()
```

## Coding style

-   Follow the tidyverse style guide (indentation, naming, spacing).
-   Use `styler::style_pkg()` to auto-format code.
-   Run `lintr::lint_package()` to check for style issues.

## Testing

-   Add or update unit tests in `tests/testthat/` for new features or bug fixes.
-   Run all tests with `devtools::test()` before submitting.
-   A full check can be performed with `devtools::check()`.

## Documentation

-   Document all exported functions with roxygen2 comments.
-   Update vignettes if your changes affect user workflows.
-   Regenerate documentation with `devtools::document()` and `pkgdown::build_site()`.
-   Preview changes with `pkgdown::preview_site()`.

### README

`README.md` is generated from `README.Rmd`. To update it, edit `README.Rmd`
and then run:

```r
devtools::build_readme()
```

## Workflow

1.  Create an issue for significant changes in the repository.
1.  Fork and clone the repository.
2.  Create a new branch (e.g. `git checkout -b issue-<issue_number>`).
3.  Make your changes and commit them with clear messages.
4.  Run tests and check documentation.
5.  Open a pull request on GitHub.

## Code of Conduct

Please be respectful and constructive. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) if available.

## Need help?

Open an issue or contact the maintainers via GitHub.

------------------------------------------------------------------------

For more details, see the README and vignettes in the repository.
