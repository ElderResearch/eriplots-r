% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/palettes.R
\name{eri_colors}
\alias{eri_colors}
\title{ERI brand-related colors}
\usage{
eri_colors(..., names = FALSE)
}
\arguments{
\item{...}{Color names or indexes to select. Repetition is allowed.}

\item{names}{Whether to include color names in the output vector.}
}
\value{
A named character vector of hex color codes.
}
\description{
Retrieve one or more colors from the ERI color palette.
If no arguments are provided, returns the entire palette.
}
\examples{
# Get all colors
eri_colors()

# Get specific colors
eri_colors("mediumblue", "darkred")

# Get colors by partial matching
eri_colors("gr", "or")

# Get colors with names
eri_colors("lightblue", "yellow", names = TRUE)

# Repeat colors in output
eri_colors("darkred", "darkred", "lightblue")

# Use named arguments to rename colors in output
eri_colors(primary = "mediumblue", secondary = "darkred")
}
