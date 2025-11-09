/* Outputs Section 2 

- #8: created and saved summary statistics table. because the variables were not continuous and instead were categorical, I used tab1 and tabulate to create summary statistics. I installed and used logout to save .csv files of the summary statistics and of the tabulate command results relating race and flee_status to investigate disparities. 
- #9: Created and saved bar graph showing the relationship between being killed by the police and being unarmed. I used a kdensity command to show gender differences, including gender data for nonbinary even though it was limited. 
- #10: Saved these graph files in Stata

*/

cd "C:\Users\Barr_James\OneDrive\coding for economists\final_assignment"

log using "log_files/fatal-police-killings_outputs.log", replace

use "cleaned_data/police-killings-wapo_transformed_section1.dta", clear //Use the cleaned data from code in  the transformation_section1 do file. 

capture mkdir "outputs" // creates output folder to later save work

tab1 race gender threat_type flee_status armed_with was_mental_illness_related

/*
This provides an overview of summary statistics of observations. Because the data is not continuous, the normal summarize command was not applicable. 

-> tabulation of race  

           race |      Freq.     Percent        Cum.
----------------+-----------------------------------
          White |      4,659       50.48       50.48
          Black |      2,486       26.94       77.42
 Asian heritage |        184        1.99       79.41
Native American |        146        1.58       80.99
       Hispanic |      1,717       18.60       99.60
          Other |         37        0.40      100.00
----------------+-----------------------------------
          Total |      9,229      100.00

-> tabulation of gender  

     gender |      Freq.     Percent        Cum.
------------+-----------------------------------
       Male |      9,943       95.51       95.51
     Female |        462        4.44       99.95
 Non-binary |          5        0.05      100.00
------------+-----------------------------------
      Total |     10,410      100.00

-> tabulation of threat_type  

         threat_type |      Freq.     Percent        Cum.
---------------------+-----------------------------------
        Fired weapon |      2,924       28.22       28.22
      Pointed weapon |      1,890       18.24       46.46
            Attacked |      1,490       14.38       60.84
  Had weapon visible |      2,674       25.81       86.64
Threatening movement |        599        5.78       92.42
             Fleeing |        192        1.85       94.28
            Accident |         55        0.53       94.81
        Undetermined |        538        5.19      100.00
---------------------+-----------------------------------
               Total |     10,362      100.00

-> tabulation of flee_status  

        flee_status |      Freq.     Percent        Cum.
--------------------+-----------------------------------
        Not fleeing |      5,575       62.37       62.37
            On foot |      1,345       15.05       77.41
            Via car |      1,634       18.28       95.69
Via another vehicle |        385        4.31      100.00
--------------------+-----------------------------------
              Total |      8,939      100.00

-> tabulation of armed_with  

  armed_with |      Freq.     Percent        Cum.
-------------+-----------------------------------
     Unarmed |        565        5.61        5.61
         Gun |      6,040       59.97       65.58
       Knife |      1,776       17.63       83.21
Blunt Object |        252        2.50       85.71
       Other |        108        1.07       86.79
     Replica |        331        3.29       90.07
Undetermined |        463        4.60       94.67
     Unknown |        165        1.64       96.31
     Vehicle |        372        3.69      100.00
-------------+-----------------------------------
       Total |     10,072      100.00

-> tabulation of was_mental_illness_related  

was_mental_ |
illness_rel |
       ated |      Freq.     Percent        Cum.
------------+-----------------------------------
      False |      8,373       80.28       80.28
       True |      2,057       19.72      100.00
------------+-----------------------------------
      Total |     10,430      100.00

. 
*/

ssc install logout // You need to install logout with this command to allow for the use of the command logout, which saves the outputs of the rest of the line of code that follows it. In this case, it is the summary tables. 

logout, save("outputs/summary-tables.xlm") replace excel: tab1 race flee_status threat_type armed_with was_mental_illness_related // Save the summary statistics as a csv file for future reference in the output folder. 

logout, save("outputs/race-and-flee-status.xlm") replace excel: tabulate race flee_status, row // save the tabulate output as a csv file demonsrating the difference between race and flee_status

/*

Visible here is a racial disparity that demonsrates that there is a signficant racial disparity of being shot while fleeing, with people with Black race being killed 21.96% while fleeing on foot, while White people were only killed 11.38% of the time when fleeing on foot from the police. This demonsrates an interesting divergence in trends worth investigating further. 

+----------------+
| Key            |
|----------------|
|   frequency    |
| row percentage |
+----------------+

                |                 flee_status
           race | Not fleei    On foot    Via car  Via anoth |     Total
----------------+--------------------------------------------+----------
          White |     2,646        456        752        154 |     4,008 
                |     66.02      11.38      18.76       3.84 |    100.00 
----------------+--------------------------------------------+----------
          Black |     1,219        480        394         93 |     2,186 
                |     55.76      21.96      18.02       4.25 |    100.00 
----------------+--------------------------------------------+----------
 Asian heritage |       120         20         20          3 |       163 
                |     73.62      12.27      12.27       1.84 |    100.00 
----------------+--------------------------------------------+----------
Native American |        71         22         17          6 |       116 
                |     61.21      18.97      14.66       5.17 |    100.00 
----------------+--------------------------------------------+----------
       Hispanic |       921        249        273         94 |     1,537 
                |     59.92      16.20      17.76       6.12 |    100.00 
----------------+--------------------------------------------+----------
          Other |        21          4          3          2 |        30 
                |     70.00      13.33      10.00       6.67 |    100.00 
----------------+--------------------------------------------+----------
          Total |     4,998      1,231      1,459        352 |     8,040 
                |     62.16      15.31      18.15       4.38 |    100.00 

. 
*/

gen unarmed = (armed_with == 0) if armed_with < .

graph bar (mean) unarmed, over(race) ytitle("% of Victims Unarmed") title("Percentage of Victims Unarmed, by Race")

graph export "outputs/percentage-of-victims-bar-graph-unarmed-by-race.png", replace // Saving the graph as a .png and replacing nay previous file with the same name. This shows the existence of some racial disparities of being  killed by police when unarmed. 

kdensity age if gender == 1, addplot((kdensity age if gender == 2) (kdensity age if gender == 3)) title("Age Distribution of Victims, by Gender Identity") legend(label(1 "Male") label(2 "Female") label(3 "Non-binary")) // using Kernel desnity graph to view the distribution of age in the observations, by gender

graph export "outputs/age-of-victims-by-gender-identity.png", replace // Saving the graphs as .png and replacing any previous file with the same name.

log close 

