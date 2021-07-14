
The Fragile Families Challenge
Version: 19 June 2018

This zipped folder contains three comma-separated values files, a text codebook file, a Stata .dta file that contains the data with variable and value labels, and a text file identifying features that are constant.

The files are not exactly the same as those used in the main Fragile Families Challenge. Based on participant feedback, we have improved the variable names and improved missing data codes.

We have also improved the metadata that provides information about the features included.
- For a user-friendly metadata platform, visit http://fragilefamiliesmetadata.org
- To access the metadata API, visit http://api.fragilefamiliesmetadata.org/
- To access the metadata from R, see the R package at https://github.com/fragilefamilieschallenge/ffmetadata

You should also refer to the full documentation at http://www.fragilefamilies.princeton.edu/ for questionnaires and more detailed information.

As you work, we encourage you to follow our code reproducibility guidelines <http://www.fragilefamilieschallenge.org/computational-reproducibility-and-the-fragile-families-challenge-special-issue/>. This is optional.

It is common to have trouble with your first submission. We recommend closely following the guidelines at <http://www.fragilefamilieschallenge.org/upload-your-contribution/> when uploading your first submission.

The remainder of this document summarizes the files.

************

background.csv contains 4,242 rows (one per family) and 13,027 columns
background.dta contains the same information, plus variable and value labels, in a Stata data file.

These files contain:

challengeID: A unique numeric identifier for each child.

13,026 background variables asked from birth to age 9, which you may use in building your model.

Full documentation is at http://www.fragilefamilies.princeton.edu/
An intro to the documentation is at http://www.fragilefamilieschallenge.org/survey-documentation/

************

train.csv contains 2,121 rows (one per child in the training set) and 7 columns.

These are the outcome variables measured at approximately child age 15, which you can use to train your models.

The file contains:

challengeID: A unique numeric identifier for each child.

Six outcome variables. Blog posts about the outcomes are available at http://www.fragilefamilieschallenge.org/blog-posts/

Continuous variables: grit, gpa, materialHardship

Binary variables: eviction, layoff, jobTraining

************

prediction.csv contains 4,242 rows and 7 columns

This file is provided as a skeleton for your submission; you will submit a file in exactly this form but with your predictions for all 4,242 children included.

The file contains:

challengeID: A unique numeric identifier for each child.

Six outcome variables, as in train.csv. These are all filled with the mean value in the training set.

************

codebook_FFChallenge.txt is a text file that contains the codebook for all variables in the Challenge data file. This combines several codebooks from the main Fragile Families and Child Wellbeing Study documentation.

************

constantVariables.txt gives the column names of variables that are constant in the data. Some of these variables are constant because they have been redacted out of concern for the privacy of respondents. We have included them in the data file so that, if you are looking for a particular variable from the documentation, you can find it somewhere in the data. However, these variables contain no information. We recommend that the first step in any analysis be to remove the variables that are constant.