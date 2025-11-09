library(testthat)
library(mockery)

test_that("get_smarter_genotypes downloads file correctly", {
  # Mock external functions
  mock_geturl <- mock("SMARTER-OA-OAR3-top-0.16.0.zip\nother-file.txt")
  mock_info <- mock(list(version = "0.16.0"))
  mock_download <- mock(NULL)

  # Stub functions with mocks
  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)
  stub(get_smarter_genotypes, 'curl::curl_download', mock_download)

  # Create a temporary directory for the test
  temp_dir <- tempdir()

  # Execute the function
  result <- get_smarter_genotypes(
    species = "Sheep",
    assembly = "OAR3",
    dest_path = temp_dir
  )

  # Verify that functions were called
  expect_called(mock_geturl, 1)
  expect_called(mock_info, 1)
  expect_called(mock_download, 1)

  # Verify that the result is the correct path
  expect_match(result, "SMARTER-OA-OAR3-top-0.16.0.zip$")

  # Normalize paths to handle / vs \ differences on Windows
  expect_true(grepl(normalizePath(temp_dir, winslash = "/"), result, fixed = TRUE))

  # Verify curl_download call arguments
  download_args <- mock_args(mock_download)[[1]]
  expect_match(download_args[[1]], "ftp://")
  expect_match(download_args[[1]], "SHEEP")
  expect_match(download_args[[1]], "OAR3")
  expect_match(download_args[[1]], "SMARTER-OA-OAR3-top-0.16.0.zip")
})

test_that("get_smarter_genotypes builds correct FTP URL", {
  mock_geturl <- mock("SMARTER-CH-ARS1-top-0.16.0.zip")
  mock_info <- mock(list(version = "0.16.0"))
  mock_download <- mock(NULL)

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)
  stub(get_smarter_genotypes, 'curl::curl_download', mock_download)

  get_smarter_genotypes(
    species = "Goat",
    assembly = "ARS1"
  )

  # Verify directory listing URL
  geturl_args <- mock_args(mock_geturl)[[1]]
  expect_match(geturl_args[[1]], "ftp://")
  expect_match(geturl_args[[1]], "GOAT/ARS1")

  # Verify download URL
  download_args <- mock_args(mock_download)[[1]]
  expect_match(download_args[[1]], "GOAT")
  expect_match(download_args[[1]], "ARS1")
  expect_match(download_args[[1]], "SMARTER-CH-ARS1-top-0.16.0.zip")
})

test_that("get_smarter_genotypes handles species case-insensitively", {
  mock_geturl <- mock("SMARTER-OA-OAR4-top-0.16.0.zip")
  mock_info <- mock(list(version = "0.16.0"))
  mock_download <- mock(NULL)

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)
  stub(get_smarter_genotypes, 'curl::curl_download', mock_download)

  # Test with lowercase input
  get_smarter_genotypes(species = "sheep", assembly = "oar4")

  download_args <- mock_args(mock_download)[[1]]
  expect_match(download_args[[1]], "SHEEP")
  expect_match(download_args[[1]], "OAR4")
})

test_that("get_smarter_genotypes uses working directory when dest_path is NULL", {
  mock_geturl <- mock("SMARTER-OA-OAR3-top-0.16.0.zip")
  mock_info <- mock(list(version = "0.16.0"))
  mock_download <- mock(NULL)

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)
  stub(get_smarter_genotypes, 'curl::curl_download', mock_download)

  result <- get_smarter_genotypes(
    species = "Sheep",
    assembly = "OAR3",
    dest_path = NULL
  )

  # Verify that path contains the working directory
  expect_match(result, normalizePath(getwd(), winslash = "/"), fixed = TRUE)
})

test_that("get_smarter_genotypes raises error when no file matches", {
  # Simulate no matching file found
  mock_geturl <- mock("other-file.txt\nsome-archive.zip")
  mock_info <- mock(list(version = "0.16.0"))

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)

  expect_error(
    get_smarter_genotypes(species = "Sheep", assembly = "OAR3"),
    "No matching file found"
  )
})

test_that("get_smarter_genotypes raises error when too many files match", {
  # Simulate multiple matching files found
  mock_geturl <- mock(
    "SMARTER-OA-OAR3-top-0.16.0.zip\nSMARTER-OA-OAR3-background-0.16.0.zip"
  )
  mock_info <- mock(list(version = "0.16.0"))

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)

  expect_error(
    get_smarter_genotypes(species = "Sheep", assembly = "OAR3"),
    "No matching file found"
  )
})

test_that("get_smarter_genotypes handles different line endings", {
  # Test with \r\n (Windows) and \r (old Mac)
  mock_geturl <- mock("file1.txt\r\nSMARTER-OA-OAR3-top-0.16.0.zip\rfile3.txt")
  mock_info <- mock(list(version = "0.16.0"))
  mock_download <- mock(NULL)

  stub(get_smarter_genotypes, 'RCurl::getURL', mock_geturl)
  stub(get_smarter_genotypes, 'get_smarter_info', mock_info)
  stub(get_smarter_genotypes, 'curl::curl_download', mock_download)

  result <- get_smarter_genotypes(
    species = "Sheep",
    assembly = "OAR3"
  )

  # Verify that the correct file was identified
  expect_called(mock_download, 1)
  download_args <- mock_args(mock_download)[[1]]
  expect_match(download_args[[1]], "SMARTER-OA-OAR3-top-0.16.0.zip")
})
