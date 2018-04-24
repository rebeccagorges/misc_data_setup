**Rebecca Gorges
**April 2018
**OOA data import into stata, 2005-2015 title III state level spending

**file saved as agid_title3.dta in the main data directory

capture log close
clear all
set more off

log using C:\Users\Rebecca\Documents\UofC\research\hcbs\logs\agid_data_prep.txt, text replace

local data C:\Users\Rebecca\Documents\UofC\research\data

**************************************************************
** this is just state name to usps code,fips crosswalk, just do one time
/*
cd `data'

import excel StateFIPSicsprAB.xls, first

rename AB state
rename NAME state_name

drop STNAME
save StateFIPSicsprAB.dta, replace
clear
*/
**************************************************************
**now actual OOA data, excel file
local raw `data'\agid_state_exp_data
cd `raw'

import delimited RadGridExport_v1.csv, varnames(1)

rename geography state_name

merge m:1 state_name using `data'\StateFIPSicsprAB.dta
tab state_name if _merge==1 //PR and Guam, drop them
drop if _merge==1
drop _merge

drop geographygroup

local trunc totalallserv personalcare ///
 homemaker chore homedelivere ///
 adultdaycare casemanageme congregateme ///
 nutritioncou assistedtran transportati ///
 legalassista nutritionedu informationa ///
 outreach other healthpromot cashcounseli
 foreach v in `trunc'{
 rename titleiiiexpenditures`v' t3exp`v'
 rename totalexpenditures`v' totalexp`v'
 destring t3exp`v', ignore("$ , ") replace
 destring totalexp`v', ignore("$ , ") replace
 }

sort state year

//collapse titleiiiexpenditurestotalallserv,by(year)
//twoway scatter titleiiiexpenditurestotalallserv year


*******************************************************
save `data'\agid_title3.dta,replace

*******************************************************
log close
