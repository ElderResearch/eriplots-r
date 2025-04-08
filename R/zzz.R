# Init settings

# Set package options
# Modified from https://r-pkgs.org/code.html#sec-code-onLoad-onAttach
.onLoad <- function(libname, pkgname) {
  op <- options()

  pkgopts <- list(
    eriplots.eriplot.format_minus_signs = TRUE,
    eriplots.eriplot.theme.apply_eri_theme = TRUE,
    eriplots.eriplot.theme.default_profile = "none"
  )

  toset <- !(names(pkgopts) %in% names(op))
  if (any(toset)) options(pkgopts[toset])

  invisible()
}
