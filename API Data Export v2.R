rm(list=ls())

# Export Data from API for Each Endpoint

options(stringsAsFactors = FALSE, scipen = 4, digits =8)
#install.packages("splitstackshape")
library(splitstackshape)
library(jsonlite)
library(dplyr)
library(tidyr)
library(data.table)
library(curl)
setwd()

########################################################
# ENDPOINT Account Awards
acc_awardurl <- "https://api.usaspending.gov/api/v1/accounts/awards/?limit=100"
pages <- list()
acc_awardapi <- fromJSON(acc_awardurl, flatten = TRUE)
acc_awardapi$page_metadata$has_next_page=TRUE
i<-1

while(acc_awardapi$pagemetadata$has_next_page=TRUE) {
  acc_awardapi <- fromJSON(paste0(acc_awardurl, "&page=", i), flatten=TRUE)
  message("Retrieving page ",i)
  pages[[i]] <- acc_awardapi$results
  i<-i+1
}

account_awards <- bind_rows(pages)
write.csv(account_awards, file="Raw API Data Export\\Account_awards_data.csv", row.names = FALSE)

########################################################
# ENDPOINT: AWARD DATA

award_url <- "https://api.usaspending.gov/api/v1/awards/?limit=100"
pages <- list()
award_api <- fromJSON(award_url, flatten=TRUE)
award_api$page_metadata$has_next_page=TRUE
i<-1

while(award_api$page_metadata$has_next_page==TRUE){
  award_api <- fromJSON(paste0(award_url, "&page=", i), flatten=TRUE)
  message("Retrieving page ", i)
  pages[[i]] <- award_api$results
  i<-i+1
}

awards_data <- bind_rows(pages)
str(awards_data)

#DATA FRAME INCLUDES COLUMN WITH A LIST, FLATTEN TO WRITE TO CSV
awards_data <- listCol_l(awards_data, "recipient.business_categories")
write.csv(awards_data, file="awards_data.csv", row.names = FALSE)

########################################################
# ENDPOINT: Federal Accounts
fedacct_url <- "https://api.usaspending.gov/api/v1/federal_accounts/?limit=100"
pages<- list()
fedacct_api <- fromJSON(fedacct_url, flatten=TRUE)
fedacct_api$page_metadata$has_next_page=TRUE
i<-1

while(fedacct_api$page_metadata$has_next_page==TRUE){
  fedacct_api <- fromJSON(paste0(fedacct_url, "&page=", i), flatten=TRUE)
  message("Retrieving page ", i)
  pages[[i]] <- fedacct_api$results
  i<-i+1
}

fedacct_data <- bind_rows(pages)
names(fedacct_data)
write.csv(fedacct_data, file="federalaccount_data.csv", row.names = FALSE)

########################################################
# ENDPOINT: TAS - Treasury Appropriation Symbol (TAS) 

tas_url <- "https://api.usaspending.gov/api/v1/tas/?limit=100"
pages <-list()
tas_api <- fromJSON(tas_url, flatten=TRUE)
tas_api$page_metadata$has_next_page=TRUE
i<-1

while(tas_api$page_metadata$has_next_page==TRUE){
  tas_api <- fromJSON(paste0(tas_url, "&page=", i),flatten = TRUE)
  message("Retrieving Page ", i)
  pages[[i]]<- tas_api$results
  i<-i+1
}

tas_data <- bind_rows(pages)
names(tas_data)
write.csv(tas_data, file="tas_data.csv", row.names = FALSE)

########################################################
# ENDPOINT: SubAward Data

sub_url <- "https://api.usaspending.gov/api/v1/subawards/?limit=100"
pages <- list()
sub_api <- fromJSON(sub_url, flatten =TRUE)
sub_api$page_metadata$has_next_page=TRUE
i<-1

while(sub_api$page_metadata$has_next_page==TRUE){
  sub_api <- fromJSON(paste0(sub_url, "&page=", i), flatten = TRUE)
  message("Retrieving Page ", i)
  pages[[i]]<- sub_api$results
  i<- i+1
}

subaward_data <- bind_rows(pages)
names(sub_data)
str(sub_data)
subaward_data2 <- listCol_l(subaward_data, "recipient.business_categories")
write.csv(subaward_data2, file="Subaward_data.csv", row.names = FALSE)
rm(sub_data, subaward_data)

########################################################
# ENDPOINT: Transactions Data
transact_url <- "https://api.usaspending.gov/api/v1/transactions/?limit=100"
pages <- list()
transact_api <- fromJSON(transact_url, flatten = TRUE)
transact_api$page_metadata$has_next_page=TRUE
i<-1

while(transact_api$page_metadata$has_next_page==TRUE){
  transact_api <- fromJSON(paste0(transact_url, "&page=", i), flatten=TRUE)
  message("Retrieving Page", i)
  pages[[i]]<- transact_api$results
  i<- i+1
}

transact_data <- bind_rows(pages)
str(transact_data)
transact_data <- unnest(transact_data, recipient.business_categories)
write.csv(transact_data, file="Transaction_Data.csv", row.names = FALSE)

########################################################
# ENDPOINT: References Data

ref_url <- "https://api.usaspending.gov/api/v1/references/agency/"
pages <- list()
ref_api <- fromJSON(ref_url, flatten = TRUE)
ref_api$page_metadata$has_next_page=TRUE
i<- 1

while(ref_api$page_metadata$has_next_page==TRUE){
  ref_api <- fromJSON(paste0(ref_url, "&page=", i), flatten = TRUE)
  message("Retrieving Page ", i)
  pages[[i]] <- ref_api$results
  i<- i+1
}

ref_data <- bind_rows(pages)
str(ref_data)
write.csv(ref_data, file="Reference_Data.csv", row.names = FALSE)
