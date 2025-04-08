library(ggplot2)

# Skip all these on CI/CRAN
skip_on_ci()
skip_on_cran()

test_that("save_figures creates files with correct explicit dimensions", {
  temp_file <- tempfile(fileext = "")
  on.exit(unlink(paste0(temp_file, ".*")))

  p <- ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(x, y)) +
    geom_point()

  files <- save_figures(
    destination = temp_file,
    plot = p,
    formats = "png",
    width = 5,
    height = 3,
    dpi = 72,
    optipng = FALSE
  )

  expect_true(file.exists(paste0(temp_file, ".png")))

  if (requireNamespace("png", quietly = TRUE)) {
    img <- png::readPNG(paste0(temp_file, ".png"))
    dims <- dim(img)
    # Dimensions should be approximately width * dpi x height * dpi
    expect_equal(dims[2], 5 * 72, tolerance = 10)
    expect_equal(dims[1], 3 * 72, tolerance = 10)
  }
})

test_that("save_figures creates files with implicit dimensions", {
  temp_file <- paste0(tempfile(fileext = ""))
  on.exit(unlink(paste0(temp_file, ".*")))

  p <- ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(x, y)) +
    geom_point()

  for (profile in c("document", "presentation")) {
    f <- paste0(temp_file, "_", profile, ".png")
    q <- p + theme_eri(profile = profile)
    z <- save_figures(f, plot = q, formats = "png", optipng = FALSE)

    expect_true(file.exists(f))

    if (requireNamespace("png", quietly = TRUE)) {
      # Get expected dimensions from profile
      expected_width <- .theme_profiles[[profile]]$width
      expected_height <- .theme_profiles[[profile]]$height
      expected_units <- .theme_profiles[[profile]]$units
      expected_dpi <- 300 # Default dpi from save_figures

      # Convert to pixels based on units (inches)
      expected_width_px <- expected_width * expected_dpi
      expected_height_px <- expected_height * expected_dpi

      img <- png::readPNG(f)
      dims <- dim(img)

      expect_equal(dims[2], expected_width_px, tolerance = 10)
      expect_equal(dims[1], expected_height_px, tolerance = 10)
    }
  }
})
