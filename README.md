---
title: "Codebook for Getting and Cleaning data project"
author: "Gilles Bertrand"
date: "July 20th 2015"
---

This readme file explains the choices made in the run_analysis.R  script to extract a tidy dataset from the raw data set.

## Project Description
This project answers the project assignment from "Coursera getting and cleaning data"
Specifically, it transforms a raw data set into a tidy dataset.


Files: 
 - README.md - general description of the project
 - codebook.txt - the present file
 - run_analysis.R - script transforming the raw data into a tidy dataset
 - tidy.txt - the tidy dataset

## Interpretation of the project instructions 

### Original instructions 
You should create one R script called run_analysis.R that does the following. 

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names. 

    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Explanation of the script 
lines 1-25 configure the working directory and run the garbage cleaner to save memory
lines 26-45 read the raw data set from txt files and load it into matrices
lines 46-52 display the dimensions of the matrices
lines 53-68 read the feature.txt file to identify the labels of the colums in the raw data set. They also identify the subset of features that match mean and standard deviation variables, as requested in the project instructions.
lines 69-93 merge the test and train datasets, and label the columns with appropriate variable descriptions
lines 94-109 convert the activity values (1:6) to textual definitions, as provided in the activity_labels.txt from the raw dataset
lines 11-155 build the tidy dataset by computing the means per column, per subject and activity.

### Choices and assumptions
I have considered that the columns to be kept in the tidy dataset where the ones whose name end by std(), mean (), or meanFreq().
I have identified the column "y" from the raw dataset as being activities because values ranged from 1 to 6
To merge the test and train datasets, I have based on the matching dimensions of the datasets. 
I have not used the data in "Inertial Signals" subfolders


