library(testthat)
library(mockery)

test_that("get_smarter_variants deals with invalid species", {
  mock_geturl <- mock(NULL)

  # Stub functions with mocks
  stub(get_smarter_variants, "httr::GET", mock_geturl)

  expect_error(
    get_smarter_variants(
      species = "InvalidSpecies",
      assembly = "OAR3"
    ),
    "Species 'InvalidSpecies' is not supported"
  )

  # Verify that functions were called
  expect_called(mock_geturl, 0)
})

test_that("get_smarter_variants deals with invalid assembly", {
  mock_geturl <- mock(NULL)

  # Stub functions with mocks
  stub(get_smarter_variants, "httr::GET", mock_geturl)

  expect_error(
    get_smarter_variants(
      species = "Sheep",
      assembly = "INVALID_ASSEMBLY"
    ),
    sprintf("Assembly '%s' is not supported for species '%s'", "INVALID_ASSEMBLY", "Sheep")
  )

  # Verify that functions were called
  expect_called(mock_geturl, 0)
})
