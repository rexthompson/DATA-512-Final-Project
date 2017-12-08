# TEMP FILE -- this is just for troubleshooting for other missing data
# NOTE: Don't worry too much about formatting, etc...

setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")
source("../../R/cleanData.R")

# merge function
library(dplyr)
mergeData <- function(transactions, blockface) {
  output <- left_join(transactions, blockface, by="ElementKey") %>%
    filter((TransactionDateTime >= EffectiveStartDate) & TransactionDateTime < pmin(today(), EffectiveEndDate, na.rm = TRUE))
}

# pull out different subsets for merge review
# trans_temp <- transactions[transactions$UserNumber==5,]

set.seed(2405)
trans_temp <- sample_n(transactions, 50000)
# trans_temp <- sample_n(transactions, 500000)
rm(transactions)
# NOTE: ~ 500,000 will result in merged .csv files of ~138 MB -- about right if working on redshift

500000/nrow(transactions)

# # export by month
# for (yr in 2012:2017) {
#   for (mo in 1:12) {
#     print(paste0(yr, "-", mo, ": ", sum(transactions$TransactionYear==yr & transactions$TransactionMonth==mo)))
#   }
# }

# merge
dim(trans_temp)
mergedDF <- mergeData(trans_temp, blockface)
dim(mergedDF)
round(mergedDF$Amount/mergedDF$Duration_mins*60,3)
View(mergedDF)

write_csv(mergedDF, "sampleMerge2.csv", na = "")

# trans_temp <- transactions[transactions$Amount>25,] # high amounts

# sum(transactions$PaymentMean=="PHONE", na.rm = TRUE)

# subset by blockface or even by meter to view records with surrounding values...

# tmp <- transactions[transactions$MeterCode==6015002,] # careful with this one, it can bog the system down
# tmp <- transactions[transactions$ElementKey==77990,]
# dim(tmp)
# View(tmp)








########################
###### OTHER MISC ######
########################


#### EDA FOR DATA CLEANING

# find outrageous prices
high_prices <- transactions[transactions$Amount > 25, ]
hist(high_prices$TransactionDateTime, breaks="months")

hist(transactions$TransactionDateTime, breaks = "years", start.on.monday = FALSE)


tmp <- read_csv("transactions_by_week/ParkingTransaction_20120617_20120623.csv",
                col_types = col_types_tsxn,
                na="NULL")

tmp2 <- read_csv("transactions_by_week/ParkingTransaction_20120115_20120121.csv",
                 col_types = col_types_tsxn,
                 na="NULL")


hist(tmp$TransactionDateTime, breaks = "hours", freq=TRUE)
hist(tmp2$TransactionDateTime, breaks = "hours", freq=TRUE)

hist(tmp2$TransactionDateTime[lubridate::date(tmp2$TransactionDateTime)=="2012-01-17"], breaks="hours")


# the following might show the bad transaction...to remove...
transactions[148068:148080]
# 176694,12131002,14824592,01/07/2012 03:08:59,166.84,1,COINS,7200,63125,2012,1,
# 176695,12131002,14824840,01/07/2012 03:12:59,.75,1,Credit Card,1800,63125,2012,1,

# identify import errors by file (check column type consistency)

setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")

i <- 0
for (f in list.files("transactions_by_week/")) {
  i <- i+1
  print(paste0(i, ": ", f))
  temp <- readr::read_csv(paste0("transactions_by_week/", f),
                          col_types = col_types,
                          na="NULL")
}









#### Check that all transaction dates will have a valid effective date range

# # get minimum EffectiveStartDate and TransactionDate for each blockface
# # NOTE: this takes a little while to run on the full dataset
# library(sqldf)
# min_bfc <- sqldf("SELECT ElementKey, min(EffectiveStartDate) FROM blockface GROUP BY ElementKey")
# min_tsx <- sqldf("SELECT ElementKey, min(TransactionDateTime) FROM transactions GROUP BY ElementKey")
# min_bfc$`min(EffectiveStartDate)` <- as.Date(min_bfc$`min(EffectiveStartDate)`, origin = "1970-01-01")
# min_tsx$`min(TransactionDateTime)` <- as.POSIXct(min_tsx$`min(TransactionDateTime)`, origin = "1970-01-01", tz="UTC")
# test <- merge(min_bfc, min_tsx, "ElementKey")
# test$bad <- test$`min(TransactionDateTime)` < test$`min(EffectiveStartDate)`
# sum(test$bad)


# import transaction data
# import blockface data

# TEMP
# trans_temp <- transactions[,c("ElementKey", "TransactionDateTime")] # "DataId",
# block_temp <- blockface[,c("ElementKey", "EffectiveStartDate", "EffectiveEndDate")]

# trans_temp <- transactions
# block_temp <- blockface

# rm(transactions)
# rm(blockface)

# trans_temp <- tail(trans_temp, 625771)


# # below returns all merged values BEFORE removing blockface records w/ non-applicable effective dates
# mergeData2 <- function(transactions, blockface) {
#   output <- left_join(transactions, blockface, by="ElementKey")# %>%
#     # filter((TransactionDateTime >= EffectiveStartDate) & TransactionDateTime < pmin(today(), EffectiveEndDate, na.rm = TRUE))
# }

# mergedDF_alldata <- mergeData2(trans_temp, block_temp)

# # BOOM!!! Confirmed that all TransactionDateTime values have a corresponding Effective Time!!!! WOHOO!!
# dim(trans_temp)
# dim(mergedDF_filtered)
# dim(trans_temp)[1]-dim(mergedDF_filtered)[1]
# 
# rejected <- trans_temp[!(trans_temp$DataId %in% mergedDF_filtered$DataId),]
# dim(rejected)
# View(rejected)
# 
# View(mergedDF_alldata[mergedDF_alldata$DataId==11675617,])
# View(mergedDF_filtered[mergedDF_filtered$DataId==11675617,])