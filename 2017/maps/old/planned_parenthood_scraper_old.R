
## OLD CODE BELOW
texas_now <- "http://www.plannedparenthood.org/health-center/TX"
texas_old <- "https://web.archive.org/web/20140721121025/http://www.plannedparenthood.org/health-center/TX"

state_abbr <- "TX"

clinics <- read_html(texas_old) %>%
  html_nodes("#content #main-content section section article h3 a") %>%
  html_text() %>%
  as.data.frame()

colnames(clinics) <- "name"

address <- read_html(texas_old) %>%
  html_nodes("#content #main-content section section article article article div h4") %>%
  html_text() %>%
  as.data.frame()

colnames(address) <- "all"
address <- filter(address, all!="Get Directions From:")


state_abbr_add <- paste0(", ", state_abbr)

address$category <- ""

for (i in 1:nrow(address)) {
  address$category[i] <- ifelse(grepl("p: ", address$all[i]), "phone", address$category[i])
  address$category[i] <- ifelse(grepl("f: ", address$all[i]), "fax", address$category[i])
  address$category[i] <- ifelse(grepl(state_abbr_add, address$all[i]), "address2", address$category[i])
}
address$category <- ifelse(address$category=="", "address1", address$category)

for (i in 2:nrow(address)) {
  if (address$category[i]==address$category[i-1]) {
    address$category[i] <- "address1.5"
  }
  
}

address$id <- ""

for (i in 1:nrow(address)) {
  if (i ==1) {
    identifier <- paste0(as.character(address$all[i]), "--1")
  }
  address$id[i] <- identifier
  
  if (grepl("f: ", address$all[i])) {
    identifier <- paste0(as.character(address$all[i+1]), "--",i)
  }
  
}

address <- spread(address, category, all)

services <- read_html(texas_now) %>%
  html_nodes("article.services.expandy") %>%
  html_text() %>%
  as.data.frame()
