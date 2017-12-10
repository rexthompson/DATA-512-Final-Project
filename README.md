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

## Data

The data consists of two parts:

* **Transaction data:** parking transactions from Seattle pay stations. Includes date/time, duration, payment amount and method (e.g. card, cash, mobile app), meter ID, blockface ID, etc.
* **Blockface data:** Seattle block-level parking-related attributes. Includes paid parking times and rates, Peak Hour parking restrictions, street capacity, neighborhood, record effective dates, etc.

Both datasets are made publicly available and accessible by the City of Seattle. The terms of use require the inclusion of the following disclaimers:

> The data made available here has been modified for use from its original source, which is the City of Seattle. Neither the City of Seattle nor the Office of the Chief Technology Officer (OCTO) makes any claims as to the completeness, timeliness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information contained in the web feed is being used at one's own risk.

Specifics of both datasets are discussed below.

### Transaction Data

The Transaction data represents payments at parking pay stations and the City’s mobile payment vendor for paid on-street parking within Seattle city limits. Records begin in January 2012.

The combined raw Transaction data is 5.21 GB in size with 62,577,106 rows and 12 columns.

More information about the Transaction dataset (including its schema) can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf  
(This document is also archived [here](./data/documentation/SeattlePaidTransactMetadata.pdf))

### Blockface Data

The Blockface data provides context to the Transaction data, including records such as street parking capacity, no-parking times, and parking rates by date/time. It can be tied to the Transaction data by the ElementKey and date (since Blockface information may change over time). Most records begin in 2012 but some blockfaces include records as early as 1969.

The raw Blockface data consists of a single .csv file 3.6 MB in size, with 13,706 rows of data and 52 columns.

More information about the Blockface dataset (including its schema) can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidBlockfaceMetadata.pdf  
(This document is also archived [here](./data/documentation/SeattlePaidBlockfaceMetadata.pdf))

## Data Retrieval and Cleaning

Data retrieval and cleaning are an important part of any project; however, I kept these steps out of the Jupyter Notebook so as to not clutter the analysis. Instead, you will find the code for these steps in this repository's [code](/code) directory.

The following includes details on these steps and instructions on how to use the data retrieval and cleaning steps if you wish to reproduce or extend my analysis.

### Data Retrieval

The raw Transaction and Blockface data required some cleaning and reformatting to enable this analysis.






## Tools

I used the R programming language (Version 3.4.2) with the `dplyr` (0.7.4), `lubridate` (1.6.0) and `readr` (1.1.1) packages and base plotting for all tasks including data import, cleaning, analysis and visualization.

I used a .sh script to combine the 300 raw 7-day transaction .csv files into a single large .csv file.

I wrote my analysis in a Jupyter Notebook with the IRKernel to clearly document each step of the research process and support readability and reproducibility.

I performed all work on a mid-2015 MacBook Pro running macOS High Sierra (Version 10.13.1).

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









It has the following schema:

| Column | Datatype | Description |
|-----|------------|----|
|DataID	|Text |	System unique identifier|
|MeterCode|	Text| 	Unique identifier of the pay station|
|TransactionID| 	Text| 	The unique transaction identifier|
|TransactionDateTime| 	Text| 	The date and time of the transaction as recorded|
|Amount| 	Text 	|The amount of the transactions in dollars|
|UserNumber| 	Text| 	Equals to 1; can be disregarded|
|PaymentMean| 	Text| 	Type of payment (Coin, Credit, Phone)|
|PaidDuration| 	Text| 	The total amount of time in seconds this payment represents. This field may include an extra 2 minute grace period or the prepayment hours before paid hours begin. Some older machines can only report time in 5 minute increments. (Number)|
|ElementKey| 	Text| 	Unique identifier for the city street segment where the pay station is located|
|Year| 	Text| 	The year of the transaction as recorded (derived from TransactionDateTime)|
|Month| 	Text| 	The month of the transaction as recorded (derived from TransactionDateTime)|
|Vendor| 	Text| 	NA - empty|





It has the following schema:

| Column | Datatype | Description |
|-----|------------|----|
|PayStationBlockfaceID|Text| 	System unique identifier|
|Elementkey |Text|Unique identifier for the city street segment (blockface)|
|ParkingSpaces|Text|Count of allowable parking spaces on the blockface|
|PaidParkingArea|Text|Paid parking area of neighborhood|
|ParkingTimeLimitCategory |Text|Parking time limit category|
|PeakHourStart1|Text|Start time for the first interval of peak hour parking restriction|
|PeakHourEnd1|Text|End time for the first interval of peak hour parking restriction|
|PeakHourStart2|Text|Start time for the second interval of peak hour parking restriction|
|PeakHourEnd2|Text|End time for the second interval of peak hour parking restriction|
|PeakHourStart3|Text|Start time for the third interval of peak hour parking|
|PeakHourEnd3|Text|End time for the third interval of peak hour parking restriction|
|PaidAreaStartTime|Text|Paid parking area start time (used prior to variable parking rate)|
|PaidAreaEndTime|Text|Paid parking area end time (used prior to variable parking rate)|
|EffectiveStartDate|Text|Effective start date of the record|
|EffectiveEndDate|Text|Effective end date of the record|
|PaidParkingRate|Text|Paid parking rate on the block (used prior to variable parking rate)|
|ParkingCategory|Text|Parking category|
|Load|Text|Count of spaces on the block allocated for various loading activities|
|Zone|Text|Count of spaces on the block allocated for short-term special use, such as passenger load, taxi, carshare, bus, etc...|
|WeekdayRate1|Text|Weekday parking rate – 1st interval|
|WeekdayStart1|Text|Weekday start time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|WeekdayEnd1|Text|Weekday end time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|WeekdayRate2|Text|Weekday parking rate – 2nd interval|
|WeekdayStart2|Text|Weekday start time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|WeekdayEnd2|Text|Weekday end time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|WeekdayRate3|Text|Weekday parking rate – 3rd interval|
|WeekdayStart3|Text|Weekday start time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|WeekdayEnd3|Text|Weekday end time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|StartTimeWeekday|Text|Weekday Paid parking start time|
|EndTimeWeekday|Text|Weekday paid parking end time|
|SaturdayRate1|Text|Saturday parking rate – 1st interval|
|SaturdayStart1|Text|Saturday start time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SaturdayEnd1|Text|Saturday end time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SaturdayRate2|Text|Saturday parking rate – 2nd interval|
|SaturdayStart2|Text|Saturday start time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SaturdayEnd2|Text|Saturday end time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SaturdayRate3|Text|Saturday parking rate – 3rd interval|
|SaturdayStart3|Text|Saturday start time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SaturdayEnd3|Text|Saturday end time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|StartTimeSaturday|Text|Saturday Paid parking start time|
|EndTimeSaturday|Text|Saturday paid parking end time|
|SundayRate1|Text|Sunday parking rate – 1st interval|
|SundayStart1|Text|Sunday start time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SundayEnd1|Text|Sunday end time parking rate for the 1st interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SundayRate2 |Text|Sunday parking rate – 2nd interval|
|SundayStart2|Text|Sunday start time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SundayEnd2|Text|Sunday end time parking rate for the 2nd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SundayRate3|Text|Sunday parking rate – 3rd interval|
|SundayStart3|Text|Sunday start time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|SundayEnd3|Text|Sunday end time parking rate for the 3rd interval. Time is in minutes after midnight(i.e., 600 = 10:00AM)|
|StartTimeSunday|Text|Sunday Paid parking start time|
|EndTimeSunday|Text|Sunday paid parking end time|