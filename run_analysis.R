########################################################
## CourseProject R script to create a tidy data set
## from the provided Samsung data: SamsungMakeTidy.R
## Assumes the data is contained in the working directory
## within R.  More details about what the user should
## encounter within these files is contained in the 
## readme.txt document.

## 0: library(data.table) for use later in the script
library(data.table)

## 1: Read the variable names in from features in order to rename
## the columns in the measurements in the X_test files
varNames<-read.table("./UCI HAR Dataset/features.txt")

## 2: Read the data files into R
##    & at the same time, replace variable names and identify activities in the
##    X and Y files
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = varNames$V2)
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainY2 <- unlist(trainY)
trainYF <- factor(trainY2, labels = c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Lying Down"))

testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = varNames$V2)
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
testY2 <- unlist(testY)
testYF <- factor(testY2, labels = c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Lying Down"))

## 3: Merge the data into a single data set
## part 1, merge the training data set into one set: subject, activity, measurements
train1 <- cbind(trainSubject, trainYF)
colnames(train1) <- c("Subject", "Activity")
train2 <- cbind(train1, trainX)
## part 2, merge the testing data set into one set: subject, activity, measurements
test1 <- cbind(testSubject, testYF)
colnames(test1) <- c("Subject", "Activity")
test2 <- cbind(test1, testX)
## part 3, merge the two entire data sets into one set, with training data before the 
## testing data
untidyData1 <- rbind(train2, test2)

## 4: Select relevant column data, i.e., columns with "mean" or
## "std" in the name.
## part 1, generate the vector needed to properly index these 
## columns, (and to keep the first two of subject and activity)
C <- colnames(untidyData1)   
vM <- grep("mean",C)
vS <- grep("std",C)
vA <- c(1, 2, vM, vS)
vA <- sort(vA)

## part 2, subset the data frame by these relevant data
## store the subset as the new untidy data version
untidyData2 <- untidyData1[, vA]

## 5: Convert the data frame to a data table, and generate
## summary mean and standard deviation values for each subject
## by activity (condensing the number of rows in the original
## data frame so that there is only one row for a subject in a 
## given activity)

untidyDT <- data.table(untidyData2)
tidyTable <- untidyDT[,lapply(.SD,mean), by=list(Subject,Activity)]

## 6: Finally, print the tidy (or at least "tidier") data set to a
## text file in the working directory by using the write.table 
## function
write.table(tidyTable, file = "TidyDataResult.txt",row.name=FALSE)




