# Getting and Cleaning Data Course Project
This repository contains the R code and documentation files for the online course "Getting and Cleaning data" on Coursera.

# Files

## CodeBook.md
describes the variables and measurements.

## tidy_data.txt 
is the output of the R script and contains, as the name suggests, clean and tidy data in a textfile. 


## run_analysis.R 
contains  the code to do the analysis. You can launch it in RStudio. First it ownloads and unzips source data. After reading the data in, it merges the training and the test sets. It then extracts only the measurements on the mean and standard deviation for each measurement. It assigns descriptive activity names to the names of the activities in the data set. It also labels the data set with descriptive variable names. Finally, it creates a tidy data set with the average of each variable for each activity and each subject as a text file.
