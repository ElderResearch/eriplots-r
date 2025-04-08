# eriplots: Simple Plotting Utilities for R

The *[eriplots][]* library for R makes it a little easier to
create clean, client-ready figures using [ggplot2][] and base R
graphics, inspired by *[Trees, maps, and theorems][tmth]* among
others.

[eriplots]: https://github.com/ElderResearch/eriplots-r
[ggplot2]: https://ggplot2.tidyverse.org/
[tmth]: https://www.principiae.be/X0100.php

## Installation

The package can be installed directly from GitHub using the
_[remotes][]_ package:

```r
# Install remotes if we haven't already
install.packages("remotes")

# Install eriplots
remotes::install_github("ElderResearch/eriplots-r")
```

[remotes]: https://remotes.r-lib.org/

## Features

The library's utilities are organized along four directions:

1. Simple plot styles and themes for _ggplot2_ and base R
2. Multi-format figure saving with automatic PNG compression
3. ERI-branded color palettes and scales

### Plot Styling

The _eriplots_ package provides customizable themes that support
two "profiles" for common scenarios:

1. **document**: 10 pt base type, 4.5 in × 2.5 in figure at 300 DPI
2. **presentation**: 20 pt base type, 7 in × 4 in figure at 300 DPI

If no profile is selected, a default text size is selected for
interactive work. This theme applies a clean style with
consistent spacing, reduced visual noise, and harmonically-scaled
text elements.

```r
library(eriplots)
library(ggplot2)

# Use directly
p <- ggplot(mtcars, aes(mpg, wt)) + 
  geom_point() +
  theme_eri(profile = "document")

# Or set globally
theme_set(theme_eri(base_size = 11))
```

The package also provides the function `eriplot()`, which creates
a `ggplot` object and attaches a couple of style changes:

1. `theme_eri()` is automatically attached
2. Minus signs are fixed with `format_minus_signs()`

If standard _ggplot2_ is preferred, these adjustments can be
added through the usual compositional methods:

```r
# Use eriplot() to set theme and adjust formatting
eriplot(example, aes(cty, manufacturer, fill = cty)) +
  geom_col(color = "gray10") +
  scale_fill_viridis_c()

# Or use ggplot(), adding new layers manually
ggplot(example, aes(cty, manufacturer, fill = cty)) +
  geom_col(color = "gray10") +
  scale_fill_viridis_c() +
  format_minus_signs() +
  theme_eri()
```

### Multi-Format Figures

The _eriplots_ library provides functions to save figures in
multiple formats with automatic PNG compression when available.

```r
# Save in multiple formats (PNG and PDF by default)
save_figures(p, "plot")

# Specify formats
save_figures(p, "plot", formats = c("png", "pdf"))

# Disable PNG optimization
save_figures(p, "plot", optimize = FALSE)
```

### Colors and Scales

Finally, the package provides ERI-branded color palettes and
scales for both _ggplot2_ and base R graphics.

```r
# Get specific colors by name
eri_colors("mediumblue", "darkred")  # "#005E7B" "#D0073A"

# Create a palette with transparency
transparent_colors <- eri_palette(5, alpha = 0.5)

# Use in ggplot2
ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
  geom_point() +
  scale_color_manual(values = eri_palette(3))
```

## Contributing

We welcome contributions, both by raising issues and submitting pull requests!

## License

The _eriplots_ library is licensed under the GPL 3 or later
([LICENSE.md](./LICENSE.md) or
<https://www.gnu.org/licenses/gpl-3.0.html>).
