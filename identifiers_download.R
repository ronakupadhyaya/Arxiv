library(OAIHarvester)
library(xml2)

get_info <- function(paper) {
  paper$identifier
}

get_identifiers <- function(baseurl, prefix, set) {
  rec <- oaih_list_identifiers(baseurl, prefix = prefix, set = set)
  identifiers <- apply(rec, 1, get_info)
  
  write.table(identifiers,"identifiers.txt", row.names=FALSE, col.names = FALSE)
}

baseurl <- "http://export.arxiv.org/oai2"
prefix <- "arXiv"
set <- "stat"

get_identifiers(baseurl, prefix, set)


