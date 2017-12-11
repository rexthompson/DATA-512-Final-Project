###########################
#### ----- SETUP ----- ####
###########################

library(lubridate)
library(readr)

# set working directory
setwd("~/Desktop/3 - DATA 512/Assignments/A6 - Final Project/data/raw/")


######################################
#### ----- TRANSACTION DATA ----- ####
######################################

#### DATA IMPORT

# define schema and column types
col_types_tsxn <- readr::cols(DataId = col_integer(),
                              MeterCode = col_integer(),
                              TransactionId = col_integer(),
                              TransactionDateTime = col_datetime("%m/%d/%Y %H:%M:%S"),
                              Amount = col_double(),
                              UserNumber = col_integer(),
                              PaymentMean = col_character(),
                              PaidDuration = col_integer(),
                              ElementKey = col_integer(),
                              TransactionYear = col_integer(),
                              TransactionMonth = col_integer(),
                              Vendor = col_character())

# import transaction data (takes a little while)
tsxnFilename <- "ParkingTransaction_20120101_20170930_raw.csv"
# tsxnFilename <- "transactions_by_week/ParkingTransaction_20120429_20120505.csv" # single file for testing
transactions <- readr::read_csv(tsxnFilename,
                                col_types = col_types_tsxn,
                                na="NULL")

#### DATA CLEANING

# replace missing PaymentMean values and convert to uppercase to eliminate inconsistencies
transactions$PaymentMean[transactions$PaymentMean=="$record.get(\"PAYMENT_TYPE\")"] <- NA
transactions$PaymentMean[transactions$PaymentMean=="Credit Card"] <- "CREDIT CARD"
transactions$PaymentMean[transactions$PaymentMean=="Smart Card"] <- "SMART CARD"
transactions$PaymentMean[transactions$PaymentMean=="Phone"] <- "PHONE"
transactions$PaymentMean[transactions$PaymentMean=="CASH"] <- "COINS"

# pull out transaction date and time
# TODO: add seconds to this time, since this might be used when pulled back in if done in R anyway...
transactions$TransactionDate <- date(transactions$TransactionDateTime)
transactions$timeStart <- paste(sprintf("%02d", hour(transactions$TransactionDateTime)),
                                sprintf("%02d", minute(transactions$TransactionDateTime)),
                                sep=":")

# add expired time column
# TODO: add seconds to this time, since this might be used when pulled back in if done in R anyway...
timeExpired <- transactions$TransactionDateTime + transactions$PaidDuration
transactions$timeExpired <- paste(sprintf("%02d", hour(timeExpired)),
                                  sprintf("%02d", minute(timeExpired)),
                                  sep=":")
rm(timeExpired)

# NOTE: the three columns above might not be fully representative of parking times
# NOTE: Per Fremont pay station, users can pre-pay for the next morning starting at 10pm

# add columns for day of the week (to make it easier to review rates, etc.)
# transactions$dayOfWeek <- weekdays(as.Date(transactions$TransactionDateTime), abbreviate = TRUE)

# remove 43 rows with erroneous Amount values (i.e. charges > $25)
transactions <- transactions[(is.na(transactions$Amount) | transactions$Amount<=25),]

# # convert PaidDuration to minutes
transactions$Duration_mins <- round(transactions$PaidDuration/60, 0)

# remove UserNumber values != 1
# Documentation says this value should be 1; 99.5% of records match this condition
# NOTE: there are 12089969 records w/ UserNumber = NA; to leave these in for now
transactions <- transactions[(is.na(transactions$UserNumber) | transactions$UserNumber==1),]

# remove records w/ PaidDuration values <=0 and >600 (10 hrs max allowed)
# Only 58 records >10 hrs; observed PaidDuration values = 11, 12 and 14 hrs
transactions <- transactions[(is.na(transactions$Duration_mins) | 
                                transactions$Duration_mins>0 |
                                transactions$Duration_mins<=600),]

# drop columns that have no (useful) data
cols_to_drop <- c("DataId", # I don't think I need this for anything...
                  "UserNumber", # all remaining values = 1 per edit above (or missing),
                  "TransactionYear", # probably don't need this for python
                  "TransactionMonth", # probably don't need this for python
                  "PaidDuration",
                  # "PaidDuration_mins",
                  "Vendor")
cols_to_drop <- colnames(transactions) %in% cols_to_drop
# unique(transactions[,cols_to_drop])
transactions <- transactions[,!cols_to_drop]

# reorder remaining columns
# newColOrder <- c("DataId", "ElementKey", "MeterCode", "TransactionId", "TransactionDateTime","Amount","PaymentMean","PaidDuration")
newColOrder <- c("TransactionId","TransactionDateTime", "TransactionDate",
                 "timeStart", "timeExpired", "Duration_mins",
                 "Amount", "PaymentMean",
                 "MeterCode", "ElementKey")
transactions <- transactions[,newColOrder]

# save cleaned file
# write_csv(transactions, "../ParkingTransaction_20120101_20170930_cleaned.csv", na="")

set.seed(228)
sampleTransactions <- transactions[sample(nrow(transactions),1000000),]
# write_csv(sampleTransactions, "../ParkingTransaction_cleanedSAMPLE.csv", na="")
