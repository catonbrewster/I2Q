****MASTER WEEKLY DOFILE*****
**Author: Caton Brewster, Dean Team RA
**Date created: 12/7/2015

/*
Purpose: This dofile is designed to be run weekly. We receive
sheets from CHCI and stickK each week with running lists of data 
on the participants.  This dofile runs the dofiles to import, 
merge, rename PII date, do HFCs on the PII data, and then strip the data of PII.
*/

do 1_globals //setting globals

**Import & Merge
do 2_Import&Merge

**Check Baseline Double Entires 
do 3_CheckBaselineDoubles

**Rename PII data
do 4_RenamePIIData

**HFCS
do 5_HFCs

**Strip PII and save
do 

