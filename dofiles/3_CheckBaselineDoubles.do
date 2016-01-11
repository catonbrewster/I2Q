****PAPER SURVEY CHECKS DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/8/2015

/*
Purpose: This dofile is designed to check that the double entires of the
baseline survey data each week, This only relevant as long as we are getting
paper surveys
*/

clear
set more off
set maxvar 32767	// Stata's max var limit
vers 12			//uncomment this if need to run for those using stata v12

***************************************************
**1. Set Globals
***************************************************
c data
do dofiles/1_globals.do

use "$rawdtaPII/CHCI/Baseline/RawBaseline_$date", clear
***************************************************
**2. Check Double Entries 
***************************************************
drop if StudyID == "" 	//If missing baseline studyID means they didn't take it fully, so don't want to run checks on them. They will be dropped from program anyway. 

//first assert double entry of StudyID and ChartNumber w/in each survey was correct
assert StudyID == ReenterStudyID
assert ChartNumber == ReenterChartNumber
drop ReenterStudyID ReenterChartNumber //only run if assertions are true!

//only interested in looking at duplicate observations - drop others
duplicates tag StudyID ChartNumber, gen(dup)
keep if dup == 1		
drop dup

//below are unique to each surveymonkey entry or we don't actually ask them
order StudyID ChartNumber
drop RespondentID CollectorID StartDate EndDate IPAddress EmailAddress FirstName LastName CustomData 

//separating each entry into two diff temp datasets to compare to one another using -cfout-

egen entry = tag(StudyID)		//create a var that is 1 for one of the StudyIDs in each pair
tempfile all entry1 entry2
saveold `all'
preserve
keep if entry == 1 
sort StudyID ChartNumber
rename EnrollerInitials EnrollerInitials1
isid StudyID ChartNumber
saveold `entry1'
restore
preserve 
keep if entry == 0
sort StudyID ChartNumber
rename EnrollerInitials EnrollerInitials2
isid StudyID ChartNumber
saveold `entry2' 
restore 

use `entry1', clear
sort StudyID ChartNumber
local excl entry EnrollerInitials1 EnrollerInitials2
ds
local vars `r(varlist)'
loc run: list vars - excl 		//don't want to check for discrepancies btwn new var "entry" or enrollers
disp "`run'"
cfout `run' using `entry2', id(StudyID ChartNumber) saving("$CHCIdta/Baseline_discrep/data/discrepancies_$date", variable(QuestionOrColumn) masterval(Entry1) usingval(Entry2) keepmaster(EnrollerInitials1) keepusing(EnrollerInitials2) replace)
cap cf `run' using `entry2'
local numdisc `r(Nsum)'
use "$rawdtaPII/merged/1_reformatted/reformatted_raw_merged_$date", clear
//duplicates drop StudyID if "`numdisc'" == "1", force	//[]until 1/1/16 there was 1 discrepancy which was entry of "kids" versus "Kids." Fine to drop. 

saveold "$rawdtaPII/merged/2_single_entry/single_entry_raw_merged_$date", replace 

//save this dataset as an excel file for CHCI to check the discrepancies 
use "$CHCIdta/Baseline_discrep/data/discrepancies_$date", clear
order StudyID ChartNumber Question Entry1 EnrollerInitials1 Entry2 EnrollerInitials2
export excel using "$CHCIdta/Baseline_Discrep/discrepancies_$date.xls", firstrow(variables) replace


