#' Save [ggplot2] figures in multiple formats
#'
#' Save ggplot2 plots in multiple formats (PNG and PDF by default)
#' with options for dimension control, optimization, and theme-based
#' profiles. When available, `optipng` is also applied.
#'
#' @param destination Where the figure(s) should be saved.
#' @param plot Plot object to save.
#' @param profile Theme profile (defaults to the plot's theme profile or "none").
#' @param formats Format(s) to save (default: c("png", "pdf")).
#' @param width Plot width (optional, overrides profile settings).
#' @param height Plot height (optional, overrides profile settings).
#' @param units Dimension units (default: "in").
#' @param dpi Resolution for raster formats (PNG, etc.; default: 300).
#' @param optipng Optimize PNGs using optipng?
#' @param ... Additional arguments passed to \code{ggplot2::ggsave}.
#'
#' @return Invisibly returns a vector of paths to the saved files.
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Create a simple plot
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point()
#'
#' # Save in both PNG and PDF formats
#' save_figures("myplot", p)
#'
#' # Save with custom dimensions
#' save_figures("myplot", p, width = 8, height = 6)
#'
#' # Save only as PDF
#' save_figures("myplot", p, formats = "pdf")
#'
#' # Save with a specific theme profile
#' save_figures("myplot", p, profile = "presentation")
#' }
save_figures <- function(
    destination,
    plot = ggplot2::last_plot(),
    profile = NULL,
    formats = c("png", "pdf"),
    width = NULL,
    height = NULL,
    units = c("in", "cm", "mm", "px"),
    dpi = 300,
    optipng = c("if_available", TRUE, FALSE),
    ...) {
  dest_base <- tools::file_path_sans_ext(destination)

  # Set up dimensions and units from profile
  profile <- profile %||% attr(plot$theme, "eri_theme_profile") %||% "none"
  units <- match.arg(units)

  if (!is.null(width) || !is.null(height)) {
    width <- width %||% NA
    height <- height %||% NA
  } else {
    width <- .theme_profiles[[profile]]$width %||% NA
    height <- .theme_profiles[[profile]]$height %||% NA
    units <- .theme_profiles[[profile]]$units %||% units
  }

  # Optimize PNGs
  optipng <- optipng[[1]]

  if (!optipng %in% c("if_available", TRUE, FALSE)) {
    stop(sprintf(
      "'optipng' should be one of: %s",
      paste0(as.list(formals()[["optipng"]])[-1], collapse = ", ")
    ))
  }

  # Save the figures
  outfiles <- c()

  for (fmt in tolower(formats)) {
    out <- paste0(dest_base, ".", fmt)
    outfiles <- c(outfiles, out)

    # Use cairo_pdf if we can, otherwise the default (NULL)
    dev <- NULL
    if (fmt == "pdf" && isTRUE(capabilities("cairo"))) {
      dev <- grDevices::cairo_pdf
    }

    args <- list(
      filename = out,
      plot = plot,
      device = dev,
      width = width,
      height = height,
      units = units,
      dpi = dpi
    )

    message(sprintf('Saving "%s"', out))
    suppressMessages(do.call(ggplot2::ggsave, utils::modifyList(args, list(...))))

    # Run optipng if we have it and if this is a PNG.
    # If TRUE, report errors if optipng fails
    # If "is_available", hide the warnings
    if (fmt == "png" && !isFALSE(optipng)) {
      message("Optimizing ", out)
      wrapper <- if (optipng == "if_available") suppressWarnings else identity
      wrapper(system2("optipng", out, stdout = NULL, stderr = NULL))
    }
  }

  invisible(outfiles)
}
