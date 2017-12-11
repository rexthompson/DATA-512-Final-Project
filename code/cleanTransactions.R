# load dependencies
library(lubridate)
library(readr)

# clean Transaction data
cleanTransactions <- function(baseDir, filename_raw, filename_clean, sample_n=NULL, sample_seed=NULL) {
  
  #### DATA IMPORT ####
  
  # define schema and column types
  col_types <- readr::cols(DataId = col_integer(),
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
  
  # import transaction data
  filepath_raw <- paste0(baseDir, filename_raw)
  transactions <- readr::read_csv(filepath_raw, col_types = col_types, na="NULL")
  
  #### DATA CLEANING ####
  
  # replace missing PaymentMean values and convert to uppercase to eliminate inconsistencies
  transactions$PaymentMean[transactions$PaymentMean=="$record.get(\"PAYMENT_TYPE\")"] <- NA
  transactions$PaymentMean[transactions$PaymentMean=="Credit Card"] <- "CREDIT CARD"
  transactions$PaymentMean[transactions$PaymentMean=="Smart Card"] <- "SMART CARD"
  transactions$PaymentMean[transactions$PaymentMean=="Phone"] <- "PHONE"
  transactions$PaymentMean[transactions$PaymentMean=="CASH"] <- "COINS"
  
  # pull out transaction date and time
  transactions$TransactionDate <- date(transactions$TransactionDateTime)
  # TODO: consider adding seconds to this time, since this might be used when pulled back in to R anyway...
  transactions$timeStart <- paste(sprintf("%02d", hour(transactions$TransactionDateTime)),
                                  sprintf("%02d", minute(transactions$TransactionDateTime)),
                                  sep=":")
  
  # add expired time column
  timeExpired <- transactions$TransactionDateTime + transactions$PaidDuration
  # TODO: consider adding seconds to this time, since this might be used when pulled back in to R anyway...
  transactions$timeExpired <- paste(sprintf("%02d", hour(timeExpired)),
                                    sprintf("%02d", minute(timeExpired)),
                                    sep=":")

  # NOTE: the three columns above might not be fully representative of parking times
  # NOTE: Per Fremont pay station, users can pre-pay for the next morning starting at 10pm
  
  # remove rows with erroneous Amount values (i.e. charges > $25)
  transactions <- transactions[(is.na(transactions$Amount) | transactions$Amount<=25),]
  
  # convert PaidDuration to minutes
  transactions$Duration_mins <- round(transactions$PaidDuration/60, 0)
  
  # remove UserNumber values != (1 | NA)
  # Documentation says this value should be 1; vast majority of records match this condition
  transactions <- transactions[(transactions$UserNumber==1 | is.na(transactions$UserNumber)),]
  
  # remove records w/ Duration_mins values <=0 and >600 (10 hrs max allowed)
  transactions <- transactions[(is.na(transactions$Duration_mins) | 
                                  transactions$Duration_mins>0 |
                                  transactions$Duration_mins<=600),]
  
  # drop columns that have no (useful) data
  cols_to_drop <- c("DataId",
                    "UserNumber",
                    "TransactionYear",
                    "TransactionMonth",
                    "PaidDuration",
                    "Vendor")
  cols_to_drop <- colnames(transactions) %in% cols_to_drop
  # unique(transactions[,cols_to_drop])
  transactions <- transactions[,!cols_to_drop]
  
  # reorder remaining columns
  newColOrder <- c("TransactionId","TransactionDateTime", "TransactionDate",
                   "timeStart", "timeExpired", "Duration_mins",
                   "Amount", "PaymentMean",
                   "MeterCode", "ElementKey")
  transactions <- transactions[,newColOrder]
  
  #### DATA EXPORT ####
  
  # pull out transactions data sample if sample_n is not null
  if (!is.null(sample_n)) {
    if (sample_n > nrow(transactions)) {
      message(paste0("sample_n > nrow(transactions) after cleaning; returned all available results (",
                     nrow(transactions), ")"))
      sample_n <- nrow(transactions)
    }
    if (!is.null(sample_seed)) {
      set.seed(sample_seed)
    }
    transactions <- transactions[sample(nrow(transactions),sample_n),]
  }
  
  # write cleaned data to new .csv file
  filepath_clean <- paste0(baseDir, filename_clean)
  readr::write_csv(transactions, filepath_clean, na = "")
  
}

# #### SAMPLE CODE ####
# baseDir <- "~/Desktop/3 - DATA 512/Assignments/A6 - Final Project/data/raw/"
# filename_raw <- "ParkingTransaction_20120101_20170930_raw.csv"
# filename_raw_test <- "transactions_by_week/ParkingTransaction_20120429_20120505.csv" # single file for testing
# filename_clean <- "../ParkingTransaction_20120101_20170930_cleaned.csv"
# filename_clean_sample <- "../ParkingTransaction_cleanedSAMPLE.csv"
# filename_clean_test <- "../ParkingTransaction_cleanedTESTTESTTEST.csv"
# 
# cleanTransactions(baseDir, filename_raw, filename_clean) # full dataset
# cleanTransactions(baseDir, filename_raw, filename_clean_sample, 1000000, 228) # 1000000-row sample
# # cleanTransactions(baseDir, filename_raw_test, filename_clean_test) # test
