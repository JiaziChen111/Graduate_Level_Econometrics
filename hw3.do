/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics\HW3\asec2015_pubuse

/*log using ATTEND.RAW,  replace t */
infile attend termgpa priGPA ACT final atndrte hwrte frosh soph skipped stndfnl using ATTEND.RAW
global var "atndrte priGPA ACT"
tabstat $var, statistics(mean sd min max) columns(statistics) format(%8.2f) 
regress atndrte priGPA ACT
clear
/*-----------------------------PART II----------------------------------------*/
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
clear

/* #1 open cps_2015 consider 25<=age<=64, 10000<=wsal<=1000000*/
use cps_2015
drop if age<25
drop if age>64
drop if wsal<10000
drop if wsal>1000000

replace wsal = wsal/1000

/* #2 percent female,median number of years of education and what are the 25th, median and 75th percentiles*/
gen female = (sex)-1
egen count_sex = count(sex)
egen total_female = sum(female)
gen per_female = ((total_female)/(count_sex))*100
drop count_sex
drop total_female
display per_female
centile (educ), centile (50)
centile (wsal), centile (25 50 75)

/* #3 Histogram & Creating dummy variables for married,separated, divorced, white, hs, having at least a Bachelor's degree (col) and northeast, south, midwest, and west */
hist wsal, title("Wage/Salary Distribution") xtitle("Wage/Salary ($1,000s)")
gen wsal_log = log(wsal)
hist wsal_log, title("Log Wage/Salary Distribution - LOG") xtitle("Log(wsal)")
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

/* #4 summary statistics */
global var "wsal age hs col white metro married separated divorced female nkids nper northeast south midwest west"
tabstat $var, statistics(mean sd min max) columns(statistics) format(%8.2f)

/*#5 Run a regression of ln(wsal)*/
gen ln_wsal = ln(wsal)
regress ln_wsal age hs col white metro married separated divorced female nkids nper south midwest west

/* 6 Regression with nkids binaries */
gen nkids1 = nkids==1
gen nkids2 = nkids==2
gen nkids3 = nkids==3
gen nkids4 = nkids>=4

regress ln_wsal age hs col white metro married separated divorced female nkids1 nkids2 nkids3 nkids4 nper south midwest west
