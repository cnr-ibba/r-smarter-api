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
