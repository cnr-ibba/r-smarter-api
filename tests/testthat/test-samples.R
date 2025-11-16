library(testthat)
library(mockery)

test_that("get_smarter_samples deals with invalid species", {
  mock_geturl <- mock(NULL)

  # Stub functions with mocks
  stub(get_smarter_samples, "httr::GET", mock_geturl)

  expect_error(
    get_smarter_samples(
      species = "InvalidSpecies"
    ),
    "Species 'InvalidSpecies' is not supported"
  )

  # Verify that functions were called
  expect_called(mock_geturl, 0)
})
