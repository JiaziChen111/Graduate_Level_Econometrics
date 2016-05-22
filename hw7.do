/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics\HW7
/*--------------------------- C10.2---------------------------------------------------*/
use barium.dta
/*----------------------------ex 10.5--------------------------------------*/
gen lnchnimp = ln(chnimp)
gen lnchempi = ln(chempi)
gen lngas = ln(gas)
gen lnrtwex = ln(rtwex)
regress lnchnimp lnchempi lngas lnrtwex befile6 affile6 afdec6
outreg using results_C10.2.doc, replace
/*----------------------------part(i)--------------------------------------*/
*create time trend variable
gen time = _n
*regress using time trend variable
regress lnchnimp lnchempi lngas lnrtwex befile6 affile6 afdec6 time
outreg using results_C10.2.doc, merge
/*----------------------------part(ii)--------------------------------------*/
*F test
test lnchempi lngas lnrtwex befile6 affile6 afdec6
/*----------------------------part(iii)--------------------------------------*/
*generate a month dummy. I created a month variable on excel and pasted it to the dta file.I'm excluding Jan
gen Feb =0
replace Feb = 1 if month=="Feb"
gen Mar =0
replace Mar = 1 if month=="Mar"
gen Apr =0
replace Apr = 1 if month=="Apr"
gen May =0
replace May = 1 if month=="May"
gen Jun =0
replace Jun = 1 if month=="Jun"
gen Jul =0
replace Jul = 1 if month=="Jul"
gen Aug =0
replace Aug = 1 if month=="Aug"
gen Sep =0
replace Sep = 1 if month=="Sep"
gen Oct =0
replace Oct = 1 if month=="Oct"
gen Nov =0
replace Nov = 1 if month=="Nov"
gen Dec =0
replace Dec = 1 if month=="Dec"
*regress using months
regress lnchnimp lnchempi lngas lnrtwex befile6 affile6 afdec6 time Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
outreg using results_C10.2.doc, merge
*F stats on months
test Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
*F stat the other variables
test lnchempi lngas lnrtwex befile6 affile6 afdec6

