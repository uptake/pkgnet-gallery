library(pkgdown)
library(glue)
library(assertthat)
library(rmarkdown)
library(knitr)

##################################################
# This script builds the gallery with pkgdown
# and then replaces relative paths.  If this is 
# not done, the pkgnet logo link will break and 
# the heading spacing will be off. 
##################################################

#### Default pkgdown build ####

pkgdown::clean_site(force = TRUE)
pkgdown::build_articles(lazy = FALSE)


#### Tweek Paths for CSS, JS, and pkgnet icon paths ######


## Read Page
htmlText <- readLines('./docs/articles/pkgnet-gallery.html')

## Find Lines to Replace
relativePathIx <- grep('(\\.){2}', htmlText)
articlesIx <- grep('(\\.){2}(/articles)', htmlText)
replaceIx <- setdiff(relativePathIx, articlesIx)

## Replace them
htmlText[replaceIx] <- gsub(pattern = '(\\.){2}'
                            , replacement = 'https://uptake.github.io/pkgnet'
                            , x = htmlText[replaceIx]
                            )

## Rebuild Page
writeLines(htmlText, './docs/articles/pkgnet-gallery.html')
