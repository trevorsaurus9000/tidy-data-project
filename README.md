# Getting and Cleaning Data Course Project

## Synopsis

This project includes the code necessary to convert the University of California, Irvine's (UCI) Human Activity Recognition Using Smartphones data set into a tidy data set, where 'tidy' is defined as:

- Each variable measured should be contained within one column
- Each observation of that variable should be in a different row
- There should be one table for each "kind" of variable
- Multiple tables should include a column/key that allows the tables to be joined
- All variables should be: lowercase, descriptive, not duplicated, contain no underscores and contain no spaces
- All character variables should be made into factor variables
- Values should be descriptive (i.e. TRUE/FALSE instead of 0/1)
- A tidy data set should only include the variables we care about
- A tidy data set should have all irrelevant and bad observations filtered out

Our tidy dataset includes the following files:

- 'README.txt'
- 'tidyDataSet.csv': A tidy data set generated from the UCI HAR dataset
- 'CODE BOOK.md': A description of the variables found in tidyDataSet.csv
- 'INSTRUCTION LIST.md': Instructions on how to recreate tidyDataSet.csv using only this project

Information about UCI's raw data set can be found in: /data/UCI HAR Dataset/README.txt

## Methodology

1. Retrieve raw data sets from UCI's website
  * url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  * Since the data set is relatively large, only download and recreate the data if it's already available locally
2. Load raw data sets into data frames
3. Combine our data sets into a single data frame
  * Data sets may need to be inspected and summarized to figure out how the sets together.  Str() was helpful
4. Label our variables using 'tidy data principles'
  * Since there are multiple, conflicting naming conventions out there, a judgement call was made to just make every header lowercase, using periods as word delimiters where it makes sense
5. Filter irrelevant variables out of the data frame
  * This project is only interested in variables that involve the mean or standard deviation of some measurement
6. Make sure every data element is descriptive
  * The activity data in particular needs to be modified, since an activity number doesn't on its own describe what the activity is.   Luckily a lookup data has been provided
7. Creates a new, independent data set that only includes the average of each variable for each activity and each subject
  * Using the dplyr package, we can group our data by subject and activity using the group_by command before applying the mean() function to each column
8. Write the tidy data set to file
  * This is an optional step, not called out in the course project requirements

## Motivation

This is the course project for John Hopkins University's Getting and Cleaning Data class, offered through Coursera.  The project will likely NOT be maintained past January 2016.


