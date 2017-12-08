# setup
library(dplyr)
library(lubridate)
library(readr)

# import data
# TODO: add option to pull from S3 if data not in local files...
baseDir <- "~/Desktop/3 - DATA 512/Final Project/data/raw/"
# baseDir <- "" TODO: add S3 baseUrl here

# filename <- "ParkingTransaction_cleanedSAMPLE.csv"
filename <- "ParkingTransaction_20120101_20170930_cleaned.csv"
trans_raw <- read_csv(paste0(baseDir, filename))
transactions <- trans_raw

filename <- "Blockface_cleaned.csv"
blkfc_raw <- read_csv(paste0(baseDir, filename))
blockface <- blkfc_raw

# drop blockface rows that don't have peak hour restrictions
peakCols <- c("PeakHourStart1", "PeakHourEnd1", "PeakHourStart2", "PeakHourEnd2")
blockface <- blockface[rowSums(is.na(blockface[,peakCols]))!=ncol(blockface[,peakCols]), ]

# drop transaction rows with blockface IDs not in those subset above
transactions <- transactions[transactions$ElementKey %in% blockface$ElementKey,]

# drop transactions with expiration time < transaction time (i.e. the overnighters)
# this step is necessary for the overlap duration calculation below
# NOTE: looks like the PaidDuration values on some of these are too long....paid values are way low
# NOTE: this is clearly a problem for some overnight transactions, but may apply to others as well
transactions <- transactions[transactions$timeExpired > transactions$timeStart,]

# drop weekend transactions
dayOfWeek <- weekdays(transactions$TransactionDateTime, abbreviate = TRUE)
transactions <- transactions[!(dayOfWeek=="Sat" | dayOfWeek=="Sun"),]

# MERGE THE DATASETS

# merge function
mergeData <- function(transactions, blockface) {
  output <- left_join(transactions, blockface, by="ElementKey") %>%
    filter((TransactionDateTime >= EffectiveStartDate) &
             TransactionDateTime < pmin(lubridate::today(), EffectiveEndDate, na.rm = TRUE))
}

# perform the merge
# NOTE: might lose rows here for transactions that took place in blockfaces that had peak restrictions at one
# NOTE: point or another, but whose effective dates do not bound the time date/time of a given transaction
merged <- mergeData(transactions, blockface)

# TODO: drop unecessary columns?

# calculate overlap w/ Peak Period 1
latestStart1 = pmax(merged$timeStart, merged$PeakHourStart1)
earliestEnd1 = pmin(merged$timeExpired, merged$PeakHourEnd1)
overlapMins1 = pmax(0, (earliestEnd1 - latestStart1)/60, na.rm = TRUE)

# calculate overlap w/ Peak Period 2
latestStart2 = pmax(merged$timeStart, merged$PeakHourStart2)
earliestEnd2 = pmin(merged$timeExpired, merged$PeakHourEnd2)
overlapMins2 = pmax(0, (earliestEnd2 - latestStart2)/60, na.rm = TRUE)

# get total overlap (possible both could be breached)
merged$overlapMins <- apply(cbind(overlapMins1, overlapMins2), 1, sum)

# reviewCols <- c("TransactionDateTime", "Duration_mins", "Amount", "timeStart", "timeExpired", peakCols)
# View(merged[,c(reviewCols, "overlap_mins")])
# View(merged[,c(reviewCols, "overlap_mins1", "overlap_mins2", "overlap_mins")])

# subset transactions with apparent illegal parking tickets issued (select >1 for rounding)
badTransactions <- merged[merged$overlapMins>1,]

View(badTransactions)

# prorate the improper fees
badTransactions$amtOver <- badTransactions$overlapMins/badTransactions$Duration_mins*badTransactions$Amount

# TOTAL BAD!!!
sum(badTransactions$amtOver)

# PLOTS
hist(badTransactions$amtOver, xlab="Amount ($)", main="'No Parking' Transaction Amounts\nJan 2012 - Sept 2017")
hist(badTransactions$TransactionDateTime, "years", xlab="Date", main="'No Parking' Transaction Counts by Year\nJan 2012 - Sept 2017", freq = TRUE)




#hist(badTransactions$TransactionDateTime, "months", freq = TRUE, xlab="Month", format = "%d %b %y", axes=FALSE,
#     main = "'No Parking' Transaction Counts by Month\nJan 2012 - Sept 2017")
#axis.Date(1, at=seq(as.Date("2011-10-10"), as.Date("2012-03-19"), by="2 weeks"),
#          format="%d %b %y")
#axis.Date(1, at=seq(as.Date("2011-10-10"), as.Date("2012-03-19"), by="weeks"), 
#          labels=F, tcl= -0.5)
