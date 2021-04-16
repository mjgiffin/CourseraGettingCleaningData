# Description of Analysis

This analysis script `run_analysis.R` summarizes the mean and standard deviation data from the UCI HAR dataset. The original dataset is avaialble here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Run Analysis

Here are the data for the analysis:
  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

1. Checks for required packagges and installs if necessary.
1. Downloads the data archive from the above URL.
1. Reads the files from the UCI HAR dataset, including activity names, subject identifier, measurement variables and measured data.
1. Merges the training and the test sets to create one data set.
1. Combines the activities and measurement data.
1. Adds the subject identity as a column to the measurement data.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Substitute descriptive activity names to name the activities in the data set.
1. Applies descriptive labels to the measurement variables the data set. 
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To run this analysis, copy the script `run_analysis.R` to your working directory and source the script. In addition to base `r`, it requires the `dplyr`, `stringr` and `reshape2` packages. The script will check whether the packages are installed and install them if necessary.

This script will output a file named `meanDataTidy.csv`.
