# Data Science Specialization - Getting and Cleaning Data Course Project

This is the course project for the Getting and Cleaning Data course.
The `run_analysis.R` script performs the following operations:

1. Downloads the data unless it already exists in the working directory
2. Loads the features and activity labels
3. Loads training and test datasets, discarding columns not related to a mean or standard deviation
4. Adds subject and activity variables to the previous datasets
5. Merges the training and the test sets to create one data set
6. Converts the *activity* variable integer values to self-explanatory string values
7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. This data set will be stored in *tidy_data.csv*
