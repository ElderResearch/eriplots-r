% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/save-figures.R
\name{save_figures}
\alias{save_figures}
\title{Save \link{ggplot2} figures in multiple formats}
\usage{
save_figures(
  destination,
  plot = ggplot2::last_plot(),
  profile = NULL,
  formats = c("png", "pdf"),
  width = NULL,
  height = NULL,
  units = c("in", "cm", "mm", "px"),
  dpi = 300,
  optipng = c("if_available", TRUE, FALSE),
  ...
)
}
\arguments{
\item{destination}{Where the figure(s) should be saved.}

\item{plot}{Plot object to save.}

\item{profile}{Theme profile (defaults to the plot's theme profile or "none").}

\item{formats}{Format(s) to save (default: c("png", "pdf")).}

\item{width}{Plot width (optional, overrides profile settings).}

\item{height}{Plot height (optional, overrides profile settings).}

\item{units}{Dimension units (default: "in").}

\item{dpi}{Resolution for raster formats (PNG, etc.; default: 300).}

\item{optipng}{Optimize PNGs using optipng?}

\item{...}{Additional arguments passed to \code{ggplot2::ggsave}.}
}
\value{
Invisibly returns a vector of paths to the saved files.
}
\description{
Save ggplot2 plots in multiple formats (PNG and PDF by default)
with options for dimension control, optimization, and theme-based
profiles. When available, \code{optipng} is also applied.
}
\examples{
\dontrun{
library(ggplot2)

# Create a simple plot
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point()

# Save in both PNG and PDF formats
save_figures("myplot", p)

# Save with custom dimensions
save_figures("myplot", p, width = 8, height = 6)

# Save only as PDF
save_figures("myplot", p, formats = "pdf")

# Save with a specific theme profile
save_figures("myplot", p, profile = "presentation")
}
}
