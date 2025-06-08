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

