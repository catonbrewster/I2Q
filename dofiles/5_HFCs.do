****HIGH FREQUENCY CHECKS DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/7/2015

/*
Purpose: This dofile is designed to be run each week only while we are 
still getting new weekly data in. It takes the reformated, renamed, merged 
PII data each week and a number of HFCs. 
*/

clear
set more off
set maxvar 32767	// Stata's max var limit
//vers 12			//uncomment this if need to run for those using stata v12

***************************************************
**1. Set Globals
***************************************************
cd X:\Dropbox\I2Q\08_Data\dofiles
do 1_globals.do

use "$rawdtaPII/merged/2_renamed/renamed_raw_merged_$date", clear


***************************************************
**1. Drop duplicates -- MAKE SURE DISCREPANCIES ARE SORTED 
***************************************************

***************************************************
**1. Baseline HFCs
***************************************************
/*
-For select multiple questions--did they select "None" or "Refuse to answer" and anything else
-Is hhsize greater than [number of members under 18 + 1] or greater than number of members than smoke other than respondent. 
	Add 1 to the number of mems under 18 because hhsize includes the respondent and they can't be under 18. 
-Check number of years smoked is not greater than age 
-Check people did not respond refuse to answer to everything
