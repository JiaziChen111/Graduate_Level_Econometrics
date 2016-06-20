/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics\HW6\comp_excer

set more off
clear

use mass_testscore_data_v13
 
sum district_number year totstu pctlep pctlowinc pctsped pct_hispanic pct_black std_gr4m std_gr8m lnppcurexp

gen pctlep_flag=1 if pctlep==.
replace pctlep_flag=0 if pctlep_flag==.
replace pctlep=0 if pctlep==.

reg std_gr4m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year
outreg using mass_test_scores, bdec(4) replace
test 2000bn.year 2001.year 2002.year 2003.year 2004.year 2005.year 2006.year

reg std_gr8m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year
outreg using mass_test_scores, bdec(4) merge
test 2000bn.year 2001.year 2002.year 2003.year 2004.year 2005.year 2006.year

sureg(std_gr4m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year)(std_gr8m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year)

test [std_gr4m]lnppcurexp=[std_gr8m]lnppcurexp
test [std_gr4m]pct_black=[std_gr8m]pct_black
test [std_gr4m]pct_hispanic=[std_gr8m]pct_hispanic
test [std_gr4m]pctsped=[std_gr8m]pctsped
test [std_gr4m]pctlowinc=[std_gr8m]pctlowinc
test [std_gr4m]pctlep=[std_gr8m]pctlep
test [std_gr4m]totstu=[std_gr8m]totstu
test [std_gr4m]pctlep_flag=[std_gr8m]pctlep_flag

xtset district_number year

xtreg std_gr4m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year, fe
outreg using mass_test_scores, bdec(4) replace

xtreg std_gr8m lnppcurexp pctlowinc pctlep pctsped pct_black pct_hispanic totstu pctlep_flag i.year, fe
outreg using mass_test_scores, bdec(4) merge


/*--------------------------------Computational Excercises Via Wooldridge--------------------------------*/
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
