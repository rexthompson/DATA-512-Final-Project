###########################
#### ----- SETUP ----- ####
###########################

library(lubridate)
library(readr)

# set working directory
setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")


####################################
#### ----- BLOCKFACE DATA ----- ####
####################################

#### DATA IMPORT

# define schema and column types
col_types_blkfc <- readr::cols(PayStationBlockfaceId = col_integer(),
                               ElementKey = col_integer(),
                               ParkingSpaces = col_integer(),
                               PaidParkingArea = col_character(),
                               ParkingTimeLimitCategory = col_integer(),
                               PeakHourStart1 = col_character(), # col_time("%H:%M:%S")
                               PeakHourEnd1 = col_character(), # col_time("%H:%M:%S")
                               PeakHourStart2 = col_character(), # col_time("%H:%M:%S")
                               PeakHourEnd2 = col_character(), # col_time("%H:%M:%S")
                               PeakHourStart3 = col_character(), # col_time("%H:%M:%S")
                               PeakHourEnd3 = col_character(), # col_time("%H:%M:%S")
                               PaidAreaStartTime = col_time("%H%p"),
                               PaidAreaEndTime = col_time("%H%p"),
                               EffectiveStartDate = col_date("%e-%b-%y"),
                               EffectiveEndDate = col_date("%e-%b-%y"),
                               PaidParkingRate = col_double(),
                               ParkingCategory = col_character(),
                               Load = col_integer(),
                               Zone = col_integer(),
                               WeekdayRate1 = col_double(),
                               WeekdayStart1 = col_integer(), # convert from mins after midnight to time
                               WeekdayEnd1 = col_integer(), # convert from mins after midnight to time
                               WeekdayRate2 = col_double(),
                               WeekdayStart2 = col_integer(), # convert from mins after midnight to time
                               WeekdayEnd2 = col_integer(), # convert from mins after midnight to time
                               WeekdayRate3 = col_double(),
                               WeekdayStart3 = col_integer(), # convert from mins after midnight to time
                               WeekdayEnd3 = col_integer(), # convert from mins after midnight to time
                               StartTimeWeekday = col_time("%H%p"),
                               EndTimeWeekday = col_time("%H%p"),
                               SaturdayRate1 = col_double(),
                               SaturdayStart1 = col_integer(), # convert from mins after midnight to time
                               SaturdayEnd1 = col_integer(),  # convert from mins after midnight to time
                               SaturdayRate2 = col_double(),
                               SaturdayStart2 = col_integer(),  # convert from mins after midnight to time
                               SaturdayEnd2 = col_integer(),  # convert from mins after midnight to time
                               SaturdayRate3 = col_double(),
                               SaturdayStart3 = col_integer(),  # convert from mins after midnight to time
                               SaturdayEnd3 = col_integer(),  # convert from mins after midnight to time
                               StartTimeSaturday = col_time("%H%p"),
                               EndTimeSaturday = col_time("%H%p"),
                               SundayRate1 = col_double(), # none; for consistency only
                               SundayStart1 = col_integer(), # none; for consistency only
                               SundayEnd1 = col_integer(), # none; for consistency only
                               SundayRate2 = col_double(), # none; for consistency only
                               SundayStart2 = col_integer(), # none; for consistency only
                               SundayEnd2 = col_integer(), # none; for consistency only
                               SundayRate3 = col_double(), # none; for consistency only
                               SundayStart3 = col_integer(), # none; for consistency only
                               SundayEnd3 = col_integer(), # none; for consistency only
                               StartTimeSunday = col_character(), # col_time("%H%p"), # none, for consistency only
                               EndTimeSunday = col_time("%H%p")) # none, for consistency only

# import blockface data
blockface <- readr::read_csv("Blockface.csv",
                             col_types = col_types_blkfc,
                             na="NULL")

#### DATA CLEANING

# define function to convert start and end times from minutes after midnight to HH:MM
convertMinsToHHMM <- function(x) {
  
  # sanity checks
  assertthat::assert_that(all(x>=0 | is.na(x)), msg="values must be non-negative")
  assertthat::assert_that(all(x<=1440 | is.na(x)), msg="values must be <= 1440")
  
  # round to nearest minute and extract hrs and mins
  x <- round(x,0)
  hrs <- floor(x/60)
  mins <- floor(x%%60)
  
  # convert to hh and mm
  hrs_hh <- sapply(hrs, sprintf, fmt="%02.f")
  mins_mm <- sapply(mins, sprintf, fmt="%02.f")
  
  # paste data together and replace NAs
  pasted_vals <- paste0(hrs_hh, ":", mins_mm, ":00")
  pasted_vals[pasted_vals=="NA:NA:00"] <- NA
  
  # convert back to dataframe
  hhmm <- data.frame(matrix(pasted_vals, nrow = nrow(x)), stringsAsFactors = FALSE)
  return(hhmm)
}

# set columns to adjust
starttimes <- c("WeekdayStart1", "WeekdayStart2", "WeekdayStart3",
                "SaturdayStart1", "SaturdayStart2", "SaturdayStart3",
                "SundayStart1", "SundayStart2", "SundayStart3")

endtimes <- c("WeekdayEnd1", "WeekdayEnd2", "WeekdayEnd3",
              "SaturdayEnd1","SaturdayEnd2", "SaturdayEnd3",
              "SundayEnd1", "SundayEnd2", "SundayEnd3")

# adjust start times
columns_to_adjust <- colnames(blockface) %in% starttimes
blockface[,columns_to_adjust] <- convertMinsToHHMM(blockface[,columns_to_adjust])

# adjust end times (add a minute to periods are inclusive)
columns_to_adjust <- colnames(blockface) %in% endtimes
blockface[,columns_to_adjust] <- apply(blockface[,columns_to_adjust], 2, function(x) ifelse(x > 0, x+1, x))
blockface[,columns_to_adjust] <- convertMinsToHHMM(blockface[,columns_to_adjust])

# adjust effective end date (to simplify merging later)
blockface$EffectiveEndDate <- blockface$EffectiveEndDate + days(1)

# convert date columns to text for easier python import, and strip NAs
cols_to_reformat <- c("StartTimeWeekday", "EndTimeWeekday", "StartTimeSaturday", "EndTimeSaturday")

for (col in cols_to_reformat) {
  new_col <- data.frame(sapply(blockface[,col], as.character), stringsAsFactors = FALSE)
  new_col[new_col=="NA"] <- NA
  blockface[,col] <- new_col
}

# drop columns that have no (useful) data
cols_to_drop <- c("PeakHourStart3","PeakHourEnd3",
                  "SundayStart1", "SundayStart2", "SundayStart3",
                  "SundayEnd1", "SundayEnd2", "SundayEnd3",
                  "SundayRate1", "SundayRate2", "SundayRate3",
                  "StartTimeSunday", "EndTimeSunday")
cols_to_drop <- colnames(blockface) %in% cols_to_drop
# unique(blockface[,cols_to_drop])
blockface <- blockface[,!cols_to_drop]

# write cleaned data to new .csv file
write_csv(blockface, "../Blockface_cleaned.csv", na = "")


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
transactions <- transactions[(is.na(transactions$PaidDuration) | 
                                transactions$PaidDuration>0 |
                                transactions$PaidDuration<=600),]

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
