## Create one R script called run_analysis.R that does the following.
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Include necessary package
library(reshape2)

# Load labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Load mean and standard deviation
features_mean_std <- grep(".*mean.*|.*std.*", features[,2])
features_mean_std.names <- features[features_mean_std,2]
features_mean_std.names = gsub('-mean', 'Mean', features_mean_std.names)
features_mean_std.names = gsub('-std', 'Std', features_mean_std.names)
features_mean_std.names <- gsub('[-()]', '', features_mean_std.names)

# Load train
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_mean_std]
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_y, train)

# Load test
test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_mean_std]
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_y, test)

# Combine datasets and add labels
combined_data <- rbind(train, test)
colnames(combined_data) <- c("subject", "activity", features_mean_std.names)

# Factoring
combined_data$activity <- factor(combined_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
combined_data$subject <- as.factor(combined_data$subject)

combined_data.melted <- melt(combined_data, id = c("subject", "activity"))
combined_data.mean <- dcast(combined_data.melted, subject + activity ~ variable, mean)

# Write output csv
write.table(combined_data.mean, "tidy_data.csv", sep = ",")

