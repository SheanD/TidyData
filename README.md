# TidyData

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Requires data.table and dplyr packages

## loads URL
## Unzips file
## imports files to datatable
## READ FILES, SET DATATABLES, STANDARDIZE COLUMN NAMES IN PREP TO USE dplyr

## Extracts desired columns
## adjusts column labels
## creates and exports independent tidy data set with summary means
