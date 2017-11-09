# TODO: SPELL CHECK!!

#### Description:
For this assignment, you will write up a study plan for your final class project. The plan will cover a variety of details about your final project, including what data you will use, what you will do with the data (e.g. statistical analysis, train a model), what results you expect or intend, and most importantly, why your project is interesting or important (and to whom, besides yourself).

# Final Project Plan - Seattle Street Parking Data Analysis
Rex Thompson  
DATA 512 (Human-Centered Data Science)  
University of Washington, Fall 2017

## Introduction

Parking is big business in Seattle. According to GeekWire, the city of Seattle grossed $37 million in parking revenue for on-street parking in 2013 alone.<sup>1</sup> Not included in that figure is revenue from off-street options such as private lots and event parking (e.g. sporting events, festivals, concerts) which are common throughout the city as well.

Like many major cities, Seattle collects on-street parking fees by electronic parking meter - those green, solar-powered kiosks you're surely familiar with if you've ever parked anywhere within the busier parts of the city. The Seattle Department of Transporation (SDOT) has used data from these meters for years for parking studies and reports.<sup>2</sup>

However, Seattle has set itself apart from other major cities by making this parking data public. SDOT has made meter transaction records availble dating back to January 2012. By releasing the data, SDOT hopes to "encourage programmers to develop mobile or other applications that can help people make smarter decisions to find parking faster and spending less time circling, stuck in traffic."<sup>3</sup>

I will analyze the SDOT parking data as my final project for my Human-Centered Data Science course (DATA 512) during Fall 2017 at the University of Washington. I plan to identify and examine general parking trends, and, in the spirit of the course, I hope to investigate a few specific research questions that have a human-centered component. See [Research Questions](#research_questions) below for details.

## Data

The data consists of two parts:

* **Transaction data:** parking transactions at meters across the city
* **Blockface data:** information about city blocks, which gives context to the transaction data above

Both datasets are made publicly available and accessible by the City of Seattle.

The terms of use for both datasets requires that I include the following disclaimers:

> The data made available here has been modified for use from its original source, which is the City of Seattle. Neither the City of Seattle nor the Office of the Chief Technology Officer (OCTO) makes any claims as to the completeness, timeliness, accuracy or content of any data contained in this application; makes any representation of any kind, including, but not limited to, warranty of the accuracy or fitness for a particular use; nor are any such warranties to be implied or inferred with respect to the information or data furnished herein. The data is subject to change as modifications and updates are complete. It is understood that the information contained in the web feed is being used at one's own risk.

SDOT claims that neither dataset has "any vehicle identification data or other data that could identify a specific vehicle parked on a city street."

### Transaction Data

http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf

This data consists of transaction 

This data includes records for each transaction that took place. Data includes date, time, meter location, region, price, and duration. 

### Blockface Data

http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidBlockfaceMetadata.pdf

This data 

Seattle DOT also publish a complementary dataset of meter regions (what are these called?), street capaity, and legal parking times.





## Research Questions

I want to try to answer the following reserach questions

### Parking Trends

I am interested in looking at parking trends in general. For instance:

*How do parking trends differ by area/date/time/season?*

This question does not have any specific deliverables. I will summarize the data and publish any interesting results.

TODO: include expected result

### Ill-gotten gains

A 2009 Seattle Times report revealed that in some areas, parking kiosks allow customers to pay for parking beyond the time allowed. For example, No Parking signs may specify that certain blocks are off limits after 3pm; however, some kiosks in these areas allowed customers to pay for parking until 6pm. This sort of programming oversight costs customers money, both in paying for unusable parking spots, but also often results in impound fees.

This story broke in 2009 but I want to see if I can identify any areas where this may still be going on. I do not have impound records, but I do have time limits for parking areas, as well as records of when/where people paid for parking and for what duration. I will look to see if any customer transactions include a duration that extends past the time of legal parking.

If there are instances, I plan to calculate:

*How much money does the city make illegally by charging for parking when there are restrictions in place (see Seattle Times article)?*

TODO: include expected result

### Anonymity

A big part of human-centered design is the concept of informed consent and anonymity. While this data does not include any identifying information, I want to test the limits of this supposed anonymity by seeing if perhaps I can identify any trends that may allow me to pinpoint specific users. For example, one of the fields in the dataset is whether users paid cash or card. At a glance it appears most users pay with card. Suppose there is a certain city block where only one cash transaction takes place each morning at about the same time of day. This might be indicative of a specific user with specific parking and payment habits. Identifying such users, combined with other published data (e.g. parking duration), may allow for nefarious means.

*Can individual drivers be identified?*

TODO: include expected result





### Others

If the ideas above don't work out, some other concepts I could explore include:

* Impact of light rail on parking trends (especially for sporting events)
* 



## Section 1: Overview, Background, and Project Justification  
why your project is interesting or important (and to whom, besides yourself).

Words...

## Section 2: Data

Parking data from ___ is made available by the City of Seattle. 

## Section 3: Expected Results / Hypothesis / Research Question

Words...








## Cited Sources

1. https://www.geekwire.com/2014/seattle-may-install-dynamic-pricing-parking-meters/
2. https://www.seattle.gov/transportation/document-library/reports-and-studies#parking
2. http://wwwqa.seattle.gov/Documents/Departments/SDOT/ParkingProgram/data/SeattlePaidTransactMetadata.pdf









## Other potential sources
https://data.seattle.gov/Transportation/Annual-Parking-Study-Data/7jzm-ucez
https://www.seattletimes.com/seattle-news/pay-parking-in-west-seattle/
http://escience.washington.edu/dssg/project-summaries-2017/