
# TODO: review the following site:
# https://www.seattle.gov/transportation/projects-and-programs/programs/parking-program/paid-parking-information

library(readr)

# set working directory
setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")

# import csv as combinedData
col_types <- readr::cols(
  DataId = col_integer(),
  MeterCode = col_integer(),
  TransactionId = col_integer(),
  # TransactionDateTime = col_character(), # TODO: update to datetime?
  TransactionDateTime = col_datetime("%m/%d/%Y %H:%M:%S"),
  Amount = col_double(),
  UserNumber = col_integer(),
  PaymentMean = col_character(),
  PaidDuration = col_integer(),
  ElementKey = col_integer(),
  TransactionYear = col_integer(),
  TransactionMonth = col_integer(),
  Vendor = col_character()
)

# import data (takes a while)
combinedData <- readr::read_csv('ParkingTransaction_20120101_20170930.csv',
                                col_types = col_types,
                                na="NULL")

# # temp for testing
# combinedData <- readr::read_csv("transactions_by_week/ParkingTransaction_20130728_20130803.csv",
#                                 col_types = col_types,
#                                 na="NULL")

# NOTE: code above imports times as datetimes, w/ TZ = UTC. This is not true time but it is
# NOTE: a good consistent approach. Might want to check to see if DST is being observed in data.

##############################
###### EDA FOR CLEANING ######
##############################

# find outrageous prices
high_prices <- combinedData[combinedData$Amount > 25, ]

hist(combinedData$TransactionDateTime, breaks = "weeks", start.on.monday = FALSE)


##################################
###### CLEANING STEPS!!!!!! ######
##################################

# set NULL UserNumber values to empty
combinedData$User[combinedData$PaymentMean=="$record.get(\"PAYMENT_TYPE\")"] <- NA

# replace missing PaymentMean data
combinedData$PaymentMean[combinedData$PaymentMean=="$record.get(\"PAYMENT_TYPE\")"] <- NA

# remove rows which have totally crazy values (e.g. charges > $100 from 2012...)




list.files()


headers <- readr::read_csv("headers.csv", col_names = FALSE)

dim(headers)
View(headers)




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




tmp <- read_csv("transactions_by_week/ParkingTransaction_20120617_20120623.csv",
                 col_types = col_types,
                 na="NULL")

tmp2 <- read_csv("transactions_by_week/ParkingTransaction_20120115_20120121.csv",
                col_types = col_types,
                na="NULL")

hist(tmp$TransactionDateTime, breaks = "hours", freq=TRUE)
hist(tmp2$TransactionDateTime, breaks = "hours", freq=TRUE)

hist(tmp2$TransactionDateTime[lubridate::date(tmp2$TransactionDateTime)=="2012-01-17"], breaks="hours")
