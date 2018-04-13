##Set your Working Directory
##Install dplyr library
library(dplyr)
##Create data directory and download the data
fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        if (!file.exists("data")) {
        dir.create("data")
        }
        download.file(fileurl, destfile = "./data/UCI HAR Dataset.zip", mode = "wb")
        unzip("./data/UCI HAR Dataset.zip", exdir = "./data")
##Read all data files into tables
xtest_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
xtrain_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytest_data <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
ytrain_data <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
stest_data <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
strain_data <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
##rbind data frames and remove originals
x_data <- bind_rows(xtest_data, xtrain_data)
        rm(xtest_data, xtrain_data)
y_data <- bind_rows(ytest_data, ytrain_data)
        rm(ytest_data, ytrain_data)
s_data <- bind_rows(stest_data, strain_data)
        rm(stest_data, strain_data)
##Get x_data variable names as character vector
x_features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE) 
x_names <- x_features$V2
## Replace x_data colnames with x_names
names(x_data) <- x_names
##replace y_data colname with "activity"
names(y_data) <- c("activity_num")
##replace s_data colname with "subject"
names(s_data) <- c("subject")
##cbind all three data frames into one and remove individual data frames
df <- cbind(s_data, y_data, x_data)
        rm(s_data, y_data, x_data)
##replace row values in "activity" column with activites and make column names lower case
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")        
names(activity)[names(activity) == "V2"] <- "activity"
df <- merge(activity, df, by.x = "V1", by.y = "activity_num", all.x = TRUE)
df <- df[,2:564]
names(df) <- tolower(names(df))
##select only mean and standard deviation for measurements and write table
tidydata_1 <- select(df, 2, 1, contains("mean()"), contains ("std()"))
write.table(tidydata_1, "./tidydata_1.txt")
##Arrange by subject and activity and return mean for all variables
tidydata_2 <- tidydata_1 %>%
        group_by(subject, activity) %>%
        summarise_all(mean)
write.table(tidydata_2, "./tidydata_2.txt", row.name = FALSE)