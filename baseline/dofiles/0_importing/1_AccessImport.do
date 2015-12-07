****IMPORT ACCESS DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/7/2015

/*
Purpose: This dofile imports the weekly CHCI sheet we receive with Access data. 
It strip sit of PII and renames and reformats to prepare to merge with the other 
weekly sheets. The weekly sheet is a running list of participants. 
*/

clear
set more off
set maxvar 32767	// Stata's max var limit
//vers 12			//uncomment this if need to run for those using stata v12


*******************************UPDATE EACH WEEK*********************************
local date 120515


********************************************************************************


*************************
**1. Import 
*************************

import excel "C:\Users\cbrewster.IPA\Dropbox\I2Q - CHCI Data Share\Access\C2Q Patients `date'.xlsx", sheet("C2Q_Patients") firstrow


*************************
**2. Strip PII and save
*************************


*************************
**2. Rename Vars
*************************

rename ID UID
rename ControlNumber chart_number
