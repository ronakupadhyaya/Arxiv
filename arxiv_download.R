library(OAIHarvester)
library(xml2)

# NOTE: If I ever rerun this, I might want to address cases like these:
# https://arxiv.org/abs/1512.01408
# https://arxiv.org/abs/1710.04350
# https://arxiv.org/abs/1501.02315
# https://arxiv.org/abs/1408.4438
# ...in which someone wrote First (AltFirst)Last for their name.

get_info <- function(paper) {
  # extract from the xml_node the information we want
  info <- as_list(paper$metadata)
  list(id = info$id[[1]],
       title = info$title[[1]],
       categories = info$categories[[1]],
       authors = first_last(info$authors))
}

first_last <- function(authors) {
  as.character(lapply(authors, 
                      function(a) paste(a$forenames, a$keyname)))
}

arxiv <- "http://export.arxiv.org/oai2"

dates <- seq(as.Date("2012/1/1"), as.Date("2019/6/15"), by = 15)
#papers <- vector("list", length(dates) - 1)
for (i in seq(length(dates) - 1)) {
  # download from arxiv in 15 day increments
  # and wait 25 seconds between requests so arxiv doesn't block
  # us.
  cat(i, dates[i], fill = TRUE)
  rec <- oaih_list_records(arxiv,
                           prefix="arXiv",
                           from = as.character(dates[i]),
                           until = dates[i + 1] - 1,
                           set = "stat")
  #papers[[i]] <- apply(rec, 1, get_info)
  papers <- list()
  papers[[as.character(dates[i])]] <- apply(rec, 1, get_info)
  save(papers, file = sprintf("downloaded/%s.Rdata", i))
  Sys.sleep(25)
}

#save(papers, file = sprintf("%s_to_%s", dates[1], dates[length(dates)]))
