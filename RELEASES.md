# Release Checklist

_On the `develop` branch._

### Preamble

- [ ] Confirm that CI checks pass

### Version and news

- [ ] Bump version with `usethis::use_version()`
- [ ] Check that NEWS.md is current
- [ ] Change the development version heading to the new version

### Merge to `main`

- [ ] Commit and push the new version number and change log
- [ ] PR and merge into `main`

### Tag and release

- [ ] `git tag -s -a X.Y.Z`
- [ ] Use "Version X.Y.Z" for the tag title
- [ ] Use the change log for the contents
- [ ] Push tag to `main`
- [ ] Cut a release on GitHub with change log contents

### Update `develop`

- [ ] Merge `main` into `develop`
- [ ] Bump dev version with `usethis::use_dev_version()`
