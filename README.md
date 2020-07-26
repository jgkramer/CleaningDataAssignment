
# Getting and Cleaning Data Assignment

### 0.  Preliminaries.   

At the outset, import necessary libraries, and download and unzip the data if it is not already present. 

```{r message = FALSE, warning = FALSE}
library(dplyr)
library(tidyr)

if(!file.exists("./UCI HAR Dataset")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI_Dataset.zip")
  unzip("UCI_Dataset.zip", exdir = ".")
  file.remove("UCI_Dataset.zip")
} 
```


### 1. Merge the training set and test set to create one data set. 

The real work of **run_analysis.R** begins by loading in the training and test data.  First, the X values represent, for each observation from the Samsung phone data set, the values from each of 561 features in the data set.  The training set and test set are merged into a single data set.  Note that in this merged set are 10,299 observations (rows) in this data set. 

```{r message = FALSE, warning = FALSE}
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_merged <- rename(rbind(X_train, X_test))
```

Second, the Y values represent the (numerical) activity values (in the range 1 - 6) for each observation.   The script reads in the data from the y_train and y_test files, merges into a single data frame, and then renames the column to correspond to the column header in the activity mapping file. 

Note that in this merged set are 10,299 rows (one label for each row in the X data set), with only 1 column. 

```{r message = FALSE, warning = FALSE}
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_merged <- rename(rbind(y_train, y_test), activity_id = V1)
```

Finally, read in the subject tables and merge the train and test data, which has one numerical identifier (in the range of 1 through 30) for each obseravtion in the data set.  Note that this merged set are 10,299 rows (again, one label for each row in the X data set), with only 1 column. 

```{r message = FALSE, warning = FALSE}
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merged <- rename(rbind(subject_train, subject_test), subject = V1)
```

### 2.  Extract only the measurements on the mean and standard deviation for each measurement. 

First, we read in the list of features from the `features.txt` file.   This table contains 561 rows, which corresponds to the number of columns (variables) in the X data file.  

```{r message = FALSE, warning = FALSE}
features <- read.table("./UCI HAR Dataset/features.txt")
```

Now, I will select the subset of these features (and the corresponding variable columns in the X data set) that correspond to means and standard deviations only.   The `features_info.txt` file indicates that for each signal (e.g., Body Acceleration in the X direction), there are a number of variables estimated -- mean, standard deviation, mean absolute deviation, minimum, maximum, etc. 

From this description I conclude that we are interested only in the variables that contain the character sequence "mean()" or "std()", and I identify these variables using a regular expression search `grep`.  Note I am not including the variables including the term "meanFreq()", which indicates a weighted average of frequency components (and not a simple mean), or the variables including the characters "Mean" withouth parentheses, such as `angle(Z,gravityMean)`, as the variable does not represent the mean of a signal, but instead is an angle value. 


```{r message = FALSE, warning = FALSE}
features <- read.table("./UCI HAR Dataset/features.txt")
names <- features[, 2]
means_and_stds <- grep("mean\\(\\)|std\\(\\)", names)
```

The `means_and_stds` variable now holds a list of (66) row indices in the features table that contain the "mean()" or "std()" components.  With this information, the script then selects the corresponding columns from the X table.  


```{r message = FALSE, warning = FALSE}
X_selected <- select(X_merged, all_of(means_and_stds))
dim(X_selected)
```

Note that this process reduces the dimensionality of the data set to 66 mean / standard deviation columns, but still with 10,299 rows (one for each observation in the original data set).  

### 3.   Use descriptive activity names to name the activities in the data set

The script then moves on to read in **activities.txt**, which contains a mapping of the numerical labels in the *Y* data files to an english language description of an activity. 

I then replace the underscore of these decsriptions with spaces, and convert them to lowercase, to make them more human-readable (i.e., "walking downstairs" instead of "WALKING_DOWNSTAIRS").  

