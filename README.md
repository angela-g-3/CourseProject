CourseProject README
=============

This README file describes the materials provided and summarizes stages of transformation in the run_analysis.R script file.


## Directory setup and materials provided
Users should have the *UCI HAR Dataset* in the working directory of R.  The *run_analysis.R* file should be in that same working directory.  The *CourseProject.txt* file describes where each of the variable parts in the *run_analysis.R* file come from and the output to be expected.  Column names in the resulting tidy data set are included at the end of that file.

## run_analysis.R file
The file  explicitly uses the *features.txt* file of the dataset for the column names of the created dataset.  Subject info, activities completed, and measurements recorded come from the test and train folders.  The *run_analysis* file creates the tidy set through 6 main steps (as organized in the file) and a library call for the data.table package in R (this is done immediately as the file is sourced).

**1.**  In step one, variable names for the columns are read into R.

**2.**  In step two, the six data files are read into R.  Measurement names are immediately added for column names in the measurement sets (*trainX* and *testX*).  The activity measurements are also converted into factors with the six activity labels at this stage (*trainYF* and *testYF*).  This second step results in the pieces that will be pieced together into the resulting data frame.

**3.** In step three the six blocks from part two are merged into one data set.  First the training set is created, then the test set, with the cbind function in two stages.  In the first stage the subject and activities are put into a data frame (with subject as the first column and activity as the second) and column names are added.  In the second stage this merged data frame has the measurements piece added (on the left) again via the cbind function.  At this stage all columns have labels and both data frames have equal column names.

Lastly in this step, these two data frames are stacked on top of each other (via rbind) with the training set on top of the test set.  This data frame is stored as *untidyData1.* 

**4.** The entire data frame is now subset, retaining only the columns that have a "mean" or "std" measurement in them (as indicated by the name in features.txt).  The grep function is used to find these columns in each case (mean in *vM,* std in *vS*).  These vectors are coerced into a single vector *vA* (along with the first two columns which we need to keep as well) and then *vA* is ordered numerically and stored by the same name.

Then, in the second part, *untidyData2* is created as the appropriate subset of *untidyData1* using the reference columns from *vA.*

**5.**  In step five, multiple observations for the same subject in the same activity are summarized by their mean value after converting the *untidyData2* into a data table (to which lapply can be applied) called *tidyTable.*  The resulting *tidyTable* now contains one row for each column for each activity where the measurement values are the means of all the corresponding measurement values for that subject for that activity.  The data set has shrunk down significantly in row numbers, but still has more rows than columns (to be tall and narrow).

**6.**  The last step writes the *tidyTable* into a text file **"TidyDataResult.txt"** (with row.names = FALSE) which will be found in the working directory after the script is sourced to R. 




