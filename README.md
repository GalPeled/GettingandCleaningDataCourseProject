# Getting and Cleaning Data - Course Project
This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

  1. Download and use the dplyr libary 
  2. Download and unzip the course project data set 
  3. Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
  4. Loads the activity and subject data for each dataset, and merges those columns with the dataset
  5. Merges the two datasets
  6. Converts the activity and subject columns into factors
  7. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
  
  
  The end result is shown in the file tidy.txt.
  
  
## How To use the run_analysis.R file

  1. download the run_analysis.R file 
  2. in R add The File using source('FileLocation/run_analysis.R')
  where File Location is the location of the run_analysis.R file that was download
  3. call the RunAnalysis() function 