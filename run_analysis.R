filename <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(filename))
{
  download.file(fileurl,filename)
}

if (!file.exists("UCI HAR Dataset")) 
{ 
  unzip(filename) 
}

#Extracting Features
features <- read.table("UCI HAR Dataset/features.txt")

#Reading the data
#Training Set
Trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
Trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
Train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
#Testing Set
Testx <- read.table("UCI HAR Dataset/test/X_test.txt")
Testy <- read.table("UCI HAR Dataset/test/y_test.txt")
Test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

##1
#Merging the data sets
Merged <- rbind(cbind(Train_subject,Trainx,Trainy),cbind(Test_subject,Testx,Testy))
colnames(Merged) <- c("subject",as.character(features$V2),"activity")

##2
#Extracts only the measurements on the mean and standard deviation for each measurement
Mergednew <- Merged[,grepl("subject|mean|std|activity",names(Merged))]


##3
#descriptive activity names to name the activities in the data set
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
Mergednew$activity <- factor(Mergednew$activity, levels = activity[,1], labels = activity[,2])
Mergednew$subject <- factor(Mergednew$subject)

##4
#Appropriately labels the data set with descriptive variable names
names(Mergednew)<-gsub("^t", "Time", names(Mergednew))
names(Mergednew)<-gsub("^f", "Frequency", names(Mergednew))
names(Mergednew)<-gsub("Acc", "Accelerometer", names(Mergednew))
names(Mergednew)<-gsub("Gyro", "Gyroscope", names(Mergednew))
names(Mergednew)<-gsub("Mag", "Magnitude", names(Mergednew))
names(Mergednew)<-gsub("BodyBody", "Body", names(Mergednew))

##5
#independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
tidy_data <- Mergednew %>% group_by(subject,activity) %>% summarize_all(funs(mean))

write.table(tidy_data, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
