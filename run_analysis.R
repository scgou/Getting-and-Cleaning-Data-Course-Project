# Create the directory for the data, download the zip file and unzip
if (!file.exists("./data")) { dir.create("./data") }
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/dataset.zip"
download.file(fileURL, destfile = destFile, method = "curl")
unzip(destFile, exdir = "./data")

