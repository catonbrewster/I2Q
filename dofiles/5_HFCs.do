
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
**1. Set Globals and log
***************************************************
c data
do dofiles/1_globals.do


use "$rawdtaPII/merged/3_renamed/renamed_raw_merged_$date", clear

//drop vars not helpful to HFCs
drop b_CollectorID b_RespondentID b_CustomData b_IPAddress
***************************************************
**2. Baseline HFCs
***************************************************
/*
-Make sure all questions were answered
-Flag ids and number of ids that selected mostly "refuse to answer" 
-For select multiple questions--did they select "None" or "Refuse to answer" and anything else
-Is hhsize less than or equal to number of members under 18  or less than or equal to  number of members that smoke other than respondent. 
-Check number of years smoked is not greater than age 
*/


**All questions answered
*******************************
local total = _N

preserve

drop if b_ReenterStudyID == "" 
qui ds b_* 
local baseline `r(varlist)'

qui ds *_other *_reason_* *_support_* *_tobac_*
local other `r(varlist)' 

loc checks: list baseline - other 		//don't want to check for empty "others" or select multiple dummies

local q 0 
foreach var of local checks {
		capture confirm string variable `var'
		if _rc {
			count if `var' == .
			if `r(N)' > 0 {
				local message`q' "`var' has `r(N)'/`total' missing observations"
				local q = `q' + 1

				}
			}
		if !_rc {
			count if `var' == ""
			if `r(N)' > 0 {
				local message`q' "`var' has `r(N)'/`total' missing observations"
				local q = `q' + 1
				}
			}
		
		}


**High number of refuse to answers - MAKE THIS SECTION BETTER 
*******************************
qui ta studyid
local num `r(r)'

gen num_rta = 0 
foreach i of numlist 1/`num' {
	foreach var of local checks {
		capture confirm string variable `var'
		if _rc {
			qui count if `var' == -1 & studyid == "`i'"
			local id_`i' = `id_`i'' + `r(N)'
			}
		if !_rc {
			qui count if (regexm(`var', "-1") | regexm(`var', "Refuse")) & studyid == "`i'"
			local id_`i' = `id_`i'' + `r(N)'
				}
		}
	if "`id_`i''"!= "0" { 
		local rfa`i' "study id `i' recorded refused to answer for `id_`i''/37 questions"
		}
	local rfap`i' = `id_`i''/37 
	cap gen  percent = ""
	replace percent = "`rfap`i''" if studyid == "`i'"
	}

destring percent, replace
ta percent if percent > .5 
local percent_rta "`r(N)'/`total' recorded refuse to answer for over half of their survey questions" 


	
**Select multiple questions
*******************************
count if (b_reason_currhealth != "" | b_reason_futurehealth != "" | b_reason_kids != "" | b_reason_cost != "" | b_reason_socialstig != "" | b_reason_other != ""  ) & b_reason_ra == "Refuse to answer"
if `r(N)' > 0 {
	local select_multiple_reason "LOGIC ERRORS: For the question about reasons not to smoke, `r(N)'/`total' selected 'Refuse to Answer' and at least one other option" 
	}
	
count if (b_support_NRT != "" | b_support_nonNRT != "" |  b_support_indcounsel != "" |  b_support_grpcounsel != "" |  b_support_quitline != "" |  b_support_internet != "" |  b_support_other !="") & (b_support_no == "None" |  b_support_ra == "Refuse to answer")
if `r(N)' > 0 {
	local select_multiple_support "LOGIC ERRORS: For the question about support used previously to quit smoking, `r(N)'/`total' selected 'Refuse to Answer' or 'None' and then at least one other option" 
	}
	
count if (b_tobac_cigars!= "" |  b_tobac_chew!= "" | b_tobac_dip!= "" |  b_tobac_ecig!= "" |  b_tobac_hookah!= "" |  b_tobac_pipe!= "" |  b_tobac_other!= "") & (b_tobac_no == "None" |  b_tobac_ra == "Refuse to answer")
if `r(N)' > 0 {
	local select_multiple_tobacco "LOGIC ERRORS: For the question about types of tobacco used, `r(N)'/`total' selected 'Refuse to Answer' or 'None' and then at least one other option" 
	}

	
**hhsize checks
*******************************
count if b_hhsize <= b_hhsize_u18 & (b_hhsize!= "-1" & b_hhsize_u18!="-1") &  !(b_hhsize== "0" & b_hhsize_u18=="0")	//these shouldn't be equal because respondent can't be under 18 		
if `r(N)' > 0 {
	local u18_morethan_hhsize "LOGIC ERRORS: `r(N)'/`total' participants wrote the HH had more than or an equal number of children under 18 than total members of the household (b_hhsize_u18 > hhsize"
	}
	
count if b_hhsize <= b_hhnum_smoke & (b_hhsize!= "-1" & b_hhnum_smoke!="-1") &  !(b_hhsize== "0" & b_hhnum_smoke=="0")		//these shouldn't be equal because the question about other smokers says not to include yourself
if `r(N)' > 0 {
	local smokenum_morethan_hhsize "LOGIC ERRORS: `r(N)'/`total' participants wrote the HH had more than or an equal number of smoking members than total members of the household (b_hhnum_smoke > hhsize"
	}


**age checks 
*******************************
//generate age using birth date and the global, $date
gen date = $date 
tostring date, replace 
gen today = date(date, "MD20Y")
drop date 
format today %tdnn/dd/CCYY
gen age = today - a_dateofbirth
replace age = age/365
format age %3.0f

destring b_years_smoke, replace 
//check that age is less than years smoked
count if age < b_years_smoke
if `r(N)' > 0 {
	local age_lessthan_smoke "LOGIC ERRORS: `r(N)'/`total' participants wrote they have smoked more years than they have been alive (b_years_smoke > age)"
	}



restore
********************************************************************************
**Displays results of HFCs
********************************************************************************
//log displays
cap log close
log using "logfiles/HFCs/HFCs_$date.smcl", replace

foreach i of numlist 0/0 {
//displays for variables with missing responses that shouldn't have missing responses
	foreach y of numlist 0/`q' {
		if "`y'" == "0" {
			display "FLAGGING VARIABLES WITH MISSING VALUES: There are `q'/37 questions (and thus vars) with missing responses. See questions listed below if number is greater than 0:" //come back and figure out how to display these in diff colors
			}
		display "`message`y''" //come back and figure out how to display these in diff colors
		}

	foreach i of numlist 1/`num' {
		//display "`rfa`i''"
		}
	display "FLAGGING REFUSE TO ANSWERS: `percent_rta'"
		
	//displays on select-multiple issues
	display "`select_multiple_reason'"		//come back and figure out how to display these in diff colors
	display  "`select_multiple_support'" 	//come back and figure out how to display these in diff colors
	display  "`select_multiple_tobacco'" 	//come back and figure out how to display these in diff colors

	//hhsize checks
	display "`u18_morethan_hhsize'" 		//come back and figure out how to display these in diff colors
	display "`smokenum_morethan_hhsize'" 		//come back and figure out how to display these in diff colors

	//age checks
	display "`age_lessthan_smoke'" 		//come back and figure out how to display these in diff colors
	}
	
cap log close
