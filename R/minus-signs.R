# Minus sign fixes for ggplot2
#
# - fix_minus_signs() is the generic operation
# - format_minus_signs() is addable to a ggplot


#' Repair ggplot2's default minus-sign formatting
#'
#' \pkg{ggplot2} applies R's `format()` for continuous scales, meaning negative
#' numbers are formatted with hyphens instead of proper minus signs. This method
#' identifies the continuous scales for which the user has not customizes the labels
#' and fixes them to have proper minus signs.
#'
#' @param plot A ggplot object
#' @param ... Unused
#'
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Apply directly
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
#' format_minus_signs(p)
#'
#' # Apply compositionally
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   format_minus_signs()
#' }
format_minus_signs <- function(plot, ...) {
  UseMethod("format_minus_signs")
}

#' @export
format_minus_signs.ggplot <- function(plot, ...) {
  # Build the plot and assign the built scales to the original.
  # This 'resolves' implicit scales
  built <- ggplot2::ggplot_build(plot)
  plot$scales$scales <- built$plot$scales$scales

  # Replace minus signs in continuous scales when 'labels' aren't set
  for (i in seq_along(plot$scales$scales)) {
    scale <- plot$scales$scales[[i]]

    if (inherits(scale, "ScaleContinuous")) {
      if (inherits(scale$labels, "waiver")) {
        scale$labels <- scales::label_number(style_negative = "minus")
      }
    }
  }

  plot
}

#' @export
format_minus_signs.default <- function(plot, ...) {
  # Sneaky way (via o3 mini, actually) to compose using `+`. When
  # adding with `+`, I think you get NULL as input. So this function
  # returns an empty object of the right type so that at plot-creation
  # time ggplot2 will compose the plot with format_minus_signa.ggplot.
  # See ggplot_add.format_minus_signs() below.
  structure(list(), class = "format_minus_signs")
}

#' Make it possible to add this to ggplot2
#'
#' @inheritParams ggplot2::ggplot_add
#' @exportS3Method ggplot2::ggplot_add
#' @keywords internal
ggplot_add.format_minus_signs <- function(object, plot, object_name) {
  format_minus_signs(plot)
}
