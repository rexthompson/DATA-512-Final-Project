#' @param startdate start date for data retrieval MMDDYYYY
#' @param enddate end date for data retrieval MMDDYYYY
#' @param baseUrl base URL for data download
#' @param saveDir directory to which data files should be saved

downloadTransactions <- function(startdate,
                                 enddate,
                                 baseUrl="http://web6.seattle.gov/SDOT/wapiParkingStudy/api/ParkingTransaction?from=startdate&to=enddate",
                                 saveDir) {
  
  # check that the date range is within acceptable bounds
  # must be >=0 and <=7 (limit for web API)
  startdate_posix <- lubridate::mdy(startdate)
  enddate_posix <- lubridate::mdy(enddate)
  dateRange <- as.numeric(enddate_posix-startdate_posix, units="days")
  assertthat::assert_that(dateRange >= 0, dateRange <= 7)
  
  # populate URL
  url <- stringr::str_replace(baseUrl, "startdate", toString(startdate))
  url <- stringr::str_replace(url, "enddate", toString(enddate))

  # retrieve data
  print(paste0("URL: ", url))
  

  
}

downloadTransactions(11172017, 11202017)
