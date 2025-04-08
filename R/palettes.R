# Color selection and color palettes

#' ERI brand-related colors
#'
#' Retrieve one or more colors from the ERI color palette.
#' If no arguments are provided, returns the entire palette.
#'
#' @param ... Color names or indexes to select. Repetition is allowed.
#' @param names Whether to include color names in the output vector.
#'
#' @returns A named character vector of hex color codes.
#' @export
#'
#' @examples
#' # Get all colors
#' eri_colors()
#'
#' # Get specific colors
#' eri_colors("mediumblue", "darkred")
#'
#' # Get colors by partial matching
#' eri_colors("gr", "or")
#'
#' # Get colors with names
#' eri_colors("lightblue", "yellow", names = TRUE)
#'
#' # Repeat colors in output
#' eri_colors("darkred", "darkred", "lightblue")
#'
#' # Use named arguments to rename colors in output
#' eri_colors(primary = "mediumblue", secondary = "darkred")
eri_colors <- function(..., names = FALSE) {
  .palette <- c(
    mediumblue = "#005E7B",
    darkred = "#D0073A",
    lightblue = "#008CA5",
    gray = "#777777",
    yellow = "#FBC15E",
    darkgreen = "#307F42",
    pink = "#FFB5B8",
    darkblue = "#063157",
    brightred = "#EA0D49",
    brown = "#603534",
    lightgreen = "#70B73F",
    orange = "#F7941D"
  )

  dots <- unlist(list(...))
  if (is.null(dots)) {
    if (isFALSE(names)) {
      names(.palette) <- NULL
    }
    return(.palette)
  }

  colors <- names(.palette)
  indices <- pmatch(dots, colors, duplicates.ok = TRUE)
  selected <- colors[indices]

  if (any(is.na(indices))) {
    stop(
      "One or more colors could not be uniquely identified: ",
      paste0('"', dots[is.na(indices)], '"', collapse = ", ")
    )
  }

  # Report missings
  misses <- selected[!selected %in% names(.palette)]
  if (length(misses) > 0) {
    warning("Color names not mapped: ", paste0(misses, collapse = ","))
  }

  out <- .palette[selected]

  if (isFALSE(names)) {
    names(out) <- NULL
    if (!is.null(names(dots))) {
      names(out) <- names(dots)
    }
  }

  out
}

#' Create a color palette from ERI colors
#'
#' @param n Number of colors to return. If missing, returns all colors.
#' @param palette Currently not used, included for API compatibility.
#' @param alpha Opacity level between 0 and 1.
#' @param recycle If TRUE, recycle colors to match requested length `n`.
#' @param names If TRUE, return the color names. If FALSE, return no names.
#'  If a character vector, assign the provided names to the colors (e.g.,
#'  for use with \pkg{ggplot2}'s `scale_color_manual()`).
#'
#' @returns A character vector of hex color codes.
#' @export
#'
#' @examples
#' # Get all ERI colors
#' all_colors <- eri_palette()
#'
#' # Get the first 3 colors
#' three_colors <- eri_palette(3)
#'
#' # Get 5 colors with 50% opacity
#' transparent_colors <- eri_palette(5, alpha = 0.5)
#'
#' # Get colors with custom names
#' named_colors <- eri_palette(3, names = c("Primary", "Secondary", "Accent"))
eri_palette <- function(n, palette = NULL, alpha, recycle = FALSE, names = FALSE) {
  pal <- eri_colors(names = TRUE)

  if (missing(n)) {
    n <- length(pal)
  }

  pal <- pal[seq_len(min(n, length(pal)))]

  if (isTRUE(recycle)) {
    pal <- rep(pal, length.out = n)
  }

  if (n > length(pal)) {
    stop("n > length(pal)")
  }

  if (!missing(alpha)) {
    alpha <- pmin(pmax(alpha, 0), 1)
    suffix <- toupper(as.hexmode(as.integer(round(alpha * 255))))
    pal <- paste0(pal, suffix)
  }

  if (isFALSE(names)) {
    names(pal) <- NULL
  } else if (is.character(names)) {
    if (length(names) != length(pal)) {
      stop("Length of argument 'names' should match the palette length")
    }
    names(pal) <- names
  }

  pal
}
