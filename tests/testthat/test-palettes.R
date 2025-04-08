test_that("eri_colors returns all colors correctly", {
  # Test getting all colors
  all_colors <- eri_colors()
  expect_type(all_colors, "character")
  expect_length(all_colors, 12) # There should be 12 colors in the palette
  expect_null(names(all_colors)) # Default has no names
})

test_that("eri_colors can get specific colors", {
  # Test getting specific colors by name
  selected <- eri_colors("mediumblue", "darkred")
  expect_length(selected, 2)
  expect_equal(selected[1], "#005E7B")
  expect_equal(selected[2], "#D0073A")

  # Test getting multiple specific colors
  three_colors <- eri_colors("mediumblue", "darkred", "yellow")
  expect_length(three_colors, 3)
  expect_equal(three_colors[3], "#FBC15E")
})

test_that("eri_colors supports partial matching", {
  # Test partial matching
  blue_match <- eri_colors("medium")
  expect_equal(blue_match, "#005E7B")

  # Multiple partial matches
  red_matches <- eri_colors("yel", "bro")
  expect_equal(red_matches[1], "#FBC15E") # yellow
  expect_equal(red_matches[2], "#603534") # brown
})

test_that("eri_colors can return colors with names", {
  # Test getting colors with names
  named_colors <- eri_colors("lightblue", "yellow", names = TRUE)
  expect_equal(names(named_colors), c("lightblue", "yellow"))
  expect_equal(named_colors[["lightblue"]], "#008CA5") # `[[` works w/o names
  expect_equal(named_colors[["yellow"]], "#FBC15E")

  # Test getting all colors with names
  all_named <- eri_colors(names = TRUE)
  expect_length(all_named, 12)
  expect_false(is.null(names(all_named)))
  expect_equal(names(all_named)[1], "mediumblue")
})

test_that("eri_colors can repeat colors in output", {
  # Test repeating colors
  repeated <- eri_colors("darkred", "darkred", "lightblue")
  expect_length(repeated, 3)
  expect_equal(repeated[1], "#D0073A")
  expect_equal(repeated[2], "#D0073A")
  expect_equal(repeated[3], "#008CA5")

  # Test repeating with names
  repeated_named <- eri_colors("darkred", "darkred", "lightblue", names = TRUE)
  expect_equal(names(repeated_named), c("darkred", "darkred", "lightblue"))
})

test_that("eri_colors can use named arguments to rename colors", {
  # Test using named arguments
  custom_named <- eri_colors(primary = "mediumblue", secondary = "darkred")
  expect_equal(names(custom_named), c("primary", "secondary"))
  expect_equal(custom_named[["primary"]], "#005E7B")
  expect_equal(custom_named[["secondary"]], "#D0073A")

  # Mix named and unnamed arguments
  mixed <- eri_colors(primary = "mediumblue", "darkred", accent = "yellow")
  expect_equal(names(mixed)[1], "primary")
  expect_equal(mixed[[1]], "#005E7B")
  expect_equal(names(mixed)[2], "")
  expect_equal(mixed[[2]], "#D0073A")
  expect_equal(names(mixed)[3], "accent")
  expect_equal(mixed[[3]], "#FBC15E")
})

test_that("eri_colors handles errors appropriately", {
  # Test error on ambiguous partial match
  expect_error(eri_colors("dark"), "could not be uniquely identified")

  # Test error on non-existent color
  expect_error(eri_colors("nonexistent"), "could not be uniquely identified")
})
