****RENAMING PII DATA DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/8/2015

/*
Purpose: This dofile is designed to be run each week only while we are 
still getting new weekly data in. It takes the reformated raw merged 
PII data each week and renames the variables to prepare it to run some
HFCs. 

IMPORTANT NOTE: In the first few months of the program, Access was updated
several times, thus the renaming may not work if you try to run it for early 
dates of the project as the excel columns in the do file won't line up with 
the actual columns in the raw sheets of data. Please be aware of this if 
trying to run these do files for early dates of the program. 
*/

clear
set more off
set maxvar 32767	// Stata's max var limit
//vers 12			//uncomment this if need to run for those using stata v12

***************************************************
**1. Set Globals
***************************************************
c data
do dofiles/1_globals.do


use "$rawdtaPII/merged/2_single_entry/single_entry_raw_merged_$date", clear
rename StudyID ChartNumber, lower
***************************************************
**2. Rename - Access. 
***************************************************

drop a_ID //this is generated buy surveymonkey - drop it. Not always accurate 

rename a_*, lower 
rename a_preferredmethodofcontact a_contactmethod
rename a_besttimetocontactyou a_contacttime
rename a_studystatus a_treatment
rename a_dateofenrollment a_enrolldate
rename a_monthreturndate a_est_2modate
rename a_monthcompleted a_2mo_done
rename a_ab a_est_6modate
rename a_ac a_6mo_done
rename a_ad a_est_12modate
rename a_ae a_12mo_done
rename a_communicationnotes a_comnotes
rename a_wouldyoupreferyourrewardsma a_mailoremail
note a_mailoremail: this is only applicable for people in a rewards treatment arm. It is their preference for receiving their 2/6 mo rewards.
rename a_enrollment a_enroll_perc
rename a_month a_2mo_perc
rename a_dateofquitii a_quitIIdate

***************************************************
**3. Rename - Baseline
***************************************************

rename b_Whatisthehighestlevelofsch b_school
rename b_K b_school_other
rename b_Whatisyourmaritalstatus b_marriage
rename b_M b_marriage_other
rename b_Includingyourselfhowmanypeo b_hhsize
rename b_Howmanypeopleinyourhousehol b_hhnum_smoke
rename b_Howmanyhouseholdmembersareu b_hhsize_u18
rename b_Pleaseindicateyourannualhous b_income
rename b_R b_income_other
rename b_Areyoucurrentlypregnant b_pregnant
rename b_Howmanydaysperweekdoyouty b_internet_days
rename b_Howsoonafteryouwakeupdoyo b_wakeup_smoke
rename b_Doyoufinditdifficulttorefr b_diff_refrain
rename b_Whichcigarettewouldyouhatem b_firstcig
rename b_Howmanycigarettesperdaydoy b_cig_perday
rename b_Doyousmokemorefrequentlyin b_smoke_morn
rename b_Doyousmokeevenifyouaresic b_smoke_sick
rename b_Howmanyyearshaveyousmoked b_years_smoke
rename b_Whatothertobaccoproductshave b_tobac_cigars
rename b_AC b_tobac_chew
rename b_AD b_tobac_dip
rename b_AE b_tobac_ecig
rename b_AF b_tobac_hookah
rename b_AG b_tobac_pipe
rename b_AH b_tobac_none
rename b_AI b_tobac_ra
rename b_AJ b_tobac_other
rename b_Howmanytimesdidyoutrytoqu b_quit_times
rename b_Sinceyoustartedsmokingwhat b_longest_quit
rename b_Whatresourceshaveyouusedin b_support_NRT
rename b_AN b_support_nonNRT
rename b_AO b_support_indcounsel
rename b_AP b_support_grpcounsel
rename b_AQ b_support_quitline
rename b_AR b_support_internet
rename b_AS b_support_no
rename b_AT b_support_ra
rename b_AU b_support_other
rename b_Realisticallywhendoyouseey b_timeline
rename b_Whydoyouwanttoquitsmoking b_reason_currhealth
rename b_AX b_reason_futurehealth
rename b_AY b_reason_kids
rename b_AZ b_reason_cost
rename b_BA b_reason_socialstig
rename b_BB b_reason_ra
rename b_BC b_reason_other
rename b_Ifgivenachoicebetween25ma b_25wk30fivewk
rename b_WhenIhavecashinmypocketI b_spendcash_immed
rename b_BF b_spendcash_regret
rename b_If100peopleparticipatedinth b_psucess_ppl
rename b_Howlikelydoyouthinkyouare b_success_own
rename b_Outof100whatdoyouthinkth b_psuccess_own
rename b_BJ b_25sixmo30sevmo 
rename b_Iamgoodatresistingtemptatio b_meis_resist_temp
rename b_Ihaveahardtimebreakingbad b_meis_hard_habits
rename b_Isayinappropriatethings b_meis_say_inaprop
rename b_Idocertainthingsthatarebad b_meis_bad_if_fun
rename b_IwishIhadmoreselfdisciplin b_meis_wish_discip
rename b_PeoplewouldsaythatIhavever b_meis_pplsay_discip
rename b_Pleasureandfunsometimeskeep b_meis_funoverwrk
rename b_Ihavetroubleconcentrating b_meis_trbl_wrking
rename b_SometimesIcantstopmyselffr b_meis_cntstop_wrong
rename b_Ioftenactwithoutthinkingthr b_meis_act_nothink


***************************************************
**4. Save
***************************************************

saveold "$rawdtaPII/merged/3_renamed/renamed_raw_merged_$date", replace


