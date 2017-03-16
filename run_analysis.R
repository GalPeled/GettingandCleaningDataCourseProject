## validate requierd packege are install and add 
## chacke if the dplyr packege is install if not install after user approvel for summery
ValidateDplyrPackage <- function(){
  list.of.packages <- c("dplyr")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)){
    print("The dplyr packege is a requierd package for this Function to work")
    install_Package <- menu(title = 'Should I automaticly install the package now?',choices = c("Yes","No"))
    if(install_Package)
    {
      suppressMessages(install.packages(new.packages))
    }
    else
    {
      return(FALSE)
    }
  }
  suppressMessages(library(dplyr))
  return(TRUE)
} 

##downloud file if need

DownloadAndUnzipAssigmentFileIfNeede<-function()
{
  fileName<- "Assigment_Data.zip"
  ##chack to see that we didnt allredy downlode and unzip the file 
  if (!file.exists("UCI HAR Dataset")) {
    if(!file.exists(fileName))
    {
      fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileURL,fileName,mode = "wb")
    }
    unzip(fileName) 
  }
}

## get relevant Tables
GetRequierdFeatures <- function()##get Features table and change vars Names
{
  features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
  requireMeasurements  <- grep(".*mean.*|.*std.*", features[,2])
  requireMeasurements  <- features[requireMeasurements,]
  colnames(requireMeasurements) <- c("Position","Name")
  requireMeasurements$Name <- gsub('-mean', 'Mean', requireMeasurements$Name)
  requireMeasurements$Name <- gsub('-std', 'Std', requireMeasurements$Name)
  requireMeasurements$Name <- gsub('[-()]', '', requireMeasurements$Name)
  requireMeasurements$Name <- gsub('^t',"Time", requireMeasurements$Name)
  requireMeasurements$Name <- gsub('^f',"Freq", requireMeasurements$Name)
  requireMeasurements$Name <- gsub('BodyBody',"Body", requireMeasurements$Name)
  return(requireMeasurements)
}
## Get The Activity Lables
GetActivityLabels <- function()
{
  activityLable<-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
  colnames(activityLable) <- c("key","Name")
  return(activityLable)
}
##Get a DataSet train or test by data Name
GetDataSetByName <- function(dataName,requireMeasurements)
{
  fileLocations<-Files<-c("UCI HAR Dataset/train/X_train.txt","UCI HAR Dataset/train/y_train.txt","UCI HAR Dataset/train/subject_train.txt")
  if(dataName == "test")
  {
    fileLocations<-gsub("train","test",fileLocations)
  }
  expData <- read.table(fileLocations[1])[requireMeasurements$Position]
  expActivities <- read.table(fileLocations[2])
  expSubject <- read.table(fileLocations[3])
  colnames(expData) <- requireMeasurements$Name
  colnames(expActivities)<-c("Activities")
  colnames(expSubject) <- c("Subject")
  combineData <- cbind(expSubject,expActivities,expData)
  return(combineData)
}

##mearge the data set and change string to factors 
CombineTrainAndTestDataSet <- function(trainDS,testDS)
{
  fullData <- rbind(trainDS,testDS)
  activityLables <- GetActivityLabels()
  fullData$Activities <- factor(fullData$Activities, labels = activityLables$Name)
  fullData$Subject <- as.factor(fullData$Subject)
  return(fullData)
}
#get the Summerys data using dplyr packege
SummerisData<-function(fullData)
{
    fullData %>%
    group_by(Subject,Activities)%>%
    summarise_each(funs(mean))
}
## the run_analysis trigger the rest of the function and return mean of data by subject and activity
RunAnalysis <- function()
{
  ValidateDplyrPackage()
  DownloadAndUnzipAssigmentFileIfNeede()
  requireMeasurements <- GetRequierdFeatures()
  trainDS <- GetDataSetByName("train",requireMeasurements)
  testDS <- GetDataSetByName("test",requireMeasurements)
  fullData <- CombineTrainAndTestDataSet(trainDS,testDS)
  summData <- SummerisData(fullData)
  return(summData)
}