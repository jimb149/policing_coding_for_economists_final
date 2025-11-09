/* 
Section 3: Filtering Observations

Tasks demonsrated: 
- #5: Dropping observations with missing values
- #6 Filtering observations by dropping observations with missing values. Filtering variables by dropping variables not related to further analyis. 

I completed this separately, as for some investigations, observations with missing values can still be valuable (eg. if armed_with is missing but race data and flee_status is present, it is still useful for finding possible racial disparities of being killed by police when fleeing). In this section, I drop if observations are missing for most observations with variables that I intend to keep, and I drop all variaibles that are not needed, such as the string variables and race_source, body_camera and agency_ids

*/ 

cd "C:\Users\Barr_James\OneDrive\coding for economists\final_assignment"

log using "log_files/fatal-police-killings-wapo_filtering.log", replace

capture mkdir "cleaned_data/filtering_section3" // creating folder for cleaned data that had observations and variables filtered when cleaning

use "cleaned_data/police-killings-wapo_transformed_section1.dta", clear // Using cleaned data cleaned with Section 1

drop if race == . // droppping observations with missing data for race

drop if armed_with == . 

drop if flee_status == . 

drop agency_ids // Dropping agency_ids variable

drop body_camera

drop race_source

drop race_string gender_string armed_with_string flee_status_string threat_type_string // Dropping all string variables no longer needed

export delimited "cleaned_data/filtering_section3/police-killings-wapo_filtering_section3.csv", replace // exporting as a separate cleaned data set to a folder for section 3, housed within th folder "cleaned_data"

save "cleaned_data/filtering_section3/police-killings-wapo_filtering_section3.dta", replace // save as both .csv and .dta

log close

