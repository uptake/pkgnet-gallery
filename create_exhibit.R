#!/usr/bin/env Rscript
# Copyright 2019 Uptake Technologies Inc.
#   
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#   
#   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
#   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
#   3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## PACKAGES ####
library("optparse")
library("pkgnet")
library("visNetwork")
library("webshot")

option_list <- list( 
  make_option(c("-o","--output_folder")
              , default = getwd()
              , type = "character"
              , dest = "outputFolder"
              , help = "(String) The path to the folder in which to create the exhibit [default is the current working directory]."
  )
  , make_option(c("-p","--package_path")
                , default = NULL
                , type = "character"
                , dest = "pkgPath"
                , help = "(String) The path to the R package directory if downloaded."
  )
  , make_option(c("-i","--inheritance_reporter")
                , action = "store_true"
                , default = FALSE
                , dest = "inheritanceReporterInd"
                , help = "Include inheritance reporter in report"
  )
)

parser <- OptionParser(usage = "%prog [options] package_name"
                       , description = "\nCreate an exhibit for the pkgnet gallery."
                       , option_list=option_list
                       , epilogue = paste0("Submit your exhibit via pull request to the pkgnet gallery at:\n"
                                           , "https://github.com/uptake/pkgnet-gallery"
                                           , '\n')
                       )

arguments <- parse_args(parser, positional_arguments = 1)
opt <- arguments$options
package_name <- arguments$args

## create directory path ##
outDir <- file.path(opt$outputFolder
                    , paste0(package_name,'_pkgnet_exhibit')
)

# The directory itself will be created during pkgnet::CreatePackageReport

## CREATE REPORT ##
Sys.setenv(PKGNET_SUPPRESS_BROWSER = TRUE) # open report after checks

reportPath <- file.path(outDir
                        , paste0(package_name,'.html')
)

if(opt$inheritanceReporterInd == TRUE){
  reporterList <- c(pkgnet::DefaultReporters()
                    , pkgnet::InheritanceReporter$new()
                    )
} else {
  reporterList <- pkgnet::DefaultReporters()
}


if (is.null(opt$pkgPath)){
  # report without covr
  t <- pkgnet::CreatePackageReport(pkg_name = package_name
                                   , report_path = reportPath
                                   , pkg_reporters = reporterList
  )
} else {
  # report with covr
  t <- pkgnet::CreatePackageReport(pkg_name = package_name
                                   , report_path = reportPath
                                   , pkg_reporters = reporterList
                                   , pkg_path = opt$pkgPath
  )
}

## CreatePackageReport should error out if report is not created.

Sys.unsetenv('PKGNET_SUPPRESS_BROWSER')

## CREATE IMAGE ##
pkgnet:::log_info("Creating exhibit image...")
tempReport <- tempfile(fileext = ".html")
imagePath <- file.path(outDir
                       , paste0(package_name,'.png')
)

# Delete Previous Image If Exists
if(file.exists(imagePath)){
  resultVal <- file.remove(imagePath) # passed to variable to suppress TRUE
}

visNetwork::visSave(t$FunctionReporter$graph_viz
                    , file = tempReport
                    , selfcontained = TRUE)

webshot::webshot(url = tempReport
                              , file = imagePath
                              , selector = '.vis-network'
                              , vwidth = 177
)

resultVal <- file.remove(tempReport) # passed to variable to suppress TRUE

## CONFIRM IMAGE IS CREATED ##
# Due to phantomJS install issues that webshot handles, this is necessary.

if (file.exists(imagePath)){
  pkgnet:::log_info(sprintf("Exhibit image successfully created! It is available at %s"
                            , imagePath
                            )
                    )
  
  utils::browseURL(reportPath)
  
} else {
  msg <- paste0('Unforunately, there was an issue creating the gallery image.\n'
                , 'It may be due to a PhantomJS installation issue.\n'
                , 'Run webshot::install_phantomjs() to install PhantomJS.\n'
                , 'See ?webshot::install_phantomjs for more details.')
  
  stop(msg)
}



