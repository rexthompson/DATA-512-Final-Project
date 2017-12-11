# Seattle Paid On-Street Parking: <br/> Payments Collected During No Parking Periods

## Abstract

I analyze Seattle paid on-street parking data from January 2012 through September 2017 to show that the city has made over $88,400 since 2012 by collecting payments from drivers during No Parking periods. I show that this practice has waned significantly in recent years, but has not entirely ceased.

Refer to [DATA-512-Final-Project.ipynb](./DATA-512-Final-Project.ipynb) for the full analysis and supporting code, as well as a discussion on the limitations of this analysis.

## Reproducibility

This work is intended to be fully reproducible. This means that any user should be able to run my code and produce the exact same result as presented here. To do so, simply clone this repository by typing the following in the command line:

`git clone https://github.com/rexthompson/DATA-512-Final-Project`

This will download all the code and most of the cleanded data needed for this analysis.

However, note that one of the two source data files is 5.32 GB in size and is therefore much too large to include within this repository (GitHub limits individual files to 100 MB and repositories to 1 GB). I have included a random sample of 1,000,000 rows from this dataset in this repository; it is used by default in the code (though note that the results displayed are from running the code on the full dataset).

Thus, if you want to duplicate the project in its entirety with the full, large dataset:

* Clone this repository per the instruction above
* Click [HERE](https://s3.us-west-2.amazonaws.com/rext-data512-final-project/ParkingTransaction_20120101_20170930_cleaned.csv?response-content-disposition=attachment&X-Amz-Security-Token=AgoGb3JpZ2luEFEaCXVzLXdlc3QtMSKAAnWqVgwqVYYnpplJsuvJ3hDQzTlGb%2FY38zsZIG1LK%2FgKZby2386%2BGlhCy6kU0%2FL0BKfvatO2X1NK3o%2B3NwTk9X9y3s%2FwAUN4qbrumvsTK54bz0mU4F5pbmYh63n9Fpq0ojB8WV%2BcT%2FFYUVk%2FaZwib3apwJ9aYX%2B1UhaglMSZZ1cXfpbp0BnfMWaNF2M7p6gbSfO4wB6vELJdR34TSbF8zynmwkVbGC76p2CO0BMsMaY2ccQk0CrBqIg6j9v7vf0G6AyWxjyyH%2Bojl5ogxJyVYHoEad41anPdFM1ZMsS9dPConrJCUbfPjKWD363ou%2Fcl4lO1IU45Np7ub1uGnWp1fTkq%2BwMItv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw5MDc2Mzg3NTQ2NDQiDAn0WXeznjxODm6nmirPA2CYQHEH%2FDJl0%2Fr454Y66Txseq4WwR9Ou3sVJsBA%2Bj1XCJdltJs2swTFAD7DpjiL9yC1%2FSS9Dk8ahLdnsnzT%2BW8vC3KBnoOa9wRufWK7ZELfG0p2W2cG%2BPnvGoUWxRlDyct4erEu96ovqTaqKjSdQhOIMUhDKIpx%2BHDucci%2B0AX02n809B3bNhQCcoohEC5d8GM2ry1aY7eEQl7ChwcD8Q%2FiC3W7BqwvMVN0aZkSqRW5QE4c5IfVRy8CK0f6KdL%2FVavBhvHkou%2FWNSgzFwiBBNEMNO%2FuKLCWXAjmSN%2FB3Ecnurjk6GeanvtyI3D2R%2Br2qO4cDrXMYctDo6nycSyNmTzM08MOrBUW3dh5gDQyM%2FJ7UdrrQHH1Ybt9e4rKxJcdhvV68cx8bt7UkUY8Z8k5nmwSHDNWBWI%2Bh4KODD6yM9zknjfe2v6ElIrutkOggIToNKoMmSJZ0HnxXx80ES34SVrZ5gk5V46nPFAoWsWILCZtOAv6e7B6koQFc13WyYearUdkrjmp2mOwOhjoZRGKLattRjzhdN%2BofluJtRZtIVonq7aes0xaXWJU3p4EvCOvgNPdaguX0jJI7gDqPZP%2BrU5Mm9eAsFz%2ByLFqV%2BPX9nUwjtqt0QU%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20171209T050356Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAIXCDFKPUD27ZFNIQ%2F20171209%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Signature=2f5381646e760bdad7a3609cb1c41b1157296de24e3f85d2e3ebf3c42c9d2e4e) to download the 5.32 GB cleaned Transaction data
* Move the file to the `data/` directory within your cloned repository
* Set the `useFullDataset` parameter in the first code chunk in the Jupyter Notebook to `TRUE`

A significant portion of this project involved data retrieval and cleaning, but to reduce clutter I have not included these steps within the Jupyter Notebook itself. Refer to the [Data Retrieval and Cleaning](#data-retrieval-and-cleaning) section below if you would like to step through this portion of the project as well (e.g. to test different QC steps or to extend the analysis to more recent data).

Also, please note that the data provider makes no guarantees "as to the completeness, timeliness, accuracy or content of any data" (see Disclaimer below). Thus, it is possible that even repeating the exact steps as me all the way from the data retrieval to analysis may result in slightly different results.

Feel free to contact me (Rex Thompson) at rext@uw.edu if you have any questions about this analysis.

## Tools

I used the R programming language (Version 3.4.2) with the `dplyr` (0.7.4), `lubridate` (1.6.0) and `readr` (1.1.1) packages and base plotting for all tasks including data import, cleaning, analysis and visualization.

I used a .sh script to combine the 300 raw 7-day transaction .csv files into a single large .csv file.

I wrote my analysis in a Jupyter Notebook with the IRKernel to clearly document each step of the research process and support readability and reproducibility.

I performed all work on a mid-2015 MacBook Pro running macOS High Sierra (Version 10.13.1).

## Raw Data

The raw data consists of two parts:

* **Transaction data:** parking transactions from Seattle pay stations. Includes date/time, duration, payment amount and method (e.g. card, cash, mobile app), meter ID, blockface ID, etc.
* **Blockface data:** Seattle block-level parking-related attributes. Includes paid parking times and rates, Peak Hour parking restrictions, street capacity, neighborhood, record effective dates, etc.

Both datasets are made publicly available and accessible by the City of Seattle. The terms of use require the inclusion of the following disclaimers:

> The data made available here has been modified for use from its original source, which is the City of Seattle. Neither the City of Seattle nor the Office of the Chief Technology Officer (OCTO) makes any claims as to the completeness, timeliness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information contained in the web feed is being used at one's own risk.

Specifics of both datasets are discussed below.

### Transaction Data

The Transaction data represents payments at parking pay stations and the City’s mobile payment vendor for paid on-street parking within Seattle city limits. Records begin in January 2012.

The combined raw Transaction data is 5.21 GB in size with 62,577,106 rows (excluding header) and 12 columns.

More information about the raw Transaction dataset (including its schema) can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf  
(This document is also archived [here](./data/documentation/SeattlePaidTransactMetadata.pdf))

### Blockface Data

The Blockface data provides context to the Transaction data, including records such as street parking capacity, no-parking times, and parking rates by date/time. It can be tied to the Transaction data by the ElementKey and date (since Blockface information may change over time). Most records begin in 2012 but some blockfaces include records as early as 1969.

The raw Blockface data consists of a single .csv file 3.6 MB in size, with 13,706 rows (excluding header) and 52 columns.

More information about the raw Blockface dataset (including its schema) can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidBlockfaceMetadata.pdf  
(This document is also archived [here](./data/documentation/SeattlePaidBlockfaceMetadata.pdf))

## Data Retrieval and Cleaning

Data retrieval and cleaning are important parts of any project; however, I kept these steps out of the Jupyter Notebook so as to not clutter the analysis. Instead, you will find the code for these steps in this repository's [code/](/code) directory.

The following includes details on these steps and instructions on how to use the data retrieval and cleaning code if you wish to reproduce or extend my analysis.


### Transaction Data

#### Data Retrieval

At the time of this project the Transaction data API limited requests to no more than seven days at a time. Thus, I wrote three functions in R to automate the process of downloading the Transaction data in seven-day chunks over the period of interest:

* `downloadTransactions()`: Base-level function which retrieves data from the Transaction data API for a given date range (up to seven days in duration)
* `downloadSevenDayChunks()`: Wrapper function around `downloadTransactions()` which automatically downloads data in seven-day chunks over a given date range
* `dateChecker()`: Checks whether a given date interval splits evenly into seven-day chunks. This is useful when trying to figure out dates to feed to `downloadSevenDayChunks()` to minimize the number of files needed to store the data.

To use this code, source [`downloadData.R`](./code/downloadData.R) and then run `downloadSevenDayChunks()` with the following three arguments:

* **startdate_YYYYMMDD:** start date (e.g. 20120101)
* **enddate_YYYYMMDD:** end date (e.g. 20170930)
* **baseDir:** directory where you want the files saved

You may want to try the startdate_YYYYMMDD and enddate_YYYYMMDD arguments in the `dateChecker()` function first if you hope to maintain files with no less than seven days of data.

Monitor the size of each download as it completes. In a few cases for me the downloads inexplicably included the header row only; I used the `downloadTransactions()` function to re-retrieve these files after my first pass across the entire period. They worked on the second attempt.

#### Data Consolidation

I used [`combineCSVs.sh`](./code/combineCSVs.sh) to combine the raw 7-day Transaction .csv files into a single large .csv file with a single header row. Note that you may need to update the file paths in rows 5 and 7 before you run this script.

#### Data Cleaning

I wrote a function in R which performs following basic data cleaning steps on the Transaction data:

* Replaces bad values and brings consistency to `PaymentMean` column
* Adds `TransactionDate`, `timeStart` and `timeExpired` columns based on values in `TransactionDateTime` and `PaidDuration` columns
* Converts paid duration from minutes to seconds
* Drops rows with `Amount` values > $25
* Drops rows with `UserNumber` not equal to 1 or NA
* Drops rows with negative or excessive durations (i.e. > 10 hours)
* Drops columns that contain no (useful) data

To use this code, source [`cleanTransactions.R`](./code/cleanTransactions.R) and then run `cleanTransactions()`, supplying the following arguments:

* **baseDir:** directory where raw data lives
* **filename_raw:** raw data file name
* **filename_clean:** cleaned data file name (can use ../ to jump up a level)
* **sample_n:** optional row count for random sample (I used 1000000 for the sample data)
* **sample_seed:** optional seed for random sample (I used 228 for the sample data)

The resulting cleaned .csv file will have the following schema:

Column | Format | Description |
|-----|------------|----|
TransactionId | Int | The unique transaction identifier |
TransactionDateTime | YYYY-MM-DD HH:MM:SS | The date and time of the transaction as recorded |
TransactionDate | YYYY-MM-DD | The date of the transaction as recorded |
timeStart | HH:MM:00 | The time of the transaction as recorded |
timeExpired | HH:MM:00 | The calculated transaction expiration time |
Duration_mins | Int | The calculated transaction duration (minutes) |
Amount | Float | The amount of the transactions in dollars | 
PaymentMean | String | Type of payment (e.g. COINS, CREDIT CARD, PHONE) |
MeterCode | Int | Unique identifier of the pay station |
ElementKey | Int | Unique identifier for the city street segment where the pay station is located |

The final cleaned Transaction .csv file used in this analysis was 5.32 GB in size with 62,327,970 rows (excluding header).

### Blockface Data

#### Data Retrieval

I manually downloaded the Blockface data since it only consisted of a single, small file. Click the link below to download:  
http://web6.seattle.gov/SDOT/wapiParkingStudy/api/blockface

#### Data Cleaning

I wrote a function in R which performs following basic data cleaning steps on the Blockface data:

* Converts all times to HH:MM
* Converts all dates to YYYY-MM-DD
* Bumps end date/time columns up by one unit to simplify downstream join logic
* Drops columns that contain no (useful) data

To use this code, source [`cleanBlockface.R`](./code/cleanBlockface.R) and then run `cleanBlockface()`, supplying the following arguments:

* **baseDir:** directory where raw data lives
* **filename_raw:** raw data file name
* **filename_clean:** cleaned data file name (can use ../ to jump up a level)

The resulting cleaned .csv file will have the following schema:

Column | Format | Description |
|-----|------------|----|
PayStationBlockfaceId | Int | System unique identifier |
ElementKey | Int | Unique identifier for the city street segment (blockface) |
ParkingSpaces | Int | Count of allowable parking spaces on the blockface |
PaidParkingArea | String | Paid parking area of neighborhood |
ParkingTimeLimitCategory | Int | Parking time limit category (minutes) |
PeakHourStart1/2 | HH:MM:00 | Start time for peak hour parking restrictions (AM and PM) |
PeakHourEnd1/2 | HH:MM:00 | End time for peak hour parking restrictions (AM and PM) |
PaidAreaStartTime | HH:MM:00 | Paid parking area start time (used prior to variable parking rate) |
PaidAreaEndTime | HH:MM:00 | Paid parking area end time (used prior to variable parking rate) |
EffectiveStartDate | YYYY-MM-DD | Effective start date of the record |
EffectiveEndDate | YYYY-MM-DD | Effective end date of the record |
PaidParkingRate | Float | Paid parking rate on the block (used prior to variable parking rate) |
ParkingCategory | String | Parking category |
Load | Int | Count of spaces on the block allocated for various loading activities |
Zone | Int | Count of spaces on the block allocated for short-term special use, such as passenger load, taxi, carshare, bus, etc... |
WeekdayRate1/2/3 | Float | Weekday parking rate – 1st 2nd and 3rd intervals |
WeekdayStart1/2/3 | HH:MM:00 | Weekday start time parking rate for the 1st 2nd and 3rd intervals |
WeekdayEnd1/2/3 | HH:MM:00 | Weekday end time parking rate for the 1st 2nd and 3rd intervals |
StartTimeWeekday | HH:MM:00 | Weekday Paid parking start time |
EndTimeWeekday | HH:MM:00 | Weekday paid parking end time |
SaturdayRate1/2/3 | Float | Saturday parking rate – 1st 2nd and 3rd intervals
SaturdayStart1/2/3 | HH:MM:00 | Saturday start time parking rate for the 1st 2nd and 3rd intervals |
SaturdayEnd1/2/3 | HH:MM:00 | Saturday end time parking rate for the 1st 2nd and 3rd intervals |
StartTimeSaturday | HH:MM:00 | Saturday Paid parking start time |
EndTimeSaturday | HH:MM:00 | Saturday Paid parking end time |

The final cleaned Blockface .csv file used in this analysis was 2.7 MB in size with 13,706 rows (excluding header).

## References

1. https://www.seattletimes.com/seattle-news/seattles-confusing-parking-meters-pay-to-6-pm-get-towed-at-3/  
2. https://www.seattle.gov/transportation/document-library/reports-and-studies#parking  
3. http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf  
4. https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/  
5. http://web6.seattle.gov/SDOT/seattleparkingmap/

## Other Resources

http://wwwqa.seattle.gov/transportation/projects-and-programs/programs/parking-program/maps-and-data  
http://gisrevprxy.seattle.gov/arcgis/rest/services/ext/WM_CityGISLayers/MapServer/38  
http://gisrevprxy.seattle.gov/arcgis/rest/services/SDOT_EXT/DSG_datasharing/MapServer/2  
http://gisrevprxy.seattle.gov/arcgis/rest/services/SDOT_EXT/DSG_datasharing/MapServer/0  
https://data.seattle.gov/Transportation/Annual-Parking-Study-Data/7jzm-ucez  
https://www.seattletimes.com/seattle-news/pay-parking-in-west-seattle/  
http://escience.washington.edu/dssg/project-summaries-2017/
