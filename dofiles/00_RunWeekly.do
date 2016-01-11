****MASTER WEEKLY DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/7/2015

/*
Purpose: This dofile is designed to be run weekly. We receive
sheets from CHCI and stickK each week with running lists of data 
on the participants.  This dofile runs the dofiles to import, 
merge, rename PII date, do HFCs on the PII data, and then strip the data of PII.
*/

cap ssc install fastcd 

cap cd "X:\Dropbox\I2Q\08_Data"
if _rc {						
	cd "/Volumes/Boxcryptor/Dropbox/I2Q/08_Data" 		//on macs 
	}


cap c cur data

******BEFORE RUNNING OPEN 1_globals AND UPDATE USERNAME AND DATE!!!**************

do 1_globals //setting globals

**Import & Merge
do "$dofiles/2_Import&Merge"

**Check Baseline Double Entires 
do "$dofiles/3_CheckBaselineDoubles"

**Rename PII data
do "$dofiles/4_RenamePIIData"

**HFCS
do "$dofiles/5_HFCs"

**Strip PII and save

