
skip_on_ci()
skip_on_cran()
skip_if_not_installed("withr")

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

    with_file("example-image.png", {
      f <- "example-image.png"
      q <- p + theme_eri(profile = profile)
      z <- save_figures(f, plot = q, formats = "png", optipng = FALSE)

      expect_true(file.exists(f))

      check_image_size(
        file = f,
        width = .theme_profiles[[profile]]$width * 300,
        height = .theme_profiles[[profile]]$height * 300
      )
    })
  }
})

test_that("save_figures inherits options correctly", {
  local_options(list(eriplots.eriplot.theme.default_profile = "none"))
  imgfile <- local_file("example-image.png")

  example <- data.frame(x = 1:3, y = 1:3)
  plot <- ggplot(example, aes(x, y)) + geom_point()

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
