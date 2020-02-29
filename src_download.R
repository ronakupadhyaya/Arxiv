library(OAIHarvester)
library(xml2)

download_file <- function(baseurl, identifier) {
  download.file(paste0(baseurl, identifier), destfile = sprintf("Documents/R/src_files/%s.gz", identifier), mode="wb")
}

load_identifiers <- function(baseurl) {
  table <- read.csv("Documents/R/identifiers.txt")
  identifiers <- as.list(levels(table$identifiers))
  for(i in seq(length(identifiers))) {
    if(i%%4 == 0) {
      Sys.sleep(1)
    }
    download_file(baseurl, gsub(".*:", "", identifiers[[i]]))
  }
}

baseurl <- "https://arxiv.org/e-print/"

load_identifiers(baseurl)


