import os 
import pandas as pd #Imports pandas library for working with data
import numpy as np #Imports numpy library for numerical operations
import matplotlib.pyplot as plt #Imports the necessary modules for generating graphs/visualizations

# Loading the Data, Defining File Paths, Creating Directories
data_path = "/Users/jamesbarr336/Library/CloudStorage/OneDrive-CentralEuropeanUniversity/Ay25-26/coding for economists/final" #Defines the path to where the raw data file is locaed
os.chdir(data_path) #Set's the current working directory to the "data_path" 
policekillings = pd.read_csv("fatal-police-shootings-data.csv") #Read the raw CSV data into a pandas DataFrame with the assigned name 'policekillings
print(policekillings.head()) #displays first five rows to confirm data was loaded correctly

main_path = os.path.expanduser("/Users/jamesbarr336/Library/CloudStorage/OneDrive-CentralEuropeanUniversity/Ay25-26/coding for economists/final/final_assignment_python") #Defines the base directory for project outputs and cleaned data
output_folder = os.path.join(main_path, "outputs") #Creates the full path to the outputs folder for graphs and other outputs
os.makedirs(output_folder, exist_ok=True) #Creates the directory if it does not already exist
print(f"Ensured folder exists: {output_folder}")
cleaned_folder = os.path.join(main_path, "cleaned_data") #Creates the full path to folder cleaned_data for cleaned files, saved in CSV format
os.makedirs(cleaned_folder, exist_ok=True) #Creates the directory of it does not already exist
print(f"Ensured folder exists: {cleaned_folder}") #Confirms the folder path

#Transforming Observations for Variables of Interest

#Here dictionaries can be used to map the categorical string data to be transformed one to one into a categorical integer. This may be useful for future mathematical modelling. 
race_map = {
    "W": 1,
    "B": 2,
    "A": 3,
    "N": 4,
    "H": 5,
    "O": 6
}
policekillings['race_int'] = policekillings['race'].map(race_map) #I followed the same logic here for mapping the integer of race to the original race coding used by the Washington Post in the data set. 

print(pd.crosstab(policekillings['race'], policekillings['race_int'], dropna=False)) #This generates a table to confirm the mapping was done correctly and there are no observations that were missed. This allows me to see an overview of the observations compared to race_int and the normal race variable to ensure no observations were missed and the transformation of the variable was done correctly.  

#Using a "for" loop to assign a categorical integer for a variable to transform  flee_status from a string variable to an integer
policekillings['flee_status_int'] = np.nan #This defines a new variable with no observation. 

i = 0 #Initializing the counter at 0
categories_list = ["not", "foot", "car", "other vehicle"] #Defining the list of categories from the data set

for cat in categories_list: #Initiating a "for" loop in order to assign categorical integers to the string variables corresponding to flee status. It will go through each category in the list. 
    policekillings.loc[policekillings['flee_status'] == cat, 'flee_status_int'] = i
    i += 1
print("\n--- Check after 'flee_status' loop: ---") #Checking to confirm the transformation fo the variable was successful

print(pd.crosstab(policekillings['flee_status'], policekillings['flee_status_int'], dropna=False))

#Data Cleaning
#Filtering observations to remove observations without data regarding the victims race or fleeing status
original_count = policekillings.shape[0]
print(f"\nOriginal number of observations: {original_count}")
columns_to_check = ['race_int', 'flee_status_int'] #Defining which variables to check to see if there is missing data in the observation
policekillings_cleaned = policekillings.dropna(subset=columns_to_check) #Drop any observation that has NaN in either column of the two previous listed variables 
print(f"Observations after dropping rows: {policekillings_cleaned.shape[0]}") #Provides the number of remaining observations in the dataset after dropping observations with missing data for race_int and flee_status_int

#Dropping unwneccessary/unwanted columns from the data set to filter variables and clean the data
columns_to_drop = ['body_camera', 'agency_ids', 'race_source'] # Defiing columns to drop
policekillings_cleaned = policekillings_cleaned.drop(columns=columns_to_drop, axis=1) #Drops the specified columns
print(f"\nSuccessfully dropped unwanted columns.")
print(f"Remaining columns: {policekillings_cleaned.columns.to_list()}")

#Saving cleaned data to the cleaned_data folder
output_filename = "fatal-police-shootings-cleaned.csv" 
full_save_path = os.path.join(cleaned_folder, output_filename) #Creates the complete file path for the cleaned data 
policekillings_cleaned.to_csv(full_save_path, index=False) #Writes the cleaned DataFrame to a new CSV files
print(f"\nSuccessfully saved cleaned data to: {full_save_path}")

#Summary Statistics for variables of interest race flee_status_int and gender. This is using the cleaned data
categorical_vars = ['race', 'flee_status_int', 'gender'] #defining variables of interest. In this case, the flee_status_int is used to have a numeric code, while the categorical vars of race and gender are used as they originally appear in the data set. 

#Using for loop to get a summary of each  of the variables of interest
for var in categorical_vars:
    print(f"\n--- Frequency Table for {var} (Counts) ---")
    print(policekillings_cleaned[var].value_counts())
    print(f"\n--- Frequency Table for {var} (Percentages) ---")
    print(policekillings_cleaned[var].value_counts(normalize=True) * 100) 
    #Converts the count to proportations multiplied by 100 for percentages

#Summary Statistics for All Variaibles
summary_table = policekillings_cleaned.describe(include='all')
print(summary_table)
#This provides a concise overview of all the observations in the cleaned data. However, the output is not useful for every variable, as some are not continous and may be incorrectly treated as continous variables.  

# Generate graph (Number of Police Killings by by Race and Flee Status)

crosstab_data = pd.crosstab(
    policekillings_cleaned['race'],
    policekillings_cleaned['flee_status']
) #determines the counts necessary for a grouped bar chart

fig, ax = plt.subplots(figsize=(10, 6)) #Creates the graph with defined dimensions

crosstab_data.plot(kind='bar', ax=ax) # Plot the raw count data as a grouped bar chart

#Customing teh graph with titles, axis labels, legend, and formatting
ax.set_title('Number of Police Killings by by Race and Flee Status')
ax.set_xlabel('Victim Race')
ax.set_ylabel('Number of Incidents (Count)')
ax.legend(title='Flee Status') 
plt.tight_layout() 

#Saving the Graph
save_filename = "race_flee_status_raw_counts_chart.png" 
full_save_path = os.path.join(output_folder, save_filename) #Uses the previously defined file path for the output folder 

plt.savefig(full_save_path) #Saves the final bar graph plot as a png file to the specified output folder

print(f"\nGraph successfully saved to: {full_save_path}") #Confirmation message. 