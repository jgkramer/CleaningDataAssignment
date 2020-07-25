---
title: "README.md"
author: "Jared Kramer"
date: "7/24/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

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

**run_analysis.R** begins by loading in the training and test data.  First, the X values represent, for each observation from the phone data set, the values from each of 561 features in the data set.  The training set and test set are merged into a single data set.  Note that in this merged set are 10,299 observations (rows) in this data set. 

```{r message = FALSE, warning = FALSE}
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_merged <- rename(rbind(X_train, X_test))
dim(X_merged)
```


Second, the Y values represent the (numerical) activity values (in the range 1 - 6) for each observation.   The script reads in the data from the y_train and y_test files, merges into a single data frame, and then renames the column to correspond to the column header in the activity mapping file. 

Note that in this merged set are 10,299 rows (one label for each row in the X data set), with only 1 column. 

```{r message = FALSE, warning = FALSE}
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_merged <- rename(rbind(y_train, y_test), activity_id = V1)
dim(y_merged)
```

Finally, read in the subject tables and merge the train and test data, which has one numerical identifier (in the range of 1 through 30) for each obseravtion in the data set.  Note that this merged set are 10,299 rows (again, one label for each row in the X data set), with only 1 column. 

```{r message = FALSE, warning = FALSE}
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merged <- rename(rbind(subject_train, subject_test), subject = V1)
dim(subject_merged)
```


### 2.  Extract only the measurements on the mean and standard deviation for each measurement. 

First, we read in the list of features from the `features.txt` file.   Note that this table contains 561 rows, which corresponds to the number of columns (variables) in the X data file.  

```{r message = FALSE, warning = FALSE}
features <- read.table("./UCI HAR Dataset/features.txt")
dim(features)
```

Now, I will select the subset of these features (and the corresponding variable columns in the X data set) that correspond to means and standard deviations only.   The `features_info.txt` file indicates that for each signal (e.g., Body Acceleration in the X direction), there are a number of variables estimated -- mean, standard deviation, mean absolute deviation, minimum, maximum, etc. 

From this description I conclude that we are interested only in the variables that contain the character sequence "mean()" or "std()", and I identify these variables using a regular expression search `grep`.  Note I am not including the variables including the term "meanFreq()", which indicates a weighted average of frequency components (and not a simple mean), or the variables including the characters "Mean" withouth parentheses, such as `angle(Z,gravityMean)`, as the variable does not represent the mean of a signal, but instead is an angle value. 


```{r message = FALSE, warning = FALSE}
features <- read.table("./UCI HAR Dataset/features.txt")
names <- features[, 2]
means_and_stds <- grep("mean\\(\\)|std\\(\\)", names)
length(means_and_stds)
```

The `means_and_stds` variable now holds a list of (66) row indices in the features table that contain the "mean()" or "std()" components.  With this information, the script then selects the corresponding columns from the X table.  


```{r message = FALSE, warning = FALSE}
X_selected <- select(X_merged, all_of(means_and_stds))
dim(X_selected)
```

Note that this process reduces the dimensionality of the data set to 66 mean / standard deviation columns, but still with 10,299 rows (one for each observation in the original data set).  

### 3.   Use descriptive activity names to name the activities in the data set

The script then moves on to read in **activities.txt**, which contains a mapping of the numerical labels in the *Y* data files to an english language description of an activity. 

I then replace the underscore of these decsriptions with spaces, and convert them to lowercase, to make them more human-readable (i.e., "walking downstairs" instead of "WALKING_DOWNSTAIRS").    Note that this process sets up to complete item #3 of the assignment (*use descriptive activity names to name the activities in the data set*) -- these descriptive names will later be assigned to the corresponding row in the data set. 

```{r message = FALSE, warning = FALSE}
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- rename(activities, activity_id = V1, activity = V2)
activities$activity <- gsub("_", " ", tolower(activities$activity))
print(activities)
```

Then, I **join** the **y** column with the activity description mapping table to create an activity description for each observation (this also contributes to item #3 in the assignment).  
Note, I used join instead of merge, because the former preserves the ordering of the rows in the first table (merge changes the order).  As a result, in the second column of this `y_labeled` data frame will be the descriptive activity label for each row obseravtion. 

```{r message = FALSE, warning = FALSE}
y_labeled <- left_join(x = y_merged, y = activities, by = "activity_id")
```


### 4. Appropriately labels the data set with descriptive variable names.


