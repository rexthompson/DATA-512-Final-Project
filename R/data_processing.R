########################################################################
###### LOOK INTO PEAK TIME VIOLATIONS -- use sample merge for now ######
########################################################################

setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")
merged_raw <- read_csv("sampleMerge2.csv")
merged <- merged_raw
# View(merged)

# add transaction time column
# merged$timeStart <- paste(sprintf("%02d", hour(merged$TransactionDateTime)), sprintf("%02d", minute(merged$TransactionDateTime)), sep=":")

# add time expired column
# timeExpired <- merged$TransactionDateTime + merged$PaidDuration
# merged$timeExpired <- paste(sprintf("%02d", hour(timeExpired)), sprintf("%02d", minute(timeExpired)), sep=":")

# drop rows that don't have values in peak times
peakColsDF <- merged[,c("PeakHourStart1", "PeakHourEnd1", "PeakHourStart2", "PeakHourEnd2")]
merged <- merged[rowSums(is.na(peakColsDF))!=ncol(peakColsDF), ]

# drop weekend transactions
merged$dayOfWeek <- weekdays(merged$TransactionDate, abbreviate = TRUE)
merged <- merged[!(merged$dayOfWeek=="Sat" | merged$dayOfWeek=="Sun"),]

# drop irrelevant columns
cols_to_keep <- c("dayOfWeek",
                  "timeStart",
                  "timeExpired",
                  # "PaidDuration",
                  "PeakHourStart1",
                  "PeakHourEnd1",
                  "PeakHourStart2",
                  "PeakHourEnd2",
                  "PaidParkingArea",
                  "PaymentMean",
                  "PaidAreaStartTime",
                  "PaidAreaEndTime",
                  # "DataId",
                  "MeterCode",
                  "TransactionId",
                  "TransactionDateTime")

temp <- merged[,cols_to_keep]
View(temp)

groupings <- dplyr::count(merged, PaidParkingArea)
barplot(groupings$n,names.arg = groupings$PaidParkingArea ,las=2)








###################
#### OLD STUFF ####
###################

# # this is code to import data for processing for my DATA 512 final project
# 
# # get data
# # NOTE: **The date range of your request cannot exceed more than 7 days.**
# # NOTE: So, will need to write a script to quickly pull down all the data...
# # NOTE: Then will need to merge the dataframes...
# 
# setwd('~/Desktop/3 - DATA 512/Final Project/')
# 
# # TODO: update filename below to new data file with all data
# parking1 <- readr::read_csv('Data/Raw/transactions/ParkingTransaction_20120115_20120121.csv')
# parking2 <- readr::read_csv('~/Downloads/ParkingTransaction.csv')
# blockface <- readr::read_csv('Data/Raw/Blockface.csv')
# 
# View(head(parking, 300))
# View(head(blockface, 300))
# 
# # need to get some information on the meters, to pair by code (see MeterCode in tsxtn data)
# 
# # Analysis
# 
# hist(parking1$Amount)
# hist(parking1$ElementKey)