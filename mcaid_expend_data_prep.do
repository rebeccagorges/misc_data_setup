**Rebecca Gorges
**June 2017
**Set up state-year level Medicaid LTSS historical data
**Data source: Excel files from Medicaid website report: Improving the 
**balance: the evoluation of Medicaid Expenditures for LTSS, FY 1981-2014
** Population abbreviation notes; OD-PD Older adults and people with physical disabilities
** DD = developmental disabilities; SMI or SED: severe mental illness or serious emotional disturbance 

capture log close
clear all
set more off

log using C:\Users\Rebecca\Documents\UofC\research\hcbs\logs\mcaid_expend_data_prep.txt, text replace

local data C:\Users\Rebecca\Documents\UofC\research\data\state
//local data E:\hrs\data

cd `data'

**file path to excel files
local raw `data'\raw\mcaid_ltss_hcbs

*******************************************************
**First for expenditures sheets
capture program drop fromexcel
program define fromexcel
args state yr col1 col2 sheet

clear
import excel using LTSS_Historic_Exp_`state'.xlsx, ///
cellrange(`col1'3:`col2'37) sheet("`state' `sheet' Expenditures") 

destring `col1' `col2',replace force

xpose, clear varname

forvalues i=1/35{
qui gen v`i'_1=v`i'[_n+1]
}

drop if _n==2

rename v1 pop1_total
label var pop1_total "Total Expend-Older adults,PD"
rename v2 pop1_nursing_fac 
label var pop1_nursing_fac "Nursing facilities Expend-Older adults,PD"
rename v3 pop1_pc
label var pop1_pc "Personal care Expend-Older adults,PD"
rename v4 pop1_1915c 
label var pop1_1915c "1915(c) waivers Expend-Older adults,PD"
rename v5 pop1_hh
label var pop1_hh "Home health Expend-Older adults,PD"
rename v6 pop1_cfh
label var pop1_cfh "Community first choice Expend-Older adults,PD"
rename v7 pop1_mc
label var pop1_mc "HCBS Managed care Expend-Older adults,PD"
rename v8 pop1_pace
label var pop1_pace "PACE Expend-Older adults,PD"
rename v9 pop1_nurse
label var pop1_nurse "Private duty nursing Expend-Older adults,PD"
rename v10 pop1_hcbs1915j
label var pop1_hcbs1915j "HCBS 1915(j) waivers Expend-Older adults,PD"
rename v11 pop1_pc1915j
label var pop1_pc1915j "Personal care 1915(j) waivers Expend-Older adults,PD"
rename v12 pop1_hcbs1915i
label var pop1_hcbs1915i "HCBS 1915(i) AD waivers Expend-Older adults,PD"

rename v13 pop2_total
label var pop2_total "Total Expend-DD"
rename v14 pop2_icfpub
label var pop2_icfpub "ICF/IID public Expend-DD"
rename v15 pop2_icfpri
label var pop2_icfpri "ICF/IID private Expend-DD"
rename v16 pop2_1915c
label var pop2_1915c "1915(c) waivers Expend-DD"
rename v17 pop2_mc
label var pop2_mc "HCBS Managed care Expend-DD"
rename v18 pop2_hcbs1915i
label var pop2_hcbs1915i "HCBS 1915(i) DD waivers Expend-DD"

rename v19 pop3_total
label var pop3_total "Total Expend-SMI or SED"
rename v20 pop3_mhf
label var pop3_mhf "Mental health facilities Expend-SMI or SED"
rename v21 pop3_mhfdsh
label var pop3_mhfdsh "Mental health facilities DSH Expend-SMI or SED"
rename v22 pop3_rehab
label var pop3_rehab "Rehabilitative services Expend-SMI or SED"
rename v23 pop3_1915c
label var pop3_1915c "1915(c) waivers Expend-SMI or SED"
rename v24 pop3_1915i
label var pop3_1915i "1915(i) waivers Expend-SMI or SED"

rename v25 pop4_total
label var pop4_total "Total Expend-Other/Multiple populations"
rename v26 pop4_cm
label var pop4_cm "Case management Expend-Other/Multiple populations"
rename v27 pop4_1915c
label var pop4_1915c "1915(c) waivers Expend-Other/Multiple populations"
rename v28 pop4_mc
label var pop4_mc "HCBS Managed care Expend-Other/Multiple populations"
rename v29 pop4_hh
label var pop4_hh "Health homes Expend-Other/Multiple populations"
rename v30 pop4_inst
label var pop4_inst "Institut MLTSS unspecified Expend-Other/Multiple populations"
rename v31 pop4_mfpd
label var pop4_mfpd "MFP demonstration Expend-Other/Multiple populations"

