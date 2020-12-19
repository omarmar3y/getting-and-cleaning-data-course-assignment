library(dplyr)
## setwd() to the directory where you want to download the data
filename <- 'uci_dataset.zip'
if(!file.exists(filename)){
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',filename,method = 'curl')
}
  
unzip(filename)

xtrain <- read.table('UCI HAR Dataset/train/X_train.txt')
ytrain <- read.table('UCI HAR Dataset/train/y_train.txt')
subtrain <- read.table('UCI HAR Dataset/train/subject_train.txt')

xtest <- read.table('UCI HAR Dataset/test/X_test.txt')
ytest <- read.table('UCI HAR Dataset/test/y_test.txt')
subtest <- read.table('UCI HAR Dataset/test/subject_test.txt')

train_set <- cbind(xtrain,ytrain,subtrain)
test_set <- cbind(xtest,ytest,subtest)
full_set <- rbind(train_set,test_set)

features <- read.table('UCI HAR Dataset/features.txt')
mean_std_indx <- grep('mean|std',features[[2]])
mean_std_indx_act_sub <- c(mean_std_indx,562,563)

mean_std_set <- full_set[,mean_std_indx_act_sub]
names(mean_std_set) <- c(features[mean_std_indx,2],'activity','subject')

acts <- read.table('UCI HAR Dataset/activity_labels.txt')
mean_std_set$activity <- factor(mean_std_set$activity,levels = acts$V1,labels = acts$V2)

means_set <- mean_std_set %>% group_by(activity,subject) %>% summarise_all(.funs =mean)
