/*these commands set basic parameters in Stata*/
clear
set more 1
capture log close
/* open a log file */
cd  C:\Users\My\Desktop\Econometrics_paper
use newfinalDataset.dta
gen wageindex = medgrossrent/state_grossrent
gen adjminwage = wageindex*minwage
/*replace adjminwage = 7.25 if adjminwage<7.25*/
regress lowskillemploy minwage medgrossrent population
outreg2 using lowskillemployreg sortvar(minwage medgrossrent population) tex(fragment) replace
regress lowskillemploy adjminwage medgrossrent population
outreg2 using lowskillemployreg sortvar(adjminwage medgrossrent population) tex(fragment) 
/*Summary statistics*/
sutex
/*correlation matrix*/
corrtex lowskillemploy minwage medgrossrent population adjminwage wageindex , file(CorrTable)

