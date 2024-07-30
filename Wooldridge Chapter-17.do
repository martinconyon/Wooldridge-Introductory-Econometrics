// Author: Martin Conyon
// Data set: Wooldridge - Chapter 17
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 17: Limited Dependent Variable Models and Sample Selection Corrections

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 17
log using "output/Chapter17.smcl", replace

// install dependencies

// net install outreg2.pkg
// ssc install outreg2

// Set the working directory (users should modify this to their specific path)
// Place this in a block comment to guide users
/*
    Set your working directory to the project root where the 'do-files' and 'data' folders are located.
    Example:
    cd "/path/to/project-root"
*/

// Check PWD
// cd "/path/to/project-root" if required
// cd "."

// Load data and descriptive statistics
use "./data/mroz.dta", clear
describe
desc inlf nwifeinc educ exper expersq age kidslt6 kidsge6
summarize inlf nwifeinc educ exper expersq age kidslt6 kidsge6

// Model estimation
regress inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
outreg2 using output/example17_1, dec(3) replace

logit inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
outreg2 using output/example17_1, append addstat(Pseudo R-squared, `e(r2_p)') dec(3)

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
outreg2 using output/example17_1, append addstat(Pseudo R-squared, `e(r2_p)') dec(3) 

// Marginal effects (Average Partial Effects)
regress inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
margins, dydx(_all) post
outreg2 using output/example17_1, dec(3) replace

logit inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
margins, dydx(_all) post
outreg2 using output/example17_1, append dec(3)

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
margins, dydx(_all) post
outreg2 using output/example17_1, append dec(3) 

// Figure 17.2
regress inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
margins, at(educ=(0(1)20))
marginsplot, name(figure17_2_reg, replace)
graph save "output/figure17_2_reg.gph", replace
graph export "output/figure17_2_reg.png", replace

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6, robust
margins, at(educ=(0(1)20))
marginsplot, name(figure17_2_probit, replace)
graph save "output/figure17_2_probit.gph", replace
graph export "output/figure17_2_probit.png", replace

// Tobit Models

// Table 17.3
use "./data/mroz.dta", clear
regress hours nwifeinc educ exper expersq age kidslt6 kidsge6, robust
tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)

// Table 17.4
regress hours nwifeinc educ exper expersq age kidslt6 kidsge6
margins, dydx(_all) at((means) _all)

tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)
margins, dydx(_all) predict(ystar(0,.)) 

tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)
margins, dydx(educ) predict(ystar(0,.)) at(educ=(0(1)20))
marginsplot, name(figure17_4_tobit, replace)
graph save "output/figure17_4_tobit.gph", replace
graph export "output/figure17_4_tobit.png", replace

// Heckman selection
use "./data/mroz.dta", clear
describe
tabulate inlf
regress educ inlf, noheader

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6
predict yhat, xb
gen imratio = normalden(yhat)/normal(yhat)

regress lwage educ exper expersq imratio

regress lwage educ exper expersq
heckman lwage educ exper expersq, select(inlf = nwifeinc educ exper expersq age kidslt6 kidsge6) twostep
margins, dydx(_all)

// Close the log file
log close
