library(rvest)
library(dplyr)
library(tidyr)

pp <- read.csv("https://docs.google.com/spreadsheets/d/1eO93U2BrSsbzSM1nmhVWVixEI-KuGUmn4eamR1kU-pI/pub?output=csv", stringsAsFactors=F)


for (x in 1:nrow(pp)) {
  state_abbr <- pp$state[x]
  print(state_abbr)
  pp_url_old <- pp$old[x]
  pp_url_now <- pp$now[x]
  
  
  address_old <- read_html(pp_url_old) %>%
    html_nodes("#content #main-content section section article article article div h4") %>%
    html_text() %>%
    as.data.frame()
  
  colnames(address_old) <- "all"
  address_old <- filter(address_old, all!="Get Directions From:")
  
  
  state_abbr_add <- paste0(", ", state_abbr)
  
  address_old$category <- ""
  
  for (i in 1:nrow(address_old)) {
    address_old$category[i] <- ifelse(grepl("p: ", address_old$all[i]), "phone", address_old$category[i])
    address_old$category[i] <- ifelse(grepl("f: ", address_old$all[i]), "fax", address_old$category[i])
    address_old$category[i] <- ifelse(grepl(state_abbr_add, address_old$all[i]), "address_old2", address_old$category[i])
  }
  address_old$category <- ifelse(address_old$category=="", "address_old1", address_old$category)
  
  for (i in 2:nrow(address_old)) {
    if (address_old$category[i]==address_old$category[i-1]) {
      address_old$category[i] <- "address_old1.5"
    }
    
  }
  
  address_old$id <- ""
  
  for (i in 1:nrow(address_old)) {
    if (i ==1) {
      identifier <- paste0(as.character(address_old$all[i]), "--1")
    }
    address_old$id[i] <- identifier
    
    if (grepl("f: ", address_old$all[i])) {
      identifier <- paste0(as.character(address_old$all[i+1]), "--",i)
    }
    
  }
  
  address_old <- spread(address_old, category, all)
  
  ##
  
  address_now <- read_html(pp_url_now) %>%
    html_nodes("#content #main-content section section article article article div h4") %>%
    html_text() %>%
    as.data.frame()
  
  colnames(address_now) <- "all"
  address_now <- filter(address_now, all!="Get Directions From:")
  
  
  state_abbr_add <- paste0(", ", state_abbr)
  
  address_now$category <- ""
  
  for (i in 1:nrow(address_now)) {
    address_now$category[i] <- ifelse(grepl("p: ", address_now$all[i]), "phone", address_now$category[i])
    address_now$category[i] <- ifelse(grepl("f: ", address_now$all[i]), "fax", address_now$category[i])
    address_now$category[i] <- ifelse(grepl(state_abbr_add, address_now$all[i]), "address_now2", address_now$category[i])
  }
  address_now$category <- ifelse(address_now$category=="", "address_now1", address_now$category)
  
  for (i in 2:nrow(address_now)) {
    if (address_now$category[i]==address_now$category[i-1]) {
      address_now$category[i] <- "address_now1.5"
    }
    
  }
  
  address_now$id <- ""
  
  for (i in 1:nrow(address_now)) {
    if (i ==1) {
      identifier <- paste0(as.character(address_now$all[i]), "--1")
    }
    address_now$id[i] <- identifier
    
    if (grepl("f: ", address_now$all[i])) {
      identifier <- paste0(as.character(address_now$all[i+1]), "--",i)
    }
    
  }
  
  address_now <- spread(address_now, category, all)
  
  address_old$state <- state_abbr
  address_now$state <- state_abbr
  
  if (ncol(address_old)!=7) {
    address_old$address_old1.5 <- ""
  }

  address_old <- address_old[c("id", "address_old1", "address_old1.5", "address_old2", "fax", "phone", "state")]
  
  if (ncol(address_now)!=7) {
    address_now$address_now1.5 <- ""
  }
  
  address_now <- address_now[c("id", "address_now1", "address_now1.5", "address_now2", "fax", "phone", "state")]
  
  
    
  if (x==1) {
    address_old_all <- address_old
    address_now_all <- address_now
  } else {
    address_old_all <- rbind(address_old_all, address_old)
    address_now_all <- rbind(address_now_all, address_now)
    
  }
  
}


address_now_all$id2 <- gsub("--.*", "", address_now_all$id)
address_now_all <- address_now_all[!duplicated(address_now_all$id2),]

address_old_all$id2 <- gsub("--.*", "", address_old_all$id)
address_old_all <- address_old_all[!duplicated(address_old_all$id2),]

states_now <- address_now_all %>%
  group_by(state) %>%
  summarize(count_now=n())

states_then <- address_old_all %>%
  group_by(state) %>%
  summarize(count_then=n())

states_now_then <- left_join(states_now, states_then)
states_now_then$diff <- states_now_then$count_now-states_now_then$count_then
