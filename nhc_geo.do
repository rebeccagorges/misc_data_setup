**Rebecca Gorges
**February 2018
**Nursing home compare data prep, 2012 data only
**Merge five star rating file with provider information, collapse to
**average rating at zip code, HRR level

capture log close
clear all
set more off

log using C:\Users\Rebecca\Documents\UofC\research\hcbs\logs\nhc_geo-log.txt, text replace

local data C:\Users\Rebecca\Documents\UofC\research\data

cd `data'

**file path to excel files **ratings
local raw_r `data'\nursing_home_compare\NHC_Ratings_09-13
**file path to excel files **providers
local raw_p `data'\nursing_home_compare\NHC_Providers_2012
**file path to excel files **zip-hsa crosswalk
local raw_z `data'\dartmouth_atlas

*******************************************************
**First for expenditures sheets
import excel `raw_r'\ratings2012.xlsx, firstrow case(lower)

*get mean ratings over the year, just collapse by provider number
collapse (mean) overall_rating survey_rating quality_rating staffing_rating rn_staffing_rating, by(provnum)

save `data'\2012_ratings.dta, replace

******************************************************
**Now import provider information

clear 
import excel `raw_p'\prov2012_nodupkits.xlsx, firstrow case(lower)
keep provnum zip bedtot

duplicates tag provnum,gen(dup)
*do dups have same zip/ if yes, just drop
preserve
keep if dup==1
sort provnum zip
by provnum (zip), sort: gen diff=zip[1]!=zip[_N]
list provnum zip if diff
*2 providers have multiple zips listed
*in zip 545**, different hsa, same hrr
*in zip 9880* are in the same hsa, hrr
*just keep first one
restore

by provnum (zip), sort: gen seq=_n
keep if seq==1
drop dup seq

save `data'\2012_providers.dta, replace

*******************************************************
**get zip-hsa crosswalk
clear
import excel `raw_z'\ZipHsaHrr12.xls, firstrow case(lower)
keep zipcode12 hsanum hrrnum hsacity hsastate

gen str5 zip=string(zipcode12,"%05.0f")
drop zipcode12
save `data'\2012_zip_hsa_hrr.dta, replace

*******************************************************
**now merge
use `data'\2012_ratings.dta
merge 1:1 provnum using `data'\2012_providers.dta

*note there are provnums in the ratings that do not appear in the provider file
*only keep matches
keep if _merge==3
drop _merge 

merge m:1 zip using `data'\2012_zip_hsa_hrr.dta
*there are many zips with no nursing homes, seems reasonable
li if _merge==1

*count of hsas, hrrs - how many do not have a nursing home?
gen nh_ind=(!missing(provnum))

sort hsanum
egen nh_count_hsa=sum(nh_ind), by(hsanum)

by hsanum, sort: gen seq=_n
sum nh_count_hsa if seq==1

tab nh_count_hsa if seq==1

sort hrrnum
egen nh_count_hrr=sum(nh_ind), by(hrrnum)

by hrrnum, sort: gen seq1=_n
sum nh_count_hrr if seq1==1

tab nh_count_hrr if seq1==1
*8% of hsas have no nursing homes in the data
*minimum number of nursing homes in hrrs is 4

*do by hrr for now, then explore further later on
keep if nh_ind==1 //drops extra zip codes with no nursing homes

*get mean ratings in the hra, weighted by number of beds (so large nh's count more)
*check this link https://www.stata.com/support/faqs/data-management/weighted-group-summary-statistics/
sort hrrnum
destring bedtot, replace
levelsof hrrnum, local(hrr)

foreach v in overall_rating survey_rating quality_rating staffing_rating rn_staffing_rating{
	gen hrr_`v'=.
	qui foreach l of local hrr {
		summarize `v'[w=bedtot]  if hrrnum==`l' & nh_ind==1
		replace hrr_`v'=r(mean) if hrrnum==`l'
		}
}
la var hrr_overall_rating "Mean HRR Overall Rating, weighted by nh beds"
la var hrr_survey_rating "Mean HRR Survey Rating, weighted by nh beds"
la var hrr_quality_rating "Mean HRR Quality Rating, weighted by nh beds"
la var hrr_staffing_rating "Mean HRR Staffing Rating, weighted by nh beds"

*keep just zip, hrr, ratings, collapse down to zip level
keep zip hrrnum hrr_*

collapse hrrnum hrr_*, by(zip)

*******************************************************
save `data'\zip_hrr_nhc_ratings_2012.dta, replace

*******************************************************
log close
