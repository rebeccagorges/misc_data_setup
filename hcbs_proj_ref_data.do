**Rebecca Gorges

** Collect state level expenditures data for 2005 and 2012 to compare with
** MAX data tabulations for data validity check

**Set up state-year level Medicaid LTSS historical data
**Data source: Excel files from KFF reports:
**1. Medicaid Home and Community-Based Services Programs: 2013 Data Update
**(Data from 2003-2013)
**2. Medicaid 1915c Home and Community-Based Service Programs: Data Update Issue Paper (2005)
**(Data from 1999-2002)

**program legend: hh = home health state program
**					pc = personal care state program (optional)
**					1915c = 1915(c) waiver

**file saved as kff_state_hcbs.dta in the main data directory

capture log close
clear all
set more off

local logpath C:\Users\Rebecca\Documents\UofC\research\hcbs\logs
local data C:\Users\Rebecca\Documents\UofC\research\hcbs\data

log using `logpath'\hcbs_proj_ref_data-LOG.txt, text replace

cd `data'

use Medicaid_state_data_combined.dta, clear

tab year, missing

**Construction spending variables
** Truven report Evolution of LTSS spending on 1915c waivers
gen expend_1915c_tru=pop1_1915c + pop2_1915c + pop3_1915c + pop4_1915c

** Truven report - home health totals, elderly population only
sum pop1_hh


** Truven report - personal care totals, elderly population only
sum pop1_pc

** KFF sources, in 1000's so multiply
** Per table footnotes, these are from Medicaid state surveys and Form 372 data
sum hcbs_1915c_expend //KFF 2012 data update, table 2D
replace hcbs_1915c_expend = 1000*hcbs_1915c_expend

sum hcbs_hh_expend //KFF 2012 data update, table 2B
replace hcbs_hh_expend = 1000*hcbs_hh_expend

sum hcbs_pc_expend //KFF 2012 data update, table 2C
replace hcbs_pc_expend = 1000*hcbs_pc_expend

** KFF also has estimates of number of participants
sum hcbs_1915c_partic //KFF 2012 update, table 1D

sum hcbs_hh_partic //KFF 2012 update, table 1B

sum hcbs_pc_partic //KFF 2012 update, table 1C

**full state list in alphabetical order to match other tables
local state2005 AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA ///
KS KY LA /*ME*/ MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK ///
OR PA RI SC SD TN TX UT VT VA WA WV WI WY

local state2012 AL AK AZ AR CA /*CO*/ CT DE DC FL GA HI /*ID*/ IL IN IA ///
/*KS*/ KY LA ME MD MA MI MN MS MO MT /*NE*/ NV NH NJ NM NY NC ND OH OK ///
OR PA /*RI*/ SC SD TN TX UT VT VA WA WV WI WY

** create tables
foreach s in `state2005'{
	mat t1=J(1,6,.)
	local c = 1
	foreach v in expend_1915c expend_1915c_tru hcbs_pc_expend pop1_pc hcbs_hh_expend pop1_hh {
		sum `v' if year==2005 & state=="`s'"
		mat t1[1,`c']=r(mean)
		local c = `c'+1
		}
	mat rownames t1=`s'
	frmttable, statmat(t1) sdec(0) store(t1_1) varlabels

	outreg, replay(t1_2_1) append(t1_1) store(t1_2_1)
		}
	
outreg using `logpath'/hcbs_checks_ref_data, ///
replay(t1_2_1) ///
title("2005 KFF and Truven sources of HCBS expenditures data") ///
ctitles("State","1915c Expend","","Personal care","","Home health","" \ ///
"","KFF","Truven","KFF", "Truven","KFF","Truven") ///
replace

foreach s in `state2012'{
	mat t1=J(1,6,.)
	local c = 1
	foreach v in expend_1915c expend_1915c_tru hcbs_pc_expend pop1_pc hcbs_hh_expend pop1_hh {
		sum `v' if year==2012 & state=="`s'"
		mat t1[1,`c']=r(mean)
		local c = `c'+1
		}
	mat rownames t1=`s'
	frmttable, statmat(t1) sdec(0) store(t1_1) varlabels

	outreg, replay(t1_2_2) append(t1_1) store(t1_2_2)
		}
	
outreg using `logpath'/hcbs_checks_ref_data, ///
replay(t1_2_2) ///
title("2012 KFF and Truven sources of HCBS expenditures data") ///
ctitles("State","1915c Expend","","Personal care","","Home health","" \ ///
"","KFF","Truven","KFF", "Truven","KFF","Truven") ///
addtable
*******************************************************
** tables of participant counts, KFF source only
foreach s in `state2005'{
	mat t1=J(1,3,.)
	local c = 1
	foreach v in hcbs_1915c_partic hcbs_pc_partic hcbs_hh_partic {
		sum `v' if year==2005 & state=="`s'"
		mat t1[1,`c']=r(mean)
		local c = `c'+1
		}
	mat rownames t1=`s'
	frmttable, statmat(t1) sdec(0) store(t1_1) varlabels

	outreg, replay(t1_3_1) append(t1_1) store(t1_3_1)
		}
	
outreg using `logpath'/hcbs_checks_ref_data, ///
replay(t1_3_1) ///
title("2005 KFF sources of HCBS participant counts ") ///
ctitles("State","1915c Waivers","Personal care","Home health") ///
addtable

foreach s in `state2012'{
	mat t1=J(1,3,.)
	local c = 1
	foreach v in hcbs_1915c_partic hcbs_pc_partic hcbs_hh_partic {
		sum `v' if year==2012 & state=="`s'"
		mat t1[1,`c']=r(mean)
		local c = `c'+1
		}
	mat rownames t1=`s'
	frmttable, statmat(t1) sdec(0) store(t1_1) varlabels

	outreg, replay(t1_3_2) append(t1_1) store(t1_3_2)
		}
	
outreg using `logpath'/hcbs_checks_ref_data, ///
replay(t1_3_2) ///
title("2012 KFF sources of HCBS participant counts ") ///
ctitles("State","1915c Waivers","Personal care","Home health") ///
addtable

	
*******************************************************
log close
