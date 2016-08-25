library(utils)
library(reshape2)
library(dplyr)

fname <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
dirname <- "UCI HAR Dataset"

# Check if the dataset is already present in current working directory, if not, download
if (!file.exists(fname) & !file.exists(dirname)){
    fURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fURL, fname, method="curl")
}
if (!file.exists(dirname)) { 
    unzip(f) 
}

# Get features and activity labels
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

# Extract only names of measurements on the mean and standard deviation
# for each measurement,then discard - separator, lower characters
# and expand prefixes
names_selected_features <- grep(".*mean.*|.*std.*", features[,2])
names_selected_features <- features[names_selected_features,2]
names_selected_features <- gsub('[()-]', '', names_selected_features) %>% tolower()
names_selected_features <- gsub('^t', 'time', names_selected_features)
names_selected_features <- gsub('^f', 'freq', names_selected_features)


# Load datasets
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[grep(".*mean.*|.*std.*", features[,2])]
train <- cbind(train_subjects, train_activities, train)

test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")[grep(".*mean.*|.*std.*", features[,2])]
test <- cbind(test_subjects, test_activities, test)

# Merge data and add names
df <- rbind(train, test)
colnames(df) <- c("subject", "activity", names_selected_features)

# For activity variable, replace integer values with the type of activity
name_activity <- function(x){
    if (x == 1)
        "WALKING"
    else if (x == 2)
        "WALKING_UPSTAIRS"
    else if (x == 3)
        "WALKING_DOWNSTAIRS"
    else if (x == 4)
        "SITTING"
    else if (x == 5)
        "STANDING"
    else if (x == 6)
        "LAYING"
    else
        NA
}
df$activity <- sapply(df$activity, name_activity)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
df.melted <- melt(df, id = c("subject", "activity"))
df.mean <- dcast(df.melted, subject + activity ~ variable, mean)

write.csv(x = df.mean, file = "tidy_data.csv", row.names = F)
write.table(x = df.mean, file = "tidy_data.txt", row.names = F)