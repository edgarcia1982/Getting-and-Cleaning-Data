# DEFINE WORKING DIRECTORY

## Defines the directory path
newDIR <- "C:/RStudio/Getting-and-Cleaning-Data"

## Create the folders if they don't exist
if (!file.exists(newDIR)) {
        dir.create(newDIR, recursive = TRUE)
        cat("Directory created:", newDIR, "\n")
} else {
        cat("The directory already exists:", newDIR, "\n")
}

## Set the new working directory
setwd(newDIR)

## Print the current path of the working directory
cat("Current working directory:", getwd(), "\n")

remove(list = ls())


# DOWNLOAD FILE WITH DATA

##I create a folder where to save the files.
if (!file.exists("Data")) {
        dir.create("Data", recursive = TRUE)
        cat("Folder created..")
} else {
        cat("The folder already exists.")
}

##Download and save file
urlDATA <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlDATA, "./Data/HAR_Dataset.zip")



# UNCOMPRESSED ZIP FILE

## Defines the path to the zip file.
ruta_zip <- "./Data/HAR_Dataset.zip"

## Load the 'zip' library to work with zip files.
if (!requireNamespace("zip", quietly = TRUE)) {
        install.packages("zip")
}
library(zip)

## Extract the file from the zip to the "Data" folder.
ruta_unzip <- "./Data"
unzip(ruta_zip, exdir = ruta_unzip)
remove(list = ls())


#OPEN FILES AND GENERATE DATA FRAMES.
features <- read.table("./Data/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")

# 1. Merges the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set.
TidyData <- merge(TidyData, activities, by = "code", all = TRUE)
TidyData <- select(TidyData, !code)

# 4. Appropriately labels the data set with descriptive variable names.
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
rm(activities, features, Merged_Data, Subject, subject_test, subject_train, X, x_test, x_train, Y, y_test, y_train)
TidyData <- TidyData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(TidyData, "./Data/TidyData.txt", row.name=FALSE)
