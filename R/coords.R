# Custom coordinates

#' Cartesian coordinates with capped axes
#'
#' A wrapper around [lemon::coord_capped_cart()] creating a Cartesian
#' coordinate system with capped left and bottom axis lines by default.
#'
#' @inheritParams lemon::coord_capped_cart
#'
#' @return A coordinate system object that can be added to a ggplot object.
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' ggplot(mtcars, aes(hp, mpg)) +
#'   geom_point() +
#'   coord_capped_cart()
#' }
coord_capped_cart <- function(
    xlim = NULL,
    ylim = NULL,
    expand = TRUE,
    top = NULL,
    left = "both",
    bottom = "both",
    right = NULL,
    gap = 0.01) {
  # Pass any not-null values to lemon
  args <- mget(names(formals()), envir = environment(), ifnotfound = NA)
  args <- Filter(Negate(is.null), args)

  do.call(lemon::coord_capped_cart, args)
}
