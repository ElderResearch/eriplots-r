test_that("theme_eri returns a valid theme object", {
  # Test that the function returns a valid theme object
  theme <- theme_eri()
  expect_s3_class(theme, "theme")
  expect_type(theme, "list")
})

test_that("theme_eri sets appropriate profiles", {
  # Default profile
  test_theme <- theme_eri()
  expect_equal(attr(test_theme, "eri_theme_profile"), "none")
  expect_equal(test_theme$text$size, 11)

  # Sizes
  expected_sizes <- c(none = 11, presentation = 20, document = 10)
  for (i in seq_along(expected_sizes)) {
    textsize <- expected_sizes[i]
    profile <- names(textsize)

    test_theme <- theme_eri(profile = profile)
    expect_equal(attr(test_theme, "eri_theme_profile"), profile)
    expect_equal(test_theme$text$size, as.integer(textsize))
  }
})

test_that("theme_eri accepts partial matching in profiles", {
  test_theme <- theme_eri(profile = "doc")
  expect_equal(attr(test_theme, "eri_theme_profile"), "document")
})
