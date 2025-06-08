## Getting and Cleaning Data Course Project

## creating Data directory if not existed
if(!file.exists("./data")){dir.create("./data")}

## Install Required Packages
# install.packages("data.table")
# install.packages("reshape2")

## Load Packages
library(data.table)  
library(reshape2)

## Load Packages (another method)
# packages <- c("data.table", "reshape2")
# sapply(packages, require, character.only=TRUE, quietly=TRUE)

## Getting the Data
path <- getwd()
data_path <- paste0(path, "/data")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(data_path, "dataFiles.zip"))
unzip(zipfile = file.path(data_path, "dataFiles.zip"), exdir = "data")

## Load activity labels + features
activityLabels <- fread(file.path(data_path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))
features <- fread(file.path(data_path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
# Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)


# Loading train dataset
train <- fread(file.path(data_path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(data_path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trainSubjects <- fread(file.path(data_path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Loading test dataset
test <- fread(file.path(data_path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(data_path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(data_path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

## Merges the training and the test sets to create one data set.
combined <- rbind(train, test)

## Appropriately labels the data set with descriptive variable names.
# Uses descriptive activity names to name the activities in the data set
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

# Converting SubjectNum to a factor variable
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

# Reshaping the data frame
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydataset <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

# Exporting tidy dataset
data.table::fwrite(x = tidydataset, file = "tidyData.txt", quote = FALSE)
write.csv(x = tidydataset, file = "tidyData.csv")
write.csv2(x = tidydataset, file = "tidyData2.csv")
