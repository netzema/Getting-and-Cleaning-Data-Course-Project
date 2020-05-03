
# Getting and cleaning data course project
# data collected from the Samsung Galaxy S smartphone

library(dplyr)


#downloading files 
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
        download.file(zipUrl, zipFile, mode = "wb")
}

dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
        unzip(zipFile)
}

# read training data
training_subj <- read.table(file.path(dataPath, "train", "subject_train.txt"))
training_vals <- read.table(file.path(dataPath, "train", "X_train.txt"))
training_act <- read.table(file.path(dataPath, "train", "y_train.txt"))

# read test data
test_subj <- read.table(file.path(dataPath, "test", "subject_test.txt"))
test_vals <- read.table(file.path(dataPath, "test", "X_test.txt"))
test_act <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)


# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


# concatenate individual data tables to make single data table
humanActivity <- rbind(
        cbind(training_subj, training_vals, training_act),
        cbind(test_subj, test_vals, test_act)
)

# remove individual data tables
rm(training_subj, training_vals, training_act, 
   test_subj, test_vals, test_act)

# assign column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")


# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# ... and keep data in these columns only
humanActivity <- humanActivity[, columnsToKeep]


# replace activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

# get column names
humanActivityCols <- colnames(humanActivity)

# remove special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

# correct typo
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols


# group by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)