#set your own working directory
#here is my setwd() on windows 10
dir<-"d:\\clean_data\\project"
setwd(dir)

#Load the file zip file of the project
if (!file.exists("./data")) {dir.create("./data")}
url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url,destfile="./data/UCI HAR Dataset.zip")

#Unzip the UCI HAR Dataset.zip file which is in ./data directory

######################################################################################
#Task 1:  Join the training and the test sets to create one data set.
######################################################################################

#Read training data + training labels 
training_set <- read.table("./data/UCI HAR Dataset/train//X_train.txt")
training_label <- read.table("./data/UCI HAR Dataset/train/y_train.txt")


#Readtest set + test  labels 
test_set <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_label <- read.table("./data/UCI HAR Dataset/test/y_test.txt")


#Read subject train +  subject test
subject_train<- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")


#join training  and test tables by row
train_test_set<-rbind(training_set,test_set)
#join training and test labels by row
train_test_label<-rbind(training_label,test_label)
#join subject_train and subject test by row
subject_train_test <- rbind(subject_train,subject_test)

######################################################################################
#Task 2:  Extracts only the measurements on the mean and standard deviation 
#         for each measurement .
#         1/ select the index of each row of features that match mean() or sd(). 
#         2/ select the columns of train_test_set  with the index.
#         3/ mamed the columns 
######################################################################################
features <- read.table("./data/UCI HAR Dataset/features.txt")
select_mean_std_index <- grep("mean\\(\\)|std\\(\\)", features$V2)
mean_std_train_test <-train_test_set[,select_mean_std_index]
names(mean_std_train_test)<-features[select_mean_std_index, 2]


######################################################################################
#Task 3:  Uses descriptive activity names to name the activities in label table 
#         
#
######################################################################################
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activity_label <- activity[train_test_label[, 1], 2]
train_test_label[, 1] <- activity_label
names(train_test_label)<-"activity"

######################################################################################
#Task 4:   Appropriately labels the data set with descriptive variable names.
#         
######################################################################################
names(subject_train_test) <- "subject"
mean_std<- cbind(subject_train_test, train_test_label, mean_std_train_test)
write.table(mean_std, "./data/join_mean_std.txt") 

######################################################################################
#Task 5:   tidy data set with the average of each variable for each activity and each subject.
#         
######################################################################################
library(dplyr)
mean_std_g<-group_by(mean_std, subject, activity)
tidy_t <-summarise_each(mean_std_g, funs(mean))
#save table
write.table(tidy_t, "./data/data_group_means.txt") 


