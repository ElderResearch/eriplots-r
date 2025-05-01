test_that("alpha() throws errors for invalid inputs", {
  expect_error(alpha(0), "n must be positive")
  expect_error(alpha(-1), "n must be positive")
  expect_error(alpha(1, max_opacity = -0.1), "max_opacity must be between 0 and 1")
  expect_error(alpha(1, max_opacity = 1.1), "max_opacity must be between 0 and 1")
})

test_that("alpha() works with single layer", {
  expect_equal(alpha(1), 0.85)
  expect_equal(alpha(1, max_opacity = 0.5), 0.5)
})

test_that("alpha() works with two layers", {
  # For two layers, the formula should give us sqrt(max_opacity) for each layer
  # When stacked, this should result in the max_opacity
  result <- alpha(2)
  expect_equal(1 - (1 - result)^2, 0.85)

  # Test with custom max_opacity
  result <- alpha(2, max_opacity = 0.5)
  expect_equal(1 - (1 - result)^2, 0.5)
})

test_that("alpha() works with custom max_opacity", {
  expect_equal(alpha(1, max_opacity = 0.3), 0.3)
})
