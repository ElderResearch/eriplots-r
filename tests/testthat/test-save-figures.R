skip_on_ci()
skip_on_cran()
skip_if_not_installed("withr")

library(testthat)
library(ggplot2)
library(withr)

# Helper to test image size
check_image_size <- function(file, width, height) {
  if (requireNamespace("png", quietly = TRUE)) {
    img <- png::readPNG(file)
    dims <- dim(img)
    expect_equal(dims[1], height)
    expect_equal(dims[2], width)
  }
}

test_that("save_figures creates files with correct explicit dimensions", {
  imgfile <- local_file("example-image.png")

  p <- data.frame(x = 1:3, y = 1:3) |>
    ggplot(aes(x, y)) +
    geom_point()

  files <- save_figures(
    destination = imgfile,
    plot = p,
    formats = "png",
    width = 5,
    height = 3,
    dpi = 72,
    optipng = FALSE
  )

  expect_true(file.exists(imgfile))
  check_image_size(imgfile, width = 5 * 72, height = 3 * 72)
})

test_that("save_figures creates files with implicit dimensions", {
  p <- data.frame(x = 1:3, y = 1:3) |>
    ggplot(aes(x, y)) +
    geom_point()

  for (profile in c("document", "presentation")) {
    imgfile <- local_file("example-image.png")
    q <- p + theme_eri(profile = profile)
    z <- save_figures(imgfile, plot = q, formats = "png", optipng = FALSE)

    expect_true(file.exists(imgfile))

    check_image_size(
      file = imgfile,
      width = .theme_profiles[[profile]]$width * 300,
      height = .theme_profiles[[profile]]$height * 300
    )
  }
})

test_that("save_figures inherits options correctly", {
  local_options(list(eriplots.eriplot.theme.default_profile = "none"))
  imgfile <- local_file("example-image.png")

  example <- data.frame(x = 1:3, y = 1:3)
  plot <- ggplot(example, aes(x, y)) +
    geom_point()

  # Should inherit from theme
  plot2 <- plot + theme_eri(profile = "presentation")
  save_figures(imgfile, plot2, formats = "png", optipng = FALSE)

  check_image_size(
    imgfile,
    width = .theme_profiles$presentation$width * 300,
    height = .theme_profiles$presentation$height * 300
  )
  expect_equal(
    getOption("eriplots.eriplot.theme.default_profile"),
    "none"
  )

  # Should override
  options(eriplots.eriplot.theme.default_profile = "presentation")

  plot3 <- plot + theme_eri(profile = "document")
  save_figures(imgfile, plot3, formats = "png", optipng = FALSE)

  check_image_size(
    imgfile,
    width = .theme_profiles$document$width * 300,
    height = .theme_profiles$document$height * 300
  )
  expect_equal(
    getOption("eriplots.eriplot.theme.default_profile"),
    "presentation"
  )
})

test_that("save_figures uses ragg for WebP output when requested", {
  skip_if_not_installed("ragg")

  imgfile <- local_file("example-image.webp")

  plot <- ggplot(data.frame(x = 1:3, y = 1:3), aes(x, y)) +
    geom_point()

  save_figures(imgfile, plot, formats = "webp", optipng = FALSE)

  expect_true(file.exists(imgfile))
  expect_gt(file.size(imgfile), 0)
})

test_that("save_figures infers format from destination extension", {
  skip_if_not_installed("ragg")

  # This test creates webp, png, and pdf files (webp from extension + default png/pdf)
  imgfile_webp <- local_file("implicit-image.webp")
  imgfile_png <- local_file("implicit-image.png")
  imgfile_pdf <- local_file("implicit-image.pdf")

  plot <- ggplot(data.frame(x = 1:3, y = 1:3), aes(x, y)) +
    geom_point()

  files <- save_figures(imgfile_webp, plot, optipng = FALSE)

  expect_true(any(endsWith(files, ".webp")))
  expect_true(any(endsWith(files, ".png")))
  expect_true(any(endsWith(files, ".pdf")))
  expect_true(file.exists(imgfile_webp))
})

test_that("save_figures leaves explicit formats unchanged", {
  # The actual output is PNG (explicit format), not WebP (destination extension)
  imgfile <- local_file("explicit-image.png")

  plot <- ggplot(data.frame(x = 1:3, y = 1:3), aes(x, y)) +
    geom_point()

  files <- save_figures("explicit-image.webp", plot, formats = "png", optipng = FALSE)

  expect_true(all(endsWith(files, ".png")))
  expect_false(file.exists("explicit-image.webp"))
  expect_true(file.exists(imgfile))
})

test_that("save_figures warns on invalid format and skips it", {
  imgfile <- local_file("test-invalid.png")

  plot <- ggplot(data.frame(x = 1:3, y = 1:3), aes(x, y)) +
    geom_point()

  expect_warning(
    files <- save_figures("test-invalid", plot, formats = c("png", "bmp"), optipng = FALSE),
    "Format 'bmp' is not supported"
  )
  expect_equal(files, "test-invalid.png")
  expect_true(file.exists(imgfile))
})
