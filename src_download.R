library(OAIHarvester)
library(xml2)

download_file <- function(baseurl, identifier) {
  download.file(paste0(baseurl, identifier), destfile = sprintf("Documents/R/src_files/%s.gz", identifier), mode="wb")
}

load_identifiers <- function(baseurl) {
  skip <- FALSE
  table <- read.csv("Documents/R/modified_identifiers.txt")
  identifiers <- as.list(levels(table$identifiers))
  for(i in seq(length(identifiers))) {
    # if(i%%4 == 0) {
    #   Sys.sleep(1)
    # }
    if(identical(identifiers[[i]], "oai:arXiv.org:1302.3446")) {
      break
    }
    tryCatch(
      download_file(baseurl, gsub(".*:", "", identifiers[[i]])),
      error = function(e) {
        skip = TRUE
      }
    )
    if(skip) {
      next
    }
  }
}

baseurl <- "https://export.arxiv.org/e-print/"

load_identifiers(baseurl)


