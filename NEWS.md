# eriplots (development version)

# eriplots 0.1.0

First package release!

## Added

- A version of *[lemon][]*'s `coord_capped_cart()` that caps the
  left and bottom axes by default
- A function, `eriplot()` that sets theme styles by default and
  allows us to patch into plots directly
- `fix_minus_signs()` and its "addable" sibling
  `format_minus_signs()` patch `ggplot` objects to use proper
  minus signs in continuous situations
- `eri_colors()` and `eri_palette()` provide direct access to ERI
  theme colors and a palette-like object
- `theme_eri()` give a clean theme with customizable sizes. It
  also supports two profiles ("document" and "presentation") that
  set reasonable sizes for common cases

[lemon]: https://github.com/stefanedwards/lemon
