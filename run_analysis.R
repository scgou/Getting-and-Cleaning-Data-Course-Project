# Create the directory for the data, download the zip file and unzip
if (!file.exists("./data")) { dir.create("./data") }
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/dataset.zip"
download.file(fileURL, destfile = destFile, method = "curl")
unzip(destFile, exdir = "./data")

# Read the training measurement data, training labels and training subject files
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read the test measurement data, test labels and test subject files
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Append the subjects and labels as new columns on left of training Data
trainData <- cbind(trainSubject, trainLabels, trainData)
testData <- cbind(testSubject, testLabels, testData)

# Append the test data to the bottom of the train data and store in a combined data variable
cData <- rbind(trainData, testData)

# Read in the features file to get the 561-feature vector variable names
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Create a vector of the feature names and add "Subject" and "Activity" to left; these are the names of the columns of cData
cnames <- c("Subject", "Activity", as.character(features[, 2]))

# Change the column names in cData
colnames(cData) <- cnames

# Now read in the activity labels
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

