library(dplyr)

# Create the directory for the data, download the zip file and unzip
if (!file.exists("./data")) { dir.create("./data") }
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/dataset.zip"
download.file(fileURL, destfile = destFile, method = "curl")
unzip(destFile, exdir = "./data")

# Read in the activity labels
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Read the training measurement data, training labels and training subject files
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read the test measurement data, test labels and test subject files
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Replace the training and test labels with the actual activities names
trainLabels[, 1] <- activities[trainLabels[, 1], 2]
testLabels[, 1] <- activities[testLabels[, 1], 2]

# Append the subjects and labels as new columns on left of training and test Data
trainData <- cbind(trainSubject, trainLabels, trainData)
testData <- cbind(testSubject, testLabels, testData)

# Append the test data to the bottom of the train data and store in a combined data variable
df <- rbind(trainData, testData)

# Read in the features file to get the 561-feature vector variable names
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Create a vector of the feature names and add "Subject" and "Activity" to left; these are the names of the columns of df
cnames <- c("Subject", "Activity", as.character(features[, 2]))

# Change the column names in cData
colnames(df) <- cnames

# Now remove all columns where the name does not contain text "mean", "std", "Actvity" or ""Subject"
bool_search <- (grepl("mean", colnames(df)) | grepl("std", colnames(df)) | grepl("Activity", colnames(df)) | grepl("Subject", colnames(df)))
names_search <- colnames(df[!bool_search])
df <- df[, !names(df) %in% names_search]

# Tidy up the column names
colnames(df) <- gsub(x = colnames(df), pattern = "^t", replacement = "Time")
colnames(df) <- gsub(x = colnames(df), pattern = "^f", replacement = "Freq")
colnames(df) <- gsub(x = colnames(df), pattern = "mean", replacement = "Mean")
colnames(df) <- gsub(x = colnames(df), pattern = "std", replacement = "StdDev")
colnames(df) <- gsub(x = colnames(df), pattern = "\\-", replacement = "")
colnames(df) <- gsub(x = colnames(df), pattern = "\\(", replacement = "")
colnames(df) <- gsub(x = colnames(df), pattern = "\\)", replacement = "")

# Group data by Subject and Activity and average each variable into new Data Frame
df2 <- df %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))

# Finally write the summary data as a csv file
write.csv(df2, file = "./data/UCI HAR Clean Data.csv")


