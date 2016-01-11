****Cleaning DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/24/2015

/*
Purpose: This dofile is designed to clean the data. 
Contents: 
1. 
2. 
3. 
*/

clear
set more off
set maxvar 32767	// Stata's max var limit
//vers 12			//uncomment this if need to run for those using stata v12





replace studyid = "000" + studyid if length(studyid) == 1
replace studyid = "00" + studyid if length(studyid) == 2
replace studyid = "0" + studyid if length(studyid) == 3
