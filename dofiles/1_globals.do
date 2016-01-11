****SET GLOBALS*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/7/2015

/*
Purpose: This dofile sets globals for the rest of the do files in this folder.
Part of it is desinged to be updated weekly
*/
cap ssc install fastcd

clear
set more off

*******************************UPDATE EACH WEEK*********************************
global date 010816
global user cbrewster

********************************************************************************
/*
cap cd "X:\Dropbox\I2Q\08_Data"
if _rc {						
	/Volumes/Boxcryptor/Dropbox/I2Q/08_Data 		//on macs 
	}


cap c cur data
*/ 

global CHCIdta ../../I2Q - CHCI Data Share
global stickKdta ../../I2Q - stickK Data Share
global rawdtaPII rawdata_encrypted
global dofiles dofiles
global data data
