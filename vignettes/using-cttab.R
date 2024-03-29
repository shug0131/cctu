## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(cctu)

## ----echo=TRUE, message=FALSE, warning=FALSE----------------------------------
data(mtcars)
# Assign variable label
var_lab(mtcars$am) <- "Transmission"

# Assign value label with named vector
val_lab(mtcars$am) <- c("Automatic" = 0, "Manual"=1)
str(mtcars$am)

## ----echo=TRUE----------------------------------------------------------------
summary(mtcars$am)

## ----echo=TRUE----------------------------------------------------------------
# Extract variable label
var_lab(mtcars$am)

# Convert variable to factor with labels attached to it
table(to_factor(mtcars$am))

## ----echo=TRUE, eval=FALSE----------------------------------------------------
#  vars <- c("mpg", "am")
#  # You can do this in the normal data.frame
#  mtcars[,vars]
#  
#  # But you can't do this for the data.table
#  dat <- data.table::data.table(mtcars)
#  mtcars[,vars]
#  
#  # You need to add with=FALSE to do that
#  mtcars[,vars, with=FALSE]

## ----eval = FALSE-------------------------------------------------------------
#  options(cctu_digits = 3) # keep 3 digits for numerical value
#  options(cctu_digits_pct = 0) # keep 0 digits for percentage
#  options(cctu_subjid_string = "subjid") # Set subject ID string
#  options(cctu_print_plot = FALSE) # Don't produce plots

## ----echo=TRUE----------------------------------------------------------------
# Read example data
dt <- read.csv(system.file("extdata", "pilotdata.csv", package="cctu"), colClasses = "character")

# Read DLU and CLU
dlu <- read.csv(system.file("extdata", "pilotdata_dlu.csv", package="cctu"))
clu <- read.csv(system.file("extdata", "pilotdata_clu.csv", package="cctu"))

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Read example data
#  dt_a <- read.csv(system.file("extdata", "test_A.csv", package="cctu"),
#                   colClasses = "character")
#  dt_b <- read.csv(system.file("extdata", "test_B.csv", package="cctu"),
#                   colClasses = "character")
#  
#  # Read DLU and CLU
#  dlu_a <- read.csv(system.file("extdata", "test_A_DLU.csv", package="cctu"))
#  dlu_b <- read.csv(system.file("extdata", "test_B_DLU.csv", package="cctu"))
#  clu_a <- read.csv(system.file("extdata", "test_A_CLU.csv", package="cctu"))
#  clu_b <- read.csv(system.file("extdata", "test_B_CLU.csv", package="cctu"))
#  
#  # Merge dataset with merge_data function
#  res <- merge_data(datalist = list(dt_a, dt_b), dlulist = list(dlu_a, dlu_b),
#                    clulist = list(clu_a, clu_b))
#  dt <- res$data # Extract combined data
#  dlu <- res$dlu # Extract combined DLU data
#  clu <- res$clu # Extract combined CLU data

## ----echo=TRUE----------------------------------------------------------------
# Create subjid
dt$subjid <- substr(dt$USUBJID, 8, 11)

# Apply CLU and DLU files
dt <- apply_macro_dict(dt, dlu = dlu, clu = clu, clean_names = FALSE)

# Give new variable a label
var_lab(dt$subjid) <- "Subject ID"

## ----echo=FALSE---------------------------------------------------------------
# You should read 
set_meta_table(cctu::meta_table_example)
#Create the population table
popn <- dt[,"subjid", drop=FALSE]
popn$safety <- TRUE

create_popn_envir("dt", popn)
.reserved <- ls()

## ----echo=TRUE----------------------------------------------------------------
# Attach population
attach_pop("1.1")

# Extract patient patient registration form and keep subjid variable
df <- extract_form(dt, "PatientReg", vars_keep = c("subjid"))

# Now report Age, Sex and BMI. For BMI, report not white only 
X <- cttab(x = c("AGE", "SEX", "BMIBL"), # Variable to report
           group = "ARM",                  # Group variable
           data = df,                      # Data
           select = c("BMIBL" = "RACEN != 1")) # Filter for variable BMI

# Write table
X

## ----eval=FALSE---------------------------------------------------------------
#  # No grouping
#  X <- cttab(AGE + SEX + BMIBL  ~ 1, data = df)
#  # Group summarise by ARM
#  X <- cttab(AGE + SEX + BMIBL ~ ARM, data = df)
#  # Group summarise by ARM and split by visit cycle
#  X <- cttab(AST + BILI ~ ARM | AVISIT, data = df)
#  # Split by visit cycle
#  X <- cttab(AST + BILI ~ 1 | AVISIT, data = df)

## ----echo=TRUE, eval=FALSE----------------------------------------------------
#  # This will save the missing report under Output folder
#  # Or you can set the output folder and name
#  dump_missing_report()
#  
#  # Pull out the missing report if you want
#  miss_rep <- get_missing_report()
#  
#  # Reset missing report
#  reset_missing_report()

## ----echo=TRUE----------------------------------------------------------------
X <- cttab(x = c("AGE", "SEX", "BMIBL"), # Variable to report
           data = df)                      # Data

X

## ----echo=TRUE----------------------------------------------------------------
X <- cttab(x = c("AGE", "SEX", "BMIBL"), # Variable to report
           group = "ARM",                  # Group variable
           data = df,                      # Data
           select = c("BMIBL" = "RACEN != 1")) # Filter for variable BMI

X

## ----echo=TRUE----------------------------------------------------------------
attach_pop("1.1")
df <- extract_form(dt, "Lab", vars_keep = c("subjid", "ARM"))

X <- cttab(x = c("AST", "BILI", "ALT"),
           group = "ARM",
           data = df,
           row_split = "AVISIT",            # Visit variable
           select = c("ALT" = "PERF == 1"))

X

## ----echo=TRUE----------------------------------------------------------------
# Prepare data as before
attach_pop("1.1")
df <- extract_form(dt, "PatientReg", vars_keep = c("subjid"))
base_lab <- extract_form(dt, "Lab", visit = "SCREENING",
                         vars_keep = c("subjid"))

# Define abnormal
base_lab$ABNORMALT <- base_lab$ALT > 22.5
var_lab(base_lab$ABNORMALT) <- "ALT abnormal"
base_lab$ABNORMAST <- base_lab$AST > 25.5
var_lab(base_lab$ABNORMAST) <- "AST abnormal"

df <- merge(df, base_lab, by = "subjid")

# Table
X <- cttab(x = list(c("AGE", "SEX", "BMIBL"),
                       # Group lab variable
                       "Blood" = c("ALT", "AST"),
                       # Group abnormal variable
                       "Pts with Abnormal" = c("ABNORMAST", "ABNORMALT")),
           group = "ARM",
           data = df,
           # Add some filtering
           select = c("BMIBL" = "RACEN != 1",
                      "ALT" = "PERF == 1"))

X                     

## ----echo=TRUE----------------------------------------------------------------
X <- cttab(x = c("AGE", "SEX", "BMIBL"), # Variable to report
           group = "ARM",                  # Group variable
           data = df,                      # Data
           digits = 2,                     # Keep 2 digits for numerical 
           digits_pct = 1,                 # Keep 1 digits for percentage
           rounding_fn = round)            # Use function round for rounding

X

