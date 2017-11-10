# Final Project Plan - Seattle Street Parking Data Analysis
Rex Thompson  
DATA 512 (Human-Centered Data Science)  
University of Washington, Fall 2017

## Introduction

Parking is big business in Seattle. The city of Seattle grossed $37 million in parking revenue for on-street parking in 2013 alone.<sup>[1](https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/)</sup> Not included in that figure is revenue from off-street options such as private lots and event parking (e.g. sporting events, festivals, concerts) which are common throughout the city as well.

Like many major cities, Seattle collects on-street parking fees by electronic pay stations - those green, solar-powered kiosks you're surely familiar with if you've ever parked anywhere within the busier parts of the city. The Seattle Department of Transportation (SDOT) has used data from these meters for years for parking studies and reports.<sup>[2](https://www.seattle.gov/transportation/document-library/reports-and-studies#parking)</sup>

However, Seattle has set itself apart from other major cities by making this parking data public. SDOT has made meter transaction records available dating back to January 2012. By releasing the data, SDOT hopes to "encourage programmers to develop mobile or other applications that can help people make smarter decisions to find parking faster and spending (sic) less time circling, stuck in traffic."<sup>[3](http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf)</sup>

I plan to analyze the SDOT parking data as my final project for my Human-Centered Data Science course (DATA 512) during Fall 2017 at the University of Washington. My goal is to identify and examine general parking trends, and, in the spirit of the course, investigate a few specific research questions that have a human-centered component. See [Research Questions](#research_questions) below for details.

## Data

The data consists of two parts:

* **Transaction data:** parking transactions from Seattle pay stations, including via mobile app
* **Blockface data:** Seattle block-level parking capacity and restriction information

Both datasets are made publicly available and accessible by the City of Seattle. The terms of use require the inclusion of the following disclaimers:

> The data made available here has been modified for use from its original source, which is the City of Seattle. Neither the City of Seattle nor the Office of the Chief Technology Officer (OCTO) makes any claims as to the completeness, timeliness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information contained in the web feed is being used at one's own risk. 

Specifics of both datasets are discussed below.

### Transaction Data

The Transaction data represents payments at parking pay stations for paid street parking within Seattle city limits and transactions from the City’s mobile payment vendor, called PayByPhone. Records begin in January 2012.

The data can be downloaded in .csv format for 7-day periods at a time. I plan to analyze as much data is available, but I have not yet retrieved all data so I am unable to provide full data size at this time. However, I can report that a three-day period in March 2014 is 8.1 MB, consisting of 98,301 rows. Thus, a rough estimate might be ~1 GB per year of data.

The Transaction data has the following schema:

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

The Transaction data described above is actually quite limited from an analytical perspective: very little information is provided to give context to the individual records. It is the Blockface data that provides this much-needed context. The Blockface data includes records such as street parking capacity, no-parking times, and parking rates by date/time. It can be tied to the Transaction data by the ElementKey, and the date (since Blockface information may change over time).

The Blockface data can be downloaded in .csv format. It consists of a single file; effective start/end dates are provided to ensure the data captures changes to Blockface records over time. The file is 3.6 MB, with of 13,706 rows of data.

The Blockface data has the following schema:

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

### Potential Data Limitations

So far, I have identified the following possible limitations to the data:

* In late 2015 the City of Seattle began implementing demand-based parking prices.<sup>[1](https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/)</sup> I need to research this further, but this could complicate the analysis. If the data does not capture this type of parking rate well, I may choose to only look at data from prior to the implementation of this methodology.
* The data does not include exact location information beyond general region (e.g. Pioneer Square). I may be able to retrieve this from another data source, but it may turn out to be too difficult, in which case I will declare specific geolocation to be beyond the scope of the analysis. At present I actually do not even think my research questions (below) necessitate such fine-grained details.

Other limitations may present themselves as I dive into the data.

## Research Questions

The Transaction and Blockface data together afford several interesting research questions. The following sections describe the analyses I hope to conduct and the questions I hope to answer.

### General Parking Trends

I am interested in looking at parking trends in general across the city. I will ask the following questions:

* *How do parking trends differ by area?*
* *How do parking trends differ by time of day?*
* *How do parking trends differ by day of week?*
* *How do parking trends differ by season?*
* *How have parking trends changed over time?*

These questions do not necessarily have any specific deliverables. Mostly I want to explore the data and see if I can find any interesting insights. For example, which areas reach capacity fastest on weekends? Which areas produce the greatest revenue for the city? How do weekend parking rates compare to those of weekdays? Is the city reaching on-street parking capacity faster as it continues to grow?

The SDOT annual parking reports include some information along these same lines, but I hope to explore the data with greater granularity and make comparisons between regions and across different time intervals in ways that are not explored in the SDOT reports.

I expect I will find some trends that are common across areas and timeframes. I also expect I may find some interesting outliers that would be fun to try to explain based on what I know about the city, or based on other supporting data. I will report on general trends and any interesting insights I come across during my exploratory data analysis.

My findings may be of interest to city managers, companies that operate within the city, or even to individuals who pay for parking often.

### Ill-gotten Gains

A 2009 Seattle Times report revealed that some parking pay stations allowed customers to pay for parking beyond the time they were actually allowed to park on the block, as per limits specified on nearby No Parking signs. Drivers in such situations were often ticketed and towed, leading to outrage from drivers and nearby businesses alike.<sup>[4](https://www.seattletimes.com/seattle-news/seattles-confusing-parking-meters-pay-to-6-pm-get-towed-at-3/)</sup>

This story broke in 2009 but I want to see if I can identify any areas where this may still be going on. Unfortunately I do not have vehicle impound records. But the Blockface data includes time limits for parking areas and the Transaction data has records of when/where people paid for parking and for what duration. Together, this should be enough to shed light on this potential issue.

Specifically, I plan to check if any customer transactions include a duration that extends past the time of legal parking for a given area. If I can find any such instances, then I will scale up the analysis to try to find all such instances, with intent to answer the following question:

* *How much money, if any, has the city made by charging drivers for parking for longer than they are actually allowed to park in certain areas, per nearby No Parking signs?*

I hope that the data allows this analysis, and if so, I hope that I do not find records of any such ill-gotten gains. However, I will certainly be excited to bring the alternative and its extent to light if this practice is confirmed to still be occurring. The Seattle Times may be interested in my analysis as a follow-up to their 2009 article if so. Or perhaps the findings would be enough to initiate a class-action lawsuit against the city.

### Anonymity

A major area of focus in human-centered data science is the concept of informed consent and anonymity. In light of this, in its metadata for both the Transaction data and the Blockface data, SDOT states that the data does not include "any vehicle identification data or other data that could identify a specific vehicle parked on a city street."

I want to put this data's anonymity to the test. Specifically, I hope to answer the following question:

* *Can individual users be identified within the data, despite the fact that neither dataset contains explicit identifying information on its own?*

For example, one of the fields in the Transaction dataset is the method by which the user paid (i.e. card, cash, or mobile app). Three days of sample data indicates that most users pay via card, while a much smaller fraction of users pay using cash, and an even smaller fraction pay via the mobile app (in fact, no mobile app payments were found in the three days of sample data). Now, suppose there is a certain city block or even a certain pay station where only one cash or mobile app transaction takes place at about the same time each morning, and always for the same duration. This might be indicative of a specific user with specific parking and payment habits. Such knowledge, if combined with nefarious intent, may be all that is required to take advantage of such a user's habits if the user can be identified in the "real world" (e.g. surveillance of activity at a specific pay station from a nearby coffee shop).

I do not expect to be able to conclusively confirm whether or not I am able to identify specific users, since I do not plan to perform field surveillance myself. But I anticipate I may be able to find a few cases where it seems likely that a single user has been identified, despite the lack of any explicitly identifying information in the data fields themselves.

The goal of this exercise is strictly to shed light on the fact that individuals may still be identifiable even if data does not explicitly contain identifying information. But, given the potentially negative ramifications of bringing such information to light, I will limit my search to data from 2014 and prior so as to not make it easy for anyone to put my findings to bad use based on more recent or even current data.

The City of Seattle may be interested in my findings as they relate to potential ramifications of the City's decision to make this parking data available to the public.

## Tools

I plan to use the R programming language with the `dplyr` package and base plotting for all tasks including data import, cleaning, analysis and visualization. I plan to produce a R Notebook using RMarkdown to document each step of the research process.

However, if I find that the dataset is too large for processing on my local machine, I may switch to Python and leverage cloud storage and/or parallel computing resources, such as Amazon S3, EC2 and Redshift. In that case, I will use `Pandas` for analysis and `matplotlib` for visualization, as well as a Jupyter notebook for documenting the research process.

Regardless of the technology used, the main task will involve retrieving and combining the Transaction data from 2012, as well as merging the Transaction and Blockface datasets on the ElementKey field. The notebook (R or Jupyter) will support reproducibility in case others wish to duplicate or expand upon my work in the future.

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