```{r message = FALSE, warning = FALSE}
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- rename(activities, activity_id = V1, activity = V2)
activities$activity <- gsub("_", " ", tolower(activities$activity))
```

Then, I **join** the **y** column with the activity description mapping table to create an activity description for each observation (this also contributes to item #3 in the assignment).  
Note, I used join instead of merge, because the former preserves the ordering of the rows in the first table (merge changes the order).  As a result, in the second column of this `y_labeled` data frame will be the descriptive activity label for each row obseravtion. 

```{r message = FALSE, warning = FALSE}
y_labeled <- left_join(x = y_merged, y = activities, by = "activity_id")
```

Note that these descriptive names will later be assigned to the corresponding row in the data set based on their "y" numerical labels. 

### 4. Appropriately label the data set with descriptive variable names.

The next section of the script manipulates the text of the feature labels to make them more descriptive. 
As we did with the columns of the "X" data set, I extract only the 66 rows from the feature table representing mean or standard deviations. 

```{r message = FALSE, warning = FALSE}
variable_labels <- features[means_and_stds, 2]
```

The following code upacks the densely named feature labels and makes them more descriptive, by using regular expression substitution via `gsub`. 

These substitutions rewrite feature names ending with "....mean()" or "....std()" by as names STARTING with "Mean of ..." or "Std. Dev. of".  
In addition, for any variable ending with X, Y or Z (the axes of measurement) or Mag, the name is rewritten to end with "X direction", "Y direction", "Z direction" or "Magnitude", respectively.

```{r message = FALSE, warning = FALSE}
variable_labels <- gsub("^(.*)-mean\\(\\)$", "Mean of \\1", variable_labels)
variable_labels <- gsub("^(.*)-std\\(\\)$", "Std. dev. of \\1", variable_labels)
variable_labels <- gsub("^(.*)-mean\\(\\)-([XYZ])$", "Mean of \\1 - \\2 direction", variable_labels)
variable_labels <- gsub("^(.*)-std\\(\\)-([XYZ])$", "Std. dev. of \\1 - \\2 direction", variable_labels)
variable_labels <- gsub("Mag$", " - Magnitude", variable_labels)
```

Finally, I unpack the densely abbreviated multiple word descriptors of the type of signal measured into complete words, turning, for example "tBodyAcc" into "body acceleration signal", and so forth. 

```{r message = FALSE, warning = FALSE}
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
```

Finally, with the variable names cleaned up, I apply these as the column names of the selected X data set. 
I then combine this column-wise with the subject data set, and the descriptive activity labels, to create the FULL data set, containing columns for each obseravtion of subject, activity label, and all 66 measured signals. 

```{r message = FALSE, warning = FALSE}
names(X_selected) <- variable_labels
CompleteDF <- cbind(subject = subject_merged, activity = y_labeled$activity, X_selected)
```

### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Finally, I create a new tidy data set by (1) grouping by the data set by subject (numbered 1 - 30) and each of the six activities, and (2) summarizing the remaining 66 columns by taking the mean of each variable within the group. 

For qualification as tidy, this treats as variables: (1) subject, (2) activity description label, and (3) the mean of each of the 66 signals from the phone sensors; each "observation" is thus the set of (mean) signal values from all of the phone senors we selected for, for a given subject's activity. 

I believe this is an appropriate interpretation of a "single observation" for this data set, as the quanities may not be individually meaningful, but the values are most meaningful when interpreted collectively (and only collectively) to determine the activity of the person carrying the phone. 

```{r message = FALSE, warning = FALSE}
GroupedDF <- 
  CompleteDF %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
```

I do acknowledge that another potential interpretation of a "tidy" data set would have been to melt the `CompleteDF` data frame and treat (1) subject, (2) activity and (3) signal name corresponding to the column name in CompleteDF (for which a value could be "Mean of Body Acceleration - X Direction")", and then (4) the observed numerical value.   This would be a narrow / tall data set with only 4 columns (only one numerical value per row).


