// Author: Martin Conyon
// Data set: Wooldridge - Chapter 12
// Date: July 2024

version 18
// The version command ensures that the do-file runs with the syntax and features of Stata 18, ensuring compatibility with the current version.

// Chapter 12: Serial Correlation and Heteroskedasticity in Time Series Regressions

// Clear memory to start fresh
capture clear _all

// Close any open log files
capture log close

// Open log file for Chapter 12
log using "output/Chapter12.smcl", replace

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

// Example 12.2: Testing for AR(1) Serial Correlation in the Phillips Curve
use "./data/phillips.dta", clear
tsset year
qui reg inf unem
predict inf_res, res
gen inf_res_1 = inf_res[_n-1]
reg inf_res inf_res_1

qui reg cinf unem
predict cinf_res, res
gen cinf_res_1 = cinf_res[_n-1]
reg cinf_res cinf_res_1

// Example 12.3: Testing for AR(1) Serial Correlation in the Minimum Wage Equation
use "./data/prminwge.dta", clear
tsset year
qui reg lprepop lmincov lprgnp lusgnp t
predict u, res
gen u_1 = u[_n-1]
reg u u_1 lmincov lprgnp lusgnp t
reg u u_1

// Example 12.3: Testing for AR(3) Serial Correlation
use "./data/barium.dta", clear
tsset t
qui reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
predict u, res
gen u_1 = u[_n-1]
gen u_2 = u[_n-2]
gen u_3 = u[_n-3]
reg u u_1 u_2 u_3 lchempi lgas lrtwex befile6 affile6 afdec6
test u_1 u_2 u_3

// Example 12.5: Prais-Winsten Estimation in the Event Study
use "./data/barium.dta", clear
tsset t
eststo clear
local x "lchempi lgas lrtwex befile6 affile6 afdec6"
eststo OLS: qui reg lchnimp `x'
eststo PraisWinsten: qui prais lchnimp `x'
estout , cells(b(nostar fmt(2)) se(par fmt(3))) ///
    stats(rho N r2, fmt(%9.3f %9.0g %9.3f) ///
    labels(rho Observations R-squared)) ///
    varlabels(_cons intercept) varwidth(20) ti(Table 12.1 LHS: log(chnimp))
eststo clear

// Example 12.6: Static Phillips Curve
use "./data/phillips.dta", clear
tsset year
eststo OLS: qui reg inf unem
eststo PW: qui prais inf unem
estout , cells(b(nostar fmt(3)) se(par fmt(3))) ///
    stats(rho N r2, fmt(%9.3f %9.0g %9.3f) ///
    labels(rho Observations R-squared)) ///
    varlabels(_cons intercept) varwidth(20) ti(Table 12.2 Dependent Variable: inf)
est clear

// Example 12.6: Differencing the Interest Rate Equation
use "./data/intdef.dta", clear
describe
tsset year
reg i3 inf def
predict u, res
gen u_1 = u[_n-1]
reg u u_1
reg ci3 cinf cdef
corr i3 i3_1
predict e, res
gen e_1 = e[_n-1]
reg e e_1

// Example 12.7: The Puerto Rican Minimum Wage
use "./data/prminwge.dta", clear
tsset year
eststo OLS: qui reg lprepop lmincov lprgnp lusgnp t
eststo Newey: qui newey lprepop lmincov lprgnp lusgnp t, lag(2)
eststo Pw: qui prais lprepop lmincov lprgnp lusgnp t
estout , cells(b(nostar fmt(4)) se(par fmt(4))) ///
    stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) ///
    labels(R-squared Adj-R-squared N)) varlabels(_cons intercept) varwidth(20) ///
    ti(LHS: log(prepop))
est clear

// Example 12.8: Heteroskedasticity and the Efficient Markets Hypothesis
use "./data/nyse.dta", clear
describe
tsset t
reg return return_1
predict u, res
gen u2 = u^2
reg u2 return_1

// Example 12.9: ARCH in Stock Returns
use "./data/nyse.dta", clear
describe
tsset t
qui reg return return_1
predict u, res
gen u2 = u^2
gen u2_1 = u2[_n-1]
reg u2 u2_1
gen u_1 = u[_n-1]
reg u u_1

// Close the log file
log close
