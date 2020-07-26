
library(dplyr)
library(tidyr)

if(!file.exists("./UCI HAR Dataset")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI_Dataset.zip")
  unzip("UCI_Dataset.zip", exdir = ".")
  file.remove("UCI_Dataset.zip")
} 


# Next, read in the data. 
# X values represent the full data set for each of the features (rows represent individual observations)
# Then merge the training and test sets together.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_merged <- rename(rbind(X_train, X_test))


# y values represent the activity labels. 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_merged <- rename(rbind(y_train, y_test), activity_id = V1)



# read in the subject (range 1 through 30)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merged <- rename(rbind(subject_train, subject_test), subject = V1)

#item #3
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- rename(activities, activity_id = V1, activity = V2)

# make activity labels readable by changing to lowercase and replacing underscores with spaces. 
activities$activity <- gsub("_", " ", tolower(activities$activity))

# left join these tables takes each activity label and creates a column with the corresponding activity description
y_labeled <- left_join(x = y_merged, y = activities, by = "activity_id")


# Read in feature list, training data, and test data. 
features <- read.table("./UCI HAR Dataset/features.txt")

#name the columns of merged X according to features label
names <- features[, 2]
means_and_stds <- grep("mean\\(\\)|std\\(\\)", names)
X_selected <- select(X_merged, all_of(means_and_stds))


# Make descriptive variable names. 

variable_labels <- features[means_and_stds, 2]

variable_labels <- gsub("^(.*)-mean\\(\\)$", "Mean of \\1", variable_labels)
variable_labels <- gsub("^(.*)-std\\(\\)$", "Std. dev. of \\1", variable_labels)
variable_labels <- gsub("^(.*)-mean\\(\\)-([XYZ])$", "Mean of \\1 - \\2 direction", variable_labels)
variable_labels <- gsub("^(.*)-std\\(\\)-([XYZ])$", "Std. dev. of \\1 - \\2 direction", variable_labels)
variable_labels <- gsub("Mag$", " - Magnitude", variable_labels)

variable_labels <- gsub("tBodyAcc ", "body acceleration signal ", variable_labels)
variable_labels <- gsub("tGravityAcc ", "gravity acceleration signal ", variable_labels)
variable_labels <- gsub("tBodyGyro ", "body gyroscope signal ", variable_labels)

variable_labels <- gsub("tBodyAccJerk ", "body acceleration jerk signal ", variable_labels)
variable_labels <- gsub("tBodyGyroJerk ", "body gyroscope jerk signal ", variable_labels)

variable_labels <- gsub("fBodyAcc ", "body acceleration signal - frequency domain ", variable_labels)
variable_labels <- gsub("fBodyGyro ", "body gyroscope signal - frequency domain ", variable_labels)
variable_labels <- gsub("fBodyAccJerk ", "body acceleration jerk signal - frequency domain ", variable_labels)
variable_labels <- gsub("fBodyGyroJerk ", "body gyroscope jerk signal - frequency domain ", variable_labels)

variable_labels <- gsub("fBodyBodyAccJerk ", "body acceleration jerk signal - frequency domain ", variable_labels)
variable_labels <- gsub("fBodyBodyGyro ", "body gyroscope signal - frequency domain ", variable_labels)
variable_labels <- gsub("fBodyBodyGyroJerk ", "body gyroscope jerk signal - frequency domain ", variable_labels)

# Assign the cleaned-up feature names as column headers to the X data table (prior to adding in activity and subject columns)
names(X_selected) <- variable_labels

# complete the data set by adding columns for subject, and the activity (decsriptive label only, not the ID)
CompleteDF <- cbind(subject = subject_merged, activity = y_labeled$activity, X_selected)


# creates a tidy data set grouped (1) subject, and (2) activity
# for each subject/activity pair, report the mean of each variable. 
GroupedDF <- 
  CompleteDF %>%
  group_by(subject, activity) %>%
  summarise_all(mean)


write.table(GroupedDF, file = "output.txt", row.names = FALSE)

GroupedDF
