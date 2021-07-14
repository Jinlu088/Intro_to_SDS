
# Example Fragile Families Challenge data processing steps
# to produce a data file that can be used in predictive models.
# Author: Ian Lundberg

print("This code will save simplified version of the Fragile Families Challenge data, containing only a few variables and for which missing values of the background variables are imputed.")
print("We prepared this code on R version 4.0.3.")
print("")
print("To use this code, do the following:")
print("1. Register for and download FFChallenge_v5 from the OPR Data Archive")
print("2. Unzip the folder FFChallenge_v5.")
print("3. Set your working directory within R to the directory that contains the folder FFChallenge_v5")
print("Do this by typing setwd('your_directory') in your R console.")
print("4. Run this code by typing prepare_simple_data()")
print("The output (example_prepared_data) will appear in your FFChallenge_v5 folder")
set.seed(08544)
prepare_simple_data <- function() {
  print("Step 1 / 5. Load required packages: tidyverse (1.3.0), haven (2.3.1), Amelia (1.7.5)")
  # Load required packages
  has_tidyverse <- suppressMessages(require(tidyverse, quietly = T))
  if (!has_tidyverse) {
    stop("ERROR: This function requires the tidyverse package. To install, type install.packages('tidyverse')")
  }
  has_haven <- suppressMessages(require(haven, quietly = T))
  if (!has_haven) {
    stop("ERROR: This function requires the haven package. To install, type install.packages('haven')")
  }
  has_Amelia <- suppressMessages(require(Amelia,warn.conflicts = F, quietly = T))
  if (!has_Amelia) {
    stop("ERROR: This function requires the Amelia package. To install, type install.packages('Amelia')")
  }

  print("Step 2 / 5. Load data: FFChallenge_v5/train.csv and FFChallenge_v5/background.dta")
  # Get files in this directory
  if (!any(list.files() == "FFChallenge_v5")) {
    stop("ERROR: This code requires that the folder FFChallenge_v5 is in the current working directory. You can download that folder from the OPR Data Archive / Fragile Families and Child Wellbeing Study / Fragile Families Challenge / FFChallenge_v5")
  }
  if (!all(c("train.csv","background.dta") %in% list.files("FFChallenge_v5"))) {
    stop("ERROR: The FFChallenge_v5 folder in this directory needs to contain train.csv and background.dta. You can download these files from the OPR Data Archive / Fragile Families and Child Wellbeing Study / Fragile Families Challenge / FFChallenge_v5")
  }
  # Load data
  train <- read_csv("FFChallenge_v5/train.csv", col_types = "ddddddd")
  background <- read_dta("FFChallenge_v5/background.dta")

  print("Step 3 / 5. Prepare variables")
  # Prepare a simple dataset with a few key variables, for which we will impute missing values
  to_impute <- background %>%
    mutate(caregiver_wave5 = case_when(m5a2 %in% 1:2 ~ "Mother",
                                       f5a2 %in% 1:2 ~ "Father",
                                       cm5pcgrel > 0 ~ as.character(as_factor(cm5pcgrel)),
                                       T ~ "No wave 5 caregiver")) %>%
    # Create some approximate lagged outcomes (used in PNAS paper benchmarks)
    mutate(
      ## For prior measure of GPA, use the teacher report of skills
      ## in language and literacy,
      ## in science and social studies,
      ## and in math,
      ## all coded 1 = far below average to 5 = far above average
      gpa_related_lag_teacher_rating = 1/3 * (ifelse(t5c13a > 0, t5c13a, NA) +
                                                ifelse(t5c13b > 0, t5c13b, NA) +
                                                ifelse(t5c13c > 0, t5c13c, NA)),
      ## For grit, use teacher reports of:
      ## Child persists in completing tasks
      ## Child fails to finish things he or she starts (reverse coded)
      ## Child does not follow through on instructions and fails to finish homework
      grit_related_lag_teacher_rating = 1 / 3 * (ifelse(t5b2b > 0, t5b2b, NA) +
                                                   ifelse(t5b4y >= 0, 4 - t5b4y, NA) +
                                                   ifelse(t5b4z >= 0, 4 - t5b4z, NA)),
      materialHardship_lagged = ifelse(
        m5a2 %in% c(1,2),
        ## Mother's material hardship
        1 / 10 * (
          ifelse(m5f23a > 0, m5f23a == 1, NA) +
            ifelse(m5f23b > 0, m5f23b == 1, NA) +
            ifelse(m5f23c > 0, m5f23c == 1, NA) +
            ifelse(m5f23d > 0, m5f23d == 1, NA) +
            ifelse(m5f23e > 0, m5f23e == 1, NA) +
            ifelse(m5f23f > 0, m5f23f == 1, NA) +
            ifelse(m5f23g > 0, m5f23g == 1, NA) +
            ifelse(m5f23h > 0, m5f23h == 1, NA) +
            ifelse(m5f23i > 0, m5f23i == 1, NA) +
            ifelse(m5f23j > 0, m5f23j == 1, NA)
        ),
        ifelse(f5a2 %in% c(1,2),
               ## Father's material hardship
               1 / 10 * (
                 ifelse(f5f23a > 0, f5f23a == 1, NA) +
                   ifelse(f5f23b > 0, f5f23b == 1, NA) +
                   ifelse(f5f23c > 0, f5f23c == 1, NA) +
                   ifelse(f5f23d > 0, f5f23d == 1, NA) +
                   ifelse(f5f23e > 0, f5f23e == 1, NA) +
                   ifelse(f5f23f > 0, f5f23f == 1, NA) +
                   ifelse(f5f23g > 0, f5f23g == 1, NA) +
                   ifelse(f5f23h > 0, f5f23h == 1, NA) +
                   ifelse(f5f23i > 0, f5f23i == 1, NA) +
                   ifelse(f5f23j > 0, f5f23j == 1, NA)
               ),
               ## Primary caregiver's material hardship
               1 / 10 * (
                 ifelse(n5g1a > 0, n5g1a == 1, NA) +
                   ifelse(n5g1b > 0, n5g1b == 1, NA) +
                   ifelse(n5g1c > 0, n5g1c == 1, NA) +
                   ifelse(n5g1d > 0, n5g1d == 1, NA) +
                   ifelse(n5g1e > 0, n5g1e == 1, NA) +
                   ifelse(n5g1f > 0, n5g1f == 1, NA) +
                   ifelse(n5g1g > 0, n5g1g == 1, NA) +
                   ifelse(n5g1h > 0, n5g1h == 1, NA) +
                   ifelse(n5g1i > 0, n5g1i == 1, NA) +
                   ifelse(n5g1j > 0, n5g1j == 1, NA)
               ))
      ),
      eviction_lagged = ifelse(m5a2 %in% c(1,2),
                               ifelse(m5f23d <= 0, NA, m5f23d == 1),
                               ifelse(f5a2 %in% c(1,2),
                                      ifelse(f5f23d <= 0, NA, f5f23d == 1),
                                      NA)),
      ## Use whether did work for pay the week of the age 9 interview
      layoff_related_lag_whether_employed = ifelse(m5a2 %in% c(1,2),
                                                   ifelse(m5i4 > 0, m5i4 == 2, NA),
                                                   ifelse(f5a2 %in% c(1,2),
                                                          ifelse(f5i4 > 0, f5i4 == 2, NA),
                                                          NA)),
      jobTraining_lagged = ifelse(m5a2 %in% c(1,2),
                                  ifelse(m5i3b > 0, m5i3b == 1, NA),
                                  ifelse(f5a2 %in% c(1,2),
                                         ifelse(f5i3b > 0, f5i3b == 1, NA),
                                         NA))) %>%
    select(challengeID, caregiver_wave5,
           # Keep the lagged approximate outcomes
           gpa_related_lag_teacher_rating,
           grit_related_lag_teacher_rating,
           materialHardship_lagged,
           eviction_lagged,
           layoff_related_lag_whether_employed,
           jobTraining_lagged,
           # Demographic variables from the first wave
           cm1relf, cm1ethrace, cm1edu, cf1edu,
           # Income / poverty line for mother and father at each wave
           cm1inpov,cm2povco,cm3povco,cm4povco,cm5povco,
           cf1inpov,cf2povco,cf3povco,cf4povco,cf5povco,
           # Standardized child scores on the Peabody Picture Vocabulary Test
           ch3ppvtstd, ch4ppvtstd, ch5ppvtss,
           # Connectedness at school (one example of many scales described here: https://fragilefamilies.princeton.edu/data-and-documentation/scales-documentation-navigator)
           k5e1a, k5e1b, k5e1c, k5e1d) %>%
    # Collapse mother-father relationship status at the birth so that
    # participants using these data will not have a problem of small cells being empty,
    # for instance in bootstrap resamples.
    mutate(cm1relf = case_when(cm1relf == 1 ~ "married",
                               cm1relf == 2 ~ "cohabiting",
                               cm1relf > 0 ~ "other")) %>%
    # Convert some haven_labelled variables to factors
    mutate(cm1ethrace = case_when(cm1ethrace > 0 ~ as_factor(cm1ethrace)),
           cm1edu = case_when(cm1edu > 0 ~ as_factor(cm1edu)),
           cf1edu = case_when(cf1edu > 0 ~ as_factor(cf1edu))) %>%
    # Remove unused factor levels
    mutate_if(is.factor, fct_drop) %>%
    # Mark missing values as NA for the non-factor variables
    mutate_if(function(variable) !is.factor(variable),
              .funs = function(x) case_when(x >= 0 ~ x)) %>%
    # Merge in the outcome variables for use in the imputation of missing values
    left_join(train %>% mutate(set = "train"), by = "challengeID") %>%
    mutate(set = ifelse(is.na(set),"holdout_or_leaderboard",set)) %>%
    # Some factor values have numbers in front of them in the survey data
    # Remove those
    mutate(cm1ethrace = factor(str_replace(cm1ethrace,"^\\d ","")),
           cm1edu = factor(str_replace(cm1edu,"^\\d ","")),
           cm1edu = fct_relevel(cm1edu,"less hs","hs or equiv","some coll, tech","coll or grad"),
           cf1edu = factor(str_replace(cf1edu,"^\\d ","")),
           cf1edu = fct_relevel(cf1edu,"less hs","hs or equiv","some coll, tech","coll or grad"),
           cm1relf = factor(cm1relf))

  print("Step 4 / 5. Impute missing values of background variables")
  # Make one imputation for missing values (single imputation for simplicity)
  imputed <- amelia(data.frame(to_impute),
                    noms = c("cm1relf","cm1ethrace","caregiver_wave5"),
                    ords = c("cm1edu","cf1edu"),
                    idvars = c("challengeID","set"),
                    # The options below will mess up
                    # the variance estimation, but this is simpler and
                    # possibly ok if we only want to make point estimates
                    m = 1, boot.type = "none", p2s = 0)

  # Create one dataset for use in models
  example_prepared_data <- imputed$imputations$imp1 %>%
    # Construct the connectedness scale
    mutate(connectedness_at_school = 1 / 5 * (k5e1a + k5e1b + k5e1c + k5e1d)) %>%
    # Remove the outcomes because we do not want imputed values for the missing cases
    select(-gpa,-grit,-materialHardship,-layoff,-eviction,-jobTraining) %>%
    # Join with the training outcome data so that missing cases are coded as missing
    left_join(train, by = "challengeID")

  print("Step 5 / 5. Save example_prepared_data in three formats: .Rdata, .csv, and .dta")

  save(example_prepared_data,
       file = "FFChallenge_v5/example_prepared_data.Rdata")
  write_csv(example_prepared_data,
            file = "FFChallenge_v5/example_prepared_data.csv")
  write_dta(example_prepared_data,
            path = "FFChallenge_v5/example_prepared_data.dta")

  return("Finished")
}
setwd('/home/porco/Dropbox/Teaching/SummerSchools/OxfordStudyAbroad/Intro_to_SDS/Lectures/lecture_5')
prepare_simple_data()