# Custom ggplot object creation

#' Create a new ggplot object
#'
#' Initializes a new `ggplot` object, prepending the class
#' `"eri_ggplot"`. This provides a hook for setting new styles.
#'
#' @inheritParams ggplot2::ggplot
#' @export
#' @examples
#' \dontrun{
#' library(eriplots)
#'
#' eriplot(mtcars, aes(hp, mpg)) +
#'   geom_point()
#' }
eriplot <- function(data = NULL, mapping = ggplot2::aes(), ...) {
  p <- ggplot2::ggplot(data = data, mapping = mapping, ...)
  class(p) <- c("eri_ggplot", class(p))
  p
}

#' Build a customized ggplot object
#' @inheritParams ggplot2::ggplot_build
#' @exportS3Method ggplot2::ggplot_build
#' @keywords internal
ggplot_build.eri_ggplot <- function(plot) {
  class(plot) <- setdiff(class(plot), "eri_ggplot")

  if (getOption("eriplots.eriplot.format_minus_signs", FALSE)) {
    plot <- plot + format_minus_signs()
  }

  # Apply the theme when three conditions are met:
  # 1. No theme was set on this plot by the user
  # 2. The user has not disabled auto-theming
  # 3. The user has not `theme_set()` a non-default theme
  ggplot_global <- get("ggplot_global", envir = asNamespace("ggplot2"))
  chk_no_theme <- is.null(plot$theme) || identical(plot$theme, list())
  chk_apply <- getOption("eriplots.eriplot.theme.apply_eri_theme", FALSE)
  chk_default <- identical(ggplot_global$theme_current, ggplot_global$theme_default)

  if (chk_no_theme && chk_apply && chk_default) {
    prof <- getOption("eriplots.eriplot.theme.default_profile", "none")
    plot <- plot + theme_eri(profile = prof)
  }

  # Render and present
  built <- NextMethod()
  class(built) <- c("eri_ggplot_built", class(built))

  built
}
