library(dplyr)
library(plyr)

n <- 19

trainData <- read.csv("train/X_train.txt",sep = "",header = F)
testData <- read.csv("test/X_test.txt",sep = "",header = F)
featuresNames <- read.csv("features.txt",sep = "",header = F,stringsAsFactors = F)

colnames(trainData) <- featuresNames[,2]
colnames(testData) <- featuresNames[,2]

featuresMeans <- grep("mean\\(\\)",featuresNames[,2])
featuresStd <- grep("std\\(\\)",featuresNames[,2])

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
features.ms <- c(featuresMeans,featuresStd)
trainData.ms <- trainData[,features.ms]
testData.ms <-testData[,features.ms]
trainData.ms$"VolunteerType" <- rep("train",length(trainData.ms[,1]))
testData.ms$"VolunteerType" <- rep("test",length(testData.ms[,1]))

## 1. Merges the training and the test sets to create one data set.
mergedData <- rbind(trainData.ms,testData.ms)
mergedData[1,]

## Uses descriptive activity names to name the activities in the data set
activites <- read.csv("activity_labels.txt",sep = "",header = F,stringsAsFactors = F)
activites <- activites[,2]
actTrain <- as.numeric(readLines("train/y_train.txt"))
actTrain <- sapply(actTrain,function(x) activites[x])
actTest <- as.numeric(readLines("test/y_test.txt"))
actTest <- sapply(actTest,function(x) activites[x])
activities <- c(actTrain,actTest)
mergedData$"activity" <- activities
mergedData[1,]

## Appropriately labels the data set with descriptive variable names
processedNames <- gsub("[\\(|\\)|-]","",colnames(mergedData))
processedNames <- gsub("mean"," mean ",processedNames)
processedNames <- gsub("std"," std ",processedNames)
colnames(mergedData) <- processedNames
mergedData[1,]

## From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable 
## for each activity and each subject.
trainSubNum <- as.numeric(readLines("train/subject_train.txt"))
testSubNum <- as.numeric(readLines("test/subject_test.txt"))
subject <- c(trainSubNum,testSubNum)
mergedData$"subject" <- subject

order <- c( (length(mergedData)-2):length(mergedData),1:(length(mergedData)-3))
mergedData <- mergedData[,order]
mergedData[1:3,]


meanVals <- lapply(split(mergedData,list(mergedData$activity,mergedData$subject)),function(x) colMeans(x[4:length(x)]))

meanVals <- as.data.frame(meanVals)
meanVals <- t(meanVals)

##write.table(meanVals,)
actNSubjLabels <- strsplit(rownames(meanVals),"\\.")
actNSubjLabels <- as.data.frame(actNSubjLabels)

subject <- actNSubjLabels[2,]
activity <- actNSubjLabels[1,]
labels <- cbind(t(activity),t(subject))
processedData <- cbind(labels,meanVals)
colnames(processedData)[1:2] <- c("activity","subject") 
processedData <- as.data.frame(processedData)
for (i in 3:length(processedData)) {
        processedData[,i] <- as.numeric(paste(processedData[,i]))
}
sapply(processedData,class)
write.table(processedData,"humanActivityTidyData.txt",row.names = FALSE)
