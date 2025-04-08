test_that("eriplot returns an object with the right class", {
  # Test that the function returns a plot with the correct class
  p <- eriplot()
  expect_s3_class(p, "eri_ggplot")
  expect_s3_class(p, "ggplot")

  # Test with data argument
  p_with_data <- eriplot(data = data.frame(x = 1:3, y = 1:3))
  expect_s3_class(p_with_data, "eri_ggplot")

  # Test with mapping argument
  p_with_mapping <- eriplot(mapping = ggplot2::aes(x = 1:3, y = 1:3))
  expect_s3_class(p_with_mapping, "eri_ggplot")
})

test_that("ggplot_build.eri_ggplot works as expected", {
  # Skip if interactive session to avoid plot display
  skip_if(interactive())

  p <- eriplot() + ggplot2::geom_point(ggplot2::aes(x = c(-1, 0, 1), y = c(-1, 0, 1)))

  # Direct build should change class
  built <- ggplot2::ggplot_build(p)
  expect_false("eri_ggplot" %in% class(built$plot))

  # Result should have the eri_ggplot_built class
  expect_true("eri_ggplot_built" %in% class(built))
})
