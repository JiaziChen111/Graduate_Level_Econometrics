/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics\HW6\comp_excer
/*--------------------------- C8.6---------------------------------------------------*/
use crime1.dta 
gen arr86 = 0
replace arr86 = 1 if narr86 > 0
regress arr86 pcnv avgsen tottime ptime86 qemp86
outreg using results_C8.6.doc, replace
predict arr86_hat
sum arr86_hat
gen h_hat = arr86_hat * (1 - arr86_hat)
regress arr86 pcnv avgsen tottime ptime86 qemp86[aw = 1/h_hat]
outreg using results_C8.6.doc, merge 
test avgsen tottime
clear
/*--------------------------C14.7---------------------------------------------------*/
use murder.dta
drop if year ==87
gen year_93 = 0
replace year_93 =1 if year==93

* part(ii):Pooled OLS estimator
regress mrdrte exec unem if year >87 
outreg using results_C14.7.doc, replace

/*Panel Data Model*/
global id id
global t year
global ylist mrdrte
global xlist exec unem year_93

describe $id $t $ylist $xlist
summarize $id $t $ylist $xlist

sort $id $t
xtset $id $t
xtdescribe
xtsum $id $t $ylist $xlist


* part(iii):Fixed effects or within estimator
xtreg $ylist $xlist, fe
outreg using results_C14.7.doc, merge
*part(iv):Compute the heteroskedasticity-robust standard error for the estimation in part (3)
xtreg $ylist $xlist, fe vce(robust)
* part(vi):Fixed effects or within estimator
drop if state=="TX"
xtreg $ylist $xlist, fe
outreg using results_C14.7.doc, merge
xtreg $ylist $xlist, fe vce(robust)
