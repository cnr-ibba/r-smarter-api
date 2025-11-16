library(testthat)

test_that("invalid assembly for Goat is rejected", {
  expect_false(is_valid_assembly("Goat", "CHI2"))
})

test_that("invalid species is rejected", {
  expect_false(is_valid_species("BTAU"))
  expect_false(is_valid_assembly("BTAU", "ARS1"))
})

test_that("valid assembly for Goat is accepted", {
  expect_true(is_valid_assembly("Goat", "ARS1"))
})

test_that("Check species function works", {
  expect_error(
    check_species("InvalidSpecies"),
    "Species 'InvalidSpecies' is not supported"
  )
  expect_silent(check_species("Sheep"))
})

test_that("Check species and assemblies function works", {
  expect_error(
    check_species_and_assemblies("InvalidSpecies", "OAR3"),
    "Species 'InvalidSpecies' is not supported"
  )
  expect_error(
    check_species_and_assemblies("Sheep", "INVALID_ASSEMBLY"),
    "Assembly 'INVALID_ASSEMBLY' is not supported for species 'Sheep'"
  )
  expect_silent(check_species_and_assemblies("Sheep", "OAR3"))
})
