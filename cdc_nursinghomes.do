capture log close
clear all
set more off

log using C:\Users\Rebecca\Documents\UofC\research\hcbs\logs\nh_occup-log.txt, text replace

local data C:\Users\Rebecca\Documents\UofC\research\data\state

cd `data'

**file path to excel file with nh resident counts, occupancy rates by state,year
local raw `data'\raw\nh_occupancy_rates

*****************************************************************************
import excel `raw'\table109_edited.xls, cellrange(B15:T65) case(lower)
rename B state
rename C number_1995
rename D number_1996
rename E number_1997
rename F number_1998
rename G number_1999
rename H number_2000
rename I number_2001
rename J number_2002
rename K number_2003
rename L number_2004
rename M number_2005
rename N number_2006
rename O number_2007
rename P number_2008
rename Q number_2009
rename R number_2010
rename S number_2011
rename T number_2012

reshape long number_, i(state) j(year)
rename number_ number_nursing_homes 
la var number_nursing_homes "Count nursing homes, state level"
sort state year
save nh_number.dta, replace

*****************************************************************************
import excel `raw'\table109_EDITED.xls, cellrange(U15:AM65) case(lower) clear
rename U state
rename V beds_1995
rename W beds_1996
rename X beds_1997
rename Y beds_1998
rename Z beds_1999
rename AA beds_2000
rename AB beds_2001
rename AC beds_2002
rename AD beds_2003
rename AE beds_2004
rename AF beds_2005
rename AG beds_2006
rename AH beds_2007
rename AI beds_2008
rename AJ beds_2009
rename AK beds_2010
rename AL beds_2011
rename AM beds_2012

reshape long beds_, i(state) j(year)
rename beds_ beds_nursing_homes

la var beds_nursing_homes "Nursing home beds, state level" 
sort state year
save nh_beds.dta, replace

*****************************************************************************
import excel `raw'\table109_edited.xls, cellrange(B75:T125) case(lower) clear
rename B state
rename C resid_1995
rename D resid_1996
rename E resid_1997
rename F resid_1998
rename G resid_1999
rename H resid_2000
rename I resid_2001
rename J resid_2002
rename K resid_2003
rename L resid_2004
rename M resid_2005
rename N resid_2006
rename O resid_2007
rename P resid_2008
rename Q resid_2009
rename R resid_2010
rename S resid_2011
rename T resid_2012

reshape long resid_, i(state) j(year)
rename resid_ resid_nursing_homes 
la var resid_nursing_homes "Nursing home residents, state level"
sort state year
save nh_resid.dta, replace

*****************************************************************************
import excel `raw'\table109_EDITED.xls, cellrange(U75:AM125) case(lower) clear
rename U state
rename V occup_1995
rename W occup_1996
rename X occup_1997
rename Y occup_1998
rename Z occup_1999
rename AA occup_2000
rename AB occup_2001
rename AC occup_2002
rename AD occup_2003
rename AE occup_2004
rename AF occup_2005
rename AG occup_2006
rename AH occup_2007
rename AI occup_2008
rename AJ occup_2009
rename AK occup_2010
rename AL occup_2011
rename AM occup_2012

reshape long occup_, i(state) j(year)
rename occup_ occup_nursing_homes

la var occup_nursing_homes "Nursing home occupancy rate, state level" 
sort state year
save nh_occup.dta, replace

*****************************************************************************
**merge into single file
use nh_number.dta
merge 1:1 state year using nh_beds.dta
drop _merge
merge 1:1 state year using nh_resid.dta
drop _merge
merge 1:1 state year using nh_occup.dta
drop _merge

sort state year

save nh_occupancy_cdc.dta, replace

*****************************************************************************
log close

