
        
library(data.table)
library(reshape2)

## drop it in a directory of your choice ## may need updated..
#download_dir <- "/users/rnarasim/Downloads/UCI HAR Dataset";
base_dir <- "/users/rnarasim/Downloads/getdata-009";
download_dir <- paste(base_dir, "/UCI HAR Dataset", sep="")

datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataFile <- paste(download_dir, "/UCI HAR Dataset.zip", sep="")

### will create a directory if the directory to work does not exist... ####
if ( ! file.exists(download_dir))
{
        dir.create(download_dir)
}



download.file(datasetURL, dataFile, method = "curl")
unzip(dataFile, exdir=download_dir);

# read activity labels and load them into data frame that is needed to decode activity id. 
# this is  needed only once and used to decode y_train and y_test files
activity_labels <- read.csv(paste(download_dir,"/activity_labels.txt", sep=""), header=FALSE, sep="")
names(activity_labels) <- c("activity_id", "activity_description")

# read the file that has all the features that are being measured and are found in the x_train and x_test

features<-read.csv(paste(download_dir,"/features.txt", sep = ""),header=FALSE, sep="")
# set the column names
names(features) <- c("columnid", "columnname")

# look and grab the column id that we will be interested using a regex grep
interested_columns <- grep( "std|mean", features$columnname)

# we grab the column names that will be used as column names.
interested_column_names <- grep( "std|mean", features$columnname, value = TRUE)

# read in observations on all the features.
x_train<-read.csv(paste(download_dir,"/train/x_train.txt", sep = ""),header=FALSE, sep="")
x_test<-read.csv(paste(download_dir,"/test/x_test.txt", sep = ""),header=FALSE, sep="")

# read in the activity id ( SLEEP, WALK etc )
y_train<-read.csv(paste(download_dir,"/train/y_train.txt", sep = ""),header=FALSE, sep="")
y_test<-read.csv(paste(download_dir,"/test/y_test.txt", sep = ""),header=FALSE, sep="")

# read in the subjects on whom the measures were taken.
train_subject<-read.csv(paste(download_dir,"/train/subject_train.txt", sep = ""),header=FALSE, sep="")
test_subject<-read.csv(paste(download_dir,"/test/subject_test.txt", sep = ""),header=FALSE, sep="")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(train_subject, test_subject)

# grab the interested columns - columns which have mean or std in their feature name.
x_data_interested <- x_data[,interested_columns]

# set the names of the columns 
names(x_data_interested) <- interested_column_names

# bind the subject, activity id
train_subject_position <- cbind(subject_data, y_data,x_data_interested)
# set the column names
names(train_subject_position) <- c("subject_id","activity_id", interested_column_names)

# merge the train_subject_position with activity_labels
# this is the final data set
train_final<- merge(train_subject_position, activity_labels, by.x="activity_id", by.y="activity_id")

# the melt the final data set...
Molten<-melt(train_final, id.vars=c("activity_id", "subject_id", "activity_description"))

# build the tidy data set with average of each activity
tidy_final <- dcast(Molten, subject_id+ activity_description ~ variable, mean)
write.table(tidy_final, file=paste(download_dir,"/tidy_final.txt", sep=""),row.name=FALSE)

View(tidy_final)