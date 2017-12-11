# load dependencies
library(lubridate)
library(readr)

# support function to convert seconds after midnight to HH:MM:SS
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

# clean Blockface data
cleanBlockface <- function(baseDir, filename_raw, filename_clean) {
  
  #### DATA IMPORT ####
  
  # define schema and column types
  col_types <- readr::cols(PayStationBlockfaceId = col_integer(),
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
  filepath_raw <- paste0(baseDir, filename_raw)
  blockface <- readr::read_csv(filepath_raw, col_types = col_types, na="NULL")
  
  #### DATA CLEANING ####
  
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
  
  # adjust end times (add a minute so periods are inclusive)
  columns_to_adjust <- colnames(blockface) %in% endtimes
  blockface[,columns_to_adjust] <- apply(blockface[,columns_to_adjust], 2, function(x) ifelse(x > 0, x+1, x))
  blockface[,columns_to_adjust] <- convertMinsToHHMM(blockface[,columns_to_adjust])
  
  # adjust effective end date (to simplify downstream join w/ Transactions data)
  blockface$EffectiveEndDate <- blockface$EffectiveEndDate + days(1)
  
  # convert date columns to text and strip "NA" values for easier re-import
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
  filepath_clean <- paste0(baseDir, filename_clean)
  readr::write_csv(blockface, filepath_clean, na = "")
  
}

# #### SAMPLE CODE ####
# 
# baseDir <- "~/Desktop/3 - DATA 512/Assignments/A6 - Final Project/data/raw/"
# filename_raw <- "Blockface.csv"
# filename_clean <- "../Blockface_cleaned.csv"
# cleanBlockface(baseDir, filename_raw, filename_clean)
