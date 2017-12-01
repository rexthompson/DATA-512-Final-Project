###########################
#### ----- SETUP ----- ####
###########################

library(readr)

# set working directory
setwd("~/Desktop/3 - DATA 512/Final Project/data/raw/")

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

# import transaction data (takes a while)
# temp: using single file for testing. Update to combined data when ready.
transactions <- readr::read_csv("transactions_by_week/ParkingTransaction_20120101_20120107.csv",
                                col_types = col_types_tsxn,
                                na="NULL")

# NOTE: code above imports times as datetimes, w/ TZ = UTC. This is not true time but it is
# NOTE: a good consistent approach. Might want to check to see if DST is being observed in data.
# NOTE: also might need to figure out how to change this foramt for data merge, etc...

#### DATA CLEANING

# replace missing PaymentMean data
transactions$PaymentMean[transactions$PaymentMean=="$record.get(\"PAYMENT_TYPE\")"] <- NA

# remove rows which have totally crazy values (e.g. charges > $100 from 2012...)
# TODO: determine "acceptable" bounds and set any bad values to NA


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
                               PeakHourStart1 = col_time("%H:%M:%S"),
                               PeakHourEnd1 = col_time("%H:%M:%S"),
                               PeakHourStart2 = col_time("%H:%M:%S"),
                               PeakHourEnd2 = col_time("%H:%M:%S"),
                               PeakHourStart3 = col_time("%H:%M:%S"),
                               PeakHourEnd3 = col_time("%H:%M:%S"),
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
                               StartTimeSunday = col_time("%H%p"), # none; for consistency only
                               EndTimeSunday = col_time("%H%p")) # none; for consistency only

# import blockface data
blockface <- readr::read_csv("Blockface.csv",
                             col_types = col_types_blkfc,
                             na="NULL")

#### DATA CLEANING

# address fact that some blockfaces don't have data for the first few days of 2012? (start 1/3/12)

# set times after midnight to actual time values (and add one...?)

cols_to_adjust <- c("WeekdayStart1", "WeekdayEnd1",
                    "WeekdayStart2", "WeekdayEnd2",
                    "WeekdayStart3","WeekdayEnd3",
                    "SaturdayStart1", "SaturdayEnd1",
                    "SaturdayStart2", "SaturdayEnd2",
                    "SaturdayStart3", "SaturdayEnd3",
                    "SundayStart1", "SundayEnd1",
                    "SundayStart2", "SundayEnd2",
                    "SundayStart3", "SundayEnd3")

data_to_adjust <- blockface[,colnames(blockface) %in% cols_to_adjust]

convertMinsToTime <- function(x) {
  print(x/60)
  
  # x <- paste0(sprintf("%04d", x),"00")
  
  x <- lubridate::minutes(x)
  
  # as.POSIXct(lubridate::minutes(340))
  
  # format(330, "%H%M")
  
  # minutes(x)
  
  # hm(x)
  
  return(x)
  
}

convertMinsToTime(480)

blockface[,colnames(blockface) %in% cols_to_adjust] <- data_to_adjust*3000












##############################
###### EDA FOR CLEANING ######
##############################

# find outrageous prices
high_prices <- transactions[transactions$Amount > 5, ]

hist(transactions$TransactionDateTime, breaks = "days", start.on.monday = FALSE)


tmp <- read_csv("transactions_by_week/ParkingTransaction_20120617_20120623.csv",
                col_types = col_types_tsxn,
                na="NULL")

tmp2 <- read_csv("transactions_by_week/ParkingTransaction_20120115_20120121.csv",
                 col_types = col_types_tsxn,
                 na="NULL")


hist(tmp$TransactionDateTime, breaks = "hours", freq=TRUE)
hist(tmp2$TransactionDateTime, breaks = "hours", freq=TRUE)

hist(tmp2$TransactionDateTime[lubridate::date(tmp2$TransactionDateTime)=="2012-01-17"], breaks="hours")


##################################
###### CLEANING STEPS!!!!!! ######
##################################




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







