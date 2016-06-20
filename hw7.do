/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
cd C:\Users\My\Desktop\Econometrics\HW7
/*----------------------------------------ARIMA---------------------------------------------*/
clear all
set more off

use timeseries_ppi

global ylist ppi
global dylist d.ppi
global time t
global lags 40

describe $time $ylist
summarize $time $ylist

* Set data as time series
tset $time
*tset $time, quarterly
*gen time=_n

* Plotting the data
twoway (tsline $ylist)
twoway (tsline d.$ylist)
*twoway line $ylist $time
*twoway line d.$ylist $time

* Dickey-Fuller test for variable
dfuller $ylist, drift regress lags(0)
regress d.$ylist l.$ylist

dfuller $ylist, trend regress lags(0)
* dfuller $ylist, regress lags(2)

* Dickey-Fuller test for differenced variable
dfuller d.$ylist, drift regress lags(0)
regress d.$dylist l.$dylist


* Correlogram, ACF, and PACF
corrgram $ylist
ac $ylist
pac $ylist
* pac d.$ylist, xscale(range(0 $lags)) yscale(range(-1 1))

corrgram d.$ylist
ac d.$ylist
pac d.$ylist


* ARIMA models

* ARIMA(1,0,0) or AR(1)
arima $ylist, arima(1,0,0)

* ARIMA(2,0,0) or AR(2)
arima $ylist, arima(2,0,0)

* ARIMA(0,0,1) or MA(1)
arima $ylist, arima(0,0,1)

* ARIMA(1,0,1) or AR(1) MA(1)
arima $ylist, arima(1,0,1)

* ARIMA on differenced variable
arima $ylist, arima(1,1,0)
arima $ylist, arima(0,1,1)
arima $ylist, arima(1,1,1)
arima $ylist, arima(1,1,3)
arima $ylist, arima(2,1,3)

*arima d.$ylist, ar(1/2) ma(1/3)
*arima d.$ylist, ar(1 2) ma(1 2 3)

* AIC and BIC for model fit
arima $ylist, arima(1,1,1)
estat ic
arima $ylist, arima(2,1,3)
estat ic

* Detrending
reg $ylist $time
predict et, resid
twoway line et $time
dfuller et, drift regress lags(0)
ac et
pac et
/*-----------------------------------------------------------------------------------------------*/

infile year totacc unem spdlaw beltlaw wkends prcfat using C:\Users\My\Desktop\Econometrics\HW7\traffic2.txt

log using homework_7_final, replace t

*Generate Time Trend and Dummy Variables

gen logtotacc = log(totacc)

gen time = m(1981:1) + _n-1
format time %tm
tsset time

gen month = mod(time,12)+1

*Regression: Time Trend and Month Binaries on logtotacc
reg logtotacc time i.month
outreg using Table_1, bdec(4) se title ("Table 1") ///
summstat(r2\N\rmse) summtitle("R_squared"\"N"\"SER") summdec(3 0 2) ///
starlevels (10 5 1) note("Standard errors in parentheses") replace

testparm i.month

*Regression: Include additional variables
reg logtotacc time i.month wkends unem spdlaw beltlaw
outreg using Table_2, bdec(4) se title ("Table 2") ///
summstat(r2\N\rmse) summtitle("R_squared"\"N"\"SER") summdec(3 0 2) ///
starlevels (10 5 1) note("Standard errors in parentheses") replace

sum prcfat

*Regression: Fatal Accidents as Dependent Variable additional variables
reg prcfat time i.month wkends unem spdlaw beltlaw
outreg using Table_3, bdec(4) se title ("Table 3") ///
summstat(r2\N\rmse) summtitle("R_squared"\"N"\"SER") summdec(3 0 2) ///
starlevels (10 5 1) note("Standard errors in parentheses") replace

/*--------------------------------------------------------------------*/
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

