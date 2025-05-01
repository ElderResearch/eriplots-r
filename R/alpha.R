#' Calculate alpha levels for stacked plot components.
#'
#' This function calculates alpha (opacity) values for plot components
#' so that when n layers are stacked they have overall alpha = max_opacity.
#'
#' @param n  Target number of stacked layers.
#' @param max_opacity The maximum opacity value at n (default: 0.85).
#'
#' @return The per-layer alpha value.
#'
#' @examples
#' # Calculate alpha for 5 elements with default max opacity
#' alpha(5)
#'
#' # Calculate alpha for 10 elements with custom max opacity
#' alpha(10, max_opacity = 0.7)
#'
#' @export
alpha <- function(n, max_opacity = 0.85) {
  if (n < 1) {
    stop("n must be positive")
  }
  if (max_opacity < 0 || max_opacity > 1) {
    stop("max_opacity must be between 0 and 1")
  }
  1 - (1 - max_opacity)^(1 / n)
}
