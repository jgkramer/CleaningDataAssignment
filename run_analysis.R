library(dplyr)
library(tidyr)

# Read in feature list, training data, and test data. 
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- rename(activities, activity_id = V1, activity = V2)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# merge the training set data and test data into a "merged" data set
# applies to X table (feature values), y table (activity labels) and subject (subject/person)

X_merged <- rename(rbind(X_train, X_test))
y_merged <- rename(rbind(y_train, y_test), activity_id = V1)


y_labeled <- left_join(x = y_merged, y = activities, by = "activity_id")
  
subject_merged <- rename(rbind(subject_train, subject_test), subject = V1)

#name the columns of merged X according to features label
names <- features[, 2]
means_and_stds <- grep("mean\\(\\)|std\\(\\)", names)

X_selected <- select(X_merged, all_of(means_and_stds))
names(X_selected) <- features[means_and_stds, 2]

AugmentedDF <- cbind(subject = subject_merged, activity = y_labeled$activity, X_selected)


##GatheredDF <- pivot_longer(AugmentedDF, cols = -c(subject, activity), names_to = "feature", values_to = "measurement")

##GroupedDF <- 
##  GatheredDF %>%
##  group_by(subject, activity, feature) %>%
##  summarise(mean = mean(measurement))

GroupedDF <- 
  AugmentedDF %>%
  group_by(subject, activity) %>%
  summarise_all(mean)