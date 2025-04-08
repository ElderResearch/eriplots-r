# ggplot2 theme


# Profile values
.theme_profiles <- list(
  none = list(text_size = 11, width = NA, height = NA),
  presentation = list(text_size = 20, width = 7, height = 4, units = "in"),
  document = list(text_size = 10, width = 4.5, height = 2.5, units = "in")
)


#' Clean baseline [ggplot2] theme
#'
#' A simple, flexible [ggplot2] theme based on
#' [`theme_minimal()`][ggplot2::theme_minimal()]. Provides clean,
#' simple defaults.
#'
#' As in other [ggplot2] themes, baseline theme settings can be
#' specified via function arguments. These value are propagated
#' downwards through the theme, and as far as possible downstream
#' element sizes, faces, etc. are defined relative to these base
#' values.
#'
#' @param profile One of "none", "presentation", or "document".
#'  Sets the text size and other parameters to support the
#'  selected document type.
#' @param base_size Font size. All inherited font sizes are
#'  defined relative to this size. The base size is 11 pt by
#'  default, following tidyverse conventions for interactive
#'  figures. Smaller sizes, like 10 pt, are be better suited for
#'  print or presented figures.
#' @param base_family Font family. If not specified then
#'  [ggplot2] default fonts are used.
#' @param base_line_size Base line width. If not specified, this
#'  is computed such that the base line width at 10 pt is 0.3 mm.
#' @param base_rect_size Base rectangle size. If not specified,
#'  this is computed such that the size at 10 pt is 0.3 mm.
#'  [`theme_minimal()`][ggplot2::theme_minimal].
#' @param aspect Aspect ratio of the plotting area (height
#'  divided by width). If `NULL` (default), the plotting area
#'  will be scaled and shaped to fit the available space. If
#'  specified, the plotting area will remain fixed to the
#'  provided ratio, potentially leaving empty space along the
#'  figure's left and right or top and bottom edges.
#'
#' @return A ggplot2 [theme][ggplot2::theme].
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(eriplots)
#'
#' # Use the theme as-is
#' theme_set(theme_eri())
#'
#' # Customize the theme, e.g., use a different typeface
#' theme_set(theme_eri(base_family = "serif"))
#' }
theme_eri <- function(
    profile = c("none", "presentation", "document"),
    base_size = NULL,
    base_family = NULL,
    base_line_size = NULL,
    base_rect_size = NULL,
    aspect = NULL) {
  # Set the profile
  profile <- match.arg(profile)
  theme_text_size <- .theme_profiles[[profile]][["text_size"]]

  # Set any defaults that are not missing
  base_size <- base_size %||% theme_text_size
  base_family <- base_family %||% "sans"
  base_line_size <- base_size / (10 / 0.3)

  # Base theme
  base_theme <- ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_line_size
  )

  # Configuration for our theme
  tick_size <- 4 / 10 * base_size
  text_gray <- "gray25"
  lims_gray <- "gray65"

  # Font scaling
  fs <- function(n) 2**(n / 5)

  new_theme <- base_theme + ggplot2::theme(
    # All text is dark gray
    text = ggplot2::element_text(color = text_gray),
    plot.title = ggplot2::element_text(size = ggplot2::rel(fs(2))),
    plot.subtitle = ggplot2::element_text(size = ggplot2::rel(fs(1))),
    plot.caption = ggplot2::element_text(size = ggplot2::rel(fs(-1))),
    # Titles are padded by the tick size
    axis.title = ggplot2::element_text(size = ggplot2::rel(fs(1))),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = tick_size)),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = tick_size)),
    # Text is padded by 1/2 the tick size
    axis.text = ggplot2::element_text(size = ggplot2::rel(fs(-1))),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = tick_size / 2)),
    axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = tick_size / 2)),
    # Axis lines and ticks are square and light gray
    axis.line = ggplot2::element_line(color = lims_gray, lineend = "square"),
    axis.ticks = ggplot2::element_line(color = lims_gray, lineend = "square"),
    axis.ticks.length = ggplot2::unit(tick_size, "pt"),
    # No grid by default
    panel.grid = ggplot2::element_blank(),
    # Right-justify legend text
    legend.text = ggplot2::element_text(size = ggplot2::rel(fs(-1)), hjust = 1),
    # Facet text is the same size as axis text
    strip.text = ggplot2::element_text(size = ggplot2::rel(fs(-1))),
    # Enforce aspect ratio if requested
    aspect.ratio = aspect
  )

  # Attach profile name to this theme
  attr(new_theme, "eri_theme_profile") <- profile

  new_theme
}
