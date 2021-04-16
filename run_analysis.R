## run_analysis.R

# This script will download the UCI HAR data set and calculate the average of each recorded measurement mean for each user and activity.

if (!require(dplyr)) install.packages('dplyr')
library(dplyr)
if (!require(stringr)) install.packages('stringr')
library(stringr)
if (!require(reshape2)) install.packages('reshape2')
library(reshape2)

# Download and extract the data archive
zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("Dataset.zip")) {
  download.file(zipurl, destfile = "Dataset.zip", method = 'curl')
  # Extract data archive into data directory
  unzip(zipfile = "Dataset.zip")
}

# 1. Read and merge the data sets
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjects_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", colClasses = "factor")
subjects_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", colClasses = "factor")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

xData <- rbind(Xtrain, Xtest)
yData <- rbind(Ytrain, Ytest)
subjects <- rbind(subjects_train, subjects_test)
mergedData <- cbind(subjects, yData, xData)
names(mergedData) <- c("Subject", "Activity", features$V2)

# 2. Extract mean and std dev for each measurement
# Include the parentheses to eliminate the meanFreq variables
meanData <- mergedData[,c(1:2, (grep("-mean\\(\\)|-std\\(\\)", colnames(mergedData))))]


# 3. Uses descriptive activity names to name the activities in the data set
# Change Activity Names
activity_labels$V2 <- gsub("_", " ", activity_labels$V2)
activity_labels$V2 <- lapply(activity_labels$V2, str_to_title)
activity_labels$V2 <- unlist(activity_labels$V2)
meanData$Activity <- activity_labels[meanData$Activity, 2]

# 4. Appropriately labels the data set with descriptive variable names.
# t = time, f = frequency, Acc = Accelerometer, Gyro = Gyroscope
names(meanData) <- gsub("^t", "Time ", names(meanData))
names(meanData) <- gsub("^f", "Frequency ", names(meanData))
names(meanData) <- gsub("Acc", " Accelerometer ", names(meanData))
names(meanData) <- gsub("Gyro", " Gyroscope ", names(meanData))
names(meanData) <- gsub("Mag", " Magnitude ", names(meanData))

# 5. Create second, tidy dataset

# Calculate means of each variable by Subject and Activity
meanDataSummarized <- meanData %>% group_by(Subject, Activity) %>% summarize(across(everything(), mean))

# Columns: Subject, Activity, Variable, Average
meanDataTidy <- melt(meanDataSummarized, id = c("Subject", "Activity"),
                     measure.vars = c(3:68),
                     variable.name = "Measurement",
                     value.name = "Average")

# Write data to file
write.table(meanDataTidy, file = "./meanDataTidy.csv", sep = ",", row.names = FALSE)

