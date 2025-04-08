test_that("default package options are set correctly", {
  # Get the default options from .onLoad
  pkgopts <- list(
    eriplots.eriplot.format_minus_signs = TRUE,
    eriplots.eriplot.theme.apply_eri_theme = TRUE,
    eriplots.eriplot.theme.default_profile = "none"
  )

  # Check that current options match the defaults
  expect_true(getOption("eriplots.eriplot.format_minus_signs"))
  expect_true(getOption("eriplots.eriplot.theme.apply_eri_theme"))
  expect_equal(getOption("eriplots.eriplot.theme.default_profile"), "none")
})

test_that("package options are set correctly", {
  # Test that package options exist
  expect_true(!is.null(getOption("eriplots.eriplot.format_minus_signs")))
  expect_true(!is.null(getOption("eriplots.eriplot.theme.apply_eri_theme")))
  expect_true(!is.null(getOption("eriplots.eriplot.theme.default_profile")))

  # Test setting and resetting options
  old_opts <- options()
  on.exit(options(old_opts))

  # Change an option
  options(eriplots.eriplot.format_minus_signs = FALSE)
  expect_false(getOption("eriplots.eriplot.format_minus_signs"))

  # Change multiple options
  options(
    eriplots.eriplot.theme.apply_eri_theme = FALSE,
    eriplots.eriplot.theme.default_profile = "presentation"
  )

  expect_false(getOption("eriplots.eriplot.theme.apply_eri_theme"))
  expect_equal(getOption("eriplots.eriplot.theme.default_profile"), "presentation")
})