rename v32 ltss_exp
label var ltss_exp "Total LTSS expenditures"
rename v33 ltss_inst_exp
label var ltss_inst_exp "Total Institutional LTSS expenditures"
rename v34 hcbs_exp
label var hcbs_exp "Total HCBS expenditures"
rename v35 mcaid_total_exp
label var mcaid_total_exp "Total Medicaid expenditures"

**percent change variables
rename v1_1 pop1_total_chg
label var pop1_total_chg "Total, Pct Change-Older adults,PD"
rename v2_1 pop1_nursing_fac_chg 
label var pop1_nursing_fac_chg "Nursing facilities, Pct Change-Older adults,PD"
rename v3_1 pop1_pc_chg
label var pop1_pc_chg "Personal care, Pct Change-Older adults,PD"
rename v4_1 pop1_1915c_chg 
label var pop1_1915c_chg "1915(c) waivers, Pct Change-Older adults,PD"
rename v5_1 pop1_hh_chg
label var pop1_hh_chg "Home health, Pct Change-Older adults,PD"
rename v6_1 pop1_cfh_chg
label var pop1_cfh_chg "Community first choice, Pct Change-Older adults,PD"
rename v7_1 pop1_mc_chg
label var pop1_mc_chg "HCBS Managed care, Pct Change-Older adults,PD"
rename v8_1 pop1_pace_chg
label var pop1_pace_chg "PACE, Pct Change-Older adults,PD"
rename v9_1 pop1_nurse_chg
label var pop1_nurse_chg "Private duty nursing, Pct Change-Older adults,PD"
rename v10_1 pop1_hcbs1915j_chg
label var pop1_hcbs1915j_chg "HCBS 1915(j) waivers, Pct Change-Older adults,PD"
rename v11_1 pop1_pc1915j_chg
label var pop1_pc1915j_chg "Personal care 1915(j) waivers, Pct Change-Older adults,PD"
rename v12_1 pop1_hcbs1915i_chg
label var pop1_hcbs1915i_chg "HCBS 1915(i) AD waivers, Pct Change-Older adults,PD"

rename v13_1 pop2_total_chg
label var pop2_total_chg "Total, Pct Change-DD"
rename v14_1 pop2_icfpub_chg
label var pop2_icfpub_chg "ICF/IID public, Pct Change-DD"
rename v15_1 pop2_icfpri_chg
label var pop2_icfpri_chg "ICF/IID private, Pct Change-DD"
rename v16_1 pop2_1915c_chg
label var pop2_1915c_chg "1915(c) waivers, Pct Change-DD"
rename v17_1 pop2_mc_chg
label var pop2_mc_chg "HCBS Managed care, Pct Change-DD"
rename v18_1 pop2_hcbs1915i_chg
label var pop2_hcbs1915i_chg "HCBS 1915(i) DD waivers, Pct Change-DD"

rename v19_1 pop3_total_chg
label var pop3_total_chg "Total, Pct Change-SMI or SED"
rename v20_1 pop3_mhf_chg
label var pop3_mhf_chg "Mental health facilities, Pct Change-SMI or SED"
rename v21_1 pop3_mhfdsh_chg
label var pop3_mhfdsh_chg "Mental health facilities DSH, Pct Change-SMI or SED"
rename v22_1 pop3_rehab_chg
label var pop3_rehab_chg "Rehabilitative services, Pct Change-SMI or SED"
rename v23_1 pop3_1915c_chg
label var pop3_1915c_chg "1915(c) waivers, Pct Change-SMI or SED"
rename v24_1 pop3_1915i_chg
label var pop3_1915i_chg "1915(i) waivers, Pct Change-SMI or SED"

rename v25_1 pop4_total_chg
label var pop4_total_chg "Total, Pct Change-Other/Multiple populations"
rename v26_1 pop4_cm_chg
label var pop4_cm_chg "Case management, Pct Change-Other/Multiple populations"
rename v27_1 pop4_1915c_chg
label var pop4_1915c_chg "1915(c) waivers, Pct Change-Other/Multiple populations"
rename v28_1 pop4_mc_chg
label var pop4_mc_chg "HCBS Managed care, Pct Change-Other/Multiple populations"
rename v29_1 pop4_hh_chg
label var pop4_hh_chg "Health homes, Pct Change-Other/Multiple populations"
rename v30_1 pop4_inst_chg
label var pop4_inst_chg "Institut MLTSS unspecified, Pct Change-Other/Multiple populations"
rename v31_1 pop4_mfpd_chg
label var pop4_mfpd_chg "MFP demonstration, Pct Change-Other/Multiple populations"

