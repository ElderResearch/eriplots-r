library(ggplot2)

test_that("format_minus_signs can be added to a ggplot", {
  expect_no_error({
    ggplot(data.frame()) +
      format_minus_signs()
  })
})

test_that("format_minus_signs correctly modifies continuous scales", {
  # Create a plot with negative values
  df <- data.frame(x = c(-10, -5, 0, 5, 10), y = c(-10, -5, 0, 5, 10))

  p <- ggplot(df, aes(x = x, y = y)) +
    geom_point()

  # After fixing, scales should use minus sign formatting
  # and have built-up scales (no waiver())
  p_fixed <- format_minus_signs(p)
  for (scale in p_fixed$scales$scales) {
    if (inherits(scale, "ScaleContinuous")) {
      expect_false(inherits(scale$labels, "waiver"))

      # Test that the formatter actually uses minus signs
      test_values <- scale$labels(c(-10, 10))
      expect_match(test_values[1], "\u2212", fixed = TRUE) # Unicode minus sign
      expect_no_match(test_values[1], "-", fixed = TRUE) # Hyphen
    }
  }
})
