# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not an R package**, despite looking like one. It is the content + build tooling for the
Gallery page of the [pkgnet website](https://uptake.github.io/pkgnet/). It lives apart from the
[main pkgnet repo](https://github.com/uptake/pkgnet) so the gallery can be updated independently of
CRAN releases and so the pkgnet repo stays small.

`DESCRIPTION`, `vignettes/`, and `_pkgdown.yml` exist only because pkgdown expects an R-package
layout. `DESCRIPTION` is a copy of pkgnet's manifest used to make pkgdown happy — CI rewrites its
`Version:` line to match the latest `v*.*.*` tag on `uptake/pkgnet`. There is no `R/` directory, no
`man/`, and no test suite; the two top-level `.R` files are standalone scripts, not package code.

## Build the gallery page

```console
Rscript pkgnet_build_gallery.R
```

`pkgnet_build_gallery.R` runs `pkgdown::clean_site()` + `pkgdown::build_articles()`, then
post-processes `docs/articles/pkgnet-gallery.html`: every relative `../` path *except* those under
`../articles/` is rewritten to absolute `https://uptake.github.io/pkgnet` URLs. That rewrite is
load-bearing — without it the pkgnet logo link and CSS/JS references break, because this page is
served from a different site than the rest of the pkgnet docs. Requires `pkgdown`, `glue`,
`assertthat`, `rmarkdown`, `knitr`.

`.gitignore` ignores all of `docs/` except `docs/articles/pkgnet-gallery.html` — that single file is
the only build output that gets committed.

To sanity-check the vignette alone without a full pkgdown build, knit
`vignettes/pkgnet-gallery.Rmd` (RStudio "Knit", or `rmarkdown::render()`). Its `assertthat` checks
are the closest thing to a test in this repo: they fail the knit if any exhibit entry is not a list,
is missing one of `package_name` / `report_url` / `image_url`, or has a non-character value.

## Create an exhibit

```console
Rscript create_exhibit.R -o exhibits <package name>        # package must be installed
Rscript create_exhibit.R -o exhibits -p <path/to/pkg> <pkg>  # adds code coverage via covr
Rscript create_exhibit.R -h
```

Produces `<pkg>.html` (the pkgnet report) and `<pkg>.png` (a webshot of the FunctionReporter
network) via `pkgnet::CreatePackageReport` + `visNetwork::visSave` + `webshot::webshot`. Needs
`optparse`, `pkgnet`, `visNetwork`, `webshot`, and a working PhantomJS
(`webshot::install_phantomjs()`); the script errors explicitly if the PNG is missing.

Note the script writes to `<output_folder>/<pkg>_pkgnet_exhibit/`, but committed exhibits live in
`exhibits/<pkg>/` (with `.` replaced by `_`, e.g. `exhibits/data_table/`). Rename the directory when
adding a new exhibit so it matches the existing convention and the URLs in the vignette.

## Adding an exhibit to the gallery

The gallery grid is generated in `vignettes/pkgnet-gallery.Rmd` from `exhibitsList`. Append a new
`list(package_name=, report_url=, image_url=)` entry immediately above the
`### ADD NEW EXHIBITS ABOVE THIS LINE ###` marker, keeping the leading comma style. Ordering in
source does not matter — the Rmd sorts alphabetically by `package_name` and lays cells out three per
row. URLs point at `https://uptake.github.io/pkgnet-gallery/exhibits/...` (self-hosted exhibits
elsewhere are also accepted).

## CI

`.github/workflows/gallery_build.yml` runs on push to `main` and on manual dispatch. It bumps
`DESCRIPTION`'s version to the latest pkgnet tag, builds the gallery, uploads `docs/` as an
artifact, and force-pushes the result to a `website_docs_update` branch for review by PR — it never
commits to `main` directly. Two existing quirks to be aware of if you touch it: `latestVersion` is a
plain shell variable that is never written to `$GITHUB_OUTPUT`, so
`steps.latesttag.outputs.latestVersion` (and `steps.previoustag.outputs.tag` in the commit message)
resolve to empty, and the version-lookup step uses GNU `tail --lines=1`/`sed -i -E` while the job
runs on `macos-latest`.
