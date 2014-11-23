### Introduction
 This is the project submission for Getting and Cleansing Data of Data Scientist Track.

### contents of the Repository
 * run_analysis.R - script file that is used to produce the tidy dataset
 * README.md - README file
 * codebook.md -  code book
 
### Steps used to solve
THis repo contains a script run_analysis.R that will attempt to download the data file
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
File downloaded to a location as indicated by base_dir.
 * Modify base_dir to a directory of your choice
 * Downloaded zip file is extracted to UCI HAR Dataset directory
 * x_ files in train and test read, combined with y_ files which have the activity and also subject_files
 
 * features.txt file which has the list of features are also read 
 * columns that contain mean and std in the features.txt are sourced from the dataset.
 * activity_labels.txt contains description of each activity like WALKING, SLEEPING etc and are read
 * finally data from the observation files, subject data, activity data is merged with activity labels
 * data from the above data set is group by subject_id, activity_name to get the mean of all the observations to produce a tidy datset wide form.
 * This wide dataset is written to a tidy_final.txt in the download directory.
 
 ### Dependencies
  * requires reshape2 package
  * requires data.table package