rename v32_1 ltss_exp_chg
label var ltss_exp_chg "Total LTSS, Pct Change"
rename v33_1 ltss_inst_exp_chg
label var ltss_inst_exp_chg "Total Institutional LTSS, Pct Change"
rename v34_1 hcbs_exp_chg
label var hcbs_exp_chg "Total HCBS, Pct Change"
rename v35_1 mcaid_total_exp_chg
label var mcaid_total_exp_chg "Total Medicaid, Pct Change"

gen year=`yr'
gen str state="`state'"

save ltss_exp_`state'_`yr'.dta,replace

end  
****************************************************************8
**next from precentages sheets

capture program drop fromexcel2
program define fromexcel2
args state yr col1 col2 sheet

clear

import excel using LTSS_Historic_Exp_`state'.xlsx, ///
cellrange(`col1'3:`col2'7) sheet("`state' `sheet' Percentages") 

destring `col1' `col2',replace force

xpose, clear varname

rename v1 ltss_pct_mcaid
label var ltss_pct_mcaid "Total LTSS as Pct of Total Medicaid"
rename v2 hcbs_pct_ltss 
label var hcbs_pct_ltss "Percentage of LTSS that is HCBS"
rename v3 hcbs_pct_ltss_pop1 
label var hcbs_pct_ltss_pop1 "Percentage of LTSS that is HCBS-Older Adults,PD"
rename v4 hcbs_pct_ltss_pop2 
label var hcbs_pct_ltss_pop2 "Percentage of LTSS that is HCBS-DD"
rename v5 hcbs_pct_ltss_pop3 
label var hcbs_pct_ltss_pop3 "Percentage of LTSS that is HCBS-SMI or SD"

gen year=`yr'
gen str state="`state'"

save ltss_pct_`state'_`yr'.dta,replace

end  

****************************************************************
**call programs
local statelist AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA ///
MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA ///
VT WA WI WV WY

foreach s in `statelist'{

cd `raw'

**first for expenditures tabs
fromexcel `s' 1996 B C 96-00
fromexcel `s' 1997 D E 96-00
fromexcel `s' 1998 F G 96-00
fromexcel `s' 1999 H I 96-00
fromexcel `s' 2000 J K 96-00

fromexcel `s' 2001 B C 01-05
fromexcel `s' 2002 D E 01-05
fromexcel `s' 2003 F G 01-05
fromexcel `s' 2004 H I 01-05
fromexcel `s' 2005 J K 01-05

fromexcel `s' 2006 B C 06-10
fromexcel `s' 2007 D E 06-10
fromexcel `s' 2008 F G 06-10
fromexcel `s' 2009 H I 06-10
fromexcel `s' 2010 J K 06-10

fromexcel `s' 2011 B C 11-14
fromexcel `s' 2012 D E 11-14
fromexcel `s' 2013 F G 11-14
fromexcel `s' 2014 H I 11-14

**next for percentages tabs
fromexcel2 `s' 1996 B B 96-00
fromexcel2 `s' 1997 C C 96-00
fromexcel2 `s' 1998 D D 96-00
fromexcel2 `s' 1999 E E 96-00
fromexcel2 `s' 2000 F F 96-00

fromexcel2 `s' 2001 B B 01-05
fromexcel2 `s' 2002 C C 01-05
fromexcel2 `s' 2003 D D 01-05
fromexcel2 `s' 2004 E E 01-05
fromexcel2 `s' 2005 F F 01-05

fromexcel2 `s' 2006 B B 06-10
fromexcel2 `s' 2007 C C 06-10
fromexcel2 `s' 2008 D D 06-10
fromexcel2 `s' 2009 E E 06-10
fromexcel2 `s' 2010 F F 06-10

fromexcel2 `s' 2011 B B 11-14
fromexcel2 `s' 2012 C C 11-14
fromexcel2 `s' 2013 D D 11-14
fromexcel2 `s' 2014 E E 11-14

**for each year, merge the exp and expenditures data
cd `data'
forvalues y=1996/2014{
use `raw'/ltss_exp_`s'_`y'.dta, clear
merge 1:1 state year using `raw'/ltss_pct_`s'_`y'.dta
save `raw'/ltss_both_`s'_`y'.dta, replace
}

**merge into single file for the state
cd `data'
use `raw'/ltss_both_`s'_1996.dta, clear
forvalues y=1997/2014{
append  using `raw'/ltss_both_`s'_`y'.dta
}
save ltss_exp_`s'_1996-2014.dta, replace
}

**merge all states into a single file
local statelistnoak /*AK*/ AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA ///
MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA ///
VT WA WI WV WY

use ltss_exp_AK_1996-2014.dta, clear
foreach s in `statelistnoak'{
append  using ltss_exp_`s'_1996-2014.dta
}

save ltss_exp_all_states_1996-2014.dta, replace
****************************************************************8
log close
