/*James Barr Coding for Economists 2025 Final

Transformed Section 1

Tasks completed:
- #5 Stata portion: fixed common data quality errors of a .csv file by solving issues related to string variables that needed to be numerical to conduct meaningful analysis. Missing values are dealth with in Do File related to filtering and saving cleaned/modified data. I did not drop variables with missing values at this stage, as for future research I may need to refer to transformed data which includes missing values and are relevant to identifying certain trends. 
- #6 Stata portion: prepared a sample for analysis by transfomring variables. In this case, I transformed varaibles of interest including race, flee_status, threat_type, and gender from string variabels of text to numeric variables. I labeled them with text, but by using the command ,nolabel I can view the numeric values. 
- #7 Stata portion: svae cleaned/modified data, both in .dta and .csv format to the outputs folder
*/

capture mkdir "log_files" //creating a file to store the logs

log using "log_files/fatal-police-killings-wapo_transformed.log", replace

cd "C:\Users\Barr_James\OneDrive\coding for economists\final_assignment"

capture mkdir "cleaned_data"

pwd // confirming that we are in the correct working directory before importing the data set

import delimited "fatal-police-shootings-data.csv", varnames(1) encoding(UTF-8) clear

rename race race_string // Renaming the race varaibel to race_string variable to reference when making race defined as categorical integers 

gen race = . // generating race to reference race_string information to make race a categorical integer

local i = 1 // using local macro to replace the string data with a number 

foreach cat in W B A N H O {
	replace race = `i' if race_string == "`cat'"
	local i = `i' + 1
	}
// Each observation now as a integer related to the race, meaning that the variable has now been transformed from a string to an integer, and Stata can work with the observations. 

label define race_labels 1 "White" 2 "Black" 3 "Asian heritage" 4 "Native American" 5 "Hispanic" 6 "Other" // assigning text labels

label values race race_labels // assigning the labels to the integers in race

browse race // visible with text labels of race

browse race, nolabel // removes the text labels and the integer values are visible

// This process is repeated for other variables to transform them from string to categorical integers to for working with the data set in stata 

rename flee_status flee_status_string

gen flee_status = .

local i = 0

foreach cat in not foot car other {
	replace flee_status = `i' if flee_status_string == "`cat'" 
	local i = `i' + 1 
	}

label define flee_labels 0 "Not fleeing" 1 "On foot" 2 "Via car" 3 "Via another vehicle"

label values flee_status flee_labels

rename threat_type threat_type_string

gen threat_type = .

local i = 1
 
foreach cat in shoot point attack threat move flee accident undetermined {
	replace threat_type = `i' if threat_type_string == "`cat'" 
	local i = `i' + 1
	}

label define threat_labels 1 "Fired weapon" 2 "Pointed weapon" 3 "Attacked" 4 "Had weapon visible" 5 "Threatening movement" 6 "Fleeing" 7 "Accident" 8 "Undetermined"

label values threat_type threat_labels

rename armed_with armed_with_string

gen armed_with = .

local i = 0

foreach cat in unarmed gun knife blunt_object other replica undetermined unknown vehicle {
	replace armed_with = `i' if armed_with_string == "`cat'"
	local i = `i' + 1 
	}
	
label define armed_with_labels 0 "Unarmed" 1 "Gun" 2 "Knife" 3 "Blunt Object" 4 "Other" 5 "Replica" 6 "Undetermined" 7 "Unknown" 8 "Vehicle"

label values armed_with armed_with_labels

tabulate armed_with_string armed_with, missing

rename gender gender_string

gen gender = .

local i = 1

foreach cat in male female non-binary { 
	replace gender = `i' if gender_string == "`cat'" 
	local i = `i' + 1
	}

label define gender_labels 1 "Male" 2 "Female" 3 "Non-binary"
	
label values gender gender_labels

tabulate gender_string gender, missing // Checking to see if when transforming the gender variable if any data was missed

rename was_mental_illness_related was_mental_illness_related_str

gen was_mental_illness_related = .

replace was_mental_illness_related = 0 if was_mental_illness_related_str == "False"

replace was_mental_illness_related = 1 if was_mental_illness_related_str == "True"

label define mental_illness_labels 1 "True" 0 "False"

label values was_mental_illness_related mental_illness_labels

tabulate was_mental_illness_related_str was_mental_illness_related, missing

save "cleaned_data/police-killings-wapo_transformed_section1.dta", replace // saving the cleaned data into a separate folder for further use both in .dta and .csv formats

export delimited "cleaned_data/police-killings-wapo_transformed_section1.csv", replace

log close
 