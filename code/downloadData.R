#######################
#### DOWNLOAD DATA ####
#######################

downloadTransactions <- function(startdate_YYYYMMDD=NULL,
                                 enddate_YYYYMMDD=NULL,
                                 baseDir="/Users/Thompson/Desktop/3 - DATA 512/Final Project/data/raw/transactions_by_week/") {
  
  # set different date formats
  startdate <- lubridate::ymd(startdate_YYYYMMDD)
  enddate <- lubridate::ymd(enddate_YYYYMMDD)
  startdate_MMDDYYYY <- format(startdate,"%m%d%Y")
  enddate_MMDDYYYY <- format(enddate,"%m%d%Y")
    
  # check that the date range is within acceptable bounds
  # must be >=0 and <=7 (limit for web API)
  dateRange <- as.numeric(enddate-startdate, units="days")
  assertthat::assert_that(dateRange >= 0, dateRange <= 7)
  
  # set URL
  baseUrl <- "http://web6.seattle.gov/SDOT/wapiParkingStudy/api/ParkingTransaction?from=startdate_MMDDYYYY&to=enddate_MMDDYYYY"
  url <- stringr::str_replace(baseUrl, "startdate_MMDDYYYY", toString(startdate_MMDDYYYY))
  url <- stringr::str_replace(url, "enddate_MMDDYYYY", toString(enddate_MMDDYYYY))

  # set destination filepath
  baseDestfile <- "ParkingTransaction_startdate_YYYYMMDD_enddate_YYYYMMDD.csv"
  destfile <- stringr::str_replace(baseDestfile, "startdate_YYYYMMDD", toString(startdate_YYYYMMDD))
  destfile <- stringr::str_replace(destfile, "enddate_YYYYMMDD", toString(enddate_YYYYMMDD))
  destfile <- paste0(baseDir,destfile)
    
  # retrieve data
  print(paste0("Downloading data for ", startdate, " to ", enddate))
  print(paste0("URL: ", url))
  print(paste0("Dest File: ", destfile))
  curl::curl_download(url, destfile)
  
}

downloadSevenDayChunks <- function(startdate_YYYYMMDD=NULL,
                                   enddate_YYYYMMDD=NULL,
                                   baseDir="/Users/Thompson/Desktop/3 - DATA 512/Final Project/data/raw/transactions_by_week/") {
  
  # initial sanity check
  assertthat::assert_that(enddate_YYYYMMDD >= startdate_YYYYMMDD)
  
  # set different date formats
  startdate <- lubridate::ymd(startdate_YYYYMMDD)
  enddate <- lubridate::ymd(enddate_YYYYMMDD)
  
  # define startdate and enddate sequences
  startdate_seq <- seq(from=startdate, to=enddate, by='7 days')
  enddate_seq <- startdate_seq + days(6)
  n <- length(enddate_seq)
  enddate_seq[n] <- min(enddate_seq[n], enddate)
   
  # combine into a single dataframe and reformat back to YYYYMMDD
  date_ranges <- data.frame(startdate=startdate_seq, enddate=enddate_seq)
  date_ranges <- format(date_ranges,"%Y%m%d")

  for (i in 1:nrow(date_ranges)) {
    downloadTransactions(date_ranges[i,1], date_ranges[i,2], baseDir)
  }

}

dateChecker <- function(startdate_YYYYMMDD=NULL,
                        enddate_YYYYMMDD=NULL,
                        interval=7) {
  
  # initial sanity check
  assertthat::assert_that(enddate_YYYYMMDD >= startdate_YYYYMMDD)
  
  # set different date formats
  startdate <- lubridate::ymd(startdate_YYYYMMDD)
  enddate <- lubridate::ymd(enddate_YYYYMMDD)
  
  # define startdate and enddate sequences
  startdate_seq <- seq(from=startdate, to=enddate, by='7 days')
  enddate_seq <- startdate_seq + days(6)
  n <- length(enddate_seq)
  enddate_seq[n] <- min(enddate_seq[n], enddate)
  
  # combine into a single dataframe and reformat back to YYYYMMDD
  date_ranges <- data.frame(startdate=startdate_seq, enddate=enddate_seq)
  date_ranges <- format(date_ranges,"%Y%m%d")
  
  # calculate offset and determine if acceptable (should be multiple of interval)
  offset <- as.numeric(enddate_seq[n]-startdate_seq[n]+1, units="days")
  evenOffset <- offset%%interval == 0
  
  if (evenOffset) {
    # pass
    message("OK")
  } else {
    option1 <- ifelse(n>1, paste0(date_ranges[n-1,2], " or "), "")
    option2 <- format(startdate_seq[n]+days(6), "%Y%m%d")
    message(paste0("BAD: Last interval (", date_ranges[n,1], " to ", date_ranges[n,2], ") is only ", offset, " days long; set enddate to ", option1, option2))
  }
  
}