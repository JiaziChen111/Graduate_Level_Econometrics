/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics\HW5\asec2015_pubuse

/* open a log file - fill in the location of the CPS data file*/

log using cps15,  replace t 

/* read in household level data */
infix type 1 hid 2-6 htype 25 region 39 state 42-43 metro_status 53 using asec2015_pubuse.dat

/* keep household observations */
keep if type==1
drop type
sum

/* sort the observations using the id variable */
sort hid

/* save as a stata data set */
save cps15_house, replace
clear

/* read in person level data */
infix type 1 hid 2-6 relationship 15-16 age 19-20 marital_status 21 sex 24 educ 25-26 race 27-28 fid 48-49 ///
wsal 364-370 using asec2015_pubuse.dat


/* keep person observations */
keep if type==3
drop type

/* sort the observations using the id variable */
sort hid

/* save as a stata data set */

save cps15_person, replace
clear

/* merge in household level data */
use cps15_person
merge m:1 hid using cps15_house
tab _merge
drop if _merge==2
drop _merge

/* generate number in family and number of children */
sort hid fid
by hid fid: egen nper=count(hid)
by hid fid: egen nk=count(hid) if age<18
by hid fid: egen nkids=max(nk)
replace nkids=0 if nkids==.
drop nk fid
tab nper
tab nkids

/* save merged stata dataset */
save cps_2015, replace


/*hw data adjustment*/
keep if age>= 25 & age<= 64
keep if wsal>=10000 & wsal<=1000000
keep if metro_status==1 | metro_status==2
replace wsal = wsal/1000

/* female dummy*/
gen female = (sex)-1


/* #Creating dummy variables for married,separated, divorced, white, hs, having at least a Bachelor's degree (col) and northeast, south, midwest, and west */
gen married = 0 
replace married = 1 if marital_status<=3
gen divorced = 0 
replace divorced = 1 if marital_status==5
gen separated = 0 
replace separated = 1 if marital_status==6
gen white = 0 
replace white = 1 if race==1
gen hs = 0 
replace hs = 1 if educ==39
gen col = 0 
replace col = 1 if educ==43
gen northeast = 0 
replace northeast = 1 if region==1
gen south = 0 
replace south = 1 if region==3
gen midwest = 0 
replace midwest = 1 if region==2
gen west = 0 
replace west = 1 if region==4


/*Run a regression of ln(wsal)*/
gen age2 = age*age
gen fem_age = female*age
gen ln_wsal = log(wsal)
regress ln_wsal age age2 hs col white metro married separated divorced female fem_age nkids nper south midwest west
outreg using test.doc, replace

/* Run a regression of wsal*/
regress wsal age age2 hs col white metro married separated divorced female fem_age nkids nper south midwest west
outreg using test.doc, merge
