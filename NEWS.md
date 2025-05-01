# eriplots 0.1.2

## Added

- `alpha(n, max_opacity=0.85)` computes layer opacities such that n
  layers stack with a cumulative `max_opacity`.
- New `set_default_profile()` function changes the option
  `eriplots.eriplot.theme.default_profile` so that all plots in the
  same session use this profile.

## Changed

- `save_figures()` correctly inherits the current plot theme, either
  set via `options()`, `theme_eri()`, or `set_default_theme()`.

# eriplots 0.1.1

## Added

- CI pipeline to run `R CMD CHECK`, lint, and report test coverage

# eriplots 0.1.0

First package release!

## Added

- A version of *lemon*'s `coord_capped_cart()` that caps the left and
  bottom axes by default
- A function, `eriplot()` that sets theme styles by default and allows
  us to patch into plots directly
- `fix_minus_signs()` and its "addable" sibling `format_minus_signs()`
  patch `ggplot` objects to use proper minus signs in continuous
  situations
- `eri_colors()` and `eri_palette()` provide direct access to ERI
  theme colors and a palette-like object
- `theme_eri()` give a clean theme with customizable sizes. It also
  supports two profiles ("document" and "presentation") that set
  reasonable sizes for common cases
