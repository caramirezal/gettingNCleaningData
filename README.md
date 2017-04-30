# gettingNCleaningData

Contains script to process data colected from acelerometers of Samsung Galaxy S smartphones 
and the resulting processed tidy data.

The ProcessData.R contains the code to process the data contained in the "UCI HAR Dataset" 
directory. The script most be executed using this directory as the working space.

The humanActivityTidyData.txt file contains the processed date output of executing
the run_analysis.R script.

The variables included in the table contained in the humanActivityTidyData.txt file are the
following:

activity: The experimental physical activity measured from the subject. It is a cathegorical
value variable.

subject: the index of the experimental subject. It is a integer value from 1 to 30.

Features mean: the mean values for each activity and each subject of the corresponding feature.
For example, in the third column "tBodyAcc mean X" indicated the mean value for the tBodyAcc
measured for the x-axis by the acelerometer. For more information, see the features_info.txt
in the "UCI HAR Dataset" directory.

Features std: analogous to the Features mean variables but in this case the standard deviation
is used instead of the mean.




