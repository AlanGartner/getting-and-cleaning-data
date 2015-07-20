# this script answers the project assignment from "Coursera getting and cleaning data"
# Specifically, it transforms a raw data set into a tidy dataset, please refer to the readme
#
# author: Gilles Bertrand
# date: July 2015

# hint:
# use "source with echo" to run and see the outputs
# source('run_analysis.R', echo=TRUE)

# accompanying files:
# - README.md
# - codebook.txt
# - the raw data is provided here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


# display working directory, for debugging purposes
getwd()

# go to the dataset directory
setwd("~/UCI HAR Dataset")

# run the garbage collector to save memory
gc()

# 1 Merges the training and the test sets to create one data set.
# load train and test data into matrices
subject_test <- as.matrix(read.table("./test/subject_test.txt",
                                     header = FALSE))

x_test <- as.matrix(read.table("./test/X_test.txt",
                               header = FALSE))

y_test <- as.matrix(read.table("./test/y_test.txt",
                               header = FALSE))

subject_train <- as.matrix(read.table("./train/subject_train.txt",
                                      header = FALSE))

x_train <- as.matrix(read.table("./train/X_train.txt",
                                header = FALSE))

y_train <- as.matrix(read.table("./train/y_train.txt",
                                header = FALSE))

# display data dimension
dim(subject_test)
dim(x_test)
dim(y_test)
dim(subject_train)
dim(x_train)
dim(y_train)


# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
# Nb: I have a cheap computer with not enough ram to merge the full datasets, so I filter as I merge

# read the labels of the colums
features <-  read.table("features.txt",header = FALSE) # read data
features <-
  as.vector(subset(features, select = c(V2))) # remove 1 col
features <-
  t(features) # transpose from vertical to horizontal format
# extract the indices corresponding to meanor std values
meanStd_idx <- grep("^.*(std|mean|meanFreq)\\(\\)",features)
colLabels <- cbind(c("subject",features[meanStd_idx],"y"))
dim(colLabels)
#head(features) # to check that the format is as expected



# merge the appropriate cols for the test dataset
# col 1 is the subject, then 561 cols for measurments (as per features.txt), then 1 col y
#class(subject_test)
#class(x_test[,meanStd_idx])
merged_test <- cbind(subject_test,x_test[,meanStd_idx])
merged_test <- cbind(merged_test,y_test)
# same operations on the train dataset
merged_train <- cbind(subject_train,x_train[,meanStd_idx])
merged_train <- cbind(merged_train,y_train)
# now delete some variables that we do not use anymore, to free memory
dim(merged_test)
dim(merged_train)
#rm(subject_test, x_test, y_test)
#rm(subject_train, x_train, y_train)
# merging the two datasets: test set forms top rows, below comes train sets
merged <- data.frame(rbind(merged_test,merged_train))
dim(merged)
# now delete some variables to free memory
#rm(merged_train,merged_test)
#set labels
colnames(merged) <- t(colLabels)
head(merged, n = 10L) # just to check


# 3 Uses descriptive activity names to name the activities in the data set
# this means that instead of figures 1:6 in y column, we use the textual definition
# which is provided in activity_labels.txt
# 1 WALKING 2 WALKING_UPSTAIRS 3 WALKING_DOWNSTAIRS 4 SITTING 5 STANDING 6 LAYING
# as there are only 6 values, I do it manually

merged[merged$y == 1,'y'] <- "WALKING"
merged[merged$y == 2,'y'] <- "WALKING_UPSTAIRS"
merged[merged$y == 3,'y'] <- "WALKING_DOWNSTAIRS"
merged[merged$y == 4,'y'] <- "SITTING"
merged[merged$y == 5,'y'] <- "STANDING"
merged[merged$y == 6,'y'] <- "LAYING"

head(merged, n = 10L) # to check

# 4 Appropriately labels the data set with descriptive variable names.
# Already done above, when I have subsetted the mean and std columns

# 5 From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
#
# From the lecture, tidy means:
# exactly 1 variable per column
# 1 observation per row
# 1 table per kind of variable
# Use of a key to link the tables if there are several tables
# use a header row with variable names, without any acronym
# save into 1 file per table
#
# Here, all measurements are homogeneous (same number of values), so I'll use a single table
#
# I run a loop to build the tidy dataset
# subset variable values for a given activity
# example: subset(merged, y=="WALKING" & subject==1)
tidy <- NULL

# TODO : check if the for loop preserve order !
# Current version not elegant. There is probably a better way than the loops
for (subj in 1:30) {
  for (activity in c(
    "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
  )) {
    subsetPerSubjectActivity <-
      subset(merged,y == activity & subject == subj)
    means <- NULL
    # as col 1 and 81 are the subject and activity respectively, I calculate the mean on the
    # remaining columns
    means <-
      colMeans(subset(subsetPerSubjectActivity,select = colLabels[2:80]))
    # I add the calculated means to the tidy dataset
    tidy <- rbind(tidy, c(subj,activity,means))    
  }
}
# setting column names appropriately
colnames(tidy) <- cbind(t(c("subject",'activity')),t(colLabels[2:80]))
head(tidy, n = 15L) # just to check
dim(tidy) # just to check

# saving the tidy dataset into a file
#dput(tidy, file = "./tidy.txt")
write.table(tidy, file="tidy.txt", row.name=FALSE)