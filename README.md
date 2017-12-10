# Seattle Paid On-Street Parking: <br/> Payments Collected During No Parking Periods

## Abstract

I analyze Seattle paid on-street parking data from January 2012 through September 2017 to show that the city has made over $88,400 since 2012 by collecting payments from drivers during No Parking periods. I show that this practice has waned significantly in recent years, but has not entirely ceased.

Refer to the [DATA-512-Final-Project.ipynb] for code and full analysis.

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

It has the following schema:

| Column | Datatype | Description |
|-----|------------|----|
|DataID	|Text |	System unique identifier|
|MeterCode|	Text| 	Unique identifier of the pay station|
|TransactionID| 	Text| 	The unique transaction identifier|
|TransactionDateTime| 	Text| 	The date and time of the transaction as recorded|
|Amount| 	Text 	|The amount of the transactions in dollars|
|User Number| 	Text| 	Equals to 1; can be disregarded|
|PaymentMean| 	Text| 	Type of payment (Coin, Credit, Phone)|
|PaidDuration| 	Text| 	The total amount of time in seconds this payment represents. This field may include an extra 2 minute grace period or the prepayment hours before paid hours begin. Some older machines can only report time in 5 minute increments. (Number)|
|Elementkey| 	Text| 	Unique identifier for the city street segment where the pay station is located|
|Year| 	Text| 	The year of the transaction as recorded (derived from TransactionDateTime)|
|Month| 	Text| 	The month of the transaction as recorded (derived from TransactionDateTime)|

The schema above, as well as more information on the Transaction dataset, can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf

### Blockface Data

The Blockface data provides context to the Transaction data, including records such as street parking capacity, no-parking times, and parking rates by date/time. It can be tied to the Transaction data by the ElementKey and date (since Blockface information may change over time). Most records begin in 2012 but some blockfaces include information as early as 1969.

The raw Blockface data consists of a single .csv file 3.6 MB in size, with 13,706 rows of data and 52 columns.

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

The schema above, as well as more information on the Blockface dataset, can be found here:  
http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidBlockfaceMetadata.pdf

### Data Cleaning

Mention this here...?

### Potential Data Limitations / Data Caveats

So far, I have identified the following possible limitations to the data:

* In late 2015 the City of Seattle began implementing demand-based parking prices.<sup>[1](https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/)</sup> I need to research this further, but this could complicate the analysis. If the data does not capture this type of parking rate well, I may choose to only look at data from prior to the implementation of this methodology.
* Some PHONE transactions appear to include a surcharge...but not all. DataId = 9144748 gives correct rate of $2/hr, while others (that were excluded from clean data) have much higher values of $30 or more which don't correspond to the amount of time paid and the corresponding rate.
* Some amounts don't appear to match the rate for the given time
* some transactions took place overnight...?

## Tools

I use the R programming language with the `dplyr` `readr` and `lubridate` packages and base plotting for all tasks including data import, cleaning, analysis and visualization. I work in a Jupyter Notebook to document each step of the research process.

Regardless of the technology used, the main task will involve retrieving and combining the Transaction data from 2012, as well as merging the Transaction and Blockface datasets on the ElementKey field. The notebook (R or Jupyter) will support reproducibility in case others wish to duplicate or expand upon my work in the future.

## Reproducibility

Instructions on how to duplicate...

If you want to duplicate this analysis, `git clone` this repository by typing the following in the command line:

`git clone https://github.com/rexthompson/DATA-512-Final-Project`

This will download all the code and most of the data needed for this analysis.

The full 2012-2017 parking transaction dataset is 5.32 GB in size and therefore is much too large to host on GitHub. I have included a random sample of 1,000,000 rows from this dataset in the repository; it is used by default in the code below. However, if you want to duplicate the project in its entirety with the full dataset:

* Click [HERE](https://s3.us-west-2.amazonaws.com/rext-data512-final-project/ParkingTransaction_20120101_20170930_cleaned.csv?response-content-disposition=attachment&X-Amz-Security-Token=AgoGb3JpZ2luEFEaCXVzLXdlc3QtMSKAAnWqVgwqVYYnpplJsuvJ3hDQzTlGb%2FY38zsZIG1LK%2FgKZby2386%2BGlhCy6kU0%2FL0BKfvatO2X1NK3o%2B3NwTk9X9y3s%2FwAUN4qbrumvsTK54bz0mU4F5pbmYh63n9Fpq0ojB8WV%2BcT%2FFYUVk%2FaZwib3apwJ9aYX%2B1UhaglMSZZ1cXfpbp0BnfMWaNF2M7p6gbSfO4wB6vELJdR34TSbF8zynmwkVbGC76p2CO0BMsMaY2ccQk0CrBqIg6j9v7vf0G6AyWxjyyH%2Bojl5ogxJyVYHoEad41anPdFM1ZMsS9dPConrJCUbfPjKWD363ou%2Fcl4lO1IU45Np7ub1uGnWp1fTkq%2BwMItv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw5MDc2Mzg3NTQ2NDQiDAn0WXeznjxODm6nmirPA2CYQHEH%2FDJl0%2Fr454Y66Txseq4WwR9Ou3sVJsBA%2Bj1XCJdltJs2swTFAD7DpjiL9yC1%2FSS9Dk8ahLdnsnzT%2BW8vC3KBnoOa9wRufWK7ZELfG0p2W2cG%2BPnvGoUWxRlDyct4erEu96ovqTaqKjSdQhOIMUhDKIpx%2BHDucci%2B0AX02n809B3bNhQCcoohEC5d8GM2ry1aY7eEQl7ChwcD8Q%2FiC3W7BqwvMVN0aZkSqRW5QE4c5IfVRy8CK0f6KdL%2FVavBhvHkou%2FWNSgzFwiBBNEMNO%2FuKLCWXAjmSN%2FB3Ecnurjk6GeanvtyI3D2R%2Br2qO4cDrXMYctDo6nycSyNmTzM08MOrBUW3dh5gDQyM%2FJ7UdrrQHH1Ybt9e4rKxJcdhvV68cx8bt7UkUY8Z8k5nmwSHDNWBWI%2Bh4KODD6yM9zknjfe2v6ElIrutkOggIToNKoMmSJZ0HnxXx80ES34SVrZ5gk5V46nPFAoWsWILCZtOAv6e7B6koQFc13WyYearUdkrjmp2mOwOhjoZRGKLattRjzhdN%2BofluJtRZtIVonq7aes0xaXWJU3p4EvCOvgNPdaguX0jJI7gDqPZP%2BrU5Mm9eAsFz%2ByLFqV%2BPX9nUwjtqt0QU%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20171209T050356Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAIXCDFKPUD27ZFNIQ%2F20171209%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Signature=2f5381646e760bdad7a3609cb1c41b1157296de24e3f85d2e3ebf3c42c9d2e4e) to download
* move the file to the `data/` directory.
* set the parameter below to `TRUE`  


NEED IRKernel

## Sources

1. https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/
2. https://www.seattle.gov/transportation/document-library/reports-and-studies#parking
3. http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf
4. https://www.seattletimes.com/seattle-news/seattles-confusing-parking-meters-pay-to-6-pm-get-towed-at-3/

## Other Resources
http://wwwqa.seattle.gov/transportation/projects-and-programs/programs/parking-program/maps-and-data
http://gisrevprxy.seattle.gov/arcgis/rest/services/ext/WM_CityGISLayers/MapServer/38
http://gisrevprxy.seattle.gov/arcgis/rest/services/SDOT_EXT/DSG_datasharing/MapServer/2
http://gisrevprxy.seattle.gov/arcgis/rest/services/SDOT_EXT/DSG_datasharing/MapServer/0
https://data.seattle.gov/Transportation/Annual-Parking-Study-Data/7jzm-ucez
https://www.seattletimes.com/seattle-news/pay-parking-in-west-seattle/
http://escience.washington.edu/dssg/project-summaries-2017/



# Other words

I posit that this figure would be much higher if prior years were included in the analysis


The Transaction data described above is actually quite limited from an analytical perspective: very little information is provided to give context to the individual records. It is the Blockface data that provides this much-needed context. 

