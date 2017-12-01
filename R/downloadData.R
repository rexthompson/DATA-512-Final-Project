###########################
#### SUPPORT FUNCTIONS ####
###########################

#' @param startdate_YYYYMMDD start date for data retrieval YYYYMMDD
#' @param enddate_YYYYMMDD end date for data retrieval YYYYMMDD
#' @param baseDir directory to which data files should be saved

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
  
  # download.file(url, destfile)
  # status was '405 Method Not Allowed'
  
}

# downloadTransactions(20171101, 20171102)


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

######################
#### DOWNLOAD LOG ####
######################

dateChecker(20120101, 20120116)
# downloadSevenDayChunks(20120101, 20120116)
# later deleted the file w/ 20120115 to 20120116 since it only covered two days

dateChecker(20120115, 20130105)
# downloadSevenDayChunks(20120115, 20130105)
# aborted after 20120225 due to small file sizes for 20120115-20120121 and 20120122-20120128

dateChecker(20120115, 20120121)
# downloadSevenDayChunks(20120115, 20120121)
# still the same size. Later realized this was probably due to a snow storm. See more below.

dateChecker(20120122, 20120128)
# downloadSevenDayChunks(20120122, 20120128)
# looked more reasonable now (was previously just the headers)

# all caught up now thru 20120225; gonna try this again
dateChecker(20120226, 20130105)
# downloadSevenDayChunks(20120226, 20130105)
# successfully downloaded all data thru 20130105!!

# now to try and run the rest, through the end of 2016...
dateChecker(20130106, 20161231)
# downloadSevenDayChunks(20130106, 20161231)
# everything above worked except two files which just had their headers returned! See below.

# Try again on the two that failed:
dateChecker(20150405, 20150411)
dateChecker(20150412, 20150418)
# downloadTransactions(20150405, 20150411)
# downloadTransactions(20150412, 20150418)

# noticed a handful of the files had an extra @ symbol in their permissions (-rw-r--r--@)
# thought this might be an issue with the files but upon further inspection it looks like 
# this just corresponds to whether I have opened the file before or not. So it's OK.

# So, looks like all the data downloaded successfully!! Only strange outlier is the third
# file (20120115, 20120121) which was only 6.5 MB which I initially thought may be due to
# some missing data but later realized it's probably small due to a big snow storm that hit
# during that week. See the following for some background:
# http://www.climate.washington.edu/events/2012snow/
# http://sites.psu.edu/yangpassion/2016/09/27/january-2012-seattle-snowstorm/

# decided to grab 2017Q1-Q3 as well, then I can chop out the first QTR which includes the small file
dateChecker(20170101, 20170930)
# downloadSevenDayChunks(20170101, 20170930)

# all done!!

# TODO: consider adding a script to functionalize the download of the blockface data, just for code completeness
