##TREVOR HARRIS
##1/28/2016
##Coursera -> Getting and Cleaning Data

##FUNCTION PURPOSE: To create a tidy data set out of the University of California, Irvine's
##  'Human Activity Recognition Using Smartphones' data set.'
##FUNCTION PROCESS: Download data of interest, merge data into a single data set, assign human-friendly
##  variable headers, extract data of interest, make sure our data elements are descriptive, return a 
##  summarized data set
##EXPECTED INPUT: N/A
##EXPECTED OUTPUT: A tidy data frame containing the average mean and standard deviation measurements,
##  by subject and activity
##RELATED SITE: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
run_analysis <- function() {
        
        library(dplyr)
        
        ##Retrieve our data
        sourceFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        targetFile <- "./data/getdata-projectfiles-UCI HAR Dataset.zip"
        if(!file.exists("./data")){dir.create("./data")}
        if(!file.exists(targetFile)){  ##This file is huge!  only download and unpack it if its missing
                download.file(sourceFileURL,targetFile)
                dateDownloaded <- date()
                unzip(targetFile,exdir = "./data")}
        
        ##Load our reference tables
        activity_labels_lookup_table <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
        names(activity_labels_lookup_table) <- c("activity.id","activity.desc")
        
        features_lookup_table <- read.table("./data/UCI HAR Dataset/features.txt",sep=" ", header = FALSE)
        names(features_lookup_table) <- c("feature.id","feature.desc")
        
        ##Load the training and test data
        subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
        x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep="", header = FALSE, fill = TRUE)
        y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
        subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
        x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep="", header = FALSE, fill = TRUE)
        y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
        
        ##Tidy our data.  Per our lecture notes...
        ##  *Each variable measured should be contained within one column
        ##  *Each observation of that variable should be in a different row
        ##  *There should be one table for each "kind" of variable
        ##  *Multiple tables should include a column/key that allows the tables to be joined
        ##  *All variables should be: lowercase, descriptive, not duplicated, contain no
        ##     underscores and contain no spaces
        ##  *All character variables should be made into factor variables
        ##  *Values should be descriptive (i.e. TRUE/FALSE instead of 0/1)
        ##  *A tidy data set should only include the variables we care about
        ##  *A tidy data set should have all irrelevant and bad observations filtered out
        
        ##Merge the training and test sets to create one data set
        testSet <- cbind(subject_test, y_test)
        testSet <- cbind(testSet,x_test)
        
        trainingSet <- cbind(subject_train, y_train)
        trainingSet <- cbind(trainingSet,x_train)
        
        mergedSet <- rbind(testSet,trainingSet)

        ##Appropriately label the data set with descriptive variable names
        ##  Note: since there are multiple, conflicting naming conventions out there, I'm going
        ##  to make a judgement call and just make everything lowercase, using periods as word
        ##  delimiters where it makes sense
        featureList <- as.vector(features_lookup_table[,2])
        featureList <- gsub("\\(|\\)","",featureList)
        featureList <- gsub("\\,|\\-",".",featureList)
        featureList <- gsub("^t","time.",featureList)
        featureList <- gsub("^f","freq.",featureList)
        featureList <- tolower(featureList)
        
        variableNames <- c("subject.id", "activity")
        
        variableNames <- append(variableNames,featureList,2)
        
        names(mergedSet) <- variableNames
        
        ##Extract only the measurements on the mean and standard deviation for each measurement.
        ##  Do this by finding all the features that contain the string 'mean' or 'std'
        meanAndStdColumns<- grep("[Mm]ean|[Ss]td",features_lookup_table[,2])+2
        subsetColumns <- append(c(1,2),meanAndStdColumns,3)
        mergedSet <- mergedSet[,subsetColumns]
        
        ##Use descriptive activity names to name the activities in the data set
        mergedSet[,2] <- as.factor(activity_labels_lookup_table[mergedSet[,2],2])

        ##Creates a second, independent tidy data set with the average of each variable for each activity and each subject
        tidySet <- mergedSet
        tidySet %>% group_by(subject.id,activity) %>% summarize_each(funs(mean(.,na.rm=TRUE)))
}