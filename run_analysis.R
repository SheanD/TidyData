

## run_analysis.R :
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/Users/Shean Dalton/Documents/R/WorkingDirectory")

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("microbenchmark")) {
  install.packages("microbenchmark")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

require("data.table")
require("microbenchmark")
require("dplyr")

library("data.table")
library("microbenchmark")
library("dplyr")

## PRESTEPS
## DOWNLOAD FILE DOWNLOAD STEPS
## URL
URLFILE <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
## DEFINE Zipped Data File
dataFileZIP <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
## Directory
dirFile <- "./UCI HAR Dataset"
## TIDY DATA FILES: Directory and filename
tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"
tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"
## Download  (. ZIP)
if (file.exists(dataFileZIP) == FALSE) {
  download.file(URLFILE, destfile = dataFileZIP)
}

## Uncompress data file
if (file.exists(dirFile) == FALSE) {
  unzip(dataFileZIP)
}

## 1. Merges the training and the test sets to create one data set.
## READ FILES, SET DATATABLES, STANDARDIZE COLUMN NAMES IN PREP TO USE dplyr


activity_labels <- read.table("UCI Har Dataset/activity_labels.txt", stringsAsFactors = FALSE,col.names=c("activity_id","activity_label"))
measurement_labels <- read.table("UCI HAR Dataset/features.txt", row.names = 1, stringsAsFactors = FALSE, col.names=c("id","fnames"))
measurement_labels <- measurement_labels$fnames

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject_id"))
measurements_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(measurements_train) <- measurement_labels

activity_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names=c("activity_id"))
train <- cbind(subject_train, measurements_train, activity_train)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names=c("subject_id"))
measurements_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(measurements_test) <- measurement_labels
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("activity_id"))

test <- cbind(subject_test, measurements_test, activity_test)

## THE ONE DATASET
mydata <- rbind(train,test)

##2 Extracts only the measurements on the mean and standard deviation for each measurement.
measurments <- grep("mean\\(|std\\(", names(mydata), value = TRUE)
mydata <- mydata[,c("subject_id","activity_id", measurments)]

## 3. Uses descriptive activity names to name the activities in the data set
mydata <- inner_join(mydata, activity_labels, by="activity_id")

mydata <- mydata[, c("subject_id", "activity_label", meas)]

## 4. Appropriately label the data set with descriptive activity names.
cnames <- names(mydata)[-(1:2)]
cnames <- gsub("\\-|\\(|\\)", "", cnames)
cnames <- gsub("^t", "time_", cnames) 
cnames <- gsub("^f", "freq_", cnames) 
cnames <- gsub("Gyro", "Gyro_", cnames) 
cnames <- gsub("Acc", "accel_", cnames) 
cnames <- gsub("Mag", "mag_", cnames) 
cnames <- gsub("mean", "_mean", cnames) 
cnames <- gsub("BodyBody", "body", cnames)
cnames <- gsub("(.+)(std|mean)(X$|Y$|Z$)", "\\1\\3\\2", cnames) 
cnames <- gsub("mean", "_mean", cnames)
cnames <- gsub("std", "_std", cnames)
cnames <- gsub("__", "_", cnames)
cnames <- tolower(cnames)
names(mydata)[-(1:2)] <-cnames

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata <- mydata %>%
  group_by(subject_id, activity_label) %>%
  summarise_each(funs(mean)) %>%
  #Generate the output text file from the tidy dataset
  write.table("./output.txt",row.names=FALSE)

