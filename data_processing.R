# this is code to import data for processing for my DATA 512 final project

# get data
# NOTE: **The date range of your request cannot exceed more than 7 days.**
# NOTE: So, will need to write a script to quickly pull down all the data...
# NOTE: Then will need to merge the dataframes...

setwd('~/Desktop/3 - DATA 512/Final Project/')

# TODO: update filename below to new data file with all data
parking <- readr::read_csv('Data/Raw/ParkingTransaction_20140303_20140305.csv')
blockface <- readr::read_csv('Data/Raw/Blockface.csv')

View(head(parking, 300))
View(head(blockface, 300))

# need to get some information on the meters, to pair by code (see MeterCode in tsxtn data)

# Analysis

hist(parking$Amount)
hist(parking$ElementKey)


