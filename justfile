
_list:
  @just --list

# Run devtools::check()
check:
  #!/usr/bin/env Rscript
  devtools::check()

# Run devtools::test()
test:
  #!/usr/bin/env Rscript
  devtools::test()

# Run devtools::build()
build:
  #!/usr/bin/env Rscript
  devtools::build()

# Run lintr::lint_package()
lint:
  #!/usr/bin/env Rscript
  pkgload::load_all()
  lintr::lint_package()

# Run devtools::document()
document:
  #!/usr/bin/env Rscript
  devtools::document()
