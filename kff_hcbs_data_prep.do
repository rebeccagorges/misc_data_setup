**Rebecca Gorges
**October 2017
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

log using C:\Users\Rebecca\Documents\UofC\research\hcbs\logs\kff_hcbs_data_prep.txt, text replace

local data C:\Users\Rebecca\Documents\UofC\research\data\state

cd `data'

**file path to excel files
local raw `data'\raw\kff_medicaid_hcbs
cd `raw'

*******************************************************
capture drop program kff
program define kff
args var tab v

clear
import excel using kff_hcbs_tables.xlsx, ///
sheet("Table `tab'") cellrange(A5:P55)

rename A state
rename B `var'1999
rename C `var'2000
rename D `var'2001
rename E `var'2002
rename F `var'2003
rename G `var'2004
rename H `var'2005
rename I `var'2006
rename J `var'2007
rename K `var'2008
rename L `var'2009
rename M `var'2010
rename N `var'2011
rename O `var'2012
rename P `var'2013

forvalues i = 1999/2013{
capture replace `var'`i'="" if `var'`i'=="-"
capture destring `var'`i', replace
}

reshape long `var' , i(state) j(year)

sort state year

save kff_`v'.dta,replace
end

kff hcbs_partic 1A 1
kff hcbs_hh_partic 1B 2
kff hcbs_pc_partic 1C 3
kff hcbs_1915c_partic 1D 4

kff hcbs_expend 2A 5
kff hcbs_hh_expend 2B 6
kff hcbs_pc_expend 2C 7
kff hcbs_1915c_expend 2D 8

kff hcbs_expend_pp 3A 9
kff hcbs_hh_expend_pp 3B 10
kff hcbs_pc_expend_pp 3C 11
kff hcbs_1915c_expend_pp 3D 12

*merge variables tables together
use kff_1.dta, clear

forvalues i = 2/12{
merge 1:1 state year using kff_`i'.dta
drop _merge
}


label var hcbs_partic "Total number HCBS participants"
label var hcbs_hh_partic "Home health state plan participants"
label var hcbs_pc_partic "Personal care state plan participants"
label var hcbs_1915c_partic "1915c Waivers participants"

label var hcbs_expend "Total HCBS Expenditures, in $1000s" 
label var hcbs_hh_expend "Home health state plan expenditures, in $1000s"
label var hcbs_pc_expend "Personal care state plan expenditures, in $1000s"
label var hcbs_1915c_expend "1915c Waivers expenditures, in $1000s"

label var hcbs_expend_pp "Total HCBS Expenditures per Participant" 
label var hcbs_hh_expend_pp "Home health state plan expenditures per Participant"
label var hcbs_pc_expend_pp "Personal care state plan expenditures per Participant"
label var hcbs_1915c_expend_pp "1915c Waivers expenditures per Participant"

sort state year

cd `data'
save kff_state_hcbs.dta,replace

*******************************************************
log close
