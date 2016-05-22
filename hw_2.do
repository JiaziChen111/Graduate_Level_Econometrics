/*clear register */
clear

/* close log file that was opened in previous run */
capture log close

/*  set path or directory that contains data */
cd C:\Users\My\Desktop\Econometrics\HW2

/* open log file */
log using HW_2, replace t

/*  open dta file */
use CollegeDistance.dta

/*  regress years completed with nearest college distance */
regress yrsed dist
/* generate a table of summary statistics */
global var "yrsed dist"
tabstat $var, statistics(mean sd min max) columns(statistics) format(%8.2f) 

/* same regression however only for men*/
drop if female == 1 
gen dist_men=dist
regress yrsed dist_men

/* generate a table of summary statistics */

global var "yrsed dist_men"
tabstat $var, statistics(mean sd min max) columns(statistics) format(%8.2f)
/* create stata dataset for males */

save CollegeDistance_male, replace


/*  open dta file */
use CollegeDistance.dta
/* same regression however only for women*/
drop if female == 0 
gen dist_women=dist
regress yrsed dist_women


/* generate a table of summary statistics */

global var "yrsed dist_women"
tabstat $var, statistics(mean sd min max) columns(statistics) format(%8.2f) 

/* create stata dataset for males */
save CollegeDistance_female, replace

/*----------------------------------PART III---------------------*/
use homework2_hourly_wages.dta
use homework2_cpi.dta
merge 1:1 year using homework2_hourly_wages.dta
drop _merge
gen M01=(jan*234.677)/jan_cpi
gen M02=(feb*234.677)/feb_cpi
gen M03=(mar*234.677)/mar_cpi
gen M04=(apr*234.677)/apr_cpi
gen M05=(may*234.677)/may_cpi
gen M06=(jun*234.677)/jun_cpi
gen M07=(jul*234.677)/jul_cpi
gen M08=(aug*234.677)/aug_cpi
gen M09=(sep*234.677)/sep_cpi
gen M10=(oct*234.677)/oct_cpi
gen M11=(nov*234.677)/nov_cpi
gen M12=(dec*234.677)/dec_cpi
keep year M01 M02 M03 M04 M05 M06 M07 M08 M09 M10 M11 M12
save real_wage_before, replace
/* I then copied and transposed the data and created a new dta file called real_wage_new*/

 merge 1:1 year using new_cpi.dta
 drop _merge
 merge 1:1 year using real_wage_new.dta
 drop _merge

