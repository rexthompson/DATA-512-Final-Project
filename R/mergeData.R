# merge data test

library(readr)

setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")

# import csv as combinedData
col_types1 <- readr::cols(DataId = col_integer(),
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
                          Vendor = col_character()
)

transactions <- readr::read_csv("transactions_by_week/ParkingTransaction_20120318_20120324.csv",
                                col_types = col_types1,
                                na="NULL